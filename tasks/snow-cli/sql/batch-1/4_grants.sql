USE ROLE accountadmin;
-- -----------------------------------------------------------------------
-- Task Account Grants
-- -----------------------------------------------------------------------
GRANT EXECUTE TASK ON ACCOUNT TO ROLE dbt_demo_rw;
GRANT EXECUTE MANAGED TASK ON ACCOUNT TO ROLE dbt_demo_rw;

USE ROLE securityadmin;
-- -----------------------------------------------------------------------
-- Warehouse Usage Grants
-- -----------------------------------------------------------------------
GRANT USAGE on WAREHOUSE dbt_demo_xs_wh TO ROLE dbt_demo_rw;
GRANT USAGE on WAREHOUSE dbt_demo_s_wh TO ROLE dbt_demo_rw;
GRANT USAGE on WAREHOUSE dbt_demo_m_wh TO ROLE dbt_demo_rw;
GRANT USAGE on WAREHOUSE dbt_demo_l_wh TO ROLE dbt_demo_rw;
GRANT USAGE on WAREHOUSE dbt_demo_xl_wh TO ROLE dbt_demo_rw;
GRANT USAGE on WAREHOUSE dbt_demo_xxl_wh TO ROLE dbt_demo_rw;

-- -----------------------------------------------------------------------
-- Database Usage Grants
-- -----------------------------------------------------------------------
GRANT USAGE ON DATABASE dev_dbt_demo TO ROLE dbt_demo_ro;
GRANT USAGE ON DATABASE dev_dbt_demo TO ROLE dbt_demo_rw;

-- -----------------------------------------------------------------------
-- Database Task Grants
-- -----------------------------------------------------------------------
GRANT OPERATE ON ALL TASKS IN DATABASE dev_dbt_demo TO ROLE dbt_demo_rw;
GRANT OPERATE ON FUTURE TASKS IN DATABASE dev_dbt_demo TO ROLE dbt_demo_rw;

-- -----------------------------------------------------------------------
-- Schema Usage Grants
-- -----------------------------------------------------------------------
GRANT USAGE ON SCHEMA dev_dbt_demo.raw TO ROLE dbt_demo_ro;
GRANT USAGE ON SCHEMA dev_dbt_demo.raw TO ROLE dbt_demo_rw;

GRANT USAGE ON SCHEMA dev_dbt_demo.curated TO ROLE dbt_demo_ro;
GRANT USAGE ON SCHEMA dev_dbt_demo.curated TO ROLE dbt_demo_rw;

GRANT USAGE ON SCHEMA dev_dbt_demo.modeled TO ROLE dbt_demo_ro;
GRANT USAGE ON SCHEMA dev_dbt_demo.modeled TO ROLE dbt_demo_rw;

GRANT USAGE ON FUTURE STAGES IN SCHEMA dev_dbt_demo.raw TO ROLE dbt_demo_rw;

GRANT USAGE ON SCHEMA dev_dbt_demo.utilities TO ROLE dbt_demo_ro;
GRANT USAGE ON SCHEMA dev_dbt_demo.utilities TO ROLE dbt_demo_rw;

-- -----------------------------------------------------------------------
-- RAW Schema-Level Read/Write Grants
-- -----------------------------------------------------------------------
GRANT CREATE FILE FORMAT ON SCHEMA dev_dbt_demo.raw TO ROLE dbt_demo_rw;
GRANT CREATE TABLE ON SCHEMA dev_dbt_demo.raw TO ROLE dbt_demo_rw;
GRANT CREATE VIEW ON SCHEMA dev_dbt_demo.raw TO ROLE dbt_demo_rw;
GRANT CREATE STAGE ON SCHEMA dev_dbt_demo.raw TO ROLE dbt_demo_rw;
GRANT CREATE PIPE ON SCHEMA dev_dbt_demo.raw TO ROLE dbt_demo_rw;
GRANT CREATE STREAM ON SCHEMA dev_dbt_demo.raw TO ROLE dbt_demo_rw;
GRANT CREATE EXTERNAL TABLE ON SCHEMA dev_dbt_demo.raw TO ROLE dbt_demo_rw;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA dev_dbt_demo.raw TO ROLE dbt_demo_rw;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA dev_dbt_demo.raw TO ROLE dbt_demo_rw;

