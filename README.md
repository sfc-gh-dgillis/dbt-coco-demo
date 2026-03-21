# dbt-coco-demo

A Snowflake dbt demo project ("Tasty Bytes") for Solution Engineers to demonstrate Cortex Code CLI and dbt capabilities.

> **First time setup?** See [Demo Environment Setup](#demo-environment-setup) at the end of this document.
>
> **Returning for another demo?** See the [Pre-Demo Checklist](#pre-demo-checklist) to reset your environment.

---

## Cortex Code CLI Demo Script

**Scenario:** You just inherited a dbt project from a colleague. You've never seen it before. Use Cortex Code to understand it, improve it, and extend it -- all from the CLI.

**Repo:** `dbt-coco-demo` (Tasty Bytes food truck analytics)

**Total time:** ~10-12 minutes

---

## Pre-Demo Checklist

Run through this before each demo to ensure a clean starting state.

1. **Terminal:** Open a terminal in the `dbt-coco-demo` project directory
2. **Branch:** Ensure you're on `main` -- `git checkout main && git pull`
3. **Clean state:** Delete leftover artifacts from any prior demo run:
   ```bash
   rm -rf .venv dbt_packages target
   rm -f models/marts/_schema.yml models/marts/f_daily_sales_summary.sql
   ```
4. **Cortex Code:** Verify the CLI is authenticated -- `cortex connections list` should show your connection
5. **Snowflake:** Verify raw data exists (quick sanity check):
   ```sql
   SELECT COUNT(*) FROM dev_dbt_demo.raw.country;  -- should return 30
   ```
6. **Browser tab:** Open Snowsight in a browser (optional, for showing query results visually)

> **Important:** Do NOT create a virtual environment or install dbt deps before the demo. Prompt 6 does this live as a demo moment.

---

## Choosing a Model

Cortex Code supports multiple LLM models. You can switch models at any time during a session with the `/model` command, or set one at launch with `cortex --model <identifier>`.

| Model | Identifier | Best For |
|-------|-----------|----------|
| **Auto (recommended)** | `auto` | Automatically selects the best available model for your account; upgrades as new models ship |
| **Claude Opus 4.6** | `claude-opus-4-6` | Most capable -- complex reasoning, multi-step tasks, architectural planning |
| **Claude Sonnet 4.6** | `claude-sonnet-4-6` | Strong balance of speed and quality for everyday development |
| **Claude Opus 4.5** | `claude-opus-4-5` | Previous-gen flagship -- still excellent for complex work |
| **Claude Sonnet 4.5** | `claude-sonnet-4-5` | Previous-gen default -- fast and reliable |
| **Claude Sonnet 4.0** | `claude-4-sonnet` | Lightweight option with broad regional availability |
| **OpenAI GPT 5.2** | `openai-gpt-5.2` | OpenAI's latest (preview) -- requires `AZURE_US` cross-region inference |

**How to choose:**
- Start with **`auto`** -- Cortex picks the best model available to your account and you automatically benefit when better models are released.
- Use **Opus** when you need the highest quality: complex multi-file refactors, debugging tricky issues, or architectural decisions.
- Use **Sonnet** for day-to-day work: building models, writing tests, exploring data, running queries.
- **OpenAI GPT 5.2** is available in preview. It requires an ACCOUNTADMIN to enable cross-region inference to Azure US:
  ```sql
  ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AZURE_US';
  ```

**Regional availability:** Not all models are available in every region. If a model isn't available in yours, enable [cross-region inference](https://docs.snowflake.com/en/user-guide/snowflake-cortex/llm-functions#cross-region-inference) by setting `CORTEX_ENABLED_CROSS_REGION` (requires ACCOUNTADMIN). Use `AWS_US` for best Claude Opus coverage, or `ANY_REGION` for broadest access.

---

## Act 1: Orientation (~2 min)

> **Story:** "I just cloned this repo from a teammate who left the company. I have no idea what it does."

### Prompt 1: Explore the project

```
@dbt_project.yml What is this dbt project? Give me a summary of the data domain, the sources, the model layers, and any custom macros or UDFs.
```

**Expected result:** The `@` prefix injects the file's contents directly into the prompt as context -- no copy-pasting needed. Cortex Code reads `dbt_project.yml` (provided via the `@` mention), then follows references to the source YAMLs, staging models, mart models, and macros. It synthesizes a clear summary: Tasty Bytes food truck company, 3 source systems (POS, Customer Loyalty, SafeGraph), 2-layer DAG (staging views → mart tables), custom UDFs, and `codegen`/`dbt_utils` packages. Skills are what make this possible -- domain-specific instruction sets that give it deep knowledge of dbt, Streamlit, Snowpark, and more.

> **Aside: How did it know all that?** → **skills**
>
> Cortex Code ships with **built-in skills** -- domain-specific instruction sets that give it deep knowledge of tools like dbt, Streamlit, Snowpark, and more. When you asked about the project, Cortex Code automatically activated the **dbt skill**, which knows how to read `dbt_project.yml`, parse source YAMLs, trace `ref()` and `source()` macros, and understand the staging-to-marts layer pattern. That's why the summary was so accurate -- it wasn't guessing, it was following a structured dbt-aware workflow.
>
> Skills are one of the key extensibility mechanisms in Cortex Code. There are three categories:
>
> - **Bundled skills** ship with the CLI (dbt, Streamlit, data governance, ML, cost intelligence, lineage, and more)
> - **Custom skills** are Markdown files you create in `.cortex/skills/` (project-level) or `~/.snowflake/cortex/skills/` (global) to encode your team's conventions
> - **Remote skills** can be pulled from Git repos and shared across your organization
>
> You can invoke a skill explicitly by prefixing it with `$` (e.g., `$data-quality`, `$lineage`), or Cortex Code activates the right skill automatically based on your prompt. Run `/skill list` to see all available skills.

### Prompt 2: Check data quality on the source tables

Now that we know what the project does, let's see if the source data is trustworthy before we start building. This uses the `$data-quality` skill to do a quick assessment.

```
$data-quality Run a quick quality scan on the raw source tables in this project. Check for nulls in key columns, row counts, and anything that looks off. Exclude analysis of the order_header and the order_detail tables since those are very large and we don't want to run expensive checks on them right now. Give me a plain-English summary of the results.
```

**Expected result:** Cortex Code activates the data-quality skill, identifies the source tables from the dbt project, and runs targeted SQL checks -- null rates on primary keys, row count validation, and anomaly detection. It returns a plain-English summary of data health. No SQL written by hand -- the skill knew exactly what to look for.

### Prompt 3: Analyze security posture

While we're assessing the project, let's check the account's security posture. The `$trust-center` skill connects to Snowflake's Trust Center -- a built-in security scanner that continuously monitors your account for vulnerabilities, misconfigurations, and threats.

```
$trust-center Analyze my security posture
```

**Expected result:** Cortex Code activates the trust-center skill, queries the Trust Center findings, and returns a structured security report: severity distribution, active findings by scanner, trends, and specific remediation steps with SQL to fix them. Same Trust Center from Snowsight, but queried conversationally from the terminal.

### Prompt 4: Cut a dev branch

Cortex Code works natively with Git -- it can create branches, stage files, commit changes, and more, all without leaving the CLI. It's good practice to work on a dev branch so we don't push untested changes directly to main.

```text
Create a new branch called dgillis-dev and switch to it
```

**Expected result:** Cortex Code runs `git checkout -b dgillis-dev` and confirms the switch. Reinforces that Cortex Code is a full development environment with native Git support -- branching, committing, diffing, all built in.

### Prompt 5: Explore the raw data

Cortex Code connects directly to Snowflake -- no extra configuration, no context switching to a SQL IDE. Let's use that to get a feel for the raw data before we start building.

```
Run row counts on all the raw source tables and give me a summary of what data we're working with. Describe the key tables.
```

**Expected result:** Cortex Code executes SQL directly against Snowflake, returning row counts for all source tables and a plain-English summary of the data -- table purposes, key columns, and approximate scale. No need to open Snowsight or a SQL IDE.

### Prompt 6: Setup dbt

```text
This project does not have a virtual environment or dbt packages installed. Set those up now. Ensure the virtual environment is added to .gitignore so it doesn't get committed.
```

### Prompt 7: Understand lineage

```
@models/marts/f_order_line.sql What does this model depend on? Trace the full lineage back to raw sources.
```

**Expected result:** The `@` mention feeds the model's SQL directly into the prompt so Cortex Code can see the `ref()` calls immediately. It traces the full lineage: `raw.order_detail -> stg_pos__order_detail -> f_order_line`. No manual file hunting -- `@` gives it the starting point, and the dbt skill traces the rest.

---

## Act 2: Code Quality & Testing (~3 min)

> **Story:** "This project has no contracts, constraints and zero tests. That's a problem. Let's fix it."

### Prompt 8: Add _schema.yml

```text
This project has no model and column properties defined for the mart models. Make a plan to add a `_schema.yml` file to models/marts/ with constraints for all mart models. Add top-level properties: name and description. Review each table and do your best to create a description based on your what you can glean from the table columns. Also add column properties: name, description, data_type as well as primary_key, foreign_key and not_null constraints. Exclude fact tables at this time as I want to focus on the dimensions first. Do not build yet, just create the YAML file.
```

**Expected result:** Cortex Code reads all the mart models, analyzes the columns, and generates a comprehensive `models/marts/_schema.yml` with model-level names and descriptions, column-level properties (name, description, data_type), and primary_key/foreign_key/not_null constraints -- all inferred from context.

### Prompt 9: Commit the changes

```text
Commit the changes
```

**Expected result:** Cortex Code stages the new and modified files, generates a meaningful commit message summarizing the schema additions, and commits. It understands the context of what changed -- no copy-pasting or context switching.

### Prompt 10: Add Tests and Think Through Something

Often times when building, I ask questions of the Cortex Code that I may be pretty sure of, but it can help validate my thinking.

```text
This project has no tests for the mart models. Add tests for all mart models but do not build yet. Include unique tests on all primary keys, and relationship tests where foreign keys reference other mart dimensions. Also, I am considering adding not_null tests, but that seems redundant considering added not_null constraints and in Snowflake these are actually enforced. What do you think?
```

**Expected result:** Cortex Code adds `unique` tests on every primary key and `relationships` tests linking foreign keys (e.g., `f_order.truck_key` -> `d_truck.truck_key`). It also provides a thoughtful response about not_null tests vs constraints -- reasoning about tradeoffs and helping make informed decisions, not just generating code.

### Prompt 11: Build the dimension models

```
Build the mart dimension models only.
```

**Expected result:** Cortex Code runs `dbt build` selecting only the dimension models, materializing them as tables in Snowflake. One prompt, no need to remember dbt selector syntax.

### Prompt 12: Add Enforced Contracts

```text
I want to use dbt contracts to define a set of upfront "guarantees" on model definitions. Add contracts to the mart models.
```

### Prompt 13: Run the tests

```
Run dbt test for the dimension marts models only and show me the results. If any tests fail, diagnose and fix them.
```

**Expected result:** Cortex Code runs `dbt test --select marts` and shows pass/fail results. If any fail, it diagnoses and fixes them live -- it operates the dbt CLI and reacts to results, not just writes files.

---

## Act 3: New Feature Build (~3-4 min)

> **Story:** "The business team wants a daily sales summary. Let's build it."

### Prompt 14: Fork before building

```
/fork before-new-model
```

**Expected result:** Cortex Code creates a new session branched from this point -- a checkpoint before we start building. This is like `git branch` for your conversation. If the next few prompts go sideways, we can come back to this exact state. The original session is preserved untouched.

> **Aside:** `/fork` and `/rewind` are session management commands. `/fork` creates a non-destructive branch (keeps the original). `/rewind` rolls back destructively (discards messages). We'll see both in action.

### Prompt 15: Build the wrong thing (intentional)

```
Build a new mart model called daily_sales that has columns for date, total_revenue, and total_orders. Materialize it as a view.
```

**Expected result:** Cortex Code builds the model -- but it's wrong. The name doesn't follow the `f_` prefix convention, it's missing the truck/location/menu item grain we actually want, and it's materialized as a view instead of a table. This is intentional -- we're about to undo it.

### Prompt 16: Rewind the mistake

```
/rewind 1
```

**Expected result:** Cortex Code rolls back one user message, discarding the bad model build from the conversation. However, `/rewind` only rolls back the *conversation state* -- any files written to disk or tables materialized in Snowflake are still there. We need to clean those up.

### Prompt 17: Clean up the mess

```
Delete the daily_sales model file and drop the table in Snowflake if it was created.
```

**Expected result:** Cortex Code removes the file from disk and drops the table from Snowflake. This is the full undo -- conversation rewound, file deleted, table dropped. Now we can re-prompt with the correct requirements.

> **Aside:** `/rewind` is destructive -- it throws away everything after the rewind point. Use `/fork` when you might want to come back, and `/rewind` when you know the recent work was wrong. Remember that `/rewind` only affects the conversation -- any side effects (files, tables, git commits) need to be cleaned up separately.

### Prompt 18: Build the model correctly

```
@models/marts/f_order.sql Build a new mart model called f_daily_sales_summary that aggregates daily revenue by truck, location, and menu item. It should follow the conventions in this file -- use surrogate keys, ref() macros, and the same SQL style. Add it to the _schema.yml with appropriate tests. Then compile and run it.
```

**Expected result:** The `@` mention gives Cortex Code the existing `f_order.sql` as a concrete style reference. It writes `models/marts/f_daily_sales_summary.sql`, adds it to `models/marts/_schema.yml` with tests, compiles, and materializes it. Because it had the actual file to reference (not just a verbal instruction to "match conventions"), the output matches the surrogate key pattern, naming conventions, and SQL formatting precisely.

### Prompt 19: Query the results

```
#DEV_DBT_DEMO.CURATED.F_DAILY_SALES_SUMMARY Show me the top 10 days by total revenue
```

**Expected result:** The `#` prefix auto-injects the table's column schema and sample rows into the prompt, so Cortex Code knows exactly what columns are available without guessing. It runs a SQL query directly against Snowflake and returns a formatted result table -- no context switching to another tool.

---

## Act 4: Ad-Hoc Data Exploration (~1-2 min)

> **Story:** "While I'm here, let me answer a few quick business questions."

### Prompt 20: Business question

```
#DEV_DBT_DEMO.CURATED.F_ORDER_LINE #DEV_DBT_DEMO.CURATED.D_MENU_ITEM What are the top 5 menu items by total revenue?
```

**Expected result:** Both `#` mentions inject their schemas into context, so Cortex Code sees the join key and revenue columns before writing a single line of SQL. It writes and executes a query joining the two tables, returning a formatted results table.

### Prompt 21: Another business question

```
#DEV_DBT_DEMO.CURATED.D_LOYALTY_MEMBER How many loyalty members signed up each year?
```

**Expected result:** A quick query against the table, grouped by year. The `#` mention ensures Cortex Code knows the exact column name for the sign-up date without having to look it up. No SQL IDE needed -- explore data, build models, and run tests all in one place.

---

## Act 5 (Bonus): Git Workflow (~30 sec)

> **Story:** "Let's commit all of this."

### Prompt 22: Commit

```
Commit all changes with an appropriate message
```

**Expected result:** Cortex Code stages the new/modified files and creates a well-formatted commit message summarizing everything that was done.

---

## Closing Talking Points

1. **Native dbt understanding** -- Cortex Code knows about sources, refs, models, tests, and lineage out of the box via the dbt skill
2. **Convention-aware** -- It reads existing code and matches style, frameworks, and patterns automatically
3. **Full lifecycle** -- Explore -> Test -> Build -> Query -> Document -> Commit, all without leaving the CLI
4. **Snowflake-native** -- Direct SQL execution against Snowflake, no extra configuration needed
5. **Time savings** -- What we just did in 10 minutes would take a developer 2-4 hours manually

---

## Troubleshooting / Backup Plans

| If this happens... | Do this... |
|---|---|
| `dbt test` fails | Let Cortex Code diagnose and fix it live -- this is actually a great demo moment |
| Snowflake connection issues | Pre-run `dbt debug` before the demo to verify connectivity |
| Model compilation error | Ask Cortex Code to fix it -- shows iterative problem-solving |
| Running low on time | Skip Acts 5-6 (bonus) and go straight to closing |
| Audience asks "can it do X?" | Try it live -- Cortex Code handles unexpected prompts well |

---

## dbt Code Generation

The [dbt-codegen package](https://github.com/dbt-labs/dbt-codegen) provides tools for generating model YAML and SQL.

### Generating Source YAML from the command line

```shell
dbt --quiet run-operation generate_source --args '{"schema_name": "raw", "table_names":["country","franchise","location","menu","order_detail","order_header","truck"], "generate_columns": true}' > models/staging/pos/_source_pos.yml
```

### Generating Staging Model for a source from the command line

```shell
dbt --quiet run-operation generate_base_model --args '{"source_name": "raw", "table_name": "customer_loyalty"}' > models/staging/loyalty/stg_loyalty__customer_loyalty.sql
```

### Generating Model YAML from the command line

```shell
dbt run-operation generate_model_yaml --args '{"model_names": ["model_name"], "upstream_descriptions": True, "include_data_types": True}'
```

---

## Demo Environment Setup

One-time setup for SEs running this demo from scratch.

### 1. Local Prerequisites

Install these tools on your machine:

| Tool | Install |
|------|---------|
| **git** | [git-scm.com](https://git-scm.com/) |
| **Python 3.10+** | [python.org](https://www.python.org/downloads/) |
| **uv** | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| **Cortex Code CLI** | `snow cortex code install` (requires [Snowflake CLI](https://docs.snowflake.com/en/developer-guide/snowflake-cli/installation/installation)) |

### 2. Clone the Repo

```bash
git clone https://github.com/sfc-gh-dgillis/dbt-coco-demo.git
cd dbt-coco-demo
```

### 3. Cortex Code CLI Authentication

Cortex Code authenticates via a Snowflake connection defined in `~/.snowflake/connections.toml`. If you already have a connection configured (e.g., from Snowflake CLI), verify it works:

```bash
cortex connections list
```

If you need to create a connection, add an entry to `~/.snowflake/connections.toml`:

```toml
[my_demo_connection]
account = "<your_account_identifier>"
user = "<your_username>"
authenticator = "SNOWFLAKE_JWT"
private_key_file = "<path_to_your_private_key.p8>"
role = "dbt_demo_data_engineer"
warehouse = "dbt_demo_xs_wh"
database = "dev_dbt_demo"
schema = "curated"
```

Then set it as the active connection:

```bash
cortex connections set my_demo_connection
```

### 4. Snowflake Account Setup

Run the batch-1 SQL scripts **in order** in a Snowflake worksheet (or via SnowSQL). These require SYSADMIN/SECURITYADMIN/ACCOUNTADMIN roles.

| Script | What It Creates | Role Required |
|--------|----------------|---------------|
| `tasks/snow-cli/sql/batch-1/1_create_warehouses.sql` | 6 warehouses (xs through xxl) | SYSADMIN |
| `tasks/snow-cli/sql/batch-1/2_init_roles.sql` | 4 roles (rw, ro, data_engineer, analyst) | SECURITYADMIN |
| `tasks/snow-cli/sql/batch-1/3_create_db_schema.sql` | `dev_dbt_demo` database + 4 schemas (raw, curated, modeled, utilities) | SYSADMIN |
| `tasks/snow-cli/sql/batch-1/4_grants.sql` | Comprehensive grants for all roles/schemas/warehouses | ACCOUNTADMIN + SECURITYADMIN |

> **Important:** The grants script (`4_grants.sql`) contains a `GRANT ROLE ... TO USER tastyb` statement on the last line. **Edit this to your own Snowflake username** before running.

### 5. Load Raw Data

Run the batch-2 data load script in a Snowflake worksheet:

```
tasks/snow-cli/sql/batch-2/5_load_raw_data.sql
```

This script:
- Creates an external stage pointing to the public Tasty Bytes S3 bucket (`s3://sfquickstarts/frostbyte_tastybytes/`)
- Creates all 9 raw source tables in `dev_dbt_demo.raw`
- Loads data via `COPY INTO` from the stage
- Uses `dbt_demo_l_wh` (Large warehouse) for bulk loading

**Estimated time:** ~5-10 minutes (the order_header and order_detail tables are 248M and 674M rows respectively).

**Verify** the load succeeded with the row count query at the end of the script:

| Table | Expected Rows |
|-------|--------------|
| country | 30 |
| franchise | 325 |
| location | 13,093 |
| menu | 100 |
| truck | 450 |
| order_header | ~248M |
| order_detail | ~674M |
| customer_loyalty | 222,541 |
| core_poi_geometry | 15,000 |

### 6. dbt Connection Profile

dbt uses [connection profiles](https://docs.getdbt.com/docs/core/connect-data-platform/connection-profiles) stored in `~/.dbt/profiles.yml`. Create the file if it doesn't exist:

```bash
mkdir -p ~/.dbt
touch ~/.dbt/profiles.yml
```

Add a profile matching this project's `dbt_project.yml` (profile name: `default`):

```yaml
default:
  target: dev-keypair-auth
  outputs:
    dev-keypair-auth:
      type: snowflake
      account: <your_account_identifier>
      user: <your_username>
      role: dbt_demo_data_engineer
      private_key_path: <path_to_your_private_key.p8>
      database: dev_dbt_demo
      warehouse: dbt_demo_xs_wh
      schema: curated
      threads: 8

    dev-pat-auth:
      type: snowflake
      account: <your_account_identifier>
      user: <your_username>
      role: dbt_demo_data_engineer
      authenticator: programmatic_access_token
      token: "{{ env_var('DBT_ENV_SECRET_PAT') }}"
      database: dev_dbt_demo
      warehouse: dbt_demo_xs_wh
      schema: curated
      threads: 8
```

For PAT auth, set the environment variable before running dbt:

```bash
export DBT_ENV_SECRET_PAT="<your_programmatic_access_token>"
```

### 7. Do NOT Create a Virtual Environment

The demo script intentionally creates the venv and installs dependencies **live** during Prompt 6. This is a key demo moment showing Cortex Code's ability to set up a project from scratch.

If you create `.venv/` or run `dbt deps` beforehand, that demo moment is lost. The [Pre-Demo Checklist](#pre-demo-checklist) includes a step to delete `.venv/` to ensure a clean state.