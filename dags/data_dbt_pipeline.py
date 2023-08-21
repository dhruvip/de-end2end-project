"""
### Run a dbt Core project as a task group with Cosmos

Simple DAG showing how to run a dbt project as a task group, using
an Airflow connection and injecting a variable into the dbt project.
"""

from airflow.decorators import dag
from airflow.providers.postgres.operators.postgres import PostgresOperator
from cosmos import DbtTaskGroup, ProjectConfig, ProfileConfig, ExecutionConfig

# adjust for other database types
from cosmos.profiles import RedshiftUserPasswordProfileMapping
from pendulum import datetime
import os

YOUR_NAME = "b2bdb"
CONNECTION_ID = "red_conn"
DB_NAME = "dev"
SCHEMA_NAME = "reporting"
MODEL_TO_QUERY = "dimensions__events"
# The path to the dbt project
DBT_PROJECT_PATH = f"{os.environ['AIRFLOW_HOME']}/dags/dbt/b2bdw"
# The path where Cosmos will find the dbt executable
# in the virtual environment created in the Dockerfile
DBT_EXECUTABLE_PATH = f"{os.environ['AIRFLOW_HOME']}/dbt_venv/bin/dbt"

profile_config = ProfileConfig(
    profile_name="default",
    target_name="dev",
    profile_mapping=RedshiftUserPasswordProfileMapping(
        conn_id=CONNECTION_ID,
        profile_args={"schema": SCHEMA_NAME},
    ),
)

execution_config = ExecutionConfig(
    dbt_executable_path=DBT_EXECUTABLE_PATH,
)


@dag(
    start_date=datetime(2023, 8, 1),
    schedule="0 6 * * *",
    catchup=False,
    tags=['processing'],
    params={"path": os.environ['AIRFLOW_HOME']},
)
def data_dbt_dag():
    """
        This dag is responsible for running the dbt models and populating the reporting schema
    """
    transform_data = DbtTaskGroup(
        group_id="transform_data",
        project_config=ProjectConfig(DBT_PROJECT_PATH),
        profile_config=profile_config,
        execution_config=execution_config,
        operator_args={
            "vars": '{"path_to_config": {{ params.path }} }',
        },
    )


    transform_data 


data_dbt_dag()