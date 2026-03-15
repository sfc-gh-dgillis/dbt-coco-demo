USE ROLE sysadmin;

CREATE DATABASE IF NOT EXISTS dev_dbt_demo
    COMMENT = 'dbt demo database';

CREATE SCHEMA IF NOT EXISTS dev_dbt_demo.raw
    COMMENT = 'dbt demo - RAW data landing schema';

CREATE SCHEMA IF NOT EXISTS dev_dbt_demo.curated
    COMMENT = 'dbt demo - Curated object schema';

CREATE SCHEMA IF NOT EXISTS dev_dbt_demo.modeled
    COMMENT = 'dbt demo - Modeled object schema';

CREATE SCHEMA IF NOT EXISTS dev_dbt_demo.utilities
    COMMENT = 'dbt demo - global utilities and tools';

SHOW DATABASES;

USE DATABASE dev_dbt_demo;
SHOW SCHEMAS;
