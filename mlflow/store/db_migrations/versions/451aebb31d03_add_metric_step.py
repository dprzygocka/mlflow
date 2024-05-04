"""add metric step

Revision ID: 451aebb31d03
Revises:
Create Date: 2019-04-22 15:29:24.921354

"""
import time
from alembic import op
import sqlalchemy as sa
from mlflow.store.tracking.dbmodels.models import SqlMetric


# revision identifiers, used by Alembic.
revision = "451aebb31d03"
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    dialect = op.get_bind().dialect
    database_type = dialect.name
    if database_type == "duckdb":
        op.create_table(
            'new_metrics_temp',
            sa.Column('key', sa.String(250), nullable=False),
            sa.Column('value', sa.Float, nullable=False),
            sa.Column('timestamp', sa.BigInteger, default=lambda: int(time.time())),
            sa.Column('run_uuid', sa.String(32), sa.ForeignKey("runs.run_uuid")),
            sa.Column('step', sa.BigInteger, nullable=False, server_default='0'),
            sa.PrimaryKeyConstraint('key', 'timestamp', 'step', 'run_uuid', 'value', name='new_metric_pk')
        )

        op.execute('INSERT INTO new_metrics_temp (key, value, timestamp, run_uuid, step) SELECT key, value, timestamp, run_uuid, 0 AS step FROM metrics;')
        op.drop_table('metrics')

        op.create_table(
            SqlMetric.__tablename__,
            sa.Column('key', sa.String(250), nullable=False),
            sa.Column('value', sa.Float, nullable=False),
            sa.Column('timestamp', sa.BigInteger, default=lambda: int(time.time())),
            sa.Column('run_uuid', sa.String(32), sa.ForeignKey("runs.run_uuid")),
            sa.Column('step', sa.BigInteger, nullable=False, server_default='0'),
            sa.PrimaryKeyConstraint('key', 'timestamp', 'step', 'run_uuid', 'value', name='metric_pk')
        )
        op.execute('INSERT INTO metrics SELECT * FROM new_metrics_temp;')
        op.drop_table('new_metrics_temp')
    else:
        op.add_column("metrics", sa.Column("step", sa.BigInteger(), nullable=False, server_default="0"))
        # Use batch mode so that we can run "ALTER TABLE" statements against SQLite
        # databases (see more info at https://alembic.sqlalchemy.org/en/latest/
        # batch.html#running-batch-migrations-for-sqlite-and-other-databases)
        with op.batch_alter_table("metrics") as batch_op:
            batch_op.drop_constraint(constraint_name="metric_pk", type_="primary")
            batch_op.create_primary_key(
                constraint_name="metric_pk", columns=["key", "timestamp", "step", "run_uuid", "value"]
            )

def downgrade():
    # This migration cannot safely be downgraded; once metric data with the same
    # (key, timestamp, run_uuid, value) are inserted (differing only in their `step`), we cannot
    # revert to a schema where (key, timestamp, run_uuid, value) is the metric primary key.
    pass
