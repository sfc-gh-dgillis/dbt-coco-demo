USE ROLE useradmin;

-- create access roles
CREATE ROLE IF NOT EXISTS dbt_demo_rw
    COMMENT = 'Access role for the dev_dbt_demo database with Read and Write permissions to all objects.';

CREATE ROLE IF NOT EXISTS dbt_demo_ro
    COMMENT = 'Access role for the dev_dbt_demo database with Read Only permissions to all objects.';

-- create functional roles
CREATE ROLE IF NOT EXISTS dbt_demo_data_engineer
    COMMENT = 'Functional role for dev_dbt_demo - business function alignment is generally for Data Engineers';

CREATE ROLE IF NOT EXISTS dbt_demo_analyst
    COMMENT = 'Functional role for dev_dbt_demo - business function alignment is generally for Data Analysts';

-- grant access roles to functional roles
GRANT ROLE dev_dbt_demo_rw TO ROLE dev_dbt_demo_data_engineer;
GRANT ROLE dev_dbt_demo_ro TO ROLE dev_dbt_demo_analyst;

-- grant functional roles to SYSADMIN
GRANT ROLE dev_dbt_demo_data_engineer TO ROLE sysadmin;
GRANT ROLE dev_dbt_demo_analyst TO ROLE sysadmin;

SHOW ROLES;
