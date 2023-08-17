CREATE DATABASE b2bdb;

CREATE USER appuser WITH PASSWORD 'appuser@123';

GRANT ALL PRIVILEGES ON DATABASE b2bdb TO appuser;
GRANT pg_read_server_files TO appuser;