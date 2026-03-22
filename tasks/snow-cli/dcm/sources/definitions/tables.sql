-- =============================================================================
-- Raw Tables
-- Source: batch-2/5_load_raw_data.sql
-- =============================================================================

-- -----------------------------------------------------------------------------
-- POS Tables
-- -----------------------------------------------------------------------------

-- Country
DEFINE TABLE DEV_DBT_DEMO.RAW.COUNTRY (
    COUNTRY_ID      NUMBER(18,0),
    COUNTRY         VARCHAR,
    ISO_CURRENCY    VARCHAR(3),
    ISO_COUNTRY     VARCHAR(2),
    CITY_ID         NUMBER(19,0),
    CITY            VARCHAR,
    CITY_POPULATION NUMBER
);

-- Franchise
DEFINE TABLE DEV_DBT_DEMO.RAW.FRANCHISE (
    FRANCHISE_ID    NUMBER(38,0),
    FIRST_NAME      VARCHAR,
    LAST_NAME       VARCHAR,
    CITY            VARCHAR,
    COUNTRY         VARCHAR,
    E_MAIL          VARCHAR,
    PHONE_NUMBER    VARCHAR
);

-- Location
DEFINE TABLE DEV_DBT_DEMO.RAW.LOCATION (
    LOCATION_ID      NUMBER(19,0),
    PLACEKEY         VARCHAR,
    LOCATION         VARCHAR,
    CITY             VARCHAR,
    REGION           VARCHAR,
    ISO_COUNTRY_CODE VARCHAR,
    COUNTRY          VARCHAR
);

-- Menu
DEFINE TABLE DEV_DBT_DEMO.RAW.MENU (
    MENU_ID                       NUMBER(19,0),
    MENU_TYPE_ID                  NUMBER(38,0),
    MENU_TYPE                     VARCHAR,
    TRUCK_BRAND_NAME              VARCHAR,
    MENU_ITEM_ID                  NUMBER(38,0),
    MENU_ITEM_NAME                VARCHAR,
    ITEM_CATEGORY                 VARCHAR,
    ITEM_SUBCATEGORY              VARCHAR,
    COST_OF_GOODS_USD             NUMBER(38,4),
    SALE_PRICE_USD                NUMBER(38,4),
    MENU_ITEM_HEALTH_METRICS_OBJ  VARIANT
);

-- Truck
DEFINE TABLE DEV_DBT_DEMO.RAW.TRUCK (
    TRUCK_ID           NUMBER(38,0),
    MENU_TYPE_ID       NUMBER(38,0),
    PRIMARY_CITY       VARCHAR,
    REGION             VARCHAR,
    ISO_REGION         VARCHAR,
    COUNTRY            VARCHAR,
    ISO_COUNTRY_CODE   VARCHAR,
    FRANCHISE_FLAG     NUMBER(38,0),
    YEAR               NUMBER(38,0),
    MAKE               VARCHAR,
    MODEL              VARCHAR,
    EV_FLAG            NUMBER(38,0),
    FRANCHISE_ID       NUMBER(38,0),
    TRUCK_OPENING_DATE DATE,
    TRUCK_TYPE         VARCHAR
);

-- Order Header (~248M rows)
DEFINE TABLE DEV_DBT_DEMO.RAW.ORDER_HEADER (
    ORDER_ID              NUMBER(38,0),
    TRUCK_ID              NUMBER(38,0),
    LOCATION_ID           FLOAT,
    CUSTOMER_ID           NUMBER(38,0),
    DISCOUNT_ID           VARCHAR,
    SHIFT_ID              NUMBER(38,0),
    SHIFT_START_TIME      TIME(9),
    SHIFT_END_TIME        TIME(9),
    ORDER_CHANNEL         VARCHAR,
    ORDER_TS              TIMESTAMP_NTZ(9),
    SERVED_TS             VARCHAR,
    ORDER_CURRENCY        VARCHAR(3),
    ORDER_AMOUNT          NUMBER(38,4),
    ORDER_TAX_AMOUNT      VARCHAR,
    ORDER_DISCOUNT_AMOUNT VARCHAR,
    ORDER_TOTAL           NUMBER(38,4)
);

-- Order Detail (~674M rows)
DEFINE TABLE DEV_DBT_DEMO.RAW.ORDER_DETAIL (
    ORDER_DETAIL_ID            NUMBER(38,0),
    ORDER_ID                   NUMBER(38,0),
    MENU_ITEM_ID               NUMBER(38,0),
    DISCOUNT_ID                VARCHAR,
    LINE_NUMBER                NUMBER(38,0),
    QUANTITY                   NUMBER(5,0),
    UNIT_PRICE                 NUMBER(38,4),
    PRICE                      NUMBER(38,4),
    ORDER_ITEM_DISCOUNT_AMOUNT VARCHAR
);

-- -----------------------------------------------------------------------------
-- Customer Loyalty
-- -----------------------------------------------------------------------------
DEFINE TABLE DEV_DBT_DEMO.RAW.CUSTOMER_LOYALTY (
    CUSTOMER_ID        NUMBER(38,0),
    FIRST_NAME         VARCHAR,
    LAST_NAME          VARCHAR,
    CITY               VARCHAR,
    COUNTRY            VARCHAR,
    POSTAL_CODE        VARCHAR,
    PREFERRED_LANGUAGE VARCHAR,
    GENDER             VARCHAR,
    FAVOURITE_BRAND    VARCHAR,
    MARITAL_STATUS     VARCHAR,
    CHILDREN_COUNT     VARCHAR,
    SIGN_UP_DATE       DATE,
    BIRTHDAY_DATE      DATE,
    E_MAIL             VARCHAR,
    PHONE_NUMBER       VARCHAR
);

-- -----------------------------------------------------------------------------
-- SafeGraph
-- -----------------------------------------------------------------------------
DEFINE TABLE DEV_DBT_DEMO.RAW.CORE_POI_GEOMETRY (
    PLACEKEY             VARCHAR,
    PARENT_PLACEKEY      VARCHAR,
    SAFEGRAPH_BRAND_IDS  VARCHAR,
    LOCATION_NAME        VARCHAR,
    BRANDS               VARCHAR,
    STORE_ID             VARCHAR,
    TOP_CATEGORY         VARCHAR,
    SUB_CATEGORY         VARCHAR,
    NAICS_CODE           NUMBER,
    LATITUDE             FLOAT,
    LONGITUDE            FLOAT,
    STREET_ADDRESS       VARCHAR,
    CITY                 VARCHAR,
    REGION               VARCHAR,
    POSTAL_CODE          VARCHAR,
    OPEN_HOURS           VARIANT,
    CATEGORY_TAGS        VARCHAR,
    OPENED_ON            VARCHAR,
    CLOSED_ON            VARCHAR,
    TRACKING_CLOSED_SINCE VARCHAR,
    GEOMETRY_TYPE        VARCHAR,
    POLYGON_WKT          VARCHAR,
    POLYGON_CLASS        VARCHAR,
    ENCLOSED             BOOLEAN,
    PHONE_NUMBER         VARCHAR,
    IS_SYNTHETIC         BOOLEAN,
    INCLUDES_PARKING_LOT BOOLEAN,
    ISO_COUNTRY_CODE     VARCHAR,
    WKT_AREA_SQ_METERS   FLOAT,
    COUNTRY              VARCHAR
);
