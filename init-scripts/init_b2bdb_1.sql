CREATE DATABASE b2bdb;

CREATE USER appuser WITH PASSWORD 'appuser@123';
GRANT root TO appuser;
\connect b2bdb;
CREATE SCHEMA IF NOT EXISTS b2bschema AUTHORIZATION appuser;

GRANT ALL PRIVILEGES ON DATABASE b2bdb TO appuser;
GRANT pg_read_server_files TO appuser;
GRANT pg_write_server_files TO appuser;
ALTER ROLE appuser in DATABASE b2bdb SET search_path TO b2bschema;
SET SEARCH_PATH='b2bschema';
DROP TABLE IF EXISTS b2bschema.test_company;
CREATE TABLE b2bschema.test_company (
    company_id character varying(45) NOT NULL,
    company_name character varying(45) DEFAULT NULL::character varying,
    is_supplier boolean,
    country_code character varying(6) NOT NULL
);

COMMIT;