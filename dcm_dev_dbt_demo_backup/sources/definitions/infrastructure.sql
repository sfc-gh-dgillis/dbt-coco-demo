-- =============================================================================
-- Infrastructure: Database and Schemas for DEV_DBT_DEMO_BACKUP
-- =============================================================================

DEFINE DATABASE DEV_DBT_DEMO_BACKUP;

DEFINE SCHEMA DEV_DBT_DEMO_BACKUP.PUBLIC;

DEFINE SCHEMA DEV_DBT_DEMO_BACKUP.RAW
    COMMENT = 'dbt demo - RAW data landing schema';

DEFINE SCHEMA DEV_DBT_DEMO_BACKUP.MODELED;

DEFINE SCHEMA DEV_DBT_DEMO_BACKUP.UTILITIES
    COMMENT = 'dbt demo - global utilities and tools';
