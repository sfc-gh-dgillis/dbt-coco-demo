-- =============================================================================
-- Access Control: Roles and Grants
-- Source: batch-1/2_init_roles.sql, batch-1/4_grants.sql
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Roles
-- -----------------------------------------------------------------------------

-- Access roles
DEFINE ROLE DBT_DEMO_RW
    COMMENT = 'Access role for the dev_dbt_demo database with Read and Write permissions to all objects.';

DEFINE ROLE DBT_DEMO_RO
    COMMENT = 'Access role for the dev_dbt_demo database with Read Only permissions to all objects.';

-- Functional roles
DEFINE ROLE DBT_DEMO_DATA_ENGINEER
    COMMENT = 'Functional role for dev_dbt_demo - business function alignment is generally for Data Engineers';

DEFINE ROLE DBT_DEMO_ANALYST
    COMMENT = 'Functional role for dev_dbt_demo - business function alignment is generally for Data Analysts';

-- -----------------------------------------------------------------------------
-- Role Hierarchy
-- -----------------------------------------------------------------------------

-- Access roles -> Functional roles
GRANT ROLE DBT_DEMO_RW TO ROLE DBT_DEMO_DATA_ENGINEER;
GRANT ROLE DBT_DEMO_RO TO ROLE DBT_DEMO_ANALYST;

-- Functional roles -> SYSADMIN
GRANT ROLE DBT_DEMO_DATA_ENGINEER TO ROLE SYSADMIN;
GRANT ROLE DBT_DEMO_ANALYST TO ROLE SYSADMIN;

-- -----------------------------------------------------------------------------
-- Warehouse Usage Grants
-- -----------------------------------------------------------------------------
GRANT USAGE ON WAREHOUSE DBT_DEMO_XS_WH TO ROLE DBT_DEMO_RW;
GRANT USAGE ON WAREHOUSE DBT_DEMO_S_WH TO ROLE DBT_DEMO_RW;
GRANT USAGE ON WAREHOUSE DBT_DEMO_M_WH TO ROLE DBT_DEMO_RW;
GRANT USAGE ON WAREHOUSE DBT_DEMO_L_WH TO ROLE DBT_DEMO_RW;
GRANT USAGE ON WAREHOUSE DBT_DEMO_XL_WH TO ROLE DBT_DEMO_RW;
GRANT USAGE ON WAREHOUSE DBT_DEMO_XXL_WH TO ROLE DBT_DEMO_RW;

-- -----------------------------------------------------------------------------
-- Database Usage Grants
-- -----------------------------------------------------------------------------
GRANT USAGE ON DATABASE DEV_DBT_DEMO TO ROLE DBT_DEMO_RO;
GRANT USAGE ON DATABASE DEV_DBT_DEMO TO ROLE DBT_DEMO_RW;

-- -----------------------------------------------------------------------------
-- Schema Usage Grants
-- -----------------------------------------------------------------------------
GRANT USAGE ON SCHEMA DEV_DBT_DEMO.RAW TO ROLE DBT_DEMO_RO;
GRANT USAGE ON SCHEMA DEV_DBT_DEMO.RAW TO ROLE DBT_DEMO_RW;

GRANT USAGE ON SCHEMA DEV_DBT_DEMO.CURATED TO ROLE DBT_DEMO_RO;
GRANT USAGE ON SCHEMA DEV_DBT_DEMO.CURATED TO ROLE DBT_DEMO_RW;

GRANT USAGE ON SCHEMA DEV_DBT_DEMO.MODELED TO ROLE DBT_DEMO_RO;
GRANT USAGE ON SCHEMA DEV_DBT_DEMO.MODELED TO ROLE DBT_DEMO_RW;

GRANT USAGE ON SCHEMA DEV_DBT_DEMO.UTILITIES TO ROLE DBT_DEMO_RO;
GRANT USAGE ON SCHEMA DEV_DBT_DEMO.UTILITIES TO ROLE DBT_DEMO_RW;

