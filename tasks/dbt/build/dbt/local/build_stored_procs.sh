#!/usr/bin/env bash

export DBT_ENV_SECRET_PAT="op://Employee/demo-tastyb/password"

# compile the udf code using a dbt macro with the dbt run-operation command
op run -- \
  dbt run-operation create_udf_concatenate_object_values \
  --target dev-tastyb \
  --args '{database: dev_dbt_demo, schema: utilities}'

# test that the udf was created successfully and can be used
snow sql -c demo_dgillis_keypair_auth -q "use warehouse dbt_demo_xs_wh; select dev_dbt_demo.utilities.udf_concatenate_object_values(to_object(parse_json('{\"key1\": \"value1\", \"key2\": \"value2\"}')));"

op run -- \
  dbt run-operation create_udf_generate_surrogate_key \
  --target dev-tastyb \
  --args '{database: 'dev_dbt_demo', schema: 'utilities'}'

# test that the udf was created successfully and can be used
snow sql -c demo_dgillis_keypair_auth -q "use warehouse dbt_demo_xs_wh; select dev_dbt_demo.utilities.udf_generate_surrogate_key(to_object(parse_json('{\"key1\": \"value1\", \"key2\": \"value2\"}')));"
