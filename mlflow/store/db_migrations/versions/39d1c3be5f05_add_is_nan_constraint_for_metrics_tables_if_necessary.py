"""add_is_nan_constraint_for_metrics_tables_if_necessary

Revision ID: 39d1c3be5f05
Revises: a8c4a736bde6
Create Date: 2021-03-16 20:40:24.214667

"""
import time
from alembic import op
import sqlalchemy as sa

from mlflow.store.tracking.dbmodels.models import SqlLatestMetric, SqlMetric

# revision identifiers, used by Alembic.
revision = "39d1c3be5f05"
down_revision = "a8c4a736bde6"
branch_labels = None
depends_on = None


def upgrade():
    dialect = op.get_bind().dialect
    database_type = dialect.name
    if database_type == "duckdb":
        op.create_table(
            'latest_metrics_temp',
            sa.Column("key", sa.String(length=250)),
            sa.Column("value", sa.Float(precision=53), nullable=False),
            sa.Column("timestamp", sa.BigInteger, default=lambda: int(time.time())),
            sa.Column("step", sa.BigInteger, default=0, nullable=False),
            sa.Column("is_nan", type_=sa.types.Boolean(create_constraint=True), default=False, nullable=False),
            sa.Column("run_uuid", sa.String(length=32), sa.ForeignKey("runs.run_uuid"), nullable=False),
            sa.PrimaryKeyConstraint("key", "run_uuid", name="latest_metric_pk"),
        )
        op.execute('INSERT INTO latest_metrics_temp SELECT * FROM latest_metrics;')
        op.drop_table('latest_metrics')

        op.create_table(
            SqlLatestMetric.__tablename__,
            sa.Column("key", sa.String(length=250)),
            sa.Column("value", sa.Float(precision=53), nullable=False),
            sa.Column("timestamp", sa.BigInteger, default=lambda: int(time.time())),
            sa.Column("step", sa.BigInteger, default=0, nullable=False),
            sa.Column("is_nan", type_=sa.types.Boolean(create_constraint=True), default=False, nullable=False),
            sa.Column("run_uuid", sa.String(length=32), sa.ForeignKey("runs.run_uuid"), nullable=False),
            sa.PrimaryKeyConstraint("key", "run_uuid", name="latest_metric_pk"),
        )
        op.execute('INSERT INTO latest_metrics SELECT * FROM latest_metrics_temp;')
        op.drop_table('latest_metrics_temp')

        op.create_table(
            'new_metrics_temp',
            sa.Column('key', sa.String(250), nullable=False),
            sa.Column('value', sa.types.Float(precision=53), nullable=False),
            sa.Column('timestamp', sa.BigInteger, default=lambda: int(time.time())),
            sa.Column('run_uuid', sa.String(32), sa.ForeignKey("runs.run_uuid")),
            sa.Column('step', sa.BigInteger, nullable=False, server_default='0'),
            sa.Column("is_nan", type_=sa.types.Boolean(create_constraint=True), nullable=False, server_default="0"),
            sa.PrimaryKeyConstraint('key', 'timestamp', 'step', 'run_uuid', 'value', 'is_nan', name='new_metric_pk')
        )
        op.execute('INSERT INTO new_metrics_temp SELECT * FROM metrics;')
        op.drop_table('metrics')
        op.create_table(
            SqlMetric.__tablename__,
            sa.Column('key', sa.String(250), nullable=False),
            sa.Column('value', sa.types.Float(precision=53), nullable=False),
            sa.Column('timestamp', sa.BigInteger, default=lambda: int(time.time())),
            sa.Column('run_uuid', sa.String(32), sa.ForeignKey("runs.run_uuid")),
            sa.Column('step', sa.BigInteger, nullable=False, server_default='0'),
            sa.Column("is_nan", type_=sa.types.Boolean(create_constraint=True), nullable=False, server_default="0"),
            sa.PrimaryKeyConstraint('key', 'timestamp', 'step', 'run_uuid', 'value', 'is_nan', name='metric_pk')
        )
        op.execute('INSERT INTO metrics SELECT * FROM new_metrics_temp;')
        op.drop_table('new_metrics_temp')
    else:
        # This part of the migration is only relevent for users who installed sqlalchemy 1.4.0 with
        # MLflow <= 1.14.1. In sqlalchemy 1.4.0, the default value of `create_constraint` for
        # `sqlalchemy.Boolean` was changed to `False` from `True`:
        # https://github.com/sqlalchemy/sqlalchemy/blob/rel_1_4_0/lib/sqlalchemy/sql/sqltypes.py#L1841.
        # To ensure that a check constraint is always present on the `is_nan` column in the
        # `latest_metrics` table, we perform an `alter_column` and explicitly set `create_constraint`
        # to `True`
        with op.batch_alter_table("latest_metrics") as batch_op:
            batch_op.alter_column(
                "is_nan", type_=sa.types.Boolean(create_constraint=True), nullable=False
            )

        # Introduce a check constraint on the `is_nan` column from the `metrics` table, which was
        # missing prior to this migration
        with op.batch_alter_table("metrics") as batch_op:
            batch_op.alter_column(
                "is_nan", type_=sa.types.Boolean(create_constraint=True), nullable=False
            )


def downgrade():
    pass
