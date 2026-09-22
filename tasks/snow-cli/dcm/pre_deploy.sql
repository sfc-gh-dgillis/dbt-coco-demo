/*--
  Pre-Deploy Script
  =================
  Creates the DCM project's parent database and schema if they don't exist.
  A DCM project cannot DEFINE its own parent containers, so these must
  exist before `snow dcm plan` runs.

  Run before: snow dcm plan / snow dcm deploy
  Usage:      snow sql -f dcm/pre_deploy.sql -c <connection> --role SYSADMIN
--*/

USE ROLE SYSADMIN;

CREATE DATABASE IF NOT EXISTS UTIL
    COMMENT = 'Utilities database';

CREATE SCHEMA IF NOT EXISTS UTIL.DCM_PROJECT_ARCHIVE
    COMMENT = 'DCM projects for the dbt demo: dbt_demo_dev and dbt_demo_prod.';
