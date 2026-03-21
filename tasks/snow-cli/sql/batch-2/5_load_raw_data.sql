/*--
  Tasty Bytes - Raw Data Load
  ============================
  Loads all 9 raw source tables from the public Snowflake quickstart S3 stage
  into DEV_DBT_DEMO.RAW.

  Prerequisites:
    - Run batch-1 scripts (1-4) first to create database, schemas, roles, and grants.
    - Use a role with CREATE TABLE, CREATE STAGE, CREATE FILE FORMAT on DEV_DBT_DEMO.RAW.

  Data source: s3://sfquickstarts/frostbyte_tastybytes/
  Estimated load time: ~5-10 minutes (order_header and order_detail are large).

  Usage:
    Execute this entire script in a Snowflake worksheet or via SnowSQL.
    Statements are ordered and should be run sequentially.
--*/

-- =============================================================================
-- 1. SET CONTEXT
-- =============================================================================
USE ROLE sysadmin;
USE DATABASE dev_dbt_demo;
USE SCHEMA raw;
USE WAREHOUSE dbt_demo_l_wh;  -- Use L warehouse for bulk loading

-- =============================================================================
-- 2. CREATE FILE FORMAT AND EXTERNAL STAGE
-- =============================================================================
CREATE OR REPLACE FILE FORMAT dev_dbt_demo.raw.csv_ff
    TYPE = 'CSV'
    COMPRESSION = 'AUTO'
    FIELD_DELIMITER = ','
    RECORD_DELIMITER = '\n'
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    TRIM_SPACE = FALSE
    ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
    NULL_IF = ('NULL', 'null', '');

CREATE OR REPLACE STAGE dev_dbt_demo.raw.s3_tastybytes
    COMMENT = 'Public S3 stage for Tasty Bytes quickstart data'
    URL = 's3://sfquickstarts/frostbyte_tastybytes/'
    FILE_FORMAT = dev_dbt_demo.raw.csv_ff;

-- =============================================================================
-- 3. CREATE RAW TABLES
-- =============================================================================

-- 3a. COUNTRY (POS)
CREATE OR REPLACE TABLE dev_dbt_demo.raw.country (
    country_id      NUMBER(18,0),
    country         VARCHAR,
    iso_currency    VARCHAR(3),
    iso_country     VARCHAR(2),
    city_id         NUMBER(19,0),
    city            VARCHAR,
    city_population NUMBER
);

-- 3b. FRANCHISE (POS)
CREATE OR REPLACE TABLE dev_dbt_demo.raw.franchise (
    franchise_id    NUMBER(38,0),
    first_name      VARCHAR,
    last_name       VARCHAR,
    city            VARCHAR,
    country         VARCHAR,
    e_mail          VARCHAR,
    phone_number    VARCHAR
);

-- 3c. LOCATION (POS)
CREATE OR REPLACE TABLE dev_dbt_demo.raw.location (
    location_id      NUMBER(19,0),
    placekey         VARCHAR,
    location         VARCHAR,
    city             VARCHAR,
    region           VARCHAR,
    iso_country_code VARCHAR,
    country          VARCHAR
);

-- 3d. MENU (POS)
CREATE OR REPLACE TABLE dev_dbt_demo.raw.menu (
    menu_id                       NUMBER(19,0),
    menu_type_id                  NUMBER(38,0),
    menu_type                     VARCHAR,
    truck_brand_name              VARCHAR,
    menu_item_id                  NUMBER(38,0),
    menu_item_name                VARCHAR,
    item_category                 VARCHAR,
    item_subcategory              VARCHAR,
    cost_of_goods_usd             NUMBER(38,4),
    sale_price_usd                NUMBER(38,4),
    menu_item_health_metrics_obj  VARIANT
);

-- 3e. TRUCK (POS)
CREATE OR REPLACE TABLE dev_dbt_demo.raw.truck (
    truck_id           NUMBER(38,0),
    menu_type_id       NUMBER(38,0),
    primary_city       VARCHAR,
    region             VARCHAR,
    iso_region         VARCHAR,
    country            VARCHAR,
    iso_country_code   VARCHAR,
    franchise_flag     NUMBER(38,0),
    year               NUMBER(38,0),
    make               VARCHAR,
    model              VARCHAR,
    ev_flag            NUMBER(38,0),
    franchise_id       NUMBER(38,0),
    truck_opening_date DATE,
    truck_type         VARCHAR
);

-- 3f. ORDER_HEADER (POS) - ~248M rows
CREATE OR REPLACE TABLE dev_dbt_demo.raw.order_header (
    order_id              NUMBER(38,0),
    truck_id              NUMBER(38,0),
    location_id           FLOAT,
    customer_id           NUMBER(38,0),
    discount_id           VARCHAR,
    shift_id              NUMBER(38,0),
    shift_start_time      TIME(9),
    shift_end_time        TIME(9),
    order_channel         VARCHAR,
    order_ts              TIMESTAMP_NTZ(9),
    served_ts             VARCHAR,
    order_currency        VARCHAR(3),
    order_amount          NUMBER(38,4),
    order_tax_amount      VARCHAR,
    order_discount_amount VARCHAR,
    order_total           NUMBER(38,4)
);

-- 3g. ORDER_DETAIL (POS) - ~674M rows
CREATE OR REPLACE TABLE dev_dbt_demo.raw.order_detail (
    order_detail_id            NUMBER(38,0),
    order_id                   NUMBER(38,0),
    menu_item_id               NUMBER(38,0),
    discount_id                VARCHAR,
    line_number                NUMBER(38,0),
    quantity                   NUMBER(5,0),
    unit_price                 NUMBER(38,4),
    price                      NUMBER(38,4),
    order_item_discount_amount VARCHAR
);

