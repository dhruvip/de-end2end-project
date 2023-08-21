\connect b2bdb;
SET SEARCH_PATH='b2bschema';

DROP TYPE IF EXISTS delivery_enum;
CREATE TYPE delivery_enum AS ENUM (
    'PENDING',
    'COMPLETED',
    'CANCELLED'
);




--
-- Name: payment_enum; Type: TYPE; Schema:  Owner: appuser
--
DROP TYPE IF EXISTS payment_enum;

CREATE TYPE payment_enum AS ENUM (
    'PENDING',
    'APPROVED',
    'CANCELLED'
);


-- Name: company; Type: TABLE; Schema:  Owner: appuser
--
DROP TABLE IF EXISTS company;

CREATE TABLE company (
    company_id character varying(45) NOT NULL,
    company_name character varying(45) DEFAULT NULL::character varying,
    is_supplier boolean,
    country_code character varying(6) NOT NULL
);




--
-- Name: company_products; Type: TABLE; Schema:  Owner: appuser
--
DROP TABLE IF EXISTS company_products;

CREATE TABLE company_products (
    id integer NOT NULL,
    company_id character varying(45) DEFAULT NULL::character varying,
    product_id character varying(45) DEFAULT NULL::character varying,
    unit_price numeric(15,2) NOT NULL
);




--
-- Name: country_codes; Type: TABLE; Schema:  Owner: appuser
--

DROP TABLE IF EXISTS country_codes;
CREATE TABLE country_codes (
    country_name character varying(45) DEFAULT NULL::character varying,
    code character varying(6) NOT NULL,
    start_ip character varying(45) DEFAULT NULL::character varying,
    end_ip character varying(45) DEFAULT NULL::character varying
);




--
-- Name: customers; Type: TABLE; Schema:  Owner: appuser
--

DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customer_id character varying(45) NOT NULL,
    f_name character varying(45) DEFAULT NULL::character varying,
    l_name character varying(45) DEFAULT NULL::character varying,
    dob timestamp without time zone,
    created_at timestamp without time zone,
    email character varying(45) DEFAULT NULL::character varying,
    username character varying(45) DEFAULT NULL::character varying,
    country_code character varying(6) NOT NULL
);




--
-- Name: invoice; Type: TABLE; Schema:  Owner: appuser
--
DROP TABLE IF EXISTS invoice;

CREATE TABLE invoice (
    invoice_id character varying(45) NOT NULL,
    buyer_id character varying(45) DEFAULT NULL::character varying,
    seller_id character varying(45) DEFAULT NULL::character varying,
    amount numeric(15,2) DEFAULT NULL::numeric
);




--
-- Name: order_line_item; Type: TABLE; Schema:  Owner: appuser
--

DROP TABLE IF EXISTS order_line_item;
CREATE TABLE order_line_item (
    id character varying(45) NOT NULL,
    order_id character varying(45) DEFAULT NULL::character varying,
    invoice_id character varying(45) DEFAULT NULL::character varying,
    product_id character varying(45) DEFAULT NULL::character varying,
    no_of_items character varying(45) DEFAULT NULL::character varying,
    final_amount numeric(15,2) DEFAULT NULL::numeric,
    created_at timestamp without time zone,
    updated_at character varying(45) DEFAULT NULL::character varying
);




--
-- Name: orders; Type: TABLE; Schema:  Owner: appuser
--

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id character varying(45) NOT NULL,
    invoice_id character varying(45) DEFAULT NULL::character varying,
    payment_status payment_enum,
    delivery_status delivery_enum
);




--
-- Name: products; Type: TABLE; Schema:  Owner: appuser
--

DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id character varying(45) NOT NULL,
    product_name character varying(45) DEFAULT NULL::character varying,
    price numeric(15,2) DEFAULT NULL::numeric,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);




--
-- Name: supplier_products; Type: TABLE; Schema:  Owner: appuser
--

DROP TABLE IF EXISTS supplier_products;
CREATE TABLE supplier_products (
    id integer NOT NULL,
    supplier_id character varying(45) DEFAULT NULL::character varying,
    product_id character varying(45) DEFAULT NULL::character varying,
    unit_price numeric(15,2) NOT NULL
);




--
-- Name: suppliers; Type: TABLE; Schema:  Owner: appuser
--
DROP TABLE IF EXISTS suppliers;

CREATE TABLE suppliers (
    supplier_id character varying(45) NOT NULL,
    supplier_name character varying(45) DEFAULT NULL::character varying,
    supplier_reg_address character varying(45) DEFAULT NULL::character varying,
    supplier_email character varying(45) DEFAULT NULL::character varying,
    supplier_phone_number bigint,
    country_code character varying(6) NOT NULL
);

--
-- Name: company company_pkey; Type: CONSTRAINT; Schema:  Owner: appuser
--

ALTER TABLE ONLY company
    ADD CONSTRAINT company_pkey PRIMARY KEY (company_id);


--
-- Name: company_products company_products_pkey; Type: CONSTRAINT; Schema:  Owner: appuser
--

ALTER TABLE ONLY company_products
    ADD CONSTRAINT company_products_pkey PRIMARY KEY (id);


--
-- Name: country_codes country_codes_pkey; Type: CONSTRAINT; Schema:  Owner: appuser
--

ALTER TABLE ONLY country_codes
    ADD CONSTRAINT country_codes_pkey PRIMARY KEY (code);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema:  Owner: appuser
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- Name: invoice invoice_pkey; Type: CONSTRAINT; Schema:  Owner: appuser
--

ALTER TABLE ONLY invoice
    ADD CONSTRAINT invoice_pkey PRIMARY KEY (invoice_id);


--
-- Name: order_line_item order_line_item_pkey; Type: CONSTRAINT; Schema:  Owner: appuser
--

ALTER TABLE ONLY order_line_item
    ADD CONSTRAINT order_line_item_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema:  Owner: appuser
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema:  Owner: appuser
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- Name: supplier_products supplier_products_pkey; Type: CONSTRAINT; Schema:  Owner: appuser
--

ALTER TABLE ONLY supplier_products
    ADD CONSTRAINT supplier_products_pkey PRIMARY KEY (id);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema:  Owner: appuser
--

ALTER TABLE ONLY suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (supplier_id);


--
-- PostgreSQL database dump complete
--

