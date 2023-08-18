SET search_path TO 'staging';
drop table if exists dim_customers; 
create table if not exists dim_customers ( 
    customer_id character varying(45) NOT NULL,
    f_name character varying(45) DEFAULT NULL::character varying,
    l_name character varying(45) DEFAULT NULL::character varying,
    dob timestamp without time zone,
    created_at timestamp without time zone,
    email character varying(45) DEFAULT NULL::character varying,
    username character varying(45) DEFAULT NULL::character varying,
    country_code character varying(6) NOT NULL 
) sortkey(customer_id) ;

drop table if exists dim_country_codes; 
create table if not exists dim_country_codes (
    country_name character varying(45) DEFAULT NULL::character varying,
    code character varying(6) NOT NULL,
    start_ip character varying(45) DEFAULT NULL::character varying,
    end_ip character varying(45) DEFAULT NULL::character varying
);
drop table if exists dim_company; 
CREATE TABLE dim_company (
    company_id character varying(45) NOT NULL,
    company_name character varying(45) DEFAULT NULL::character varying,
    is_supplier character varying(1),
    country_code character varying(6) NOT NULL
);
drop table if exists dim_invoice; 
CREATE TABLE dim_invoice (
    invoice_id character varying(45) NOT NULL,
    buyer_id character varying(45) DEFAULT NULL::character varying,
    seller_id character varying(45) DEFAULT NULL::character varying,
    amount numeric(15,2) DEFAULT NULL::numeric
);
drop table if exists dim_orders; 
CREATE TABLE dim_orders (
    order_id character varying(45) NOT NULL,
    invoice_id character varying(45) DEFAULT NULL::character varying,
    payment_status character varying(20),
    delivery_status character varying(20)
);
drop table if exists dim_products; 
CREATE TABLE dim_products (
    product_id character varying(45) NOT NULL,
    product_name character varying(45) DEFAULT NULL::character varying,
    price numeric(15,2) DEFAULT NULL::numeric,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
drop table if exists dim_suppliers; 
CREATE TABLE dim_suppliers (
    supplier_id character varying(45) NOT NULL,
    supplier_name character varying(45) DEFAULT NULL::character varying,
    supplier_reg_address character varying(45) DEFAULT NULL::character varying,
    supplier_email character varying(45) DEFAULT NULL::character varying,
    supplier_phone_number bigint,
    country_code character varying(6) NOT NULL
);