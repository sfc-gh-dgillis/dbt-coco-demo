# Cortex Code + dbt Demo Prompts

---

## Act 1: Orientation (~2 min)

### Prompt 1: Explore the project

```
What is this dbt project? Give me a summary of the data domain, the sources, the model layers, and any custom macros or UDFs.
```

### Prompt 2: Check data quality on the source tables

```
$data-quality Run a quick quality scan on the raw source tables in this project. Check for nulls in key columns, row counts, and anything that looks off. Exclude analysis of the order_header and the order_detail tables since those are very large and we don't want to run expensive checks on them right now. Give me a plain-English summary of the results.
```

### Prompt 3: Analyze security posture

```
$trust-center Analyze my security posture
```

### Prompt 4: Cut a dev branch

```text
Create a new branch called dgillis-dev and switch to it
```

### Prompt 5: Explore the raw data

```
Run row counts on all the raw source tables and give me a summary of what data we're working with. Describe the key tables.
```

### Prompt 6: Setup dbt

```text
This project does not have a virtual environment or dbt packages installed. Set those up now. Ensure the virtual environment is added to .gitignore so it doesn't get committed.
```

### Prompt 7: Understand lineage

```
What does the f_order_line model depend on? Trace the full lineage back to raw sources.
```

---

## Act 2: Code Quality & Testing (~3 min)

### Prompt 8: Add schema.yml

```text
This project has no model and column properties defined for the mart models. Make a plan to add a `_schema.yml` file to models/marts/ with constraints for all mart models. Add top-level properties: name and description. Review each table and do your best to create a description based on your what you can glean from the table columns. Also add column properties: name, description, data_type as well as primary_key, foreign_key and not_null constraints. Exclude fact tables at this time as I want to focus on the dimensions first. Do not build yet, just create the YAML file.
```

### Prompt 9: Commit the changes

```text
Commit the changes
```

### Prompt 10: Add Tests and Think Through Something

```text
This project has no tests for the mart models. Add tests for all mart models but do not build yet. Include unique tests on all primary keys, and relationship tests where foreign keys reference other mart dimensions. Also, I am considering adding not_null tests, but that seems redundant considering added not_null constraints and in Snowflake these are actually enforced. What do you think?
```

### Prompt 11: Build empty models

```
Build the mart dimension models only with the --empty flag so the tables exist for schema validation, but data doesn't have to load yet. This will allow us to run tests faster and iterate on the schema if needed.
```

### Prompt 12: Add Enforced Contracts

```text
I want to use dbt contracts to define a set of upfront "guarantees" on model definitions. Add contracts to the mart models.
```

### Prompt 13: Run the tests

```
Run dbt test for the dimension marts models only and show me the results. If any tests fail, diagnose and fix them.
```

---

## Act 3: New Feature Build (~3-4 min)

### Prompt 14: Build a new model

```
Build a new mart model called f_daily_sales_summary that aggregates daily revenue by truck, location, and menu item. It should follow the existing conventions in this project -- use surrogate keys, ref() macros, and the same SQL style. Add it to the schema.yml with appropriate tests. Then compile and run it.
```

### Prompt 15: Query the results

```
Show me the top 10 days by total revenue from f_daily_sales_summary
```

---

## Act 4: Ad-Hoc Data Exploration (~1-2 min)

### Prompt 16: Business question

```
What are the top 5 menu items by total revenue?
```

### Prompt 17: Another business question

```
How many loyalty members signed up each year?
```
---

## Act 5 (Bonus): Git Workflow (~30 sec)

### Prompt 18: Commit
```
Commit all changes with an appropriate message
```
