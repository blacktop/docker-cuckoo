#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER cuckoo WITH PASSWORD cuckoo;
    CREATE DATABASE cuckoo;
    GRANT ALL PRIVILEGES ON DATABASE cuckoo TO cuckoo;
EOSQL
