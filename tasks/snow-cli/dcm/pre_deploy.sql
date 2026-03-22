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

CREATE DATABASE IF NOT EXISTS DCM_ADMIN
    COMMENT = 'Admin database for DCM project management';

CREATE SCHEMA IF NOT EXISTS DCM_ADMIN.PROJECTS
    COMMENT = 'Schema for DCM project objects';
