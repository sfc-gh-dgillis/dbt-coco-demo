-- =============================================================================
-- Access Control: Roles and Grants
--
-- Object-level read/write grants use inherited grants (GRANT INHERITED ... ON ALL)
-- so they apply to current AND future objects in the container. This requires
-- FEATURE_RBAC_INHERITED_GRANTS = 'ENABLED' on the account.
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
GRANT USAGE ON DATABASE {{ db }} TO ROLE DBT_DEMO_RO;
GRANT USAGE ON DATABASE {{ db }} TO ROLE DBT_DEMO_RW;

-- -----------------------------------------------------------------------------
-- Schema Usage Grants
-- -----------------------------------------------------------------------------
GRANT USAGE ON SCHEMA {{ db }}.RAW TO ROLE DBT_DEMO_RO;
GRANT USAGE ON SCHEMA {{ db }}.RAW TO ROLE DBT_DEMO_RW;

GRANT USAGE ON SCHEMA {{ db }}.CURATED TO ROLE DBT_DEMO_RO;
GRANT USAGE ON SCHEMA {{ db }}.CURATED TO ROLE DBT_DEMO_RW;

GRANT USAGE ON SCHEMA {{ db }}.MODELED TO ROLE DBT_DEMO_RO;
GRANT USAGE ON SCHEMA {{ db }}.MODELED TO ROLE DBT_DEMO_RW;

GRANT USAGE ON SCHEMA {{ db }}.UTILITIES TO ROLE DBT_DEMO_RO;
GRANT USAGE ON SCHEMA {{ db }}.UTILITIES TO ROLE DBT_DEMO_RW;

-- -----------------------------------------------------------------------------
-- Account-Level Task Grants
-- -----------------------------------------------------------------------------
GRANT EXECUTE TASK ON ACCOUNT TO ROLE DBT_DEMO_RW;
GRANT EXECUTE MANAGED TASK ON ACCOUNT TO ROLE DBT_DEMO_RW;

-- -----------------------------------------------------------------------------
-- Database-Level Task Grants
-- -----------------------------------------------------------------------------
-- Inherited grant covers all current and future tasks in the database.
GRANT INHERITED OPERATE ON ALL TASKS IN DATABASE {{ db }} TO ROLE DBT_DEMO_RW;

-- -----------------------------------------------------------------------------
-- RAW Schema-Level Grants
-- -----------------------------------------------------------------------------
GRANT CREATE FILE FORMAT ON SCHEMA {{ db }}.RAW TO ROLE DBT_DEMO_RW;
GRANT CREATE TABLE ON SCHEMA {{ db }}.RAW TO ROLE DBT_DEMO_RW;
GRANT CREATE VIEW ON SCHEMA {{ db }}.RAW TO ROLE DBT_DEMO_RW;
GRANT CREATE STAGE ON SCHEMA {{ db }}.RAW TO ROLE DBT_DEMO_RW;
GRANT CREATE PIPE ON SCHEMA {{ db }}.RAW TO ROLE DBT_DEMO_RW;
GRANT CREATE STREAM ON SCHEMA {{ db }}.RAW TO ROLE DBT_DEMO_RW;
GRANT CREATE EXTERNAL TABLE ON SCHEMA {{ db }}.RAW TO ROLE DBT_DEMO_RW;

-- Read-only on RAW
GRANT INHERITED SELECT ON ALL TABLES IN SCHEMA {{ db }}.RAW TO ROLE DBT_DEMO_RO;

-- Read-write on RAW
GRANT INHERITED SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA {{ db }}.RAW TO ROLE DBT_DEMO_RW;
GRANT INHERITED SELECT ON ALL VIEWS IN SCHEMA {{ db }}.RAW TO ROLE DBT_DEMO_RW;
GRANT INHERITED USAGE ON ALL STAGES IN SCHEMA {{ db }}.RAW TO ROLE DBT_DEMO_RW;

