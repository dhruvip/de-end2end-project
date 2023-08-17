
CREATE TYPE delivery_enum AS ENUM (
    'PENDING',
    'COMPLETED',
    'CANCELLED'
);




--
-- Name: payment_enum; Type: TYPE; Schema:  Owner: appuser
--

CREATE TYPE payment_enum AS ENUM (
    'PENDING',
    'APPROVED',
    'CANCELLED'
);




SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: company; Type: TABLE; Schema:  Owner: appuser
--

CREATE TABLE company (
    company_id character varying(45) NOT NULL,
    company_name character varying(45) DEFAULT NULL::character varying,
    is_supplier boolean,
    country_code character varying(6) NOT NULL
);




--
-- Name: company_products; Type: TABLE; Schema:  Owner: appuser
--

CREATE TABLE company_products (
    id integer NOT NULL,
    company_id character varying(45) DEFAULT NULL::character varying,
    product_id character varying(45) DEFAULT NULL::character varying,
    unit_price numeric(15,2) NOT NULL
);




--
-- Name: country_codes; Type: TABLE; Schema:  Owner: appuser
--

CREATE TABLE country_codes (
    country_name character varying(45) DEFAULT NULL::character varying,
    code character varying(6) NOT NULL,
    start_ip character varying(45) DEFAULT NULL::character varying,
    end_ip character varying(45) DEFAULT NULL::character varying
);




--
-- Name: customers; Type: TABLE; Schema:  Owner: appuser
--

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

CREATE TABLE invoice (
    invoice_id character varying(45) NOT NULL,
    buyer_id character varying(45) DEFAULT NULL::character varying,
    seller_id character varying(45) DEFAULT NULL::character varying,
    amount numeric(15,2) DEFAULT NULL::numeric
);




--
-- Name: order_line_item; Type: TABLE; Schema:  Owner: appuser
--

