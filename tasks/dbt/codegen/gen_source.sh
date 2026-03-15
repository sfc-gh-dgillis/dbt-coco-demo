#!/usr/bin/env bash

# Generate source files for dbt models
export DBT_ENV_SECRET_PAT="op://Employee/demo-tastyb/password"
op run -- dbt --quiet run-operation generate_source --target dev-tastyb --args '{"schema_name": "raw", "table_names":["country","franchise","location","menu","order_detail","order_header","truck"], "generate_columns": true}' > models/staging/pos/_source_pos.yml

export DBT_ENV_SECRET_PAT="op://Employee/demo-tastyb/password"
op run -- dbt --quiet run-operation generate_source --target dev-tastyb --args '{"schema_name": "raw", "table_names":["customer_loyalty"], "generate_columns": true}' > models/staging/loyalty/_source_customer_loyalty.yml

export DBT_ENV_SECRET_PAT="op://Employee/demo-tastyb/password"
op run -- dbt --quiet run-operation generate_source --target dev-tastyb --args '{"schema_name": "raw", "table_names":["core_poi_geometry"], "generate_columns": true}' > models/staging/safegraph/_source_safegraph.yml
