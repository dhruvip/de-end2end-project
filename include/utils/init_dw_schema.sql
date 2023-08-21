SET search_path TO 'staging';
drop table if exists raw_customers; 
create table if not exists raw_customers ( 
    customer_id character varying(45) NOT NULL,
    f_name character varying(45) DEFAULT NULL::character varying,
    l_name character varying(45) DEFAULT NULL::character varying,
    dob timestamp without time zone,
    created_at timestamp without time zone,
    email character varying(45) DEFAULT NULL::character varying,
    username character varying(45) DEFAULT NULL::character varying,
    country_code character varying(6) NOT NULL 
) sortkey(customer_id) ;

drop table if exists raw_country_codes; 
create table if not exists raw_country_codes (
    country_name character varying(45) DEFAULT NULL::character varying,
    code character varying(6) NOT NULL,
    start_ip character varying(45) DEFAULT NULL::character varying,
    end_ip character varying(45) DEFAULT NULL::character varying
);
drop table if exists raw_company; 
CREATE TABLE raw_company (
    company_id character varying(45) NOT NULL,
    company_name character varying(45) DEFAULT NULL::character varying,
    is_supplier character varying(1),
    country_code character varying(6) NOT NULL
);
drop table if exists raw_invoice; 
CREATE TABLE raw_invoice (
    invoice_id character varying(45) NOT NULL,
    buyer_id character varying(45) DEFAULT NULL::character varying,
    seller_id character varying(45) DEFAULT NULL::character varying,
    amount numeric(15,2) DEFAULT NULL::numeric
);
drop table if exists raw_orders; 
CREATE TABLE raw_orders (
    order_id character varying(45) NOT NULL,
    invoice_id character varying(45) DEFAULT NULL::character varying,
    payment_status character varying(20),
    delivery_status character varying(20)
);
drop table if exists raw_products; 
CREATE TABLE raw_products (
    product_id character varying(45) NOT NULL,
    product_name character varying(45) DEFAULT NULL::character varying,
    price numeric(15,2) DEFAULT NULL::numeric,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
drop table if exists raw_suppliers; 
CREATE TABLE raw_suppliers (
    supplier_id character varying(45) NOT NULL,
    supplier_name character varying(45) DEFAULT NULL::character varying,
    supplier_reg_address character varying(45) DEFAULT NULL::character varying,
    supplier_email character varying(45) DEFAULT NULL::character varying,
    supplier_phone_number bigint,
    country_code character varying(6) NOT NULL
);

drop table if exists raw_supplier_products;
CREATE TABLE raw_supplier_products (
    id integer NOT NULL,
    supplier_id character varying(45) DEFAULT NULL::character varying,
    product_id character varying(45) DEFAULT NULL::character varying,
    unit_price numeric(15,2) NOT NULL
);

drop table if exists raw_company_products;
CREATE TABLE raw_company_products (
    id integer NOT NULL,
    company_id character varying(45) DEFAULT NULL::character varying,
    product_id character varying(45) DEFAULT NULL::character varying,
    unit_price numeric(15,2) NOT NULL
);

drop table if exists raw_order_line_item;
CREATE TABLE raw_order_line_item (
    id character varying(45) NOT NULL,
    order_id character varying(45) DEFAULT NULL::character varying,
    invoice_id character varying(45) DEFAULT NULL::character varying,
    product_id character varying(45) DEFAULT NULL::character varying,
    no_of_items character varying(45) DEFAULT NULL::character varying,
    final_amount numeric(15,2) DEFAULT NULL::numeric,
    created_at timestamp without time zone,
    updated_at character varying(45) DEFAULT NULL::character varying
);

drop table if exists raw_marketing_leads;
-- ["lead_id","uname","first_contact_date","campaign_channel","campaign_name","order_id","product_id"]
CREATE TABLE raw_marketing_leads (
    lead_id character varying(45) NOT NULL,
    uname character varying(45) NOT NULL,
    first_contact_date character varying(45) NOT NULL,
    campaign_channel character varying(45) NOT NULL,
    campaign_name character varying(45) NOT NULL,
    order_id character varying(45) NOT NULL,
    product_id character varying(45) NOT NULL

);

drop table if exists raw_events;

create table raw_events (
    ip character varying(45),
    u_ident character varying(45),
    username character varying(45),
    tstamp character varying(45),
    req character varying(45),
    statuscode int,
    bytes int,
    refr_path character varying(45),
    uagent character varying(100)
);