CREATE TABLE order_line_item (
    id integer NOT NULL,
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

CREATE TABLE orders (
    order_id character varying(45) NOT NULL,
    invoice_id character varying(45) DEFAULT NULL::character varying,
    payment_status payment_enum,
    delivery_status delivery_enum
);




--
-- Name: products; Type: TABLE; Schema:  Owner: appuser
--

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

CREATE TABLE supplier_products (
    id integer NOT NULL,
    supplier_id character varying(45) DEFAULT NULL::character varying,
    product_id character varying(45) DEFAULT NULL::character varying,
    unit_price numeric(15,2) NOT NULL
);




--
-- Name: suppliers; Type: TABLE; Schema:  Owner: appuser
--

CREATE TABLE suppliers (
    supplier_id character varying(45) NOT NULL,
    supplier_name character varying(45) DEFAULT NULL::character varying,
    supplier_reg_address character varying(45) DEFAULT NULL::character varying,
    supplier_email character varying(45) DEFAULT NULL::character varying,
    supplier_phone_number bigint,
    country_code character varying(6) NOT NULL
);




--
-- Data for Name: company; Type: TABLE DATA; Schema:  Owner: appuser
--

INSERT INTO company VALUES ('COM001', 'Sani, Bhatia and Kaur Inc', true, 'BB');
INSERT INTO company VALUES ('COM002', 'Upadhyay LLC Ltd', true, 'AX');
INSERT INTO company VALUES ('COM003', 'Dhingra, Bhattacharyya and Rajagopal Inc', false, 'AD');
INSERT INTO company VALUES ('COM004', 'Bir, Bora and Golla LLC', false, 'AM');
INSERT INTO company VALUES ('COM005', 'Mangat LLC Inc', false, 'AL');
INSERT INTO company VALUES ('COM006', 'Mangat Ltd Group', false, 'AW');
INSERT INTO company VALUES ('COM007', 'Saini, Shroff and Borra Inc', false, 'AM');
INSERT INTO company VALUES ('COM008', 'Thaman-Deshpande Ltd', true, 'AI');
INSERT INTO company VALUES ('COM009', 'Rout Ltd Ltd', false, 'BS');
INSERT INTO company VALUES ('COM010', 'Lalla, Bava and Karpe Ltd', false, 'BS');


--
-- Data for Name: company_products; Type: TABLE DATA; Schema:  Owner: appuser
--

INSERT INTO company_products VALUES (1, 'COM008', 'PROD001', 2.55);
INSERT INTO company_products VALUES (2, 'COM007', 'PROD002', 3.39);
INSERT INTO company_products VALUES (3, 'COM006', 'PROD003', 2.75);
INSERT INTO company_products VALUES (4, 'COM008', 'PROD004', 3.39);
INSERT INTO company_products VALUES (5, 'COM005', 'PROD005', 3.39);
INSERT INTO company_products VALUES (6, 'COM002', 'PROD006', 7.65);
INSERT INTO company_products VALUES (7, 'COM003', 'PROD007', 4.25);
INSERT INTO company_products VALUES (8, 'COM007', 'PROD008', 1.85);
INSERT INTO company_products VALUES (9, 'COM002', 'PROD009', 1.85);
INSERT INTO company_products VALUES (10, 'COM003', 'PROD010', 1.69);
INSERT INTO company_products VALUES (11, 'COM003', 'PROD011', 2.10);
INSERT INTO company_products VALUES (12, 'COM001', 'PROD012', 2.10);
INSERT INTO company_products VALUES (13, 'COM007', 'PROD013', 3.75);
INSERT INTO company_products VALUES (14, 'COM010', 'PROD014', 1.65);
INSERT INTO company_products VALUES (15, 'COM006', 'PROD015', 4.25);
INSERT INTO company_products VALUES (16, 'COM004', 'PROD016', 4.95);
INSERT INTO company_products VALUES (17, 'COM005', 'PROD017', 9.95);
INSERT INTO company_products VALUES (18, 'COM007', 'PROD018', 5.95);
INSERT INTO company_products VALUES (19, 'COM010', 'PROD019', 5.95);
INSERT INTO company_products VALUES (20, 'COM003', 'PROD020', 7.95);
INSERT INTO company_products VALUES (21, 'COM007', 'PROD021', 7.95);
INSERT INTO company_products VALUES (22, 'COM001', 'PROD022', 4.25);
INSERT INTO company_products VALUES (23, 'COM006', 'PROD023', 4.95);
INSERT INTO company_products VALUES (24, 'COM010', 'PROD024', 4.95);
INSERT INTO company_products VALUES (25, 'COM007', 'PROD025', 4.95);
INSERT INTO company_products VALUES (26, 'COM008', 'PROD026', 5.95);
INSERT INTO company_products VALUES (27, 'COM003', 'PROD027', 3.75);
INSERT INTO company_products VALUES (28, 'COM008', 'PROD028', 3.75);
INSERT INTO company_products VALUES (29, 'COM010', 'PROD029', 3.75);
INSERT INTO company_products VALUES (30, 'COM006', 'PROD030', 0.85);
INSERT INTO company_products VALUES (31, 'COM007', 'PROD031', 0.65);
INSERT INTO company_products VALUES (32, 'COM006', 'PROD032', 0.85);
INSERT INTO company_products VALUES (33, 'COM003', 'PROD033', 1.25);
INSERT INTO company_products VALUES (34, 'COM005', 'PROD034', 2.95);
INSERT INTO company_products VALUES (35, 'COM003', 'PROD035', 2.95);
INSERT INTO company_products VALUES (36, 'COM007', 'PROD036', 1.95);
INSERT INTO company_products VALUES (37, 'COM002', 'PROD037', 1.95);
INSERT INTO company_products VALUES (38, 'COM006', 'PROD038', 1.95);
INSERT INTO company_products VALUES (39, 'COM008', 'PROD039', 0.85);
INSERT INTO company_products VALUES (40, 'COM002', 'PROD040', 1.65);
INSERT INTO company_products VALUES (41, 'COM007', 'PROD041', 2.95);
INSERT INTO company_products VALUES (42, 'COM005', 'PROD042', 3.75);
INSERT INTO company_products VALUES (43, 'COM007', 'PROD043', 0.42);
INSERT INTO company_products VALUES (44, 'COM004', 'PROD044', 0.42);
INSERT INTO company_products VALUES (45, 'COM008', 'PROD045', 0.65);
INSERT INTO company_products VALUES (46, 'COM007', 'PROD046', 18.00);
INSERT INTO company_products VALUES (47, 'COM004', 'PROD047', 2.55);
INSERT INTO company_products VALUES (48, 'COM005', 'PROD048', 1.85);
INSERT INTO company_products VALUES (49, 'COM001', 'PROD049', 1.85);
INSERT INTO company_products VALUES (50, 'COM001', 'PROD050', 2.55);
INSERT INTO company_products VALUES (51, 'COM004', 'PROD102', 5.90);
INSERT INTO company_products VALUES (52, 'COM010', 'PROD104', 2.50);
INSERT INTO company_products VALUES (53, 'COM005', 'PROD106', 0.76);


--
-- Data for Name: country_codes; Type: TABLE DATA; Schema:  Owner: appuser
--

INSERT INTO country_codes VALUES ('Afghanistan', 'AF', NULL, NULL);
INSERT INTO country_codes VALUES ('Åland Islands', 'AX', NULL, NULL);
INSERT INTO country_codes VALUES ('Albania', 'AL', NULL, NULL);
INSERT INTO country_codes VALUES ('Algeria', 'DZ', NULL, NULL);
INSERT INTO country_codes VALUES ('American Samoa', 'AS', NULL, NULL);
INSERT INTO country_codes VALUES ('Andorra', 'AD', NULL, NULL);
INSERT INTO country_codes VALUES ('Angola', 'AO', NULL, NULL);
INSERT INTO country_codes VALUES ('Anguilla', 'AI', NULL, NULL);
INSERT INTO country_codes VALUES ('Antarctica', 'AQ', NULL, NULL);
INSERT INTO country_codes VALUES ('Antigua and Barbuda', 'AG', NULL, NULL);
INSERT INTO country_codes VALUES ('Argentina', 'AR', NULL, NULL);
INSERT INTO country_codes VALUES ('Armenia', 'AM', NULL, NULL);
INSERT INTO country_codes VALUES ('Aruba', 'AW', NULL, NULL);
INSERT INTO country_codes VALUES ('Australia', 'AU', NULL, NULL);
INSERT INTO country_codes VALUES ('Austria', 'AT', NULL, NULL);
INSERT INTO country_codes VALUES ('Azerbaijan', 'AZ', NULL, NULL);
INSERT INTO country_codes VALUES ('Bahamas', 'BS', NULL, NULL);
INSERT INTO country_codes VALUES ('Bahrain', 'BH', NULL, NULL);
INSERT INTO country_codes VALUES ('Bangladesh', 'BD', NULL, NULL);
INSERT INTO country_codes VALUES ('Barbados', 'BB', NULL, NULL);


--
-- Data for Name: customers; Type: TABLE DATA; Schema:  Owner: appuser
--

INSERT INTO customers VALUES ('CUST001', 'Veer', 'Sibal', '1964-11-11 00:00:00', '2021-08-10 07:16:41', 'diya76@example.com', 'lgola', 'AG');
INSERT INTO customers VALUES ('CUST002', 'Madhav', 'Krishnan', '1926-07-31 00:00:00', '2022-08-20 05:35:15', 'tanyabatta@example.net', 'hazel92', 'BS');
INSERT INTO customers VALUES ('CUST003', 'Sahil', 'Bawa', '2006-12-15 00:00:00', '2021-09-30 23:13:41', 'anaya81@example.com', 'ndugar', 'AW');
INSERT INTO customers VALUES ('CUST004', 'Navya', 'Chaudry', '1982-10-28 00:00:00', '2023-06-19 10:07:28', 'hverma@example.com', 'swaminathanira', 'AW');
INSERT INTO customers VALUES ('CUST005', 'Abram', 'Batra', '2005-07-29 00:00:00', '2023-02-17 23:07:49', 'rameshbhamini@example.com', 'samihagaba', 'AM');
INSERT INTO customers VALUES ('CUST006', 'Renee', 'Virk', '1916-03-12 00:00:00', '2022-04-01 05:24:30', 'nakulsuri@example.org', 'fbath', 'AT');
INSERT INTO customers VALUES ('CUST007', 'Samar', 'Vora', '1976-10-02 00:00:00', '2023-07-08 11:50:40', 'doraishita@example.com', 'mahalshamik', 'AG');
INSERT INTO customers VALUES ('CUST008', 'Hrishita', 'Chaudry', '2016-06-04 00:00:00', '2022-08-29 06:33:04', 'mbath@example.com', 'kashvi34', 'AZ');
INSERT INTO customers VALUES ('CUST009', 'Kabir', 'Chandra', '2019-06-05 00:00:00', '2022-03-25 11:41:33', 'rameshnirvi@example.com', 'fbanerjee', 'BH');
INSERT INTO customers VALUES ('CUST010', 'Parinaaz', 'Shukla', '1925-05-07 00:00:00', '2022-01-26 17:33:05', 'upadhyaydhanush@example.net', 'ttoor', 'AO');


--
-- Data for Name: invoice; Type: TABLE DATA; Schema:  Owner: appuser
--

INSERT INTO invoice VALUES ('15a5459e-3ce4-11ee-958e-0242c0a85004', 'CUST002', 'COM006', 4.25);
INSERT INTO invoice VALUES ('15a57046-3ce4-11ee-958e-0242c0a85004', 'CUST004', 'COM007', 9.10);
INSERT INTO invoice VALUES ('15a58a18-3ce4-11ee-958e-0242c0a85004', 'CUST005', 'COM007', 234.00);
INSERT INTO invoice VALUES ('15a5a304-3ce4-11ee-958e-0242c0a85004', 'CUST007', 'COM004', 45.90);
INSERT INTO invoice VALUES ('15a5c10e-3ce4-11ee-958e-0242c0a85004', 'COM003', 'SUP010', 14.70);
INSERT INTO invoice VALUES ('15a5e3be-3ce4-11ee-958e-0242c0a85004', 'COM008', 'SUP010', 9.54);
INSERT INTO invoice VALUES ('15a5faa2-3ce4-11ee-958e-0242c0a85004', 'COM002', 'SUP002', 1.06);
INSERT INTO invoice VALUES ('15a61154-3ce4-11ee-958e-0242c0a85004', 'COM006', 'SUP003', 3.30);
INSERT INTO invoice VALUES ('15a62748-3ce4-11ee-958e-0242c0a85004', 'COM005', 'COM002', 38.25);
INSERT INTO invoice VALUES ('15a64e12-3ce4-11ee-958e-0242c0a85004', 'COM005', 'COM008', 30.00);
INSERT INTO invoice VALUES ('15a67162-3ce4-11ee-958e-0242c0a85004', 'COM010', 'COM008', 40.68);
INSERT INTO invoice VALUES ('15a69494-3ce4-11ee-958e-0242c0a85004', 'COM004', 'COM008', 11.90);


--
-- Data for Name: order_line_item; Type: TABLE DATA; Schema:  Owner: appuser
--

INSERT INTO order_line_item VALUES (1, '15a54670-3ce4-11ee-958e-0242c0a85004', '15a5459e-3ce4-11ee-958e-0242c0a85004', 'PROD015', '1', 4.25, '2023-01-27 20:53:49', '2023-03-23 17:57:22');
INSERT INTO order_line_item VALUES (2, '15a57104-3ce4-11ee-958e-0242c0a85004', '15a57046-3ce4-11ee-958e-0242c0a85004', 'PROD031', '14', 9.10, '2023-01-27 20:53:49', '2023-03-23 17:57:22');
INSERT INTO order_line_item VALUES (3, '15a58aae-3ce4-11ee-958e-0242c0a85004', '15a58a18-3ce4-11ee-958e-0242c0a85004', 'PROD046', '13', 234.00, '2023-01-27 20:53:49', '2023-03-23 17:57:22');
INSERT INTO order_line_item VALUES (4, '15a5a390-3ce4-11ee-958e-0242c0a85004', '15a5a304-3ce4-11ee-958e-0242c0a85004', 'PROD047', '18', 45.90, '2023-01-27 20:53:49', '2023-03-23 17:57:22');
INSERT INTO order_line_item VALUES (5, '15a5c1b8-3ce4-11ee-958e-0242c0a85004', '15a5c10e-3ce4-11ee-958e-0242c0a85004', 'PROD060', '7', 14.70, '2023-01-27 20:53:49', '2023-03-23 17:57:22');
INSERT INTO order_line_item VALUES (6, '15a5e45e-3ce4-11ee-958e-0242c0a85004', '15a5e3be-3ce4-11ee-958e-0242c0a85004', 'PROD072', '9', 9.54, '2023-01-27 20:53:49', '2023-03-23 17:57:22');
INSERT INTO order_line_item VALUES (7, '15a5fb2e-3ce4-11ee-958e-0242c0a85004', '15a5faa2-3ce4-11ee-958e-0242c0a85004', 'PROD071', '1', 1.06, '2023-01-27 20:53:49', '2023-03-23 17:57:22');
INSERT INTO order_line_item VALUES (8, '15a611ea-3ce4-11ee-958e-0242c0a85004', '15a61154-3ce4-11ee-958e-0242c0a85004', 'PROD094', '2', 3.30, '2023-01-27 20:53:49', '2023-03-23 17:57:22');
INSERT INTO order_line_item VALUES (9, '15a627d4-3ce4-11ee-958e-0242c0a85004', '15a62748-3ce4-11ee-958e-0242c0a85004', 'PROD006', '5', 38.25, '2023-01-27 20:53:49', '2023-03-23 17:57:22');
INSERT INTO order_line_item VALUES (10, '15a64e94-3ce4-11ee-958e-0242c0a85004', '15a64e12-3ce4-11ee-958e-0242c0a85004', 'PROD028', '8', 30.00, '2023-01-27 20:53:49', '2023-03-23 17:57:22');
INSERT INTO order_line_item VALUES (11, '15a671e4-3ce4-11ee-958e-0242c0a85004', '15a67162-3ce4-11ee-958e-0242c0a85004', 'PROD004', '12', 40.68, '2023-01-27 20:53:49', '2023-03-23 17:57:22');
INSERT INTO order_line_item VALUES (12, '15a69516-3ce4-11ee-958e-0242c0a85004', '15a69494-3ce4-11ee-958e-0242c0a85004', 'PROD039', '14', 11.90, '2023-01-27 20:53:49', '2023-03-23 17:57:22');


--
-- Data for Name: orders; Type: TABLE DATA; Schema:  Owner: appuser
--

INSERT INTO orders VALUES ('15a54670-3ce4-11ee-958e-0242c0a85004', '15a5459e-3ce4-11ee-958e-0242c0a85004', 'CANCELLED', 'COMPLETED');
INSERT INTO orders VALUES ('15a57104-3ce4-11ee-958e-0242c0a85004', '15a57046-3ce4-11ee-958e-0242c0a85004', 'APPROVED', 'COMPLETED');
INSERT INTO orders VALUES ('15a58aae-3ce4-11ee-958e-0242c0a85004', '15a58a18-3ce4-11ee-958e-0242c0a85004', 'PENDING', 'COMPLETED');
INSERT INTO orders VALUES ('15a5a390-3ce4-11ee-958e-0242c0a85004', '15a5a304-3ce4-11ee-958e-0242c0a85004', 'CANCELLED', 'CANCELLED');
INSERT INTO orders VALUES ('15a5c1b8-3ce4-11ee-958e-0242c0a85004', '15a5c10e-3ce4-11ee-958e-0242c0a85004', 'CANCELLED', 'CANCELLED');
INSERT INTO orders VALUES ('15a5e45e-3ce4-11ee-958e-0242c0a85004', '15a5e3be-3ce4-11ee-958e-0242c0a85004', 'PENDING', 'PENDING');
INSERT INTO orders VALUES ('15a5fb2e-3ce4-11ee-958e-0242c0a85004', '15a5faa2-3ce4-11ee-958e-0242c0a85004', 'CANCELLED', 'PENDING');
INSERT INTO orders VALUES ('15a611ea-3ce4-11ee-958e-0242c0a85004', '15a61154-3ce4-11ee-958e-0242c0a85004', 'PENDING', 'CANCELLED');
INSERT INTO orders VALUES ('15a627d4-3ce4-11ee-958e-0242c0a85004', '15a62748-3ce4-11ee-958e-0242c0a85004', 'CANCELLED', 'CANCELLED');
INSERT INTO orders VALUES ('15a64e94-3ce4-11ee-958e-0242c0a85004', '15a64e12-3ce4-11ee-958e-0242c0a85004', 'CANCELLED', 'PENDING');
INSERT INTO orders VALUES ('15a671e4-3ce4-11ee-958e-0242c0a85004', '15a67162-3ce4-11ee-958e-0242c0a85004', 'CANCELLED', 'COMPLETED');
INSERT INTO orders VALUES ('15a69516-3ce4-11ee-958e-0242c0a85004', '15a69494-3ce4-11ee-958e-0242c0a85004', 'APPROVED', 'CANCELLED');


--
-- Data for Name: products; Type: TABLE DATA; Schema:  Owner: appuser
--

INSERT INTO products VALUES ('PROD001', 'WHITE HANGING HEART T-LIGHT HOLDER', 2.55, '2023-06-25 21:18:52', '2023-06-14 18:05:07');
INSERT INTO products VALUES ('PROD002', 'WHITE METAL LANTERN', 3.39, '2022-11-14 01:11:04', '2022-11-24 06:10:16');
INSERT INTO products VALUES ('PROD003', 'CREAM CUPID HEARTS COAT HANGER', 2.75, '2021-12-18 13:04:32', '2023-06-22 15:33:04');
INSERT INTO products VALUES ('PROD004', 'KNITTED UNION FLAG HOT WATER BOTTLE', 3.39, '2021-12-05 15:00:18', '2023-07-21 14:47:56');
INSERT INTO products VALUES ('PROD005', 'RED WOOLLY HOTTIE WHITE HEART.', 3.39, '2023-04-02 00:18:02', '2021-08-06 04:06:22');
INSERT INTO products VALUES ('PROD006', 'SET 7 BABUSHKA NESTING BOXES', 7.65, '2022-09-20 09:40:30', '2022-11-10 22:40:12');
INSERT INTO products VALUES ('PROD007', 'GLASS STAR FROSTED T-LIGHT HOLDER', 4.25, '2022-02-05 05:29:21', '2022-02-22 03:34:31');
INSERT INTO products VALUES ('PROD008', 'HAND WARMER UNION JACK', 1.85, '2023-01-12 20:13:32', '2021-10-21 10:35:23');
INSERT INTO products VALUES ('PROD009', 'HAND WARMER RED POLKA DOT', 1.85, '2021-09-18 16:24:20', '2021-10-17 22:37:17');
INSERT INTO products VALUES ('PROD010', 'ASSORTED COLOUR BIRD ORNAMENT', 1.69, '2022-04-12 01:23:16', '2022-05-17 19:34:39');
INSERT INTO products VALUES ('PROD011', 'POPPY''S PLAYHOUSE BEDROOM ', 2.10, '2021-09-11 09:58:40', '2023-01-27 04:44:19');
INSERT INTO products VALUES ('PROD012', 'POPPY''S PLAYHOUSE KITCHEN', 2.10, '2021-06-20 14:37:04', '2021-11-07 18:28:06');
INSERT INTO products VALUES ('PROD013', 'FELTCRAFT PRINCESS CHARLOTTE DOLL', 3.75, '2023-02-10 04:08:08', '2022-09-01 15:12:50');
INSERT INTO products VALUES ('PROD014', 'IVORY KNITTED MUG COSY ', 1.65, '2023-05-06 04:51:14', '2023-07-07 10:56:25');
INSERT INTO products VALUES ('PROD015', 'BOX OF 6 ASSORTED COLOUR TEASPOONS', 4.25, '2022-05-11 21:42:37', '2023-03-27 13:54:49');
INSERT INTO products VALUES ('PROD016', 'BOX OF VINTAGE JIGSAW BLOCKS ', 4.95, '2021-10-16 09:06:10', '2023-01-01 14:18:11');
INSERT INTO products VALUES ('PROD017', 'BOX OF VINTAGE ALPHABET BLOCKS', 9.95, '2022-05-16 09:14:43', '2022-07-18 17:35:04');
INSERT INTO products VALUES ('PROD018', 'HOME BUILDING BLOCK WORD', 5.95, '2022-02-22 04:30:18', '2023-04-09 06:59:46');
INSERT INTO products VALUES ('PROD019', 'LOVE BUILDING BLOCK WORD', 5.95, '2022-04-02 14:08:23', '2022-12-17 08:31:11');
INSERT INTO products VALUES ('PROD020', 'RECIPE BOX WITH METAL HEART', 7.95, '2021-12-04 01:53:03', '2021-09-15 14:42:28');
INSERT INTO products VALUES ('PROD021', 'DOORMAT NEW ENGLAND', 7.95, '2021-07-21 07:37:12', '2023-05-10 23:13:08');
INSERT INTO products VALUES ('PROD022', 'JAM MAKING SET WITH JARS', 4.25, '2022-04-17 17:22:54', '2021-12-10 03:12:28');
INSERT INTO products VALUES ('PROD023', 'RED COAT RACK PARIS FASHION', 4.95, '2023-07-20 14:40:31', '2023-02-16 14:41:48');
INSERT INTO products VALUES ('PROD024', 'YELLOW COAT RACK PARIS FASHION', 4.95, '2022-07-11 20:09:59', '2022-04-26 08:04:44');
INSERT INTO products VALUES ('PROD025', 'BLUE COAT RACK PARIS FASHION', 4.95, '2021-08-12 19:33:57', '2022-05-09 19:02:11');
INSERT INTO products VALUES ('PROD026', 'BATH BUILDING BLOCK WORD', 5.95, '2022-01-21 18:24:07', '2021-11-17 22:47:19');
INSERT INTO products VALUES ('PROD027', 'ALARM CLOCK BAKELIKE PINK', 3.75, '2022-04-11 22:46:09', '2023-05-21 12:36:06');
INSERT INTO products VALUES ('PROD028', 'ALARM CLOCK BAKELIKE RED ', 3.75, '2023-01-16 15:57:51', '2022-12-22 04:54:20');
INSERT INTO products VALUES ('PROD029', 'ALARM CLOCK BAKELIKE GREEN', 3.75, '2022-01-29 12:03:55', '2021-11-18 03:08:07');
INSERT INTO products VALUES ('PROD030', 'PANDA AND BUNNIES STICKER SHEET', 0.85, '2023-07-06 08:11:38', '2022-01-24 22:44:21');
INSERT INTO products VALUES ('PROD031', 'STARS GIFT TAPE ', 0.65, '2023-02-28 23:12:59', '2023-03-27 21:24:00');
INSERT INTO products VALUES ('PROD032', 'INFLATABLE POLITICAL GLOBE ', 0.85, '2023-07-17 23:58:57', '2022-10-22 08:06:10');
INSERT INTO products VALUES ('PROD033', 'VINTAGE HEADS AND TAILS CARD GAME ', 1.25, '2023-07-22 17:08:03', '2023-07-23 00:48:12');
INSERT INTO products VALUES ('PROD034', 'SET/2 RED RETROSPOT TEA TOWELS ', 2.95, '2022-04-18 04:41:34', '2022-05-14 06:21:48');
INSERT INTO products VALUES ('PROD035', 'ROUND SNACK BOXES SET OF4 WOODLAND ', 2.95, '2021-06-23 11:43:37', '2022-11-18 22:14:37');
INSERT INTO products VALUES ('PROD036', 'SPACEBOY LUNCH BOX ', 1.95, '2022-10-15 19:28:58', '2022-10-21 08:24:45');
INSERT INTO products VALUES ('PROD037', 'LUNCH BOX I LOVE LONDON', 1.95, '2021-08-02 12:15:49', '2022-01-24 21:25:45');
INSERT INTO products VALUES ('PROD038', 'CIRCUS PARADE LUNCH BOX ', 1.95, '2022-07-12 11:09:46', '2022-02-05 14:29:03');
INSERT INTO products VALUES ('PROD039', 'CHARLOTTE BAG DOLLY GIRL DESIGN', 0.85, '2023-01-18 04:14:44', '2022-09-08 17:16:49');
INSERT INTO products VALUES ('PROD040', 'RED TOADSTOOL LED NIGHT LIGHT', 1.65, '2023-06-09 04:51:51', '2021-09-19 11:57:31');
INSERT INTO products VALUES ('PROD041', ' SET 2 TEA TOWELS I LOVE LONDON ', 2.95, '2021-10-17 21:38:09', '2021-08-08 15:26:23');
INSERT INTO products VALUES ('PROD042', 'VINTAGE SEASIDE JIGSAW PUZZLES', 3.75, '2021-09-19 11:47:35', '2022-05-24 01:53:56');
INSERT INTO products VALUES ('PROD043', 'MINI JIGSAW CIRCUS PARADE ', 0.42, '2021-12-28 03:05:08', '2021-08-10 12:46:58');
INSERT INTO products VALUES ('PROD044', 'MINI JIGSAW SPACEBOY', 0.42, '2022-09-18 03:26:07', '2021-07-02 03:46:56');
INSERT INTO products VALUES ('PROD045', 'MINI PAINT SET VINTAGE ', 0.65, '2023-05-06 06:31:29', '2022-11-03 23:21:44');
INSERT INTO products VALUES ('PROD046', 'POSTAGE', 18.00, '2022-02-13 00:52:14', '2022-01-25 14:18:13');
INSERT INTO products VALUES ('PROD047', 'PAPER CHAIN KIT 50''S CHRISTMAS ', 2.55, '2023-05-25 03:21:37', '2023-01-06 05:47:37');
INSERT INTO products VALUES ('PROD048', 'HAND WARMER RED POLKA DOT', 1.85, '2023-08-01 21:39:51', '2023-01-23 04:34:25');
INSERT INTO products VALUES ('PROD049', 'HAND WARMER UNION JACK', 1.85, '2023-07-28 21:48:25', '2021-07-30 15:16:53');
INSERT INTO products VALUES ('PROD050', 'WHITE HANGING HEART T-LIGHT HOLDER', 2.55, '2021-10-27 05:28:19', '2021-10-05 00:44:51');
INSERT INTO products VALUES ('PROD051', 'WHITE METAL LANTERN', 3.39, '2023-04-01 18:00:46', '2022-04-24 14:03:22');
INSERT INTO products VALUES ('PROD052', 'CREAM CUPID HEARTS COAT HANGER', 2.75, '2022-09-01 09:22:22', '2023-03-19 12:08:22');
INSERT INTO products VALUES ('PROD053', 'EDWARDIAN PARASOL RED', 4.95, '2023-06-27 12:08:08', '2023-02-02 00:48:33');
INSERT INTO products VALUES ('PROD054', 'RETRO COFFEE MUGS ASSORTED', 1.06, '2022-06-06 06:04:21', '2021-07-10 05:31:38');
INSERT INTO products VALUES ('PROD055', 'SAVE THE PLANET MUG', 1.06, '2021-06-08 18:53:05', '2022-03-18 02:12:15');
INSERT INTO products VALUES ('PROD056', 'VINTAGE BILLBOARD DRINK ME MUG', 1.06, '2022-09-21 05:46:04', '2023-08-04 18:56:20');
INSERT INTO products VALUES ('PROD057', 'VINTAGE BILLBOARD LOVE/HATE MUG', 1.06, '2022-07-08 16:50:42', '2022-11-07 05:20:14');
INSERT INTO products VALUES ('PROD058', 'WOOD 2 DRAWER CABINET WHITE FINISH', 4.95, '2021-09-18 08:26:00', '2023-07-15 01:17:53');
INSERT INTO products VALUES ('PROD059', 'WOOD S/3 CABINET ANT WHITE FINISH', 6.95, '2022-07-20 10:15:35', '2022-09-21 19:17:42');
INSERT INTO products VALUES ('PROD060', 'WOODEN PICTURE FRAME WHITE FINISH', 2.10, '2023-03-04 07:58:53', '2023-01-26 04:25:25');
INSERT INTO products VALUES ('PROD061', 'WOODEN FRAME ANTIQUE WHITE ', 2.55, '2023-01-25 10:31:01', '2021-09-13 03:05:09');
INSERT INTO products VALUES ('PROD062', 'KNITTED UNION FLAG HOT WATER BOTTLE', 3.39, '2022-02-17 20:38:49', '2021-12-23 04:46:30');
INSERT INTO products VALUES ('PROD063', 'RED WOOLLY HOTTIE WHITE HEART.', 3.39, '2022-06-14 14:40:34', '2022-08-28 09:20:24');
INSERT INTO products VALUES ('PROD064', 'SET 7 BABUSHKA NESTING BOXES', 7.65, '2022-11-09 07:15:09', '2021-09-02 16:06:33');
INSERT INTO products VALUES ('PROD065', 'GLASS STAR FROSTED T-LIGHT HOLDER', 4.25, '2021-08-03 05:37:17', '2023-06-26 03:12:34');
INSERT INTO products VALUES ('PROD066', 'VICTORIAN SEWING BOX LARGE', 10.95, '2023-03-19 13:05:11', '2022-01-13 07:13:32');
INSERT INTO products VALUES ('PROD067', 'WHITE HANGING HEART T-LIGHT HOLDER', 2.55, '2023-07-12 10:41:53', '2021-10-13 04:54:42');
INSERT INTO products VALUES ('PROD068', 'WHITE METAL LANTERN', 3.39, '2022-01-29 13:32:03', '2022-12-08 10:11:54');
INSERT INTO products VALUES ('PROD069', 'CREAM CUPID HEARTS COAT HANGER', 2.75, '2023-03-09 02:19:43', '2021-08-02 01:30:31');
INSERT INTO products VALUES ('PROD070', 'EDWARDIAN PARASOL RED', 4.95, '2023-06-02 18:03:02', '2023-01-30 02:29:54');
INSERT INTO products VALUES ('PROD071', 'RETRO COFFEE MUGS ASSORTED', 1.06, '2023-05-22 06:17:04', '2021-08-20 11:25:31');
INSERT INTO products VALUES ('PROD072', 'SAVE THE PLANET MUG', 1.06, '2021-11-13 01:22:43', '2023-06-09 21:55:59');
INSERT INTO products VALUES ('PROD073', 'VINTAGE BILLBOARD DRINK ME MUG', 1.06, '2022-01-29 13:18:36', '2021-07-09 20:04:06');
INSERT INTO products VALUES ('PROD074', 'VINTAGE BILLBOARD LOVE/HATE MUG', 1.06, '2021-07-28 20:18:40', '2021-12-31 13:23:54');
INSERT INTO products VALUES ('PROD075', 'WOOD 2 DRAWER CABINET WHITE FINISH', 4.95, '2022-10-24 14:12:06', '2021-11-18 23:30:43');
INSERT INTO products VALUES ('PROD076', 'WOOD S/3 CABINET ANT WHITE FINISH', 6.95, '2022-11-28 22:37:48', '2022-04-07 07:03:16');
INSERT INTO products VALUES ('PROD077', 'WOODEN PICTURE FRAME WHITE FINISH', 2.10, '2023-01-25 00:37:25', '2023-07-10 02:21:13');
INSERT INTO products VALUES ('PROD078', 'WOODEN FRAME ANTIQUE WHITE ', 2.55, '2021-11-27 20:10:34', '2021-09-09 20:52:09');
INSERT INTO products VALUES ('PROD079', 'KNITTED UNION FLAG HOT WATER BOTTLE', 3.39, '2023-06-04 03:57:27', '2022-11-15 06:26:43');
INSERT INTO products VALUES ('PROD080', 'RED WOOLLY HOTTIE WHITE HEART.', 3.39, '2021-12-18 13:02:16', '2022-09-11 19:59:47');
INSERT INTO products VALUES ('PROD081', 'SET 7 BABUSHKA NESTING BOXES', 7.65, '2021-12-22 20:52:57', '2023-01-31 14:23:23');
INSERT INTO products VALUES ('PROD082', 'GLASS STAR FROSTED T-LIGHT HOLDER', 4.25, '2022-09-07 19:42:02', '2021-12-14 05:42:47');
INSERT INTO products VALUES ('PROD083', 'HOT WATER BOTTLE TEA AND SYMPATHY', 3.45, '2022-03-29 05:05:39', '2021-08-06 17:31:44');
INSERT INTO products VALUES ('PROD084', 'RED HANGING HEART T-LIGHT HOLDER', 2.55, '2023-02-07 09:42:51', '2023-04-30 01:02:24');
INSERT INTO products VALUES ('PROD085', 'HAND WARMER RED POLKA DOT', 1.85, '2023-01-06 15:28:43', '2022-03-31 07:25:45');
INSERT INTO products VALUES ('PROD086', 'HAND WARMER UNION JACK', 1.85, '2023-05-16 23:04:20', '2022-12-14 07:12:02');
INSERT INTO products VALUES ('PROD087', 'JUMBO BAG PINK POLKADOT', 1.95, '2021-10-03 10:46:27', '2021-08-16 18:14:40');
INSERT INTO products VALUES ('PROD088', 'JUMBO  BAG BAROQUE BLACK WHITE', 1.95, '2021-08-09 12:29:55', '2023-07-03 15:27:35');
INSERT INTO products VALUES ('PROD089', 'JUMBO BAG CHARLIE AND LOLA TOYS', 2.95, '2022-07-10 03:24:12', '2021-07-19 19:43:07');
INSERT INTO products VALUES ('PROD090', 'STRAWBERRY CHARLOTTE BAG', 0.85, '2022-05-09 22:12:22', '2022-05-31 04:04:44');
INSERT INTO products VALUES ('PROD091', 'RED 3 PIECE RETROSPOT CUTLERY SET', 3.75, '2021-10-31 14:57:25', '2023-07-28 21:13:12');
INSERT INTO products VALUES ('PROD092', 'BLUE 3 PIECE POLKADOT CUTLERY SET', 3.75, '2023-03-23 00:47:19', '2023-08-05 04:13:12');
INSERT INTO products VALUES ('PROD093', 'SET/6 RED SPOTTY PAPER PLATES', 0.85, '2022-09-25 16:45:07', '2021-12-01 15:26:36');
INSERT INTO products VALUES ('PROD094', 'LUNCH BAG RED RETROSPOT', 1.65, '2022-01-20 17:38:37', '2023-04-01 03:13:58');
INSERT INTO products VALUES ('PROD095', 'STRAWBERRY LUNCH BOX WITH CUTLERY', 2.55, '2023-03-26 01:19:06', '2021-10-16 22:51:11');
INSERT INTO products VALUES ('PROD096', 'LUNCH BOX WITH CUTLERY RETROSPOT ', 2.55, '2021-11-18 03:49:09', '2023-03-16 02:08:17');
INSERT INTO products VALUES ('PROD097', 'PACK OF 72 RETROSPOT CAKE CASES', 0.42, '2021-09-14 03:50:39', '2021-11-09 12:45:53');
INSERT INTO products VALUES ('PROD098', 'PACK OF 60 DINOSAUR CAKE CASES', 0.55, '2023-03-15 08:15:06', '2022-02-05 23:51:53');
INSERT INTO products VALUES ('PROD099', 'PACK OF 60 PINK PAISLEY CAKE CASES', 0.55, '2021-07-26 02:31:17', '2023-05-03 08:47:15');
INSERT INTO products VALUES ('PROD100', '60 TEATIME FAIRY CAKE CASES', 0.55, '2023-04-09 01:58:25', '2023-03-18 05:31:31');
INSERT INTO products VALUES ('PROD101', 'TOMATO CHARLIE+LOLA COASTER SET', 2.95, '2021-07-25 05:23:48', '2023-07-19 21:25:28');
INSERT INTO products VALUES ('PROD102', 'TOMATO CHARLIE+LOLA COASTER SET', 5.90, '2022-10-25 12:06:55', '2022-07-05 18:59:49');
INSERT INTO products VALUES ('PROD103', 'CHARLIE & LOLA WASTEPAPER BIN FLORA', 1.25, '2021-10-08 10:02:24', '2022-12-08 00:10:35');
INSERT INTO products VALUES ('PROD104', 'CHARLIE & LOLA WASTEPAPER BIN FLORA', 2.50, '2021-09-25 15:59:01', '2021-12-13 23:12:39');
INSERT INTO products VALUES ('PROD105', 'RED CHARLIE+LOLA PERSONAL DOORSIGN', 0.38, '2022-12-18 11:50:43', '2021-07-24 01:11:02');
INSERT INTO products VALUES ('PROD106', 'RED CHARLIE+LOLA PERSONAL DOORSIGN', 0.76, '2022-11-27 01:02:17', '2022-11-30 19:43:58');


--
-- Data for Name: supplier_products; Type: TABLE DATA; Schema:  Owner: appuser
--

INSERT INTO supplier_products VALUES (1, 'SUP003', 'PROD051', 3.39);
INSERT INTO supplier_products VALUES (2, 'SUP008', 'PROD052', 2.75);
INSERT INTO supplier_products VALUES (3, 'SUP009', 'PROD053', 4.95);
INSERT INTO supplier_products VALUES (4, 'SUP010', 'PROD054', 1.06);
INSERT INTO supplier_products VALUES (5, 'SUP005', 'PROD055', 1.06);
INSERT INTO supplier_products VALUES (6, 'SUP006', 'PROD056', 1.06);
INSERT INTO supplier_products VALUES (7, 'SUP002', 'PROD057', 1.06);
INSERT INTO supplier_products VALUES (8, 'SUP006', 'PROD058', 4.95);
INSERT INTO supplier_products VALUES (9, 'SUP003', 'PROD059', 6.95);
INSERT INTO supplier_products VALUES (10, 'SUP010', 'PROD060', 2.10);
INSERT INTO supplier_products VALUES (11, 'SUP008', 'PROD061', 2.55);
INSERT INTO supplier_products VALUES (12, 'SUP002', 'PROD062', 3.39);
INSERT INTO supplier_products VALUES (13, 'SUP008', 'PROD063', 3.39);
INSERT INTO supplier_products VALUES (14, 'SUP004', 'PROD064', 7.65);
INSERT INTO supplier_products VALUES (15, 'SUP009', 'PROD065', 4.25);
INSERT INTO supplier_products VALUES (16, 'SUP010', 'PROD066', 10.95);
INSERT INTO supplier_products VALUES (17, 'SUP008', 'PROD067', 2.55);
INSERT INTO supplier_products VALUES (18, 'SUP003', 'PROD068', 3.39);
INSERT INTO supplier_products VALUES (19, 'SUP007', 'PROD069', 2.75);
INSERT INTO supplier_products VALUES (20, 'SUP004', 'PROD070', 4.95);
INSERT INTO supplier_products VALUES (21, 'SUP002', 'PROD071', 1.06);
INSERT INTO supplier_products VALUES (22, 'SUP010', 'PROD072', 1.06);
INSERT INTO supplier_products VALUES (23, 'SUP002', 'PROD073', 1.06);
INSERT INTO supplier_products VALUES (24, 'SUP008', 'PROD074', 1.06);
INSERT INTO supplier_products VALUES (25, 'SUP008', 'PROD075', 4.95);
INSERT INTO supplier_products VALUES (26, 'SUP005', 'PROD076', 6.95);
INSERT INTO supplier_products VALUES (27, 'SUP005', 'PROD077', 2.10);
INSERT INTO supplier_products VALUES (28, 'SUP005', 'PROD078', 2.55);
INSERT INTO supplier_products VALUES (29, 'SUP001', 'PROD079', 3.39);
INSERT INTO supplier_products VALUES (30, 'SUP009', 'PROD080', 3.39);
INSERT INTO supplier_products VALUES (31, 'SUP009', 'PROD081', 7.65);
INSERT INTO supplier_products VALUES (32, 'SUP007', 'PROD082', 4.25);
INSERT INTO supplier_products VALUES (33, 'SUP010', 'PROD083', 3.45);
INSERT INTO supplier_products VALUES (34, 'SUP005', 'PROD084', 2.55);
INSERT INTO supplier_products VALUES (35, 'SUP003', 'PROD085', 1.85);
INSERT INTO supplier_products VALUES (36, 'SUP004', 'PROD086', 1.85);
INSERT INTO supplier_products VALUES (37, 'SUP004', 'PROD087', 1.95);
INSERT INTO supplier_products VALUES (38, 'SUP005', 'PROD088', 1.95);
INSERT INTO supplier_products VALUES (39, 'SUP005', 'PROD089', 2.95);
INSERT INTO supplier_products VALUES (40, 'SUP008', 'PROD090', 0.85);
INSERT INTO supplier_products VALUES (41, 'SUP009', 'PROD091', 3.75);
INSERT INTO supplier_products VALUES (42, 'SUP006', 'PROD092', 3.75);
INSERT INTO supplier_products VALUES (43, 'SUP010', 'PROD093', 0.85);
INSERT INTO supplier_products VALUES (44, 'SUP003', 'PROD094', 1.65);
INSERT INTO supplier_products VALUES (45, 'SUP001', 'PROD095', 2.55);
INSERT INTO supplier_products VALUES (46, 'SUP002', 'PROD096', 2.55);
INSERT INTO supplier_products VALUES (47, 'SUP009', 'PROD097', 0.42);
INSERT INTO supplier_products VALUES (48, 'SUP003', 'PROD098', 0.55);
INSERT INTO supplier_products VALUES (49, 'SUP005', 'PROD099', 0.55);
INSERT INTO supplier_products VALUES (50, 'SUP008', 'PROD100', 0.55);
INSERT INTO supplier_products VALUES (51, 'SUP003', 'PROD101', 2.95);
INSERT INTO supplier_products VALUES (52, 'SUP004', 'PROD103', 1.25);
INSERT INTO supplier_products VALUES (53, 'SUP005', 'PROD105', 0.38);


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema:  Owner: appuser
--

INSERT INTO suppliers VALUES ('SUP001', 'Sibal-Walia Group', '76/47
Manne Path
Dibrugarh 421948', 'sahilbawa@example.net', 915781565938, 'AQ');
INSERT INTO suppliers VALUES ('SUP002', 'Kant-Verma PLC', '01/60, Koshy, Latur 139332', 'fbath@example.com', 7148418583, 'DZ');
INSERT INTO suppliers VALUES ('SUP003', 'Mahal, Raj and Dhawan Group', 'H.No. 93
Chanda Road
Gaya 947112', 'armaanupadhyay@example.org', 8684833969, 'AM');
INSERT INTO suppliers VALUES ('SUP004', 'Kar-Koshy Ltd', 'H.No. 91, Raj Chowk, Jhansi 041352', 'aaryahi01@example.org', 3098910139, 'BD');
INSERT INTO suppliers VALUES ('SUP005', 'Bhasin, Hayre and Bath LLC', '03/21, Cheema Chowk
Lucknow 914131', 'stuvan62@example.org', 7091634579, 'AQ');
INSERT INTO suppliers VALUES ('SUP006', 'Sarkar Ltd and Sons', '584, Raju Zila
Akola 769845', 'qtoor@example.com', 918071508423, 'AI');
INSERT INTO suppliers VALUES ('SUP007', 'Goda-Ramaswamy LLC', '46/610, Char, Kozhikode 376960', 'sviswanathan@example.net', 271427878, 'BS');
INSERT INTO suppliers VALUES ('SUP008', 'Shroff, Acharya and Wagle Inc', 'H.No. 70
Chandra Marg, Bikaner-665030', 'tatapari@example.net', 1319344217, 'AM');
INSERT INTO suppliers VALUES ('SUP009', 'Ratti-Baria Inc', 'H.No. 428
Bhandari Path, Alwar 003485', 'jiya09@example.net', 7658236940, 'AI');
INSERT INTO suppliers VALUES ('SUP010', 'Borra LLC LLC', '15/900
Bumb Road, Ballia 568241', 'psetty@example.org', 2814654611, 'AO');


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

