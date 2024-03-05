"""allow nulls for metric values

Revision ID: 181f10493468
Revises: 90e64c465722
Create Date: 2019-07-10 22:40:18.787993

"""
import time
from alembic import op
import sqlalchemy as sa
from mlflow.store.tracking.dbmodels.models import SqlMetric

# revision identifiers, used by Alembic.
revision = "181f10493468"
down_revision = "90e64c465722"
branch_labels = None
depends_on = None


def upgrade():
    print('problem here')
    dialect = op.get_bind().dialect
    database_type = dialect.name
    if database_type == "duckdb":
        op.create_table(
            'new_metrics_temp',
            sa.Column('key', sa.String(250), nullable=False),
            sa.Column('value', sa.types.Float(precision=53), nullable=False),
            sa.Column('timestamp', sa.BigInteger, default=lambda: int(time.time())),
            sa.Column('run_uuid', sa.String(32), sa.ForeignKey("runs.run_uuid")),
            sa.Column('step', sa.BigInteger, nullable=False, server_default='0'),
            sa.Column('is_nan', sa.Boolean(create_constraint=False), nullable=False, server_default="0"),
            sa.PrimaryKeyConstraint('key', 'timestamp', 'step', 'run_uuid', 'value', 'is_nan', name='new_metric_pk')
        )
        op.execute('INSERT INTO new_metrics_temp (key, value, timestamp, run_uuid, step, is_nan) SELECT key, value, timestamp, run_uuid, 0 AS step, 0 AS is_nan FROM metrics;')
        op.drop_table('metrics')

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
        op.execute('INSERT INTO new_metrics_temp SELECT * FROM metrics;')
        op.drop_table('new_metrics_temp')
        print('finish 181f10493468')
    else:
        with op.batch_alter_table("metrics") as batch_op:
            batch_op.alter_column("value", type_=sa.types.Float(precision=53), nullable=False)
            batch_op.add_column(
                sa.Column(
                    "is_nan", sa.Boolean(create_constraint=False), nullable=False, server_default="0"
                )
            )
            batch_op.drop_constraint(constraint_name="metric_pk", type_="primary")
            batch_op.create_primary_key(
                constraint_name="metric_pk",
                columns=["key", "timestamp", "step", "run_uuid", "value", "is_nan"],
            )


def downgrade():
    pass
