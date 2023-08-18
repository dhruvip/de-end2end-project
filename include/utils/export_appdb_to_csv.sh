psql -h $APPDB_HOST -U $APPDB_UNAME -d $APPDB_DATABASE -p 5432 -c "COPY customers TO STDOUT WITH DELIMITER ',' CSV;" > customers.csv;

psql -h $APPDB_HOST -U $APPDB_UNAME -d $APPDB_DATABASE -p 5432 -c "COPY company TO STDOUT WITH DELIMITER ',' CSV;" > company.csv;

psql -h $APPDB_HOST -U $APPDB_UNAME -d $APPDB_DATABASE -p 5432 -c "COPY company_products TO STDOUT WITH DELIMITER ',' CSV;" > company_products.csv;

psql -h $APPDB_HOST -U $APPDB_UNAME -d $APPDB_DATABASE -p 5432 -c "COPY country_codes TO STDOUT WITH DELIMITER ',' CSV;" > country_codes.csv;

psql -h $APPDB_HOST -U $APPDB_UNAME -d $APPDB_DATABASE -p 5432 -c "COPY invoice TO STDOUT WITH DELIMITER ',' CSV;" > invoice.csv;

psql -h $APPDB_HOST -U $APPDB_UNAME -d $APPDB_DATABASE -p 5432 -c "COPY order_line_item TO STDOUT WITH DELIMITER ',' CSV;" > order_line_item.csv;

psql -h $APPDB_HOST -U $APPDB_UNAME -d $APPDB_DATABASE -p 5432 -c "COPY orders TO STDOUT WITH DELIMITER ',' CSV;" > orders.csv;

psql -h $APPDB_HOST -U $APPDB_UNAME -d $APPDB_DATABASE -p 5432 -c "COPY products TO STDOUT WITH DELIMITER ',' CSV;" > products.csv;

psql -h $APPDB_HOST -U $APPDB_UNAME -d $APPDB_DATABASE -p 5432 -c "COPY supplier_products TO STDOUT WITH DELIMITER ',' CSV;" > supplier_products.csv;

psql -h $APPDB_HOST -U $APPDB_UNAME -d $APPDB_DATABASE -p 5432 -c "COPY suppliers TO STDOUT WITH DELIMITER ',' CSV;" > suppliers.csv;
