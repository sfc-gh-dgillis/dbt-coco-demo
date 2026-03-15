#!/usr/bin/env bash

# loyalty
export DBT_ENV_SECRET_PAT="op://Employee/demo-tastyb/password"
op run -- dbt --quiet run-operation generate_base_model --args '{"source_name": "raw", "table_name": "customer_loyalty"}' > models/staging/loyalty/stg_loyalty__customer_loyalty.sql

# pos
export DBT_ENV_SECRET_PAT="op://Employee/demo-tastyb/password"
op run -- dbt --quiet run-operation generate_base_model --args '{"source_name": "raw", "table_name": "country"}' > models/staging/pos/stg_pos__country.sql

export DBT_ENV_SECRET_PAT="op://Employee/demo-tastyb/password"
op run -- dbt --quiet run-operation generate_base_model --args '{"source_name": "raw", "table_name": "franchise"}' > models/staging/pos/stg_pos__franchise.sql

export DBT_ENV_SECRET_PAT="op://Employee/demo-tastyb/password"
op run -- dbt --quiet run-operation generate_base_model --args '{"source_name": "raw", "table_name": "location"}' > models/staging/pos/stg_pos__location.sql

export DBT_ENV_SECRET_PAT="op://Employee/demo-tastyb/password"
op run -- dbt --quiet run-operation generate_base_model --args '{"source_name": "raw", "table_name": "menu"}' > models/staging/pos/stg_pos__menu.sql

export DBT_ENV_SECRET_PAT="op://Employee/demo-tastyb/password"
op run -- dbt --quiet run-operation generate_base_model --args '{"source_name": "raw", "table_name": "order_detail"}' > models/staging/pos/stg_pos__order_detail.sql

export DBT_ENV_SECRET_PAT="op://Employee/demo-tastyb/password"
op run -- dbt --quiet run-operation generate_base_model --args '{"source_name": "raw", "table_name": "order_header"}' > models/staging/pos/stg_pos__order_header.sql

export DBT_ENV_SECRET_PAT="op://Employee/demo-tastyb/password"
op run -- dbt --quiet run-operation generate_base_model --args '{"source_name": "raw", "table_name": "truck"}' > models/staging/pos/stg_pos__truck.sql

# safegraph
export DBT_ENV_SECRET_PAT="op://Employee/demo-tastyb/password"
op run -- dbt --quiet run-operation generate_base_model --args '{"source_name": "raw", "table_name": "core_poi_geometry"}' > models/staging/safegraph/stg_safegraph__core_poi_geometry.sql
