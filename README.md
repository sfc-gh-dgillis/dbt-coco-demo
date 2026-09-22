# dbt-coco-demo

A Snowflake dbt demo project ("Tasty Bytes") for Solution Engineers to demonstrate Cortex Code CLI and dbt capabilities.

> **First time setup?** See [Demo Environment Setup](#demo-environment-setup) for one-time Snowflake account configuration.
>
> **Returning for another demo?** Open Cortex Code in the project directory and tell it to "reset the demo". The `dbt-coco-demo` skill handles the rest.

---

## Cortex Code CLI Demo Script

**Scenario:** You just inherited a dbt project from a colleague. You've never seen it before. Use Cortex Code to understand it, improve it, and extend it -- all from the CLI.

**Repo:** `dbt-coco-demo` (Tasty Bytes food truck analytics)

**Total time:** ~10-12 minutes

---

## Pre-Demo Checklist

Run through this before each demo to ensure a clean starting state.

1. **Open Cortex Code** in the `dbt-coco-demo` project directory root
2. **Reset the demo** — tell Cortex Code to "reset the demo and switch to the main branch". The `dbt-coco-demo` skill cleans up artifacts (`.venv/`, dbt_packages, target, generated model files) and gets you back to a clean `main`
3. **Verify the environment** — ask Cortex Code to "verify the Snowflake connection and check that raw data exists". It runs `dbt debug` and a row count sanity check for you
4. **Browser tab** — open Snowsight in a browser (optional, for showing query results visually)

> **Important:** Do NOT create a virtual environment or install dbt deps before the demo. Prompt 7 does this live as a demo moment.

---

## Demo Overview

You've just inherited an unfamiliar dbt project from a colleague who left the company. Using Cortex Code, you go from zero understanding to a fully tested, extended, and committed codebase -- all from the CLI in about 10 minutes.

**Data domain:** Tasty Bytes, a fictitious global food truck company. Three source systems (POS, customer loyalty, SafeGraph location data), ~922 million rows of raw data across 9 tables in Snowflake.

**The arc follows five acts:**

**Act 1: Orientation** (~2 min)

- Explain Cortex startup and AGENTS.md 
- Choose an LLM model (`/model`)
- Explore the project structure using `@` file mentions and the dbt skill
- Assess data quality on raw source tables (`$data-quality`)
- Check account security posture (`$trust-center`)
- Cut a dev branch (native Git)
- Explore raw data using `#` table mentions for schema/sample injection
- Set up the dev environment live (`.venv/`, dbt deps)
- Trace model lineage back to raw sources, then view the DAG with `/lineage`

**Act 2: Code Quality & Testing** (~3 min)
- Generate `_schema.yml` with descriptions, data types, and constraints for all dimension marts
- Commit the schema changes
- Add `unique` and `relationships` tests; discuss tradeoffs (e.g., `not_null` tests vs enforced constraints)
- Build dimension models
- Add enforced dbt contracts
- Run the test suite and diagnose/fix any failures live; verify correctness with the `dbt-verify` subagent
- `/compact` to free up context window

**Act 3: New Feature Build** (~3-4 min)
- `/fork` to checkpoint the session before building
- Build the wrong thing intentionally (bad naming, wrong materialization)
- `/rewind` to undo the mistake, then clean up files and Snowflake objects
- Rebuild correctly using `@` file mention as a style reference
- Query the new model with `#` table mention

**Act 4: Ad-Hoc Data Exploration** (~1-2 min)
- Top menu items by revenue (`#` two-table join)
- Loyalty signups by year (`#` single-table query)
- Best-selling items by truck brand (`#` three-table join)

**Act 5: Git Workflow** (bonus, ~30 sec)
- Commit all changes with an auto-generated message

**Key capabilities demonstrated:** built-in and custom skills (dbt, data-quality, trust-center), `@` file mentions and `#` table mentions for context injection, direct SQL execution, native Git, session management (`/compact`, `/fork`, `/rewind`), and iterative problem-solving when builds or tests fail.

---

## Act 1: Orientation (~2 min)

> **Story:** "I just cloned this repo from a teammate who left the company. I have no idea what it does."

It's a dbt project, but that's all you know. Let's use Cortex Code to explore and understand it before we start making changes. If you haven't already, start Cortex Code CLI in a terminal in the project directory root and follow along with the prompts below.

### Prompt 1: Choose a model

Cortex Code supports multiple LLM models. Run `/model` to see the live list available to **your** account and switch at any time mid-session, or set one at launch with `cortex --model <identifier>`:

```bash
cortex --model claude-opus-5
```

> **Model names change often.** New models ship regularly and availability varies by account and region, so this guide deliberately does not pin an exhaustive list. `/model` is always the source of truth -- open it during the demo and read off what's actually there.

**How to choose:**
- Start with **`auto`** -- Cortex picks the best model available to your account, and you automatically benefit when better models ship. This is the recommended default.
- Reach for an **Opus** model when you need the highest quality: complex multi-file refactors, debugging tricky issues, or architectural decisions.
- Use a **Sonnet** model for day-to-day work: building models, writing tests, exploring data, running queries.
- The bracketed number next to each model in `/model` (for example `[1M]`, `[200K]`) is its **context window size** in tokens -- how much conversation, file content, and tool output it can hold before the session needs compacting. A larger window means longer sessions and more files in context at once. The `auto` entries show no number because they route across multiple models.
- **OpenAI GPT** models are offered in preview. They require an ACCOUNTADMIN to enable cross-region inference to Azure US:
  ```sql
  ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AZURE_US';
  ```

**Regional availability:** Not all models are available in every region. If a model isn't available in yours, enable [cross-region inference](https://docs.snowflake.com/en/user-guide/snowflake-cortex/llm-functions#cross-region-inference) by setting `CORTEX_ENABLED_CROSS_REGION` (requires ACCOUNTADMIN). Use `AWS_US` for best Claude Opus coverage, or `ANY_REGION` for broadest access.

```
/model
```

**Expected result:** Cortex Code opens the model picker showing exactly which models your account can use. Pick a current Opus model for the demo. This is a good moment to talk through the tradeoffs -- and to point out that `auto` means the audience never has to track model names themselves.

### Prompt 2: Explore the project

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
> - **Custom skills** are Markdown files you create in `.cortex/skills/` (project-level) or `~/.snowflake/cortex/skills/` (global) to encode your team's conventions. This project includes one: `dbt-coco-demo` (in `.cortex/skills/dbt-coco-demo/SKILL.md`), which knows how to set up, reset, build, and test the demo without you needing to remember any commands
> - **Remote skills** can be pulled from Git repos and shared across your organization
>
> You can invoke a skill explicitly by prefixing it with `$` (e.g., `$data-quality`, `$lineage`), or Cortex Code activates the right skill automatically based on your prompt. Run `/skill` to browse and manage available skills, or `cortex skill list` from a shell.

### Prompt 3: Check data quality on the source tables

Now that we know what the project does, let's see if the source data is trustworthy before we start building. This uses the `$data-quality` skill to do a quick assessment.

```
$data-quality Run a quick quality scan on the raw source tables in this project. Check for nulls in key columns, row counts, and anything that looks off. Exclude analysis of the order_header and the order_detail tables since those are very large and we don't want to run expensive checks on them right now. Give me a plain-English summary of the results.
```

**Expected result:** Cortex Code activates the data-quality skill, identifies the source tables from the dbt project, and runs targeted SQL checks -- null rates on primary keys, row count validation, and anomaly detection. It returns a plain-English summary of data health. No SQL written by hand -- the skill knew exactly what to look for.

### Prompt 4: Analyze security posture

While we're assessing the project, let's check the account's security posture. The `$trust-center` skill connects to Snowflake's Trust Center -- a built-in security scanner that continuously monitors your account for vulnerabilities, misconfigurations, and threats.

```
$trust-center Analyze my security posture
```

**Expected result:** Cortex Code activates the trust-center skill, queries the Trust Center findings, and returns a structured security report: severity distribution, active findings by scanner, trends, and specific remediation steps with SQL to fix them. Same Trust Center from Snowsight, but queried conversationally from the terminal.

### Prompt 5: Cut a dev branch

Cortex Code works natively with Git -- it can create branches, stage files, commit changes, and more, all without leaving the CLI. It's good practice to work on a dev branch so we don't push untested changes directly to main.

```text
Create a new branch called dbt-coco-demo-dev and switch to it
```

**Expected result:** Cortex Code runs `git checkout -b dbt-coco-demo-dev` and confirms the switch. Reinforces that Cortex Code is a full development environment with native Git support -- branching, committing, diffing, all built in.

### Prompt 6: Explore the raw data

Cortex Code connects directly to Snowflake -- no extra configuration, no context switching to a SQL IDE. Let's use that to get a feel for the raw data before we start building.

```
#DEV_DBT_DEMO.RAW.MENU What does this raw menu data look like? Also run row counts on all the raw source tables and give me a summary of what data we're working with.
```

**Expected result:** The `#` prefix auto-injects the table's column schema and a sample of rows directly into the prompt, so Cortex Code immediately sees what columns exist and what the data looks like. It describes the menu table in detail, then executes SQL against Snowflake for row counts across all source tables and returns a plain-English summary. No need to open Snowsight or a SQL IDE.

> **Aside: `#` table mentions**
>
> The `#` prefix works like `@` for files, but for Snowflake tables. When you type `#DB.SCHEMA.TABLE`, Cortex Code auto-injects the table's column schema and a sample of rows into the prompt context. This means it knows exact column names, data types, and what the data looks like -- no guessing, no `DESCRIBE TABLE` needed. You can mention multiple tables in a single prompt to give it join context. You'll see this used throughout Acts 3 and 4 for querying mart tables directly.

### Prompt 7: Setup dbt

```text
This project does not have a virtual environment or dbt packages installed. Set those up now. Ensure the virtual environment is added to .gitignore so it doesn't get committed.
```

**Expected result:** The `dbt-coco-demo` skill activates automatically and handles the full setup: creates a virtual environment, installs dbt-core and dbt-snowflake, runs `dbt deps`, and verifies the Snowflake connection. It also adds the `.venv/` directory to `.gitignore`. The skill knows the exact versions and target to use -- no need to remember CLI flags or install commands.

### Prompt 8: Understand lineage

```
@models/marts/f_order_line.sql What does this model depend on? Trace the full lineage back to raw sources.
```

**Expected result:** The `@` mention feeds the model's SQL directly into the prompt so Cortex Code can see the `ref()` calls immediately. It traces the full lineage: `raw.order_detail -> stg_pos__order_detail -> f_order_line`. No manual file hunting -- `@` gives it the starting point, and the dbt skill traces the rest.

Then show the same thing as a picture. `/lineage` opens an interactive full-screen DAG of the project:

```
/lineage
```

**Expected result:** A navigable graph of all 19 models -- 9 staging views feeding 10 mart tables -- rendered right in the terminal. Great visual payoff after the text-based trace, and a fast way to orient in an unfamiliar project.

> **Aside: `/fdbt` for fast dbt introspection**
>
> Cortex Code ships a purpose-built dbt project explorer that is far faster than shelling out to dbt for structural questions. Try `/fdbt models`, `/fdbt lineage f_order_line`, or `/fdbt tests`. It reads the project directly, so it answers instantly without a dbt parse or a warehouse connection.

---

## Act 2: Code Quality & Testing (~3 min)

> **Story:** "This project has no contracts, constraints and zero tests. That's a problem. Let's fix it."

### Prompt 9: Add _schema.yml

```text
This project has no model and column properties defined for the mart models. Make a plan to add a `_schema.yml` file to models/marts/ with constraints for all mart models. Add top-level properties: name and description. Review each table and do your best to create a description based on your what you can glean from the table columns. Also add column properties: name, description, data_type as well as primary_key, foreign_key and not_null constraints. Exclude fact tables at this time as I want to focus on the dimensions first. Do not build yet, just create the YAML file.
```

**Expected result:** Cortex Code reads all the mart models, analyzes the columns, and generates a comprehensive `models/marts/_schema.yml` with model-level names and descriptions, column-level properties (name, description, data_type), and primary_key/foreign_key/not_null constraints -- all inferred from context.

### Prompt 10: Commit the changes

```text
Commit the changes
```

**Expected result:** Cortex Code stages the new and modified files, generates a meaningful commit message summarizing the schema additions, and commits. It understands the context of what changed -- no copy-pasting or context switching.

### Prompt 11: Add Tests and Think Through Something

Often times when building, I ask questions of the Cortex Code that I may be pretty sure of, but it can help validate my thinking.

```text
This project has no tests for the mart models. Add tests for all mart models but do not build yet. Include unique tests on all primary keys, and relationship tests where foreign keys reference other mart dimensions. Also, I am considering adding not_null tests, but that seems redundant considering added not_null constraints and in Snowflake these are actually enforced. What do you think?
```

**Expected result:** Cortex Code adds `unique` tests on every primary key and `relationships` tests linking foreign keys (e.g., `f_order.truck_key` -> `d_truck.truck_key`). It also provides a thoughtful response about not_null tests vs constraints -- reasoning about tradeoffs and helping make informed decisions, not just generating code.

### Prompt 12: Build the dimension models

```
Build the mart dimension models only.
```

**Expected result:** Cortex Code runs `dbt build` selecting only the dimension models, materializing them as tables in Snowflake. One prompt, no need to remember dbt selector syntax.

### Prompt 13: Add Enforced Contracts

```text
I want to use dbt contracts to define a set of upfront "guarantees" on model definitions. Add contracts to the mart models.
```

### Prompt 14: Run the tests

```
Run dbt test for the dimension marts models only and show me the results. If any tests fail, diagnose and fix them.
```

**Expected result:** Cortex Code runs `dbt test --select marts` and shows pass/fail results. If any fail, it diagnoses and fixes them live -- it operates the dbt CLI and reacts to results, not just writes files.

> **Aside: the `dbt-verify` subagent**
>
> A green `dbt test` run does not prove a model is *correct* -- it only proves the tests you wrote passed. Cortex Code bundles a **`dbt-verify`** subagent that goes further: it checks row counts against sources, spot-checks boundary values, validates that classification logic covers every case, and re-derives expected values straight from the source tables. Ask for it by name:
>
> ```text
> Use the dbt-verify subagent to verify the dimension models are actually correct, not just passing tests.
> ```
>
> There is a matching **`sql-verify`** subagent for ad-hoc SQL, which statically hunts for cartesian joins, fanout from one-to-many joins, NULL comparison traps, and integer-division precision loss. Both are worth showing to an audience that has been burned by silently-wrong data.

---

### Prompt 15: Compact the context

We've done a lot of work -- schema generation, test writing, builds. The conversation context is getting long, which can slow down responses and use up the context window. Let's compact it before starting fresh.

```
/compact
```

**Expected result:** Cortex Code summarizes the entire conversation history into a condensed form and frees up context window space. All the important state is preserved (what files exist, what was built, what branch we're on), but the verbose back-and-forth is compressed. Think of it as garbage collection for your conversation. Use `/compact` proactively during long sessions to keep things snappy.

---

## Act 3: New Feature Build (~3-4 min)

> **Story:** "Let's analyze menu item profitability."

### Prompt 16: Fork before building

```
/fork before-new-model
```

**Expected result:** Cortex Code creates a new session branched from this point -- a checkpoint before we start building. This is like `git branch` for your conversation. If the next few prompts go sideways, we can come back to this exact state. The original session is preserved untouched.

> **Aside:** `/fork` and `/rewind` are session management commands. `/fork` creates a non-destructive branch (keeps the original). `/rewind` rolls back destructively (discards messages). We'll see both in action.

### Prompt 17: Build the wrong thing (intentional)

```
Build a new mart model called menu_profitability that shows profit margin per menu item. Include the item name, brand, category, cost, price, and margin. Materialize it as a view.
```

**Expected result:** Cortex Code builds the model -- but it's wrong. The name doesn't follow the `d_` or `f_` prefix convention, it uses no surrogate keys, and it's materialized as a view instead of a table. This is intentional -- we're about to undo it.

### Prompt 18: Rewind the mistake

```
/rewind 1
```

**Expected result:** Cortex Code rolls back one user message, discarding the bad model build from the conversation. However, `/rewind` only rolls back the *conversation state* -- any files written to disk or tables materialized in Snowflake are still there. We need to clean those up.

### Prompt 19: Clean up the mess

```
Delete the menu_profitability model file and drop the view in Snowflake if it was created.
```

**Expected result:** Cortex Code removes the file from disk and drops the view from Snowflake. This is the full undo -- conversation rewound, file deleted, view dropped. Now we can re-prompt with the correct requirements.

> **Aside:** `/rewind` is destructive -- it throws away everything after the rewind point. Use `/fork` when you might want to come back, and `/rewind` when you know the recent work was wrong. Remember that `/rewind` only affects the conversation -- any side effects (files, tables, git commits) need to be cleaned up separately.

### Prompt 20: Build the model correctly

```
@models/marts/d_menu_item.sql Build a new mart model called f_menu_profitability that calculates profit margin per menu item. It should follow the conventions in this file -- use surrogate keys, ref() macros, and the same SQL style. Materialize as a table. Add it to _schema.yml with appropriate tests. Then compile and run it.
```

**Expected result:** The `@` mention gives Cortex Code the existing `d_menu_item.sql` as a concrete style reference. It writes `models/marts/f_menu_profitability.sql`, adds it to `models/marts/_schema.yml` with tests, compiles, and materializes it. Because it had the actual file to reference (not just a verbal instruction to "match conventions"), the output matches the surrogate key pattern, naming conventions, and SQL formatting precisely.

### Prompt 21: Query the results

```
#DEV_DBT_DEMO.MODELED.F_MENU_PROFITABILITY Show me the top 5 most profitable menu items by margin percentage
```

**Expected result:** The `#` prefix auto-injects the table's column schema and sample rows into the prompt, so Cortex Code knows exactly what columns are available without guessing. It runs a SQL query directly against Snowflake and returns a formatted result table -- no context switching to another tool.

---

## Act 4: Ad-Hoc Data Exploration (~1-2 min)

> **Story:** "While I'm here, let me answer a few quick business questions."

### Prompt 22: Business question

```
#DEV_DBT_DEMO.MODELED.F_ORDER_LINE #DEV_DBT_DEMO.MODELED.D_MENU_ITEM What are the top 5 menu items by total revenue?
```

**Expected result:** Both `#` mentions inject their schemas into context, so Cortex Code sees the join key and revenue columns before writing a single line of SQL. It writes and executes a query joining the two tables, returning a formatted results table.

### Prompt 23: Another business question

```
#DEV_DBT_DEMO.MODELED.D_LOYALTY_MEMBER How many loyalty members signed up each year?
```

**Expected result:** A quick query against the table, grouped by year. The `#` mention ensures Cortex Code knows the exact column name for the sign-up date without having to look it up. No SQL IDE needed -- explore data, build models, and run tests all in one place.

### Prompt 24: Multi-table join

```
#DEV_DBT_DEMO.MODELED.F_ORDER_LINE #DEV_DBT_DEMO.MODELED.D_MENU_ITEM #DEV_DBT_DEMO.MODELED.D_TRUCK What are the top 3 best-selling menu items for each truck brand?
```

**Expected result:** Three `#` mentions inject all three table schemas at once, giving Cortex Code the join keys and columns across fact and dimension tables. It writes a multi-table join with window functions or grouping -- no manual schema lookup needed. This shows the real power of `#`: the more tables you mention, the more context Cortex Code has to write accurate, complex SQL in one shot.

---

## Act 5 (Bonus): Git Workflow (~30 sec)

> **Story:** "Let's commit all of this."

### Prompt 25: Commit

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
6. **`@` and `#` context injection** -- `@` for files, `#` for Snowflake tables. Auto-injects schemas, sample data, and file contents so Cortex Code writes accurate code and SQL without guessing
7. **Infrastructure as code** -- the entire Snowflake environment behind this demo (database, schemas, warehouses, roles, grants, tables, file formats, stages) is a declarative [DCM project](https://docs.snowflake.com/en/user-guide/dcm-projects/dcm-projects-overview). `task demo-init` deploys it, `task destroy-demo` purges it, and `snow dcm plan` previews any drift. Cortex Code authored and debugged those definitions
8. **Verification, not just generation** -- the `dbt-verify` and `sql-verify` subagents check that generated models and queries are actually *correct*, which is the part that matters when the output feeds a business decision

---

## Troubleshooting / Backup Plans

| If this happens... | Do this... |
|---|---|
| `dbt test` fails | Let Cortex Code diagnose and fix it live -- this is actually a great demo moment |
| Snowflake connection issues | Run `/doctor` to diagnose the connection, or pre-run `dbt debug` before the demo to verify connectivity |
| Model compilation error | Ask Cortex Code to fix it -- shows iterative problem-solving |
| Running low on time | Skip Act 5 (bonus) and go straight to closing |
| Audience asks "can it do X?" | Try it live -- Cortex Code handles unexpected prompts well |

---

## Beyond the Script

The scripted demo is deliberately tight. When the audience asks "can it do X?", these are all live and worth a detour.

**Session & context control**

| Capability | What to say |
|---|---|
| `/goal` | Set a persistent objective for a long task so the agent keeps its own progress on track |
| `/qq` | Ask a side question without polluting the main conversation's context |
| `/rewind` / `/unrewind` | Undo the last N user messages, then change your mind and restore them |
| `/context`, `/stats` | Show exactly what is consuming the context window and how many tokens you have spent |
| `cortex memory` | Preferences and conventions that persist across sessions, not just within one |
| `cortex conversations search` | Search every past session -- "what did I do to that model last week?" |

**Code quality & review**

| Capability | What to say |
|---|---|
| `/review` (`/diff`) | Full-screen review of working-tree or staged changes before committing |
| `/simplify` | Ask the agent to clean up what it just wrote -- reuse, dedupe, right altitude |
| `/index`, `/tgrep` | Semantic code search: find files by *meaning* rather than exact string, which matters in a large monorepo |
| `sql-verify` subagent | Static correctness review of a query: cartesian joins, fanout, NULL traps, integer division |

**Scale & automation**

| Capability | What to say |
|---|---|
| `/team` (`Ctrl+G`) | Multiple agents working in parallel with distinct ownership, for work that genuinely decomposes |
| `/batch` | Fan out one uniform change across many files using isolated git worktrees, then open a PR |
| `/background-agent` (`/bg`) | Hand a long task to a background agent and keep working in the foreground |
| `/automation` | Schedule this work as a recurring Snowflake AGENT TASK -- a nightly freshness check or cost report |
| `/loop` (`/cron`) | Schedule a recurring prompt within the session |

**Governance & safety**

| Capability | What to say |
|---|---|
| `/guardrails` | Restricted Session Scope -- make the agent's SQL read-only, or block specific roles, before letting it near a sensitive account |
| `/permissions` | Per-tool approval rules and workspace trust |
| `$trust-center`, `$data-governance`, `$cost-intelligence` | Bundled skills covering security posture, masking/classification, and credit spend |

Run `/help` for the full command list, or `/skill` to browse every available skill.

---

## dbt Code Generation

The [dbt-codegen package](https://github.com/dbt-labs/dbt-codegen) provides tools for generating model YAML and SQL.

### Generating Source YAML from the command line

```shell
.venv/bin/dbt --quiet run-operation generate_source --target dev-keypair-auth \
  --args '{"schema_name": "raw", "table_names":["country","franchise","location","menu","order_detail","order_header","truck"], "generate_columns": true}' \
  > models/staging/pos/_source_pos.yml
```

The loyalty and SafeGraph sources live in their own files (`_source_customer_loyalty.yml`, `_source_safegraph.yml`) -- pass only the relevant `table_names` for each.

### Generating Staging Model for a source from the command line

```shell
.venv/bin/dbt --quiet run-operation generate_base_model --target dev-keypair-auth \
  --args '{"source_name": "raw", "table_name": "customer_loyalty"}' \
  > models/staging/loyalty/stg_loyalty__customer_loyalty.sql
```

### Generating Model YAML from the command line

```shell
.venv/bin/dbt run-operation generate_model_yaml --target dev-keypair-auth \
  --args '{"model_names": ["d_country"], "upstream_descriptions": true, "include_data_types": true}'
```

---

## Demo Environment Setup

One-time setup for SEs running this demo from scratch. After this initial setup, ongoing operations (setup, reset, build, test) can be handled conversationally via the `dbt-coco-demo` skill in Cortex Code.

### 1. Local Prerequisites

Install these tools on your machine:

| Tool | Install |
|------|---------|
| **git** | [git-scm.com](https://git-scm.com/) |
| **Python 3.10+** | [python.org](https://www.python.org/downloads/) |
| **uv** | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| **Snowflake CLI 3.24+** | Required for the DCM Projects commands this demo uses. `pip install snowflake-cli --upgrade` ([installation docs](https://docs.snowflake.com/en/developer-guide/snowflake-cli/installation/installation)) |
| **Cortex Code CLI** | `snow cortex code install` (requires Snowflake CLI above) |

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

### 4. Snowflake Account Setup and Raw Data Load

All Snowflake infrastructure is managed declaratively as a
[DCM project](https://docs.snowflake.com/en/user-guide/dcm-projects/dcm-projects-overview)
under `tasks/snow-cli/dcm/`. One command stands up the whole environment:

```bash
task demo-init
```

This requires Snowflake CLI 3.24+ and a connection with ACCOUNTADMIN available
(the deployment creates account-level roles and grants).

The task runs four steps:

| Step | What It Does |
|------|--------------|
| `pre_deploy.sql` | Creates `UTIL.DCM_PROJECT_ARCHIVE`, the parent schema for the DCM project object. A DCM project cannot `DEFINE` its own parent containers. |
| `snow dcm create` | Creates the DCM project object `UTIL.DCM_PROJECT_ARCHIVE.DBT_COCO_DEMO_DCM`. |
| `snow dcm deploy` | Deploys everything in `dcm/sources/definitions/`: the `dev_dbt_demo` database and its 4 schemas, 6 warehouses (xs through xxl), 4 roles, all grants, the 9 raw tables, the CSV file format, and the S3 external stage. |
| `post_deploy.sql` | Loads the raw data via `COPY INTO` from the public Tasty Bytes S3 bucket. |

The definition files are:

| File | Defines |
|------|---------|
| `dcm/sources/definitions/infrastructure.sql` | Database, 4 schemas, 6 warehouses |
| `dcm/sources/definitions/access.sql` | 4 roles (rw, ro, data_engineer, analyst), role hierarchy, and all grants |
| `dcm/sources/definitions/tables.sql` | The 9 raw source tables |
| `dcm/sources/definitions/storage.sql` | `CSV_FF` file format and the `S3_TASTYBYTES` external stage |

> **Important:** `access.sql` ends with a `GRANT ROLE DBT_DEMO_DATA_ENGINEER TO USER tastyb`
> statement. **Edit this to your own Snowflake username** before deploying.

Because the deployment is declarative, re-running `task demo-init` is safe — DCM
reconciles the account against the definitions rather than recreating objects.
To preview changes without applying them:

```bash
cd tasks/snow-cli/dcm && snow dcm plan UTIL.DCM_PROJECT_ARCHIVE.DBT_COCO_DEMO_DCM --database UTIL
```

**Note:** `access.sql` uses
[inherited grants](https://docs.snowflake.com/en/user-guide/inherited-grants-intro)
(`GRANT INHERITED ... ON ALL`) so privileges apply to current *and* future objects.
This needs a one-time account opt-in:

```sql
ALTER ACCOUNT SET FEATURE_RBAC_INHERITED_GRANTS = 'ENABLED';
```

### 5. Verify the Raw Data Load

**Estimated time:** ~5-10 minutes (the order_header and order_detail tables are 248M and 674M rows respectively).

`post_deploy.sql` ends with a row count query. Expected results:

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

The demo script intentionally creates `.venv/` and installs dependencies **live** during Prompt 7. This is a key demo moment showing Cortex Code's ability to set up a project from scratch.

If you create `.venv/` or run `dbt deps` beforehand, that demo moment is lost. The [Pre-Demo Checklist](#pre-demo-checklist) includes a step to delete `.venv/` to ensure a clean state.