-- -----------------------------------------------------------------------------
-- RAW Schema-Level Grants
-- -----------------------------------------------------------------------------
GRANT CREATE FILE FORMAT ON SCHEMA DEV_DBT_DEMO.RAW TO ROLE DBT_DEMO_RW;
GRANT CREATE TABLE ON SCHEMA DEV_DBT_DEMO.RAW TO ROLE DBT_DEMO_RW;
GRANT CREATE VIEW ON SCHEMA DEV_DBT_DEMO.RAW TO ROLE DBT_DEMO_RW;
GRANT CREATE STAGE ON SCHEMA DEV_DBT_DEMO.RAW TO ROLE DBT_DEMO_RW;
GRANT CREATE PIPE ON SCHEMA DEV_DBT_DEMO.RAW TO ROLE DBT_DEMO_RW;
GRANT CREATE STREAM ON SCHEMA DEV_DBT_DEMO.RAW TO ROLE DBT_DEMO_RW;
GRANT CREATE EXTERNAL TABLE ON SCHEMA DEV_DBT_DEMO.RAW TO ROLE DBT_DEMO_RW;

-- Read-only on RAW tables
GRANT SELECT ON ALL TABLES IN SCHEMA DEV_DBT_DEMO.RAW TO ROLE DBT_DEMO_RO;

-- Read-write on RAW tables
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA DEV_DBT_DEMO.RAW TO ROLE DBT_DEMO_RW;

-- -----------------------------------------------------------------------------
-- CURATED Schema-Level Grants
-- -----------------------------------------------------------------------------
GRANT CREATE TABLE ON SCHEMA DEV_DBT_DEMO.CURATED TO ROLE DBT_DEMO_RW;
GRANT CREATE VIEW ON SCHEMA DEV_DBT_DEMO.CURATED TO ROLE DBT_DEMO_RW;
GRANT CREATE TASK ON SCHEMA DEV_DBT_DEMO.CURATED TO ROLE DBT_DEMO_RW;

-- Read-only on CURATED tables
GRANT SELECT ON ALL TABLES IN SCHEMA DEV_DBT_DEMO.CURATED TO ROLE DBT_DEMO_RO;

-- Read-write on CURATED tables
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA DEV_DBT_DEMO.CURATED TO ROLE DBT_DEMO_RW;

-- -----------------------------------------------------------------------------
-- MODELED Schema-Level Grants
-- -----------------------------------------------------------------------------
GRANT CREATE TABLE ON SCHEMA DEV_DBT_DEMO.MODELED TO ROLE DBT_DEMO_RW;
GRANT CREATE VIEW ON SCHEMA DEV_DBT_DEMO.MODELED TO ROLE DBT_DEMO_RW;
GRANT CREATE DYNAMIC TABLE ON SCHEMA DEV_DBT_DEMO.MODELED TO ROLE DBT_DEMO_RW;

-- Read-only on MODELED
GRANT SELECT ON ALL TABLES IN SCHEMA DEV_DBT_DEMO.MODELED TO ROLE DBT_DEMO_RO;
GRANT SELECT ON ALL VIEWS IN SCHEMA DEV_DBT_DEMO.MODELED TO ROLE DBT_DEMO_RO;

-- Read-write on MODELED tables
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA DEV_DBT_DEMO.MODELED TO ROLE DBT_DEMO_RW;

-- -----------------------------------------------------------------------------
-- UTILITIES Schema-Level Grants
-- -----------------------------------------------------------------------------
GRANT CREATE TABLE ON SCHEMA DEV_DBT_DEMO.UTILITIES TO ROLE DBT_DEMO_RW;
GRANT CREATE VIEW ON SCHEMA DEV_DBT_DEMO.UTILITIES TO ROLE DBT_DEMO_RW;
GRANT CREATE DYNAMIC TABLE ON SCHEMA DEV_DBT_DEMO.UTILITIES TO ROLE DBT_DEMO_RW;
GRANT CREATE FUNCTION ON SCHEMA DEV_DBT_DEMO.UTILITIES TO ROLE DBT_DEMO_RW;

-- Read-only on UTILITIES
GRANT SELECT ON ALL TABLES IN SCHEMA DEV_DBT_DEMO.UTILITIES TO ROLE DBT_DEMO_RO;
GRANT SELECT ON ALL VIEWS IN SCHEMA DEV_DBT_DEMO.UTILITIES TO ROLE DBT_DEMO_RO;
