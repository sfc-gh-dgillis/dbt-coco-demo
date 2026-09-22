/*--
  Post-Deploy Script
  ==================
  Imperative operations that DCM cannot manage declaratively:
    - COPY INTO data loading (imperative DML)

  The CSV file format and the S3 external stage are managed declaratively by
  the DCM project; see sources/definitions/storage.sql.

  Run after: snow dcm deploy
  Usage:     snow sql -f dcm/post_deploy.sql -c <connection> --role SYSADMIN

  Source: batch-2/5_load_raw_data.sql
--*/

-- =============================================================================
-- 1. SET CONTEXT
-- =============================================================================
USE ROLE SYSADMIN;
USE DATABASE DEV_DBT_DEMO;
USE SCHEMA RAW;
USE WAREHOUSE DBT_DEMO_L_WH;

-- =============================================================================
-- 2. LOAD DATA VIA COPY INTO
-- =============================================================================

-- Small dimension tables (fast loads)
COPY INTO DEV_DBT_DEMO.RAW.COUNTRY
    FROM @DEV_DBT_DEMO.RAW.S3_TASTYBYTES/raw_pos/country/;

COPY INTO DEV_DBT_DEMO.RAW.FRANCHISE
    FROM @DEV_DBT_DEMO.RAW.S3_TASTYBYTES/raw_pos/franchise/;

COPY INTO DEV_DBT_DEMO.RAW.LOCATION
    FROM @DEV_DBT_DEMO.RAW.S3_TASTYBYTES/raw_pos/location/;

COPY INTO DEV_DBT_DEMO.RAW.MENU
    FROM @DEV_DBT_DEMO.RAW.S3_TASTYBYTES/raw_pos/menu/;

COPY INTO DEV_DBT_DEMO.RAW.TRUCK
    FROM @DEV_DBT_DEMO.RAW.S3_TASTYBYTES/raw_pos/truck/;

COPY INTO DEV_DBT_DEMO.RAW.CUSTOMER_LOYALTY
    FROM @DEV_DBT_DEMO.RAW.S3_TASTYBYTES/raw_customer/customer_loyalty/;

COPY INTO DEV_DBT_DEMO.RAW.CORE_POI_GEOMETRY
    FROM @DEV_DBT_DEMO.RAW.S3_TASTYBYTES/raw_safegraph/;

-- Large fact tables (these take a few minutes)
COPY INTO DEV_DBT_DEMO.RAW.ORDER_HEADER
    FROM @DEV_DBT_DEMO.RAW.S3_TASTYBYTES/raw_pos/order_header/;

COPY INTO DEV_DBT_DEMO.RAW.ORDER_DETAIL
    FROM @DEV_DBT_DEMO.RAW.S3_TASTYBYTES/raw_pos/order_detail/;

-- =============================================================================
-- 3. VERIFY ROW COUNTS
-- =============================================================================
SELECT 'COUNTRY' AS TABLE_NAME, COUNT(*) AS ROW_COUNT FROM DEV_DBT_DEMO.RAW.COUNTRY
UNION ALL SELECT 'FRANCHISE', COUNT(*) FROM DEV_DBT_DEMO.RAW.FRANCHISE
UNION ALL SELECT 'LOCATION', COUNT(*) FROM DEV_DBT_DEMO.RAW.LOCATION
UNION ALL SELECT 'MENU', COUNT(*) FROM DEV_DBT_DEMO.RAW.MENU
UNION ALL SELECT 'TRUCK', COUNT(*) FROM DEV_DBT_DEMO.RAW.TRUCK
UNION ALL SELECT 'ORDER_HEADER', COUNT(*) FROM DEV_DBT_DEMO.RAW.ORDER_HEADER
UNION ALL SELECT 'ORDER_DETAIL', COUNT(*) FROM DEV_DBT_DEMO.RAW.ORDER_DETAIL
UNION ALL SELECT 'CUSTOMER_LOYALTY', COUNT(*) FROM DEV_DBT_DEMO.RAW.CUSTOMER_LOYALTY
UNION ALL SELECT 'CORE_POI_GEOMETRY', COUNT(*) FROM DEV_DBT_DEMO.RAW.CORE_POI_GEOMETRY
ORDER BY TABLE_NAME;
