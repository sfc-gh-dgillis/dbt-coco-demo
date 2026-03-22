-- =============================================================================
-- Infrastructure: Database, Schemas, and Warehouses
-- Source: batch-1/1_create_warehouses.sql, batch-1/3_create_db_schema.sql
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Database
-- -----------------------------------------------------------------------------
DEFINE DATABASE DEV_DBT_DEMO
    COMMENT = 'dbt demo database';

-- -----------------------------------------------------------------------------
-- Schemas
-- -----------------------------------------------------------------------------
DEFINE SCHEMA DEV_DBT_DEMO.RAW
    COMMENT = 'dbt demo - RAW data landing schema';

DEFINE SCHEMA DEV_DBT_DEMO.CURATED
    COMMENT = 'dbt demo - Curated object schema';

DEFINE SCHEMA DEV_DBT_DEMO.MODELED
    COMMENT = 'dbt demo - Modeled object schema';

DEFINE SCHEMA DEV_DBT_DEMO.UTILITIES
    COMMENT = 'dbt demo - global utilities and tools';

-- -----------------------------------------------------------------------------
-- Warehouses
-- -----------------------------------------------------------------------------
DEFINE WAREHOUSE DBT_DEMO_XS_WH
    WITH WAREHOUSE_SIZE = XSMALL
    INITIALLY_SUSPENDED = TRUE;

DEFINE WAREHOUSE DBT_DEMO_S_WH
    WITH WAREHOUSE_SIZE = SMALL
    INITIALLY_SUSPENDED = TRUE;

DEFINE WAREHOUSE DBT_DEMO_M_WH
    WITH WAREHOUSE_SIZE = MEDIUM
    INITIALLY_SUSPENDED = TRUE;

DEFINE WAREHOUSE DBT_DEMO_L_WH
    WITH WAREHOUSE_SIZE = LARGE
    INITIALLY_SUSPENDED = TRUE;

DEFINE WAREHOUSE DBT_DEMO_XL_WH
    WITH WAREHOUSE_SIZE = XLARGE
    INITIALLY_SUSPENDED = TRUE;

DEFINE WAREHOUSE DBT_DEMO_XXL_WH
    WITH WAREHOUSE_SIZE = XXLARGE
    INITIALLY_SUSPENDED = TRUE;
