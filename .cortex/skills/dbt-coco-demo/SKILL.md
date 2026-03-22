---
name: dbt-coco-demo
description: "Manage the Tasty Bytes dbt demo project. Use this skill whenever the user mentions: demo setup, demo reset, build models, run tests, dbt build, dbt test, dbt docs, Tasty Bytes, food truck data, set up the demo, clean up, reset environment, run the demo, project structure, staging models, mart models, dimension tables, fact tables, or any dbt/demo operations in this project. Always use this skill for demo-related tasks even if the user doesn't explicitly say 'demo'."
---

# Tasty Bytes Demo Skill

This skill helps Snowflake Solution Engineers operate the Tasty Bytes dbt demo project without needing to know Taskfile syntax or dbt CLI commands. It translates natural language requests into the correct commands.

## Important Context

- The project uses **Taskfile** (go-task) for automation, but you should run the underlying commands directly rather than requiring SEs to install `task`
- All dbt commands must run from the **venv** virtual environment at `venv/bin/`
- The default dbt target is **`dev-keypair-auth`** (key pair auth). An alternative is `dev-pat-auth` (PAT auth)
- Default databases: `dev_dbt_demo` (dev), `dbt_demo` (prod)
- Default schemas: `curated` (marts), `raw` (sources/staging)
- **Snowflake CLI 3.16+** is required for DCM operations (`snow dcm raw-analyze`, etc.). Check with `snow --version`. If below 3.16, upgrade with `pip install snowflake-cli --upgrade`

## Quick Reference: What to Run

### Setting Up the Demo (First Time or Fresh Start)

When the user wants to set up, initialize, or start the demo, run these steps in order:

```bash
# 1. Create virtual environment (skip if venv/ already exists)
uv venv venv

# 2. Install dbt into the venv (skip if venv/bin/dbt already exists)
uv pip install --python venv/bin/python dbt-core==1.11.7 dbt-snowflake

# 3. Install dbt packages (skip if dbt_packages/ already exists)
venv/bin/dbt deps

# 4. Verify Snowflake connection
venv/bin/dbt debug --target dev-keypair-auth

# 5. Create the custom UDF
venv/bin/dbt run-operation create_udf_concatenate_object_values \
  --target dev-keypair-auth \
  --args '{database: dev_dbt_demo, schema: utilities}'
```

Or if `task` is installed, the user can simply run:
```bash
task demo-up
```

Check the status of each prerequisite before running it -- skip steps that are already done.

### Resetting the Demo (Clean Slate)

When the user wants to reset, clean, tear down, or start over:

```bash
rm -rf venv dbt_packages logs target package-lock.yml
```

Or with task:
```bash
task reset-demo
```

After resetting, the user needs to run setup again.

### Building Models

**Build everything** (models + tests):
```bash
venv/bin/dbt build --target dev-keypair-auth
```

**Build a specific model** (replace `<model_name>` with the actual name, e.g., `d_country`, `f_order`):
```bash
venv/bin/dbt build --target dev-keypair-auth --select <model_name>
```

**Run models only** (no tests):
```bash
venv/bin/dbt run --target dev-keypair-auth
```

**Run a specific model only**:
```bash
venv/bin/dbt run --target dev-keypair-auth --select <model_name>
```

**Build a model and its upstream dependencies**:
```bash
venv/bin/dbt build --target dev-keypair-auth --select +<model_name>
```

### Running Tests

**All tests**:
```bash
venv/bin/dbt test --target dev-keypair-auth
```

**Tests for a specific model**:
```bash
venv/bin/dbt test --target dev-keypair-auth --select <model_name>
```

**Data tests only**:
```bash
venv/bin/dbt test --target dev-keypair-auth --select test_type:data
```

### Generating Documentation

```bash
venv/bin/dbt docs generate --target dev-keypair-auth
venv/bin/dbt docs serve --target dev-keypair-auth
```

### Debugging Connection Issues

```bash
venv/bin/dbt debug --target dev-keypair-auth
```

This checks profiles.yml, project config, Snowflake connectivity, and dependency versions.

## Project Structure

```
models/
├── staging/              # Materialized as VIEWS
│   ├── pos/              # Point of sale data
│   │   ├── stg_pos__country.sql
│   │   ├── stg_pos__franchise.sql
│   │   ├── stg_pos__location.sql
│   │   ├── stg_pos__menu.sql
│   │   ├── stg_pos__order_detail.sql
│   │   ├── stg_pos__order_header.sql
│   │   └── stg_pos__truck.sql
│   ├── loyalty/          # Customer loyalty program
│   │   └── stg_loyalty__customer_loyalty.sql
│   └── safegraph/        # Location/POI data
│       └── stg_safegraph__core_poi_geometry.sql
└── marts/                # Materialized as TABLES
    ├── d_country.sql          # Dimension: countries
    ├── d_franchise.sql        # Dimension: franchise brands
    ├── d_location.sql         # Dimension: truck locations
    ├── d_loyalty_member.sql   # Dimension: loyalty program members
    ├── d_menu_item.sql        # Dimension: menu items
    ├── d_menu_item_ingredients.sql  # Dimension: item ingredients
    ├── d_menu_type.sql        # Dimension: menu categories
    ├── d_truck.sql            # Dimension: food trucks
    ├── f_order.sql            # Fact: order headers
    └── f_order_line.sql       # Fact: order line items

macros/                   # Custom Snowflake UDFs
data-tests/               # Data validation tests
tasks/                    # Taskfile automation
```

### Naming Conventions

- Staging: `stg_<source>__<table>` (e.g., `stg_pos__country`)
- Dimensions: `d_<entity>` (e.g., `d_country`)
- Facts: `f_<entity>` (e.g., `f_order`)
- Sources defined in `_source_*.yml` files

### Data Sources

| Source    | Tables                                                                        | Description             |
| --------- | ----------------------------------------------------------------------------- | ----------------------- |
| pos       | country, franchise, location, menu, order_detail, order_header, truck         | Point of sale system    |
| loyalty   | customer_loyalty                                                              | Loyalty program members |
| safegraph | core_poi_geometry                                                             | Location/POI geo data   |

## Troubleshooting

### "dbt: command not found" or "not found in $PATH"
The venv isn't activated or doesn't exist. Use the full path `venv/bin/dbt` or run setup.

### "dbt found 1 package(s) specified but 0 installed"
Run `venv/bin/dbt deps` to install dbt packages.

### "No such file or directory: venv/bin/python"
The virtual environment doesn't exist. Create it with `uv venv venv`.

### Connection errors during dbt debug
Check that `~/.dbt/profiles.yml` has the correct target configured. Do NOT read or modify this file -- it contains credentials. Ask the user to verify their connection settings.

### "uv: command not found"
The user needs to install uv. Point them to: `curl -LsSf https://astral.sh/uv/install.sh | sh`
