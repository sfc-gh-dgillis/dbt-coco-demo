# AGENTS.md

## Project Overview

This is a Snowflake dbt demo project ("Tasty Bytes") designed for Snowflake Solutions Engineers to demonstrate Cortex Code CLI and dbt capabilities. The project models a food truck business with POS, loyalty, and location data.

**Tech Stack:** dbt-core 1.11.7, dbt-snowflake, Python 3.12, Snowflake

IMPORTANT: Any time you make changes to any files in this project, be sure to ask: "Would you like me to commit these changes to git?" If the answer is yes, then commit the changes to git with a descriptive commit message. The first line of the commit message should be less than or equal to 50 characters. If the answer is no, then just continue. This will help ensure that our git history remains clean and meaningful, and that we can easily track the evolution of this project over time.

## Setup Commands

```bash
# Create virtual environment with uv
uv venv
source .venv/bin/activate

# Install dependencies
uv pip install dbt-core==1.11.7 dbt-snowflake

# Install dbt packages
dbt deps

# Verify connection
dbt debug --target dev-keypair-auth
```

## Build Commands

```bash
# Build all models
dbt build --target dev-keypair-auth

# Build specific model
dbt build --target dev-keypair-auth --select <model_name>

# Run models only (no tests)
dbt run --target dev-keypair-auth

# Generate and serve docs
dbt docs generate --target dev-keypair-auth && dbt docs serve
```

## Test Commands

```bash
# Run all tests
dbt test --target dev-keypair-auth

# Run tests for specific model
dbt test --target dev-keypair-auth --select <model_name>

# Run data tests
dbt test --target dev-keypair-auth --select test_type:data
```

## Project Structure

```
models/
├── staging/           # Views - source data transformations
│   ├── pos/           # Point of sale: orders, trucks, menu, locations
│   ├── loyalty/       # Customer loyalty program
│   └── safegraph/     # Location/POI data
└── marts/             # Tables - business-ready dimensional models
    ├── d_*.sql        # Dimension tables (country, franchise, truck, etc.)
    └── f_*.sql        # Fact tables (orders, order lines)

macros/                # Custom Snowflake UDFs and utilities
tasks/                 # Taskfile automation (task demo-up)
data-tests/            # Custom data validation tests
```

## Code Style

- Follow dbt's [best practices for project structure](https://docs.getdbt.com/guides/best-practices/how-we-structure/1-guide-overview)
- Staging models: prefix with `stg_<source>__<table>`
- Mart dimensions: prefix with `d_`
- Mart facts: prefix with `f_`
- Source definitions in `_source_*.yml` files
- Use `{{ source('source_name', 'table_name') }}` for raw data references
- Use `{{ ref('model_name') }}` for model references

## Connection Profiles

Profiles are stored in `~/.dbt/profiles.yml`. Available targets:
- `dev-keypair-auth` - Key pair authentication
- `dev-pat-auth` - Programmatic Access Token (PAT) authentication

Do NOT read or modify `~/.dbt/profiles.yml` directly as it contains credentials.

## dbt Packages

- `dbt-labs/codegen` - Code generation utilities for sources and models

## Custom Macros

- `create_udf_concatenate_object_values` - Creates a Python UDF that concatenates an OBJECT's values in key order, substituting a placeholder for nulls/empties
- `create_udf_generate_surrogate_key` - Creates a SQL UDF that MD5_BINARY-hashes the output of `udf_concatenate_object_values` to produce a surrogate key (depends on the UDF above)

Both macros take `database` and `schema` arguments and are invoked via `dbt run-operation`; see the `dbt:create-udf-*` Taskfile tasks.

## Important Notes

- Default database: `dev_dbt_demo`, deployed by the DCM project (`task demo-init`)
- Default schema: `modeled` for marts, `raw` for sources
- Staging models materialize as views
- Mart models materialize as tables
- Always use the full object name (database.schema.table) in output and SQL for clarity and to avoid ambiguity
- Always ensure you're working in the correct virtual environment and using the appropriate dbt target for your authentication method when running commands. Never run from a global Python environment to avoid conflicts with other projects or system packages.
- Always use uv to manage your virtual environment and dependencies. Do not use pip or other package managers outside of the uv environment to avoid conflicts and ensure reproducibility.
- Always use uv pip to install specific versions of dbt-core and dbt-snowflake as specified in the setup commands to ensure compatibility and avoid issues with newer or older versions.
- Activate the environment with source .venv/bin/activate before running any dbt commands to ensure you're using the correct Python environment and dependencies for this project.