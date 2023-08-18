TRUNCATE TABLE staging.dim_customers;

COPY staging.dim_customers 
FROM 's3://airflow-stg-bucket/raw/customers.csv'
iam_role IAMROLE
CSV QUOTE AS '"'
DELIMITER AS ',';

TRUNCATE TABLE staging.dim_company;

COPY staging.dim_company
FROM 's3://airflow-stg-bucket/raw/company.csv'
iam_role IAMROLE
CSV QUOTE AS '"'
DELIMITER AS ',';

TRUNCATE TABLE staging.dim_country_codes;

COPY staging.dim_country_codes
FROM 's3://airflow-stg-bucket/raw/country_codes.csv'
iam_role IAMROLE
CSV QUOTE AS '"'
DELIMITER AS ',';

TRUNCATE TABLE staging.dim_invoice;
COPY staging.dim_invoice
FROM 's3://airflow-stg-bucket/raw/invoice.csv'
iam_role IAMROLE
CSV QUOTE AS '"'
DELIMITER AS ',';

TRUNCATE TABLE staging.dim_orders;
COPY staging.dim_orders
FROM 's3://airflow-stg-bucket/raw/orders.csv'
iam_role IAMROLE
CSV QUOTE AS '"'
DELIMITER AS ',';

TRUNCATE TABLE staging.dim_products;
COPY staging.dim_products
FROM 's3://airflow-stg-bucket/raw/products.csv'
iam_role IAMROLE
CSV QUOTE AS '"'
DELIMITER AS ',';

TRUNCATE TABLE staging.dim_suppliers;
COPY staging.dim_suppliers
FROM 's3://airflow-stg-bucket/raw/suppliers.csv'
iam_role IAMROLE
CSV QUOTE AS '"'
DELIMITER AS ',';