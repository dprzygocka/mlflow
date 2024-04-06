global_var = False

import logging
import os
import socket
import time
from contextlib import contextmanager

from duckdb import IOException, OperationalError
from sqlalchemy.exc import OperationalError
import sqlalchemy
from alembic.migration import MigrationContext
from alembic.script import ScriptDirectory
from sqlalchemy import sql
from sqlalchemy import create_engine, inspect

# We need to import sqlalchemy.pool to convert poolclass string to class object
from sqlalchemy.pool import (
    AssertionPool,
    AsyncAdaptedQueuePool,
    FallbackAsyncAdaptedQueuePool,
    NullPool,
    QueuePool,
    SingletonThreadPool,
    StaticPool,
)

from mlflow.environment_variables import (
    MLFLOW_SQLALCHEMYSTORE_ECHO,
    MLFLOW_SQLALCHEMYSTORE_MAX_OVERFLOW,
    MLFLOW_SQLALCHEMYSTORE_POOL_RECYCLE,
    MLFLOW_SQLALCHEMYSTORE_POOL_SIZE,
    MLFLOW_SQLALCHEMYSTORE_POOLCLASS,
)
from mlflow.exceptions import MlflowException
from mlflow.protos.databricks_pb2 import BAD_REQUEST, INTERNAL_ERROR, TEMPORARILY_UNAVAILABLE
from mlflow.store.db.db_types import SQLITE
from mlflow.store.model_registry.dbmodels.models import (
    SqlModelVersion,
    SqlModelVersionTag,
    SqlRegisteredModel,
    SqlRegisteredModelAlias,
    SqlRegisteredModelTag,
)
from mlflow.store.tracking.dbmodels.initial_models import Base as InitialBase
from mlflow.store.tracking.dbmodels.models import (
    SqlDataset,
    SqlExperiment,
    SqlExperimentTag,
    SqlInput,
    SqlInputTag,
    SqlLatestMetric,
    SqlMetric,
    SqlParam,
    SqlRun,
    SqlTag,
)

_logger = logging.getLogger(__name__)

MAX_RETRY_COUNT = 15


def _get_package_dir():
    """Returns directory containing MLflow python package."""
    current_dir = os.path.dirname(os.path.abspath(__file__))
    return os.path.normpath(os.path.join(current_dir, os.pardir, os.pardir))


def _all_tables_exist(engine):
    print('in utils _all_tables_exist')
    print(sqlalchemy.inspect(engine).get_table_names())
    return {
        t
        for t in sqlalchemy.inspect(engine).get_table_names()
        # Filter out alembic tables
        if not t.startswith("alembic_")
    } == {
        SqlExperiment.__tablename__,
        SqlRun.__tablename__,
        SqlMetric.__tablename__,
        SqlParam.__tablename__,
        SqlTag.__tablename__,
        SqlExperimentTag.__tablename__,
        SqlLatestMetric.__tablename__,
        SqlRegisteredModel.__tablename__,
        SqlModelVersion.__tablename__,
        SqlRegisteredModelTag.__tablename__,
        SqlModelVersionTag.__tablename__,
        SqlRegisteredModelAlias.__tablename__,
        SqlDataset.__tablename__,
        SqlInput.__tablename__,
        SqlInputTag.__tablename__,
    }


def _initialize_tables(engine):
    _logger.info("Creating initial MLflow database tables...")
    InitialBase.metadata.create_all(engine)
    inspector = inspect(engine)
    table_names = inspector.get_table_names()

    # Print the table names
    print("Tables in the database:", table_names)
    _upgrade_db(engine)


def _get_latest_schema_revision():
    print('_get_latest_schema_revision')
    """Get latest schema revision as a string."""
    # We aren't executing any commands against a DB, so we leave the DB URL unspecified
    config = _get_alembic_config(db_url="")
    script = ScriptDirectory.from_config(config)
    print('beofre heads')
    heads = script.get_heads()
    if len(heads) != 1:
        raise MlflowException(
            f"Migration script directory was in unexpected state. Got {len(heads)} head "
            f"database versions but expected only 1. Found versions: {heads}"
        )
    print('finish verifcation of latest schema revision')
    return heads[0]


def _verify_schema(engine):
    print('verify schema')
    head_revision = _get_latest_schema_revision()
    current_rev = _get_schema_version(engine)
    if current_rev != head_revision:
        raise MlflowException(
            f"Detected out-of-date database schema (found version {current_rev}, "
            f"but expected {head_revision}). Take a backup of your database, then run "
            "'mlflow db upgrade <database_uri>' "
            "to migrate your database to the latest schema. NOTE: schema migration may "
            "result in database downtime - please consult your database's documentation for "
            "more detail."
        )


