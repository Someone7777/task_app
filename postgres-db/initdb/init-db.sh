#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL¡
    CREATE DATABASE taskappdb;
    CREATE USER taskapp_api_user WITH PASSWORD '${TASKAPP_USER_PASSWORD}';
    GRANT ALL PRIVILEGES ON DATABASE taskappdb TO taskapp_api_user;
    ALTER DATABASE taskappdb OWNER TO taskapp_api_user;
EOSQL