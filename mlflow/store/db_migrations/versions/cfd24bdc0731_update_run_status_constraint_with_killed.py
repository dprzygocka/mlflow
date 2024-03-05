"""Update run status constraint with killed

Revision ID: cfd24bdc0731
Revises: 89d4b8295536
Create Date: 2019-10-11 15:55:10.853449

"""
import time
import alembic
from alembic import op
from packaging.version import Version
from sqlalchemy import CheckConstraint, Enum
import sqlalchemy as sa

from mlflow.entities import RunStatus, ViewType
from mlflow.entities.lifecycle_stage import LifecycleStage
from mlflow.store.tracking.dbmodels.models import SqlRun, SourceTypes, SqlTag, SqlMetric, SqlLatestMetric, SqlParam

# revision identifiers, used by Alembic.
revision = "cfd24bdc0731"
down_revision = "2b4d017a5e9b"
branch_labels = None
depends_on = None

old_run_statuses = [
    RunStatus.to_string(RunStatus.SCHEDULED),
    RunStatus.to_string(RunStatus.FAILED),
    RunStatus.to_string(RunStatus.FINISHED),
    RunStatus.to_string(RunStatus.RUNNING),
]

new_run_statuses = [*old_run_statuses, RunStatus.to_string(RunStatus.KILLED)]

# Certain SQL backends (e.g., SQLite) do not preserve CHECK constraints during migrations.
# For these backends, CHECK constraints must be specified as table arguments. Here, we define
# the collection of CHECK constraints that should be preserved when performing the migration.
# The "status" constraint is excluded from this set because it is explicitly modified
# within the migration's `upgrade()` routine.
check_constraint_table_args = [
    CheckConstraint(SqlRun.source_type.in_(SourceTypes), name="source_type"),
    CheckConstraint(
        SqlRun.lifecycle_stage.in_(LifecycleStage.view_type_to_stages(ViewType.ALL)),
        name="runs_lifecycle_stage",
    ),
]