def _get_managed_session_maker(SessionMaker, db_type):
    """
    Creates a factory for producing exception-safe SQLAlchemy sessions that are made available
    using a context manager. Any session produced by this factory is automatically committed
    if no exceptions are encountered within its associated context. If an exception is
    encountered, the session is rolled back. Finally, any session produced by this factory is
    automatically closed when the session's associated context is exited.
    """

    @contextmanager
    def make_managed_session():
        """Provide a transactional scope around a series of operations."""
        with SessionMaker() as session:
            try:
                if db_type == SQLITE:
                    session.execute(sql.text("PRAGMA foreign_keys = ON;"))
                    session.execute(sql.text("PRAGMA busy_timeout = 20000;"))
                    session.execute(sql.text("PRAGMA case_sensitive_like = true;"))
                yield session
                session.commit()
            except MlflowException:
                session.rollback()
                raise
            except sqlalchemy.exc.OperationalError as e:
                session.rollback()
                _logger.exception(
                    "SQLAlchemy database error. The following exception is caught.\n%s",
                    e,
                )
                raise MlflowException(message=e, error_code=TEMPORARILY_UNAVAILABLE)
            except sqlalchemy.exc.SQLAlchemyError as e:
                session.rollback()
                raise MlflowException(message=e, error_code=BAD_REQUEST)
            except Exception as e:
                session.rollback()
                raise MlflowException(message=e, error_code=INTERNAL_ERROR)

    return make_managed_session


def _get_alembic_config(db_url, alembic_dir=None):
    print('_get_alembic_config')
    print(db_url)
    """
    Constructs an alembic Config object referencing the specified database and migration script
    directory.

    Args:
        db_url: Database URL, like sqlite:///<absolute-path-to-local-db-file>. See
            https://docs.sqlalchemy.org/en/13/core/engines.html#database-urls for a full list of
            valid database URLs.
        alembic_dir: Path to migration script directory. Uses canonical migration script
            directory under mlflow/alembic if unspecified. TODO: remove this argument in MLflow 1.1,
            as it's only used to run special migrations for pre-1.0 users to remove duplicate
            constraint names.
    """
    from alembic.config import Config

    final_alembic_dir = (
        os.path.join(_get_package_dir(), "store", "db_migrations")
        if alembic_dir is None
        else alembic_dir
    )
    print('final_alembic_dir')
    print(final_alembic_dir)
    # Escape any '%' that appears in a db_url. This could be in a password,
    # url, or anything that is part of a potentially complex database url
    db_url = db_url.replace("%", "%%")
    config = Config(os.path.join(final_alembic_dir, "alembic.ini"))
    config.set_main_option("script_location", final_alembic_dir)
    print('make sure that alembic connects to right db')
    print(db_url)
    config.set_main_option("sqlalchemy.url", db_url)
    print('end of the function _get_alembic_config')
    print(config)
    return config

import subprocess

def get_duckdb_pid():
    # Run the command to list DuckDB processes
    result = subprocess.run(['pgrep', '-f', 'duckdb'], capture_output=True, text=True)
    
    # Check if the command was successful
    if result.returncode == 0:
        # Split the output by lines and get the first PID
        pids = result.stdout.strip().split('\n')
        if pids:
            return int(pids[0])  # Return the first PID found
    else:
        print("Error:", result.stderr)
    
    return None


def _upgrade_db(engine):
    """
    Upgrade the schema of an MLflow tracking database to the latest supported version.
    Note that schema migrations can be slow and are not guaranteed to be transactional -
    we recommend taking a backup of your database before running migrations.

    Args:
        url: Database URL, like sqlite:///<absolute-path-to-local-db-file>. See
            https://docs.sqlalchemy.org/en/13/core/engines.html#database-urls for a full list of
            valid database URLs.
    """
    # alembic adds significant import time, so we import it lazily
    from alembic import command
    from alembic.ddl.impl import DefaultImpl

    print(sqlalchemy.inspect(engine).get_table_names())
    for t in sqlalchemy.inspect(engine).get_table_names():
        print('name of th etable 2')
        print(t)

    class AlembicDuckDBImpl(DefaultImpl):
        """Alembic implementation for DuckDB."""

        __dialect__ = "duckdb"

    db_url = str(engine.url)
    _logger.info("Updating database tables")
    config = _get_alembic_config(db_url)

    # Initialize a shared connection to be used for the database upgrade, ensuring that
    # any connection-dependent state (e.g., the state of an in-memory database) is preserved
    # for reference by the upgrade routine. For more information, see
    # https://alembic.sqlalchemy.org/en/latest/cookbook.html#sharing-a-
    # connection-with-a-series-of-migration-commands-and-environments
    print('upgrade db begin connection')
    with engine.begin() as connection:
        config.attributes["connection"] = connection
        command.upgrade(config, "heads")
        # Get the DuckDB PID
        #duckdb_pid = get_duckdb_pid()
        #print("DuckDB PID:", duckdb_pid)
    # Get the DuckDB PID
    #duckdb_pid = get_duckdb_pid()
    #print("DuckDB PID:", duckdb_pid)
    engine.dispose()


def _get_schema_version(engine):
    from alembic.ddl.impl import DefaultImpl

    class AlembicDuckDBImpl(DefaultImpl):
        """Alembic implementation for DuckDB."""

        __dialect__ = "duckdb"

    print('_get_schema_version')
    print('engine')
    print(engine)
    with engine.connect() as connection:
        mc = MigrationContext.configure(connection)
        return mc.get_current_revision()


