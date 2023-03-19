FROM postgres:15.1-alpine

LABEL author="Sathish"
LABEL description="Postgres Image for ecomm system"
LABEL version="1.0"

COPY ecom_db_init.sql /docker-entrypoint-initdb.d/