def upgrade():
    dialect = op.get_bind().dialect
    database_type = dialect.name
    if database_type == "duckdb":
        op.create_table(
            'temp_runs',
            sa.Column('run_uuid', sa.String(32), nullable=False),
            sa.Column('name', sa.String(250)),
            sa.Column('source_type', sa.String(20), default='LOCAL'),
            sa.Column('source_name', sa.String(500)),
            sa.Column('entry_point_name', sa.String(50)),
            sa.Column('user_id', sa.String(256), nullable=True, default=None),
            sa.Column('status', Enum(*new_run_statuses, create_constraint=True, native_enum=False), server_default='SCHEDULED'),
            sa.Column('start_time', sa.BigInteger, default=int(time.time())),
            sa.Column('end_time', sa.BigInteger, nullable=True, default=None),
            sa.Column('source_version', sa.String(50)),
            sa.Column('lifecycle_stage', sa.String(20), default='active'),
            sa.Column('artifact_uri', sa.String(200), default=None),
            sa.Column('experiment_id', sa.Integer, sa.ForeignKey('experiments.experiment_id')),
            sa.CheckConstraint("source_type IN ('NOTEBOOK','JOB','LOCAL','UNKNOWN','PROJECT')", name='new_source_type_constraint'),
            sa.CheckConstraint("status IN ('SCHEDULED','FAILED','FINISHED','RUNNING')", name='new_status_constraint'),
            sa.CheckConstraint("lifecycle_stage IN ('active', 'deleted')", name='new_runs_lifecycle_stage_constraint'),
            sa.PrimaryKeyConstraint('run_uuid', name='new_run_pk')
        )
        op.execute('INSERT INTO temp_runs (run_uuid, name, source_type, source_name, entry_point_name, user_id, status, start_time, end_time, source_version, lifecycle_stage,artifact_uri, experiment_id) SELECT run_uuid, name, source_type, source_name, entry_point_name, user_id, status, start_time, end_time, source_version, lifecycle_stage,artifact_uri, experiment_id FROM runs;')

        #recreate temp tags table
        op.create_table(
            'temp_tags',
            sa.Column('key', sa.String(250)),
            sa.Column('value', sa.String(5000), nullable=True, server_default=None),
            sa.Column('run_uuid', sa.String(32), sa.ForeignKey("temp_runs.run_uuid")),
            sa.PrimaryKeyConstraint('key', 'run_uuid', name='temp_tag_pk')
        )
        op.execute('INSERT INTO temp_tags SELECT * FROM tags;')
        op.drop_table('tags')

        #recreate temp params table
        op.create_table(
            'temp_params',
            sa.Column('key', sa.String(250)),
            sa.Column('value', sa.String(250), nullable=True),
            sa.Column('run_uuid', sa.String(32), sa.ForeignKey("temp_runs.run_uuid")),
            sa.PrimaryKeyConstraint('key', 'run_uuid', name='temp_param_pk')
        )
        op.execute('INSERT INTO temp_params SELECT * FROM params;')
        op.drop_table('params')

        op.create_table(
            'new_metrics_temp',
            sa.Column('key', sa.String(250), nullable=False),
            sa.Column('value', sa.types.Float(precision=53), nullable=False),
            sa.Column('timestamp', sa.BigInteger, default=lambda: int(time.time())),
            sa.Column('run_uuid', sa.String(32), sa.ForeignKey("temp_runs.run_uuid")),
            sa.Column('step', sa.BigInteger, nullable=False, server_default='0'),
            sa.Column('is_nan', sa.Boolean(create_constraint=False), nullable=False, server_default="0"),
            sa.PrimaryKeyConstraint('key', 'timestamp', 'step', 'run_uuid', 'value', 'is_nan', name='new_metric_pk')
        )
        op.execute('INSERT INTO new_metrics_temp SELECT * FROM metrics;')
        op.drop_table('metrics')

        op.create_table(
            'latest_metrics_temp',
            sa.Column("key", sa.String(length=250)),
            sa.Column("value", sa.Float(precision=53), nullable=False),
            sa.Column("timestamp", sa.BigInteger, default=lambda: int(time.time())),
            sa.Column("step", sa.BigInteger, default=0, nullable=False),
            sa.Column("is_nan", sa.Boolean, default=False, nullable=False),
            sa.Column("run_uuid", sa.String(length=32), sa.ForeignKey("temp_runs.run_uuid"), nullable=False),
            sa.PrimaryKeyConstraint("key", "run_uuid", name="latest_metric_pk"),
        )
        op.execute('INSERT INTO latest_metrics_temp SELECT * FROM latest_metrics;')
        op.drop_table('latest_metrics')

        op.drop_table('runs')

        # create runs table
        op.create_table(
            SqlRun.__tablename__,
            sa.Column('run_uuid', sa.String(32), nullable=False),
            sa.Column('name', sa.String(250)),
            sa.Column('source_type', sa.String(20), default='LOCAL'),
            sa.Column('source_name', sa.String(500)),
            sa.Column('entry_point_name', sa.String(50)),
            sa.Column('user_id', sa.String(256), nullable=True, default=None),
            sa.Column('status', Enum(*new_run_statuses, create_constraint=True, native_enum=False), server_default='SCHEDULED'),
            sa.Column('start_time', sa.BigInteger, default=int(time.time())),
            sa.Column('end_time', sa.BigInteger, nullable=True, default=None),
            sa.Column('source_version', sa.String(50)),
            sa.Column('lifecycle_stage', sa.String(20), default='active'),
            sa.Column('artifact_uri', sa.String(200), default=None),
            sa.Column('experiment_id', sa.Integer, sa.ForeignKey('experiments.experiment_id')),
            sa.CheckConstraint("source_type IN ('NOTEBOOK','JOB','LOCAL','UNKNOWN','PROJECT')", name='source_type_constraint'),
            sa.CheckConstraint("status IN ('SCHEDULED','FAILED','FINISHED','RUNNING')", name='status_constraint'),
            sa.CheckConstraint("lifecycle_stage IN ('active', 'deleted')", name='runs_lifecycle_stage_constraint'),
            sa.PrimaryKeyConstraint('run_uuid', name='run_pk')
        )
        op.execute('INSERT INTO runs (run_uuid, name, source_type, source_name, entry_point_name, user_id, status, start_time, end_time, source_version, lifecycle_stage,artifact_uri, experiment_id) SELECT run_uuid, name, source_type, source_name, entry_point_name, user_id, status, start_time, end_time, source_version, lifecycle_stage,artifact_uri, experiment_id FROM temp_runs;')

        # create tags table
        op.create_table(
            SqlTag.__tablename__,
            sa.Column('key', sa.String(250)),
            sa.Column('value', sa.String(5000), nullable=True, server_default=None),
            sa.Column('run_uuid', sa.String(32), sa.ForeignKey("runs.run_uuid")),
            sa.PrimaryKeyConstraint('key', 'run_uuid', name='tag_pk')
        )
        op.execute('INSERT INTO tags SELECT * FROM temp_tags;')
        op.drop_table('temp_tags')

        # create params table
        op.create_table(
            SqlParam.__tablename__,
            sa.Column('key', sa.String(250)),
            sa.Column('value', sa.String(250), nullable=True),
            sa.Column('run_uuid', sa.String(32), sa.ForeignKey("runs.run_uuid")),
            sa.PrimaryKeyConstraint('key', 'run_uuid', name='param_pk')
        )
        op.execute('INSERT INTO params SELECT * FROM temp_params;')
        op.drop_table('temp_params')

        # create metrics table
        op.create_table(
            SqlMetric.__tablename__,
            sa.Column('key', sa.String(250), nullable=False),
            sa.Column('value', sa.types.Float(precision=53), nullable=False),
            sa.Column('timestamp', sa.BigInteger, default=lambda: int(time.time())),
            sa.Column('run_uuid', sa.String(32), sa.ForeignKey("runs.run_uuid")),
            sa.Column('step', sa.BigInteger, nullable=False, server_default='0'),
            sa.Column('is_nan', sa.Boolean(create_constraint=False), nullable=False, server_default="0"),
            sa.PrimaryKeyConstraint('key', 'timestamp', 'step', 'run_uuid', 'value', 'is_nan', name='metric_pk')
        )
        op.execute('INSERT INTO metrics SELECT * FROM new_metrics_temp;')
        op.drop_table('new_metrics_temp')

        # create new latest_metrics tables         
        op.create_table(
            SqlLatestMetric.__tablename__,
            sa.Column("key", sa.String(length=250)),
            sa.Column("value", sa.Float(precision=53), nullable=False),
            sa.Column("timestamp", sa.BigInteger, default=lambda: int(time.time())),
            sa.Column("step", sa.BigInteger, default=0, nullable=False),
            sa.Column("is_nan", sa.Boolean, default=False, nullable=False),
            sa.Column("run_uuid", sa.String(length=32), sa.ForeignKey("runs.run_uuid"), nullable=False),
            sa.PrimaryKeyConstraint("key", "run_uuid", name="latest_metric_pk"),
        )
        op.execute('INSERT INTO latest_metrics SELECT * FROM latest_metrics_temp;')
        op.drop_table('latest_metrics_temp')

        op.drop_table('temp_runs')
    else:
        # In alembic >= 1.7.0, `table_args` is unnecessary since CHECK constraints are preserved
        # during migrations.
        table_args = (
            [] if Version(alembic.__version__) >= Version("1.7.0") else check_constraint_table_args
        )
        with op.batch_alter_table("runs", table_args=table_args) as batch_op:
            # Transform the "status" column to an `Enum` and define a new check constraint. Specify
            # `native_enum=False` to create a check constraint rather than a
            # database-backend-dependent enum (see https://docs.sqlalchemy.org/en/13/core/
            # type_basics.html#sqlalchemy.types.Enum.params.native_enum)
            batch_op.alter_column(
                "status",
                type_=Enum(
                    *new_run_statuses,
                    create_constraint=True,
                    native_enum=False,
                ),
                existing_type=Enum(
                    *old_run_statuses,
                    create_constraint=True,
                    native_enum=False,
                    name="status",
                ),
            )


def downgrade():
    # Omit downgrade logic for now - we don't currently provide users a command/API for
    # reverting a database migration, instead recommending that they take a database backup
    # before running the migration.
    pass
