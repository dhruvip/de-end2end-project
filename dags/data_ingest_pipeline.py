from airflow.decorators import dag, task
from datetime import datetime, date
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from airflow.models.baseoperator import chain
from airflow.providers.amazon.aws.transfers.local_to_s3 import LocalFilesystemToS3Operator
from include.utils.helper import copy_csv_to_s3_bulk, convert_leads_to_csv_s3, process_logs_to_csv_s3


@dag(
    start_date=datetime(1970,1,1),
    schedule="0 5 * * *",
    catchup=False,
    tags=['ingest'],
    template_searchpath='/usr/local/airflow/include/'
)
def data_ingest_pipeline():
    """
        At the end of this pipeline all the data is available in stading schema
    """
    
    # Gets the most recent dump of the application db and puts it in csv files 
    get_fresh_appdb_dumps = BashOperator(
        task_id='get_fresh_appdb_dumps',
        bash_command='''export PGPASSWORD=$APPDB_PASSWORD; 
        bash /usr/local/airflow/include/utils/export_appdb_to_csv.sh;
        ''',
        cwd='/tmp'
    )
    
    # The application db dump csv files are put to s3
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

    # This processer converts the combined log format to csv and puts to local
    process_server_logs=PythonOperator(
        task_id='process_server_logs',
        python_callable=process_logs_to_csv_s3,
        op_kwargs={
            'aws_conn_id':'aws_conn', 
            'dest_bucket':'airflow-stg-bucket',
            'source_dir': '/tmp/logs',
            'dest_key': 'logs/',
            'file_ext': 'log',
            'delete_on_success': True
        },
    )

    # this processor uploads the combined log file of the day to s3
    upload_combined_log = LocalFilesystemToS3Operator(
        task_id='upload_combined_log',
        filename='/tmp/logs/combined_logs.csv',
        dest_key=f"logs/{date.today().strftime('%Y%m%d')}-combined_logs.csv",
        dest_bucket='airflow-stg-bucket',
        aws_conn_id='aws_conn',
        replace=True
    )    

    # uploads leads to s3
    upload_leads_to_s3 = LocalFilesystemToS3Operator(
        task_id='upload_leads_to_s3',
        filename='/tmp/leads/marketing_sales_leads.xlsx',
        dest_key=f"leads/{date.today().strftime('%Y%m%d')}-marketing_sales_leads.xlsx",
        dest_bucket='airflow-stg-bucket',
        aws_conn_id='aws_conn',
        replace=True
    )

    # this processor converts the xlxs file to csv and puts to s3
    convert_leads_to_csv = PythonOperator(
        task_id='convert_leads_to_csv',
        python_callable=convert_leads_to_csv_s3,
        op_kwargs={
            'aws_conn_id':'aws_conn', 
            'dest_bucket':'airflow-stg-bucket',
            'target': f"s3://airflow-stg-bucket/leads/{date.today().strftime('%Y%m%d')}-marketing_sales_leads.csv",
            'source': f"s3://airflow-stg-bucket/leads/{date.today().strftime('%Y%m%d')}-marketing_sales_leads.xlsx",
            'csv_header':["lead_id","uname","first_contact_date","campaign_channel","campaign_name","order_id","product_id"]
        },
    )

    # this is a bash script which puts all the csvs to their respective staging tables
    load_all_data_to_staging = BashOperator(
        task_id='load_all_data_to_staging',
        bash_command='''export PGPASSWORD=$REDSHIFT_PASSWORD; 
        cp /usr/local/airflow/include/utils/load_all_data_to_staging.sql .;
        sed -i.bak "s|IAMROLE|$REDSHIFT_IAM|g" load_all_data_to_staging.sql;
        sed -i.bak "s|TDATE|$(date +%Y%m%d)|g" load_all_data_to_staging.sql;
        psql -v ON_ERROR_STOP=1 -h $REDSHIFT_HOST -U $REDSHIFT_UNAME -d $REDSHIFT_SCHEMA -p 5439 -f load_all_data_to_staging.sql''',
        cwd='/tmp'
    )
    
    upload_leads_to_s3 >> convert_leads_to_csv 
    process_server_logs >> upload_combined_log

    get_fresh_appdb_dumps >> upload_appdata_to_s3
    # process_server_logs >> upload_appdata_to_s3
    convert_leads_to_csv >> upload_appdata_to_s3

    upload_appdata_to_s3 >> load_all_data_to_staging
    upload_combined_log >> load_all_data_to_staging
    # (get_fresh_appdb_dumps, process_server_logs, convert_leads_to_csv) >> (upload_combined_log, upload_appdata_to_s3) >> load_all_data_to_staging
    
data_ingest_pipeline()    