-- -----------------------------------------------------------------------------
-- CURATED Schema-Level Grants
-- -----------------------------------------------------------------------------
GRANT CREATE TABLE ON SCHEMA {{ db }}.CURATED TO ROLE DBT_DEMO_RW;
GRANT CREATE VIEW ON SCHEMA {{ db }}.CURATED TO ROLE DBT_DEMO_RW;
GRANT CREATE TASK ON SCHEMA {{ db }}.CURATED TO ROLE DBT_DEMO_RW;

-- Read-only on CURATED
GRANT INHERITED SELECT ON ALL TABLES IN SCHEMA {{ db }}.CURATED TO ROLE DBT_DEMO_RO;

-- Read-write on CURATED
GRANT INHERITED SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA {{ db }}.CURATED TO ROLE DBT_DEMO_RW;
GRANT INHERITED SELECT ON ALL VIEWS IN SCHEMA {{ db }}.CURATED TO ROLE DBT_DEMO_RW;

-- -----------------------------------------------------------------------------
-- MODELED Schema-Level Grants
-- -----------------------------------------------------------------------------
GRANT CREATE TABLE ON SCHEMA {{ db }}.MODELED TO ROLE DBT_DEMO_RW;
GRANT CREATE VIEW ON SCHEMA {{ db }}.MODELED TO ROLE DBT_DEMO_RW;
GRANT CREATE DYNAMIC TABLE ON SCHEMA {{ db }}.MODELED TO ROLE DBT_DEMO_RW;

-- Read-only on MODELED
GRANT INHERITED SELECT ON ALL TABLES IN SCHEMA {{ db }}.MODELED TO ROLE DBT_DEMO_RO;
GRANT INHERITED SELECT ON ALL VIEWS IN SCHEMA {{ db }}.MODELED TO ROLE DBT_DEMO_RO;

-- Read-write on MODELED
GRANT INHERITED SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA {{ db }}.MODELED TO ROLE DBT_DEMO_RW;
GRANT INHERITED SELECT ON ALL VIEWS IN SCHEMA {{ db }}.MODELED TO ROLE DBT_DEMO_RW;

-- -----------------------------------------------------------------------------
-- UTILITIES Schema-Level Grants
-- -----------------------------------------------------------------------------
GRANT CREATE TABLE ON SCHEMA {{ db }}.UTILITIES TO ROLE DBT_DEMO_RW;
GRANT CREATE VIEW ON SCHEMA {{ db }}.UTILITIES TO ROLE DBT_DEMO_RW;
GRANT CREATE DYNAMIC TABLE ON SCHEMA {{ db }}.UTILITIES TO ROLE DBT_DEMO_RW;
GRANT CREATE FUNCTION ON SCHEMA {{ db }}.UTILITIES TO ROLE DBT_DEMO_RW;

-- Read-only on UTILITIES
GRANT INHERITED SELECT ON ALL TABLES IN SCHEMA {{ db }}.UTILITIES TO ROLE DBT_DEMO_RO;
GRANT INHERITED SELECT ON ALL VIEWS IN SCHEMA {{ db }}.UTILITIES TO ROLE DBT_DEMO_RO;
GRANT INHERITED USAGE ON ALL FUNCTIONS IN SCHEMA {{ db }}.UTILITIES TO ROLE DBT_DEMO_RO;

-- Read-write on UTILITIES
GRANT INHERITED SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA {{ db }}.UTILITIES TO ROLE DBT_DEMO_RW;
GRANT INHERITED SELECT ON ALL VIEWS IN SCHEMA {{ db }}.UTILITIES TO ROLE DBT_DEMO_RW;
GRANT INHERITED USAGE ON ALL FUNCTIONS IN SCHEMA {{ db }}.UTILITIES TO ROLE DBT_DEMO_RW;

-- -----------------------------------------------------------------------------
-- Role-to-User Grants
-- IMPORTANT: Update the username below to your own Snowflake username.
-- -----------------------------------------------------------------------------
GRANT ROLE DBT_DEMO_DATA_ENGINEER TO USER tastyb;