def create_sqlalchemy_engine_with_retry(db_uri):
    attempts = 0
    while True:
        attempts += 1
        print("create_sqlalchemy_engine_with_retry")
        engine = create_sqlalchemy_engine(db_uri)
        print(engine)
        try:
            sqlalchemy.inspect(engine)
            print("sqlalchemy inspection worked")
            return engine
        except Exception as e:
            if attempts < MAX_RETRY_COUNT:
                sleep_duration = 0.1 * ((2**attempts) - 1)
                _logger.warning(
                    "SQLAlchemy engine could not be created. The following exception is caught.\n"
                    "%s\nOperation will be retried in %.1f seconds",
                    e,
                    sleep_duration,
                )
                time.sleep(sleep_duration)
                continue
            raise


import subprocess

def find_duckdb_process(file_name):
    # Execute the lsof command to find processes using the DuckDB file
    print('before result')
    try:
        result = subprocess.run(['lsof', f'./{file_name}'], capture_output=True, text=True)
    except Exception as e:
        return None
    print(result)
    
    # Check if the command was successful
    if result.returncode == 0:
        # Split the output by lines and extract the PID from the first line
        lines = result.stdout.strip().split('\n')
        if lines:
            pid = lines[1].split()[1]  # Second column of the second line contains the PID
            return int(pid)
    else:
        print("Error:", result.stderr)
    
    return None

def kill_process(pid):
    # Execute the kill command to terminate the process
    subprocess.run(['kill', str(pid)])

def is_port_in_use(port):
    # Create a socket object
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    # Set a timeout for the connection attempt (optional)
    sock.settimeout(1)
    try:
        # Try to connect to the port
        sock.connect(('localhost', port))
        # If connection succeeds, the port is in use
        return True
    except ConnectionRefusedError:
        # If connection is refused, the port is not in use
        return False
    finally:
        # Close the socket
        sock.close()

def create_sqlalchemy_engine(db_uri, method = None):
    pool_size = MLFLOW_SQLALCHEMYSTORE_POOL_SIZE.get()
    pool_max_overflow = MLFLOW_SQLALCHEMYSTORE_MAX_OVERFLOW.get()
    pool_recycle = MLFLOW_SQLALCHEMYSTORE_POOL_RECYCLE.get()
    echo = MLFLOW_SQLALCHEMYSTORE_ECHO.get()
    poolclass = MLFLOW_SQLALCHEMYSTORE_POOLCLASS.get()
    pool_kwargs = {}
    # Send argument only if they have been injected.
    # Some engine does not support them (for example sqllite)
    if pool_size:
        pool_kwargs["pool_size"] = pool_size
    if pool_max_overflow:
        pool_kwargs["max_overflow"] = pool_max_overflow
    if pool_recycle:
        pool_kwargs["pool_recycle"] = pool_recycle
    if echo:
        pool_kwargs["echo"] = echo
    if poolclass:
        pool_class_map = {
            "AssertionPool": AssertionPool,
            "AsyncAdaptedQueuePool": AsyncAdaptedQueuePool,
            "FallbackAsyncAdaptedQueuePool": FallbackAsyncAdaptedQueuePool,
            "NullPool": NullPool,
            "QueuePool": QueuePool,
            "SingletonThreadPool": SingletonThreadPool,
            "StaticPool": StaticPool,
        }
        if poolclass not in pool_class_map:
            list_str = " ".join(pool_class_map.keys())
            err_str = (
                f"Invalid poolclass parameter: {poolclass}. Set environment variable "
                f"poolclass to empty or one of the following values: {list_str}"
            )
            _logger.warning(err_str)
            raise ValueError(err_str)
        pool_kwargs["poolclass"] = pool_class_map[poolclass]
    if pool_kwargs:
        _logger.info("Create SQLAlchemy engine with pool options %s", pool_kwargs)
    print("utils.py 286")
    print("db_uri")
    print(db_uri)
    print("**pool_kwargs")
    print(**pool_kwargs)
    print("db_uri", db_uri)
    print('ask sql alchemy to create engine based on uri')
    print('how sqlalchemy know how to create duckdb engine??? bc i installed duckdb-engine created by mouse')

    import re
    #connect_args={'read_only': True,}
    print('method try')
    pattern = r'[^/]+$'
    match = re.search(pattern, db_uri)
    print(db_uri)
    print(match.group(0))
    file_name = match.group(0)
    print('find file')
    print(os.path.exists(f'./{match.group(0)}'))

    print('global_var')
    print(global_var)
    free = is_port_in_use(5000)
    if not free:
        duckdb_pid = find_duckdb_process(file_name)
        if duckdb_pid is not None:
            print("DuckDB process found with PID:", duckdb_pid)
            # Kill the DuckDB process
            kill_process(duckdb_pid)
            print("DuckDB process killed.")
        else:
            print("No DuckDB process found.")
        engine = sqlalchemy.create_engine(db_uri, pool_pre_ping=True, **pool_kwargs, connect_args={'read_only': True,})
    else:
        engine = sqlalchemy.create_engine(db_uri, pool_pre_ping=True, **pool_kwargs)
    # Attempt to create SQLAlchemy engine
    print('engine object')
    print(engine)
    return engine
