from airflow.decorators import dag, task
from datetime import datetime, date
from airflow.operators.bash import BashOperator
from airflow.models.baseoperator import chain


@dag(
    start_date=datetime(1970,1,1),
    schedule=None,
    catchup=False,
    tags=['seed'],
    template_searchpath='/usr/local/airflow/include',
)
def generate_data_for_testing():
    '''
        this dag will initialize the redshift warehouse  for staging schema and 
        This dag will create new orders, leads and logs
    '''

    init_dw_schema = BashOperator(
        task_id='init_dw_schema',
        bash_command='''export PGPASSWORD=$REDSHIFT_PASSWORD; 
        cp /usr/local/airflow/include/utils/init_dw_schema.sql .;
        sed -i.bak "s|IAMROLE|$REDSHIFT_IAM|g" init_dw_schema.sql;
        psql -v ON_ERROR_STOP=1 -h $REDSHIFT_HOST -U $REDSHIFT_UNAME -d $REDSHIFT_SCHEMA -p 5439 -f init_dw_schema.sql''',
        cwd='/tmp'
    )
    generate_new_orders = BashOperator(
        task_id='generate_new_orders',
        bash_command='''export PGPASSWORD=$APPDB_PASSWORD; 
        bash /usr/local/airflow/include/utils/generate_new_orders.sh;
        ''',
        cwd='/tmp'
    )
    chain(init_dw_schema,generate_new_orders)

generate_data_for_testing()