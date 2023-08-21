#!/bin/bash

psql -h $APPDB_HOST -U $APPDB_UNAME -d $APPDB_DATABASE -p 5432 -v SEARCH_PATH=b2bschema  -c "COPY customers TO STDOUT WITH DELIMITER ',' CSV;" > customers.csv;

psql -h $APPDB_HOST -U $APPDB_UNAME -d $APPDB_DATABASE -p 5432 -v SEARCH_PATH=b2bschema  -c "COPY company TO STDOUT WITH DELIMITER ',' CSV;" > company.csv;

psql -h $APPDB_HOST -U $APPDB_UNAME -d $APPDB_DATABASE -p 5432 -v SEARCH_PATH=b2bschema  -c "COPY company_products TO STDOUT WITH DELIMITER ',' CSV;" > company_products.csv;

psql -h $APPDB_HOST -U $APPDB_UNAME -d $APPDB_DATABASE -p 5432 -v SEARCH_PATH=b2bschema  -c "COPY supplier_products TO STDOUT WITH DELIMITER ',' CSV;" > supplier_products.csv;

psql -h $APPDB_HOST -U $APPDB_UNAME -d $APPDB_DATABASE -p 5432 -v SEARCH_PATH=b2bschema  -c "COPY suppliers TO STDOUT WITH DELIMITER ',' CSV;" > suppliers.csv;

python -c "from include.utils.generate_app_data import generate_orders, generate_insert_queries; generate_orders(350,True); generate_insert_queries();";

value=$(cat order_insert_queries.sql);

psql -h $APPDB_HOST -U $APPDB_UNAME -d $APPDB_DATABASE -p 5432 -v SEARCH_PATH=b2bschema  -c "${value}; "

python -c "from include.utils.generate_app_data import generate_fake_leads; generate_fake_leads(10); ";