from airflow.decorators import dag, task
from datetime import datetime, date
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from airflow.providers.amazon.aws.transfers.local_to_s3 import LocalFilesystemToS3Operator
# from airflow.providers.amazon.aws.operators.redshift_sql import RedshiftSQLOperator
from airflow.providers.amazon.aws.transfers.s3_to_redshift import S3ToRedshiftOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
import pandas as pd
import numpy as np
from include.utils.generate_app_data import generate, fake_leads
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.models.baseoperator import chain
from include.utils.helper import copy_csv_to_s3_bulk


@dag(
    start_date=datetime(1970,1,1),
    schedule=None,
    catchup=False,
    tags=['seed'],
    template_searchpath='/usr/local/airflow/include/sql',
)
def first_run():
    generate_leads_data = PythonOperator(
        task_id="generate_leads_data",
        python_callable=fake_leads,
    )
    upload_leads_to_s3 = LocalFilesystemToS3Operator(
        task_id='upload_leads_to_s3',
        filename='leads.csv',
        dest_key='leads.csv',
        dest_bucket='airflow-stg-bucket',
        aws_conn_id='aws_conn',
    )

    generate_app_data = PythonOperator(
        task_id="generate_app_data",
        python_callable=generate,
    )
    # upload_appdata_to_s3 = LocalFilesystemToS3Operator(
    #     task_id='upload_appdata_to_s3',
    #     filename='/tmp/*.csv',
    #     dest_key='*.csv',
    #     dest_bucket='airflow-stg-bucket',
    #     aws_conn_id='aws_conn',
    # )
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
    create_appdb_schema= PostgresOperator(
        task_id='create_appdb_schema',
        database='b2bdb',
        sql="populate_b2bdb.sql",
        postgres_conn_id='appdb_conn'
    )
    create_appdb_seed_data= PostgresOperator(
        task_id='create_appdb_seed_data',
        database='b2bdb',
        sql='''
        COPY customers FROM '/docker-entrypoint-initdb.d/customers.csv' WITH (FORMAT csv);
        COPY company FROM '/docker-entrypoint-initdb.d/company.csv' WITH (FORMAT csv);
        COPY suppliers FROM '/docker-entrypoint-initdb.d/suppliers.csv' WITH (FORMAT csv);
        COPY products FROM '/docker-entrypoint-initdb.d/products.csv' WITH (FORMAT csv);
        COPY company_products FROM '/docker-entrypoint-initdb.d/company_products.csv' WITH (FORMAT csv);
        COPY supplier_products FROM '/docker-entrypoint-initdb.d/supplier_products.csv' WITH (FORMAT csv);
        COPY orders FROM '/docker-entrypoint-initdb.d/orders.csv' WITH (FORMAT csv);
        COPY order_line_item FROM '/docker-entrypoint-initdb.d/order_line_item.csv' WITH (FORMAT csv);
        COPY invoice FROM '/docker-entrypoint-initdb.d/invoice.csv' WITH (FORMAT csv);
        COPY country_codes FROM '/docker-entrypoint-initdb.d/country_codes.csv' WITH (FORMAT csv);''',
        postgres_conn_id='appdb_conn'
    )
    generate_logs = BashOperator(
        task_id='generate_logs',
        bash_command='''log-generator /usr/local/airflow/dags/log-gene-config.yml''',
    )
    upload_logs_to_s3 = LocalFilesystemToS3Operator(
        task_id='upload_logs_to_s3',
        filename='/usr/local/airflow/include/dataset/web_logs.log',
        dest_key='web_logs.log',
        dest_bucket='airflow-stg-buckets',
        aws_conn_id='aws_conn',
        replace=True
    )

    init_dw_schema = BashOperator(
        task_id='init_dw_schema',
        bash_command='''export PGPASSWORD=$REDSHIFT_PASSWORD; 
        cp /usr/local/airflow/include/sql/init_dw_schema.sql .;
        sed -i.bak "s|IAMROLE|$REDSHIFT_IAM|g" init_dw_schema.sql;
        psql -v ON_ERROR_STOP=1 -h $REDSHIFT_HOST -U $REDSHIFT_UNAME -d $REDSHIFT_SCHEMA -p 5439 -f init_dw_schema.sql''',
        cwd='/tmp'
    )

    chain(
        generate_leads_data,
        upload_leads_to_s3,
        generate_app_data,
        upload_appdata_to_s3,
        create_appdb_schema,
        create_appdb_seed_data,
        generate_logs,
        upload_logs_to_s3,
        init_dw_schema
    )

first_run()