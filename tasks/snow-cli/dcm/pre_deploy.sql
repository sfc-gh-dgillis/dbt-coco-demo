/*--
  Pre-Deploy Script
  =================
  Creates the DCM project's parent database and schema if they don't exist.
  A DCM project cannot DEFINE its own parent containers, so these must
  exist before `snow dcm plan` runs.

  UTIL is an ACCOUNTADMIN-owned shared utilities database, so this script runs
  as ACCOUNTADMIN and then grants SYSADMIN (the manifest's project_owner) the
  privileges it needs to create and own the DCM project object.

  Run before: snow dcm plan / snow dcm deploy
  Usage:      snow sql -f dcm/pre_deploy.sql -c <connection> --role ACCOUNTADMIN
--*/

USE ROLE ACCOUNTADMIN;

CREATE DATABASE IF NOT EXISTS UTIL
    COMMENT = 'Utilities database';

CREATE SCHEMA IF NOT EXISTS UTIL.DCM_PROJECT_ARCHIVE
    COMMENT = 'DCM projects for the dbt demo: dbt_demo_dev and dbt_demo_prod.';

-- Allow SYSADMIN (project_owner in manifest.yml) to create the DCM project object.
GRANT USAGE ON DATABASE UTIL TO ROLE SYSADMIN;
GRANT USAGE ON SCHEMA UTIL.DCM_PROJECT_ARCHIVE TO ROLE SYSADMIN;
GRANT CREATE DCM PROJECT ON SCHEMA UTIL.DCM_PROJECT_ARCHIVE TO ROLE SYSADMIN;