-- -----------------------------------------------------------------------
-- RAW Schema-Level Read Only Grants
-- -----------------------------------------------------------------------
GRANT SELECT ON FUTURE TABLES IN SCHEMA dev_dbt_demo.raw TO ROLE dbt_demo_ro;

-- -----------------------------------------------------------------------
-- CURATED Schema-Level Read/Write Grants
-- -----------------------------------------------------------------------
GRANT CREATE TABLE ON SCHEMA dev_dbt_demo.curated TO ROLE dbt_demo_rw;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA dev_dbt_demo.curated TO ROLE dbt_demo_rw;

GRANT CREATE VIEW ON SCHEMA dev_dbt_demo.curated TO ROLE dbt_demo_rw;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA dev_dbt_demo.curated TO ROLE dbt_demo_rw;
GRANT CREATE TASK ON SCHEMA dev_dbt_demo.curated TO ROLE dbt_demo_rw;

-- -----------------------------------------------------------------------
-- CURATED Schema-Level Read Only Grants
-- -----------------------------------------------------------------------
GRANT SELECT ON FUTURE TABLES IN SCHEMA dev_dbt_demo.curated TO ROLE dbt_demo_ro;

-- -----------------------------------------------------------------------
-- MODELED Schema-Level Read/Write Grants
-- -----------------------------------------------------------------------
GRANT CREATE TABLE ON SCHEMA dev_dbt_demo.modeled TO ROLE dbt_demo_rw;
GRANT CREATE VIEW ON SCHEMA dev_dbt_demo.modeled TO ROLE dbt_demo_rw;
GRANT CREATE DYNAMIC TABLE ON SCHEMA dev_dbt_demo.modeled TO ROLE dbt_demo_rw;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA dev_dbt_demo.modeled TO ROLE dbt_demo_rw;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA dev_dbt_demo.modeled TO ROLE dbt_demo_rw;

-- -----------------------------------------------------------------------
-- MODELED Schema-Level Read Only Grants
-- -----------------------------------------------------------------------
GRANT SELECT ON FUTURE TABLES IN SCHEMA dev_dbt_demo.modeled TO ROLE dbt_demo_ro;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA dev_dbt_demo.modeled TO ROLE dbt_demo_ro;

-- -----------------------------------------------------------------------
-- UTILITIES Schema-Level Read/Write Grants
-- -----------------------------------------------------------------------
GRANT CREATE TABLE ON SCHEMA dev_dbt_demo.utilities TO ROLE dbt_demo_rw;
GRANT CREATE VIEW ON SCHEMA dev_dbt_demo.utilities TO ROLE dbt_demo_rw;
GRANT CREATE DYNAMIC TABLE ON SCHEMA dev_dbt_demo.utilities TO ROLE dbt_demo_rw;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA dev_dbt_demo.utilities TO ROLE dbt_demo_rw;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA dev_dbt_demo.utilities TO ROLE dbt_demo_rw;
GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA dev_dbt_demo.utilities TO ROLE dbt_demo_rw;
GRANT CREATE FUNCTION ON SCHEMA dev_dbt_demo.utilities TO ROLE dbt_demo_rw;

-- -----------------------------------------------------------------------
-- UTILITIES Schema-Level Read Only Grants
-- -----------------------------------------------------------------------
GRANT SELECT ON FUTURE TABLES IN SCHEMA dev_dbt_demo.utilities TO ROLE dbt_demo_ro;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA dev_dbt_demo.utilities TO ROLE dbt_demo_ro;
GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA dev_dbt_demo.utilities TO ROLE dbt_demo_ro;

-- -----------------------------------------------------------------------
-- ROLE to ROLE Grants
-- -----------------------------------------------------------------------
GRANT ROLE dbt_demo_rw TO ROLE dbt_demo_data_engineer;
GRANT ROLE dbt_demo_ro TO ROLE dbt_demo_analyst;

-- -----------------------------------------------------------------------
-- ROLE to USER Grants
-- -----------------------------------------------------------------------
GRANT ROLE dbt_demo_data_engineer to USER tastyb;
