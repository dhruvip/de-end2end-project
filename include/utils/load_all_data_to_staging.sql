TRUNCATE TABLE staging.raw_customers;

COPY staging.raw_customers 
FROM 's3://airflow-stg-bucket/raw/customers.csv'
iam_role IAMROLE
CSV QUOTE AS '"'
DELIMITER AS ',';

TRUNCATE TABLE staging.raw_company;

COPY staging.raw_company
FROM 's3://airflow-stg-bucket/raw/company.csv'
iam_role IAMROLE
CSV QUOTE AS '"'
DELIMITER AS ',';

TRUNCATE TABLE staging.raw_country_codes;

COPY staging.raw_country_codes
FROM 's3://airflow-stg-bucket/raw/country_codes.csv'
iam_role IAMROLE
CSV QUOTE AS '"'
DELIMITER AS ',';

TRUNCATE TABLE staging.raw_invoice;
COPY staging.raw_invoice
FROM 's3://airflow-stg-bucket/raw/invoice.csv'
iam_role IAMROLE
CSV QUOTE AS '"'
DELIMITER AS ',';

TRUNCATE TABLE staging.raw_orders;
COPY staging.raw_orders
FROM 's3://airflow-stg-bucket/raw/orders.csv'
iam_role IAMROLE
CSV QUOTE AS '"'
DELIMITER AS ',';

TRUNCATE TABLE staging.raw_products;
COPY staging.raw_products
FROM 's3://airflow-stg-bucket/raw/products.csv'
iam_role IAMROLE
CSV QUOTE AS '"'
DELIMITER AS ',';

TRUNCATE TABLE staging.raw_suppliers;
COPY staging.raw_suppliers
FROM 's3://airflow-stg-bucket/raw/suppliers.csv'
iam_role IAMROLE
CSV QUOTE AS '"'
DELIMITER AS ',';

TRUNCATE TABLE staging.raw_order_line_item;
COPY staging.raw_order_line_item
FROM 's3://airflow-stg-bucket/raw/order_line_item.csv'
iam_role IAMROLE
CSV QUOTE AS '"'
DELIMITER AS ',';

TRUNCATE TABLE staging.raw_company_products;
COPY staging.raw_company_products
FROM 's3://airflow-stg-bucket/raw/company_products.csv'
iam_role IAMROLE
CSV QUOTE AS '"'
DELIMITER AS ',';


TRUNCATE TABLE staging.raw_supplier_products;
COPY staging.raw_supplier_products
FROM 's3://airflow-stg-bucket/raw/supplier_products.csv'
iam_role IAMROLE
CSV QUOTE AS '"'
DELIMITER AS ',';

--  Marketing Leads
DROP TABLE IF EXISTS staging.raw_marketing_leads_TDATE;

CREATE TABLE staging.raw_marketing_leads_TDATE
AS 
(SELECT * FROM staging.raw_marketing_leads limit 1);

TRUNCATE TABLE staging.raw_marketing_leads_TDATE;

COPY staging.raw_marketing_leads_TDATE
FROM 's3://airflow-stg-bucket/leads/TDATE-marketing_sales_leads.csv'
iam_role IAMROLE
CSV QUOTE AS '"'
DELIMITER AS ',';

INSERT INTO staging.raw_marketing_leads
(
    SELECT * FROM staging.raw_marketing_leads_TDATE
);

-- Web Logs

DROP TABLE IF EXISTS staging.raw_events_TDATE;

CREATE TABLE staging.raw_events_TDATE
AS 
(SELECT * FROM staging.raw_events limit 1);

TRUNCATE TABLE staging.raw_events_TDATE;

COPY staging.raw_events_TDATE
FROM 's3://airflow-stg-bucket/logs/TDATE-combined_logs.csv'
iam_role IAMROLE
CSV QUOTE AS '"'
TRUNCATECOLUMNS
DELIMITER AS ',';

INSERT INTO staging.raw_events
(
    SELECT * FROM staging.raw_events_TDATE
);
