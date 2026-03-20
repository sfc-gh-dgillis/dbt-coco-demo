# dbt-coco-demo

A Snowflake dbt demo project ("Tasty Bytes") for Solution Engineers to demonstrate Cortex Code CLI and dbt capabilities.

> **First time setup?** See [Environment Setup](#environment-setup) at the end of this document.

## Quick Start

```bash
# Activate virtual environment
source .venv/bin/activate

# Verify connection
dbt debug

# Build all models
dbt build
```

---

## Cortex Code CLI Demo Script

**Scenario:** You just inherited a dbt project from a colleague. You've never seen it before. Use Cortex Code to understand it, improve it, and extend it -- all from the CLI.

**Repo:** `dbt-coco-demo` (Tasty Bytes food truck analytics)

**Total time:** ~10-12 minutes

---

## Pre-Demo Setup

1. Open a terminal in your IDE of choice in the `dbt-coco-demo` project directory
2. Ensure `cortex` CLI is installed and authenticated
3. Verify the dbt virtual environment works: `source .venv/bin/activate && dbt debug`
4. Have Snowflake open in a browser tab (optional, for showing results in Snowsight)

---

## Act 1: Orientation (~2 min)

> **Story:** "I just cloned this repo from a teammate who left the company. I have no idea what it does."

### Prompt 1: Explore the project

```
What is this dbt project? Give me a summary of the data domain, the sources, the model layers, and any custom macros or UDFs.
```

**What the audience sees:** Cortex Code reads `dbt_project.yml`, the source YAMLs, the staging models, the mart models, and the macros. It synthesizes a clear summary:

- Tasty Bytes food truck company
- 3 source systems: POS (7 tables), Customer Loyalty (1 table), SafeGraph (1 table)
- 2-layer DAG: staging views -> mart tables (dimensional model)
- Custom UDFs for surrogate key generation and VARIANT flattening
- Uses `codegen` and `dbt_utils` packages

> **Aside: How did it know all that?** This is a good moment to explain **skills** to the audience.
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

**Key talking point:** "Skills are what make Cortex Code more than a general-purpose AI. It has deep, built-in expertise for Snowflake workflows -- and you can extend it with your own."

### Prompt 2: Check data quality on the source tables

Now that we know what the project does, let's see if the source data is trustworthy before we start building. This uses the `$data-quality` skill to do a quick assessment.

```
$data-quality Run a quick quality scan on the raw source tables in this project. Check for nulls in key columns, row counts, and anything that looks off. Exclude analysis of the order_header and the order_detail tables since those are very large and we don't want to run expensive checks on them right now. Give me a plain-English summary of the results.
```

**What the audience sees:** Cortex Code activates the data-quality skill, identifies the source tables from the dbt project, and runs targeted SQL checks -- null rates on primary keys, row count validation, and anomaly detection. It returns a plain-English summary of data health.

**Key talking point:** "I didn't write a single SQL query. I just told it to check data quality, and the skill knew exactly what to look for."

### Prompt 3: Analyze security posture

While we're assessing the project, let's check the account's security posture. The `$trust-center` skill connects to Snowflake's Trust Center -- a built-in security scanner that continuously monitors your account for vulnerabilities, misconfigurations, and threats.

```
$trust-center Analyze my security posture
```

**What the audience sees:** Cortex Code activates the trust-center skill, queries the `snowflake.trust_center.findings` view, and returns a structured security report: severity distribution, active findings by scanner, week-over-week trends, and specific remediation steps. In this account, all findings are MFA/authentication related -- it even generates the SQL to fix them.

**Key talking point:** "This is the same Trust Center you see in Snowsight, but now I can query it conversationally and get actionable remediation steps -- right here in my terminal."

### Prompt 4: Cut a dev branch

Cortex Code works natively with Git -- it can create branches, stage files, commit changes, and more, all without leaving the CLI. It's good practice to work on a dev branch so we don't push untested changes directly to main.

```text
Create a new branch called dgillis-dev and switch to it
```

**What the audience sees:** Cortex Code runs `git checkout -b dgillis-dev` and confirms the switch. Simple, but it reinforces that Cortex Code is a full development environment -- not just a code generator.

**Key talking point:** "Cortex Code understands Git natively. Branching, committing, diffing -- it's all built in. No context switching."

### Prompt 5: Explore the raw data

Cortex Code connects directly to Snowflake -- no extra configuration, no context switching to a SQL IDE. Let's use that to get a feel for the raw data before we start building.

```
Run row counts on all the raw source tables and give me a summary of what data we're working with. Describe the key tables.
```

**What the audience sees:** Cortex Code executes SQL directly against Snowflake, returning row counts for all source tables and a plain-English summary of the data -- table purposes, key columns, and approximate scale. No need to open Snowsight or a SQL IDE.

**Key talking point:** "Cortex Code has a native Snowflake connection. You can query data, inspect tables, and answer questions -- all without leaving the CLI."

### Prompt 6: Setup dbt

```text
This project does not have a virtual environment or dbt packages installed. Set those up now. Ensure the virtual environment is added to .gitignore so it doesn't get committed.
```

### Prompt 7: Understand lineage

```
What does the f_order_line model depend on? Trace the full lineage back to raw sources.
```

**What the audience sees:** Cortex Code uses the dbt skill to show:

```
raw.order_detail -> stg_pos__order_detail -> f_order_line
```

**Key talking point:** "I didn't have to read a single file. Cortex Code understands dbt project structure natively."

---

## Act 2: Code Quality & Testing (~3 min)

> **Story:** "This project has no contracts, constraints and zero tests. That's a problem. Let's fix it."

### Prompt 8: Add schema.yml

```text
This project has no model and column properties defined for the mart models. Make a plan to add a `_schema.yml` file to models/marts/ with constraints for all mart models. Add top-level properties: name and description. Review each table and do your best to create a description based on your what you can glean from the table columns. Also add column properties: name, description, data_type as well as primary_key, foreign_key and not_null constraints. Exclude fact tables at this time as I want to focus on the dimensions first. Do not build yet, just create the YAML file.
```

**What the audience sees:** Cortex Code reads all the mart models, analyzes the columns, and generates a comprehensive `models/marts/schema.yml` with:

- Model-level `name` and `description` for all 10 mart models
- Column-level `name`, `description`, and `data_type` for every column
- `primary_key`, `foreign_key`, and `not_null` constraints where appropriate

**Key talking point:** "It inferred descriptions and constraints from context -- column names, data types, and relationships to other models."

### Prompt 9: Commit the changes

```text
Commit the changes
```

**What the audience sees:** Cortex Code stages the new and modified files, generates a meaningful commit message summarizing the schema additions, and commits.

**Key talking point:** "It understands the context of what changed and writes a descriptive commit message -- no copy-pasting or context switching."

### Prompt 10: Add Tests and Think Through Something

Often times when building, I ask questions of the Cortex Code that I may be pretty sure of, but it can help validate my thinking.

```text
This project has no tests for the mart models. Add tests for all mart models but do not build yet. Include unique tests on all primary keys, and relationship tests where foreign keys reference other mart dimensions. Also, I am considering adding not_null tests, but that seems redundant considering added not_null constraints and in Snowflake these are actually enforced. What do you think?
```

**What the audience sees:** Cortex Code adds dbt tests to the schema.yml:

- `unique` tests on every primary key
- `relationships` tests linking foreign keys (e.g., `f_order.truck_key` -> `d_truck.truck_key`)

It also provides a thoughtful response about not_null tests vs constraints -- explaining that while Snowflake enforces NOT NULL constraints at write time, dbt tests catch issues in upstream data *before* it hits the table, so there's value in both approaches depending on your data quality strategy.

**Key talking point:** "Cortex Code isn't just a code generator -- it can reason about tradeoffs and help you make informed decisions."

### Prompt 11: Build empty models

```
Build the mart dimension models only with the --empty flag so the tables exist for schema validation, but data doesn't have to load yet. This will allow us to run tests faster and iterate on the schema if needed.
```

**What the audience sees:** Cortex Code runs `dbt build --select marts --empty` which creates the table structures without loading data. This is fast and ensures the schema exists for relationship tests to validate against.

**Key talking point:** "The --empty flag is a dbt trick for quickly validating schema and relationships without waiting for data to load."

### Prompt 12: Add Enforced Contracts

```text
I want to use dbt contracts to define a set of upfront "guarantees" on model definitions. Add contracts to the mart models.
```

### Prompt 13: Run the tests

```
Run dbt test for the dimension marts models only and show me the results. If any tests fail, diagnose and fix them.
```

**What the audience sees:** Cortex Code runs `dbt test --select marts` and shows pass/fail results. If any fail, it diagnoses and fixes them live (which is actually a *better* demo moment than all passing).

**Key talking point:** "Cortex Code doesn't just write files -- it operates the dbt CLI and reacts to results."

---

## Act 3: New Feature Build (~3-4 min)

> **Story:** "The business team wants a daily sales summary. Let's build it."

### Prompt 14: Build a new model

```
Build a new mart model called f_daily_sales_summary that aggregates daily revenue by truck, location, and menu item. It should follow the existing conventions in this project -- use surrogate keys, ref() macros, and the same SQL style. Add it to the schema.yml with appropriate tests. Then compile and run it.
```

**What the audience sees:** Cortex Code:

1. Writes `models/marts/f_daily_sales_summary.sql` joining `f_order`, `f_order_line`, and the relevant dimensions
2. Adds the model to `models/marts/schema.yml` with tests
3. Runs `dbt compile --select f_daily_sales_summary` to validate
4. Runs `dbt run --select f_daily_sales_summary` to materialize it

**Key talking point:** "It matched the existing surrogate key pattern, the naming conventions, even the SQL formatting -- because it read the other models first."

### Prompt 15: Query the results

```
Show me the top 10 days by total revenue from f_daily_sales_summary
```

**What the audience sees:** Cortex Code runs a SQL query directly against Snowflake and returns a formatted result table -- no context switching to another tool.

---

## Act 4: Ad-Hoc Data Exploration (~1-2 min)

> **Story:** "While I'm here, let me answer a few quick business questions."

### Prompt 16: Business question

```
What are the top 5 menu items by total revenue?
```

**What the audience sees:** Cortex Code writes and executes a query joining `f_order_line` with `d_menu_item`, returning results like:

| menu_item_name | total_revenue |
|---|---|
| Lobster Mac & Cheese | $X,XXX,XXX |
| ... | ... |

### Prompt 17: Another business question

```
How many loyalty members signed up each year?
```

**What the audience sees:** A quick query against `d_loyalty_member` grouped by year.

**Key talking point:** "No SQL IDE needed. I can explore data, build models, and run tests all in one place."

---

## Act 5 (Bonus): Documentation (~1-2 min)

> **Story:** "Let's also clean up the source definitions while we're at it."

### Prompt 18: Add descriptions

```
Add meaningful column descriptions to the POS source YAML in
models/staging/pos/_source_pos.yml. Infer descriptions from the column names
and data types.
```

**What the audience sees:** Cortex Code updates the source YAML with human-readable descriptions for every column across all 7 POS tables.

**Key talking point:** "Documentation is the thing nobody wants to do. Now there's no excuse."

---

## Act 6 (Bonus): Git Workflow (~30 sec)

> **Story:** "Let's commit all of this."

### Prompt 19: Commit

```
Commit all changes with an appropriate message
```

**What the audience sees:** Cortex Code stages the new/modified files and creates a well-formatted commit message summarizing everything that was done.

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

## Environment Setup

### Minimum Requirements

- [git](https://git-scm.com/)
- [Python 3.9+](https://www.python.org/downloads/)
- [uv](https://docs.astral.sh/uv/) - Python package and project manager

### Get the Code

```shell
git clone https://github.com/sfc-gh-dgillis/dbt-coco-demo.git
cd dbt-coco-demo
```

### Virtual Environment Setup

Install uv if you don't have it:

```shell
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Create and activate the virtual environment:

```shell
uv venv
source .venv/bin/activate
```

Install dbt:

```shell
uv pip install dbt-core dbt-snowflake
```

### Connection Profile Setup

dbt uses [connection profiles](https://docs.getdbt.com/docs/core/connect-data-platform/connection-profiles) stored in `~/.dbt/profiles.yml`.

Create the directory and file:

```shell
mkdir -p ~/.dbt
touch ~/.dbt/profiles.yml
```

Add your target configuration. Below are examples for key pair and PAT authentication:

```yaml
default:
  target: dev-keypair-auth
  outputs:
    dev-keypair-auth:
      type: snowflake
      account: <your_account_identifier>
      user: <your_username>
      role: <your_role>
      private_key_path: <path_to_your_private_key.p8>
      database: <your_database>
      warehouse: <your_warehouse>
      schema: curated
      threads: 8

    dev-pat-auth:
      type: snowflake
      account: <your_account_identifier>
      user: <your_username>
      role: <your_role>
      password: "{{ env_var('DBT_ENV_SECRET_PAT') }}"
      database: <your_database>
      warehouse: <your_warehouse>
      schema: curated
      threads: 8
```

### Verify Your Connection

```shell
source .venv/bin/activate
dbt debug
```

You should see `All checks passed!` at the end. 