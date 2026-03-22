/*--
  Post-Deployment Grants
  ======================
  Grants that DCM cannot manage declaratively. Run after `snow dcm deploy`.

  These include:
    - Account-level grants (GRANT ... ON ACCOUNT)
    - Future grants (GRANT ... ON FUTURE ...)
    - Role-to-user grants

  Usage: snow sql -f dcm/post_deployment_grants.sql -c <connection> --role ACCOUNTADMIN
--*/

-- =============================================================================
-- Account-Level Grants (requires ACCOUNTADMIN)
-- =============================================================================
USE ROLE ACCOUNTADMIN;

GRANT EXECUTE TASK ON ACCOUNT TO ROLE DBT_DEMO_RW;
GRANT EXECUTE MANAGED TASK ON ACCOUNT TO ROLE DBT_DEMO_RW;

-- =============================================================================
-- Future Grants on Database-Level Tasks (requires SECURITYADMIN)
-- =============================================================================
USE ROLE SECURITYADMIN;

GRANT OPERATE ON FUTURE TASKS IN DATABASE DEV_DBT_DEMO TO ROLE DBT_DEMO_RW;

-- =============================================================================
-- Future Grants on Stages
-- =============================================================================
GRANT USAGE ON FUTURE STAGES IN SCHEMA DEV_DBT_DEMO.RAW TO ROLE DBT_DEMO_RW;

-- =============================================================================
-- Future Grants: RAW Schema
-- =============================================================================
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA DEV_DBT_DEMO.RAW TO ROLE DBT_DEMO_RW;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA DEV_DBT_DEMO.RAW TO ROLE DBT_DEMO_RW;
GRANT SELECT ON FUTURE TABLES IN SCHEMA DEV_DBT_DEMO.RAW TO ROLE DBT_DEMO_RO;

-- =============================================================================
-- Future Grants: CURATED Schema
-- =============================================================================
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA DEV_DBT_DEMO.CURATED TO ROLE DBT_DEMO_RW;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA DEV_DBT_DEMO.CURATED TO ROLE DBT_DEMO_RW;
GRANT SELECT ON FUTURE TABLES IN SCHEMA DEV_DBT_DEMO.CURATED TO ROLE DBT_DEMO_RO;

-- =============================================================================
-- Future Grants: MODELED Schema
-- =============================================================================
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA DEV_DBT_DEMO.MODELED TO ROLE DBT_DEMO_RW;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA DEV_DBT_DEMO.MODELED TO ROLE DBT_DEMO_RW;
GRANT SELECT ON FUTURE TABLES IN SCHEMA DEV_DBT_DEMO.MODELED TO ROLE DBT_DEMO_RO;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA DEV_DBT_DEMO.MODELED TO ROLE DBT_DEMO_RO;

-- =============================================================================
-- Future Grants: UTILITIES Schema
-- =============================================================================
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA DEV_DBT_DEMO.UTILITIES TO ROLE DBT_DEMO_RW;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA DEV_DBT_DEMO.UTILITIES TO ROLE DBT_DEMO_RW;
GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA DEV_DBT_DEMO.UTILITIES TO ROLE DBT_DEMO_RW;
GRANT SELECT ON FUTURE TABLES IN SCHEMA DEV_DBT_DEMO.UTILITIES TO ROLE DBT_DEMO_RO;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA DEV_DBT_DEMO.UTILITIES TO ROLE DBT_DEMO_RO;
GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA DEV_DBT_DEMO.UTILITIES TO ROLE DBT_DEMO_RO;

-- =============================================================================
-- Role-to-User Grants
-- IMPORTANT: Update the username below to your own Snowflake username.
-- =============================================================================
GRANT ROLE DBT_DEMO_DATA_ENGINEER TO USER tastyb;
