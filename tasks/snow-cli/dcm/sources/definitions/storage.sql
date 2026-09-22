-- =============================================================================
-- Storage: File Formats and Stages
-- =============================================================================

-- -----------------------------------------------------------------------------
-- File Formats
-- -----------------------------------------------------------------------------
DEFINE FILE FORMAT {{ db }}.RAW.CSV_FF
    TYPE = 'CSV'
    COMPRESSION = 'AUTO'
    FIELD_DELIMITER = ','
    RECORD_DELIMITER = '\n'
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    TRIM_SPACE = FALSE
    ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
    NULL_IF = ('NULL', 'null', '', '\\N');

-- -----------------------------------------------------------------------------
-- External Stages
-- -----------------------------------------------------------------------------
DEFINE STAGE {{ db }}.RAW.S3_TASTYBYTES
    URL = 's3://sfquickstarts/frostbyte_tastybytes/'
    FILE_FORMAT = {{ db }}.RAW.CSV_FF
    COMMENT = 'Public S3 stage for Tasty Bytes quickstart data';