-- 3h. CUSTOMER_LOYALTY (Customer)
CREATE OR REPLACE TABLE dev_dbt_demo.raw.customer_loyalty (
    customer_id        NUMBER(38,0),
    first_name         VARCHAR,
    last_name          VARCHAR,
    city               VARCHAR,
    country            VARCHAR,
    postal_code        VARCHAR,
    preferred_language VARCHAR,
    gender             VARCHAR,
    favourite_brand    VARCHAR,
    marital_status     VARCHAR,
    children_count     VARCHAR,
    sign_up_date       DATE,
    birthday_date      DATE,
    e_mail             VARCHAR,
    phone_number       VARCHAR
);

-- 3i. CORE_POI_GEOMETRY (SafeGraph)
CREATE OR REPLACE TABLE dev_dbt_demo.raw.core_poi_geometry (
    placekey             VARCHAR,
    parent_placekey      VARCHAR,
    safegraph_brand_ids  VARCHAR,
    location_name        VARCHAR,
    brands               VARCHAR,
    store_id             VARCHAR,
    top_category         VARCHAR,
    sub_category         VARCHAR,
    naics_code           NUMBER,
    latitude             FLOAT,
    longitude            FLOAT,
    street_address       VARCHAR,
    city                 VARCHAR,
    region               VARCHAR,
    postal_code          VARCHAR,
    open_hours           VARIANT,
    category_tags        VARCHAR,
    opened_on            VARCHAR,
    closed_on            VARCHAR,
    tracking_closed_since VARCHAR,
    geometry_type        VARCHAR,
    polygon_wkt          VARCHAR,
    polygon_class        VARCHAR,
    enclosed             BOOLEAN,
    phone_number         VARCHAR,
    is_synthetic         BOOLEAN,
    includes_parking_lot BOOLEAN,
    iso_country_code     VARCHAR,
    wkt_area_sq_meters   FLOAT,
    country              VARCHAR
);

-- =============================================================================
-- 4. LOAD DATA VIA COPY INTO
-- =============================================================================

-- 4a. Small dimension tables (fast loads)
COPY INTO dev_dbt_demo.raw.country
    FROM @dev_dbt_demo.raw.s3_tastybytes/raw_pos/country/;

COPY INTO dev_dbt_demo.raw.franchise
    FROM @dev_dbt_demo.raw.s3_tastybytes/raw_pos/franchise/;

COPY INTO dev_dbt_demo.raw.location
    FROM @dev_dbt_demo.raw.s3_tastybytes/raw_pos/location/;

COPY INTO dev_dbt_demo.raw.menu
    FROM @dev_dbt_demo.raw.s3_tastybytes/raw_pos/menu/;

COPY INTO dev_dbt_demo.raw.truck
    FROM @dev_dbt_demo.raw.s3_tastybytes/raw_pos/truck/;

COPY INTO dev_dbt_demo.raw.customer_loyalty
    FROM @dev_dbt_demo.raw.s3_tastybytes/raw_customer/customer_loyalty/;

COPY INTO dev_dbt_demo.raw.core_poi_geometry
    FROM @dev_dbt_demo.raw.s3_tastybytes/raw_safegraph/;

-- 4b. Large fact tables (these take a few minutes)
COPY INTO dev_dbt_demo.raw.order_header
    FROM @dev_dbt_demo.raw.s3_tastybytes/raw_pos/order_header/;

COPY INTO dev_dbt_demo.raw.order_detail
    FROM @dev_dbt_demo.raw.s3_tastybytes/raw_pos/order_detail/;

-- =============================================================================
-- 5. VERIFY ROW COUNTS
-- =============================================================================
SELECT 'country' AS table_name, COUNT(*) AS row_count FROM dev_dbt_demo.raw.country
UNION ALL SELECT 'franchise', COUNT(*) FROM dev_dbt_demo.raw.franchise
UNION ALL SELECT 'location', COUNT(*) FROM dev_dbt_demo.raw.location
UNION ALL SELECT 'menu', COUNT(*) FROM dev_dbt_demo.raw.menu
UNION ALL SELECT 'truck', COUNT(*) FROM dev_dbt_demo.raw.truck
UNION ALL SELECT 'order_header', COUNT(*) FROM dev_dbt_demo.raw.order_header
UNION ALL SELECT 'order_detail', COUNT(*) FROM dev_dbt_demo.raw.order_detail
UNION ALL SELECT 'customer_loyalty', COUNT(*) FROM dev_dbt_demo.raw.customer_loyalty
UNION ALL SELECT 'core_poi_geometry', COUNT(*) FROM dev_dbt_demo.raw.core_poi_geometry
ORDER BY table_name;

-- =============================================================================
-- 6. CLEANUP STAGE AND FILE FORMAT (optional)
-- =============================================================================
-- Uncomment the lines below after confirming data loaded successfully.
-- DROP STAGE IF EXISTS dev_dbt_demo.raw.s3_tastybytes;
-- DROP FILE FORMAT IF EXISTS dev_dbt_demo.raw.csv_ff;

-- =============================================================================
-- 7. GRANT ACCESS TO LOADED TABLES
-- =============================================================================
-- The batch-1/4_grants.sql script should have set up future grants on RAW tables.
-- If not, run the following to grant access to the demo roles:
-- GRANT SELECT ON ALL TABLES IN SCHEMA dev_dbt_demo.raw TO ROLE dbt_demo_ro;
-- GRANT ALL ON ALL TABLES IN SCHEMA dev_dbt_demo.raw TO ROLE dbt_demo_rw;
