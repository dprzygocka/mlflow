"""change param value length to 500

Revision ID: cc1f77228345
Revises: 0c779009ac13
Create Date: 2022-08-04 22:40:56.960003

"""
from alembic import op
import sqlalchemy as sa

from mlflow.store.tracking.dbmodels.initial_models import SqlParam


# revision identifiers, used by Alembic.
revision = "cc1f77228345"
down_revision = "0c779009ac13"
branch_labels = None
depends_on = None


def upgrade():
    dialect = op.get_bind().dialect
    database_type = dialect.name
    if database_type == "duckdb":
        op.create_table(
            'temp_params',
            sa.Column('key', sa.String(250)),
            sa.Column('value', sa.String(500), nullable=False),
            sa.Column('run_uuid', sa.String(32), sa.ForeignKey("runs.run_uuid")),
            sa.PrimaryKeyConstraint('key', 'run_uuid', name='temp_param_pk')
        )
        op.execute('INSERT INTO temp_params SELECT * FROM params;')
        op.drop_table('params')

        op.create_table(
            SqlParam.__tablename__,
            sa.Column('key', sa.String(250)),
            sa.Column('value', sa.String(500), nullable=False),
            sa.Column('run_uuid', sa.String(32), sa.ForeignKey("runs.run_uuid")),
            sa.PrimaryKeyConstraint('key', 'run_uuid', name='param_pk')
        )
        op.execute('INSERT INTO params SELECT * FROM temp_params;')
        op.drop_table('temp_params')
    else:
        """
        Enlarge the maximum param value length to 500.
        """
        with op.batch_alter_table("params") as batch_op:
            batch_op.alter_column(
                "value",
                existing_type=sa.String(250),
                type_=sa.String(500),
                existing_nullable=False,
                nullable=False,
            )


def downgrade():
    pass
