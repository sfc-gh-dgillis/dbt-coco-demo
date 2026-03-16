comm# AGENTS.md

## Project Overview

This is a Snowflake dbt demo project ("Tasty Bytes") designed for Snowflake Solutions Engineers to demonstrate Cortex Code CLI and dbt capabilities. The project models a food truck business with POS, loyalty, and location data.

**Tech Stack:** dbt-core 1.9+, dbt-snowflake, Python 3.12, Snowflake

## Setup Commands

```bash
# Create virtual environment with uv
uv venv
source .venv/bin/activate

# Install dependencies
uv pip install dbt-core dbt-snowflake

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

- `create_udf_concatenate_object_values` - Creates a Python UDF for surrogate key generation from OBJECT types

## Important Notes

- Default database: `dbt_demo` (prod) or `dev_dbt_demo` (dev)
- Default schema: `curated` for marts, `raw` for sources
- Staging models materialize as views
- Mart models materialize as tables
