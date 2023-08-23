use staging;
drop table if exists raw_customers; 
create table if not exists raw_customers ( 
    customer_id string,
    f_name string,
    l_name string,
    dob timestamp,
    created_at timestamp,
    email string,
    username string,
    country_code string
);

drop table if exists raw_country_codes; 
create table if not exists raw_country_codes (
    country_name string,
    code string,
    start_ip string,
    end_ip string
);
drop table if exists raw_company; 
CREATE TABLE raw_company (
    company_id string,
    company_name string,
    is_supplier string,
    country_code string
);
drop table if exists raw_invoice; 
CREATE TABLE raw_invoice (
    invoice_id string,
    buyer_id string,
    seller_id string,
    amount decimal(15,2)
);
drop table if exists raw_orders; 
CREATE TABLE raw_orders (
    order_id string,
    invoice_id string,
    payment_status string,
    delivery_status string
);
drop table if exists raw_products; 
CREATE TABLE raw_products (
    product_id string,
    product_name string,
    price decimal(15,2),
    created_at timestamp,
    updated_at timestamp
);
drop table if exists raw_suppliers; 
CREATE TABLE raw_suppliers (
    supplier_id string,
    supplier_name string,
    supplier_reg_address string,
    supplier_email string,
    supplier_phone_number decimal(15,2),
    country_code string
);

drop table if exists raw_supplier_products;
CREATE TABLE raw_supplier_products (
    id int,
    supplier_id string,
    product_id string,
    unit_price decimal(15,2)
);

drop table if exists raw_company_products;
CREATE TABLE raw_company_products (
    id int,
    company_id string,
    product_id string,
    unit_price decimal(15,2)
);

drop table if exists raw_order_line_item;
CREATE TABLE raw_order_line_item (
    id string,
    order_id string,
    invoice_id string,
    product_id string,
    no_of_items string,
    final_amount decimal(15,2),
    created_at timestamp,
    updated_at string
);

drop table if exists raw_marketing_leads;
-- ["lead_id","uname","first_contact_date","campaign_channel","campaign_name","order_id","product_id"]
CREATE TABLE raw_marketing_leads (
    lead_id string,
    uname string,
    first_contact_date string,
    campaign_channel string,
    campaign_name string,
    order_id string,
    product_id string

);

drop table if exists raw_events;

create table raw_events (
    ip string,
    u_ident string,
    username string,
    tstamp string,
    req string,
    statuscode int,
    bytes int,
    refr_path string,
    uagent string
);

load data inpath '/home/dhruvi/dhruvi/Dhruvi-Pandya-3/init-scripts/orders.csv' into table raw_orders;
load data inpath '/home/dhruvi/dhruvi/Dhruvi-Pandya-3/init-scripts/customers.csv' into table raw_customers;
load data inpath '/home/dhruvi/dhruvi/Dhruvi-Pandya-3/init-scripts/company.csv' into table raw_company;
load data inpath '/home/dhruvi/dhruvi/Dhruvi-Pandya-3/init-scripts/suppliers.csv' into table raw_suppliers;
load data inpath '/home/dhruvi/dhruvi/Dhruvi-Pandya-3/init-scripts/invoice.csv' into table raw_invoice;
load data inpath '/home/dhruvi/dhruvi/Dhruvi-Pandya-3/init-scripts/order_line_item.csv' into table raw_order_line_item;
load data inpath '/home/dhruvi/dhruvi/Dhruvi-Pandya-3/init-scripts/products.csv' into table raw_products;
load data inpath '/home/dhruvi/dhruvi/Dhruvi-Pandya-3/init-scripts/company_products.csv' into table raw_company_products;
load data inpath '/home/dhruvi/dhruvi/Dhruvi-Pandya-3/init-scripts/supplier_products.csv' into table raw_supplier_products;
load data inpath '/home/dhruvi/dhruvi/Dhruvi-Pandya-3/init-scripts/country_codes.csv' into table raw_country_codes;
