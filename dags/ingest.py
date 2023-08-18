from airflow.decorators import dag, task
from datetime import datetime, date
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from airflow.models.baseoperator import chain
from include.utils.helper import copy_csv_to_s3_bulk
@dag(
    start_date=datetime(1970,1,1),
    schedule=None,
    catchup=False,
    tags=['ingest'],
    template_searchpath='/usr/local/airflow/include/'
)
def ingest_pipeline():
    get_fresh_appdb_dumps = BashOperator(
        task_id='get_fresh_appdb_dumps',
        bash_command='''export PGPASSWORD=$APPDB_PASSWORD; 
        bash /usr/local/airflow/include/utils/export_appdb_to_csv.sh;
        ''',
        cwd='/tmp'
    )
    upload_appdata_to_s3=PythonOperator(
        task_id='upload_appdata_to_s3',
        python_callable=copy_csv_to_s3_bulk,
        op_kwargs={
            'aws_conn_id':'aws_conn', 
            'dest_bucket':'airflow-stg-bucket',
            'source_dir': '/tmp',
            'dest_key': 'raw/'
        },
    )
    load_appdata_to_staging = BashOperator(
        task_id='load_appdata_to_staging',
        bash_command='''export PGPASSWORD=$REDSHIFT_PASSWORD; 
        cp /usr/local/airflow/include/sql/load_appdata_to_redshift.sql .;
        sed -i.bak "s|IAMROLE|$REDSHIFT_IAM|g" load_appdata_to_staging.sql;
        psql -v ON_ERROR_STOP=1 -h $REDSHIFT_HOST -U $REDSHIFT_UNAME -d $REDSHIFT_SCHEMA -p 5439 -f load_appdata_to_staging.sql''',
        cwd='/tmp'
    )

ingest_pipeline()    