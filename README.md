# dbt-demo

Welcome to the Snowflake dbt-demo project!

This project's structure is modeled after dbt's [How we structure our dbt projects](https://docs.getdbt.com/guides/best-practices/how-we-structure/1-guide-overview) best practices guide and extended to meet Snowflake standards and methodologies.

## Sections

- [Minimum Requirements](#minimum-requirements)
- [Getting Started](#getting-started)
  - [Get the Code](#get-the-code)
  - [Local dbt Installation (MacOS)](#local-dbt-installation-macos)
    - [Python Setup](#python-setup)
      - [Step 1 - Download and install python](#step-1---download-and-install-python)
      - [Step 2 - Install SSL root certificates](#step-2---install-ssl-root-certificates)
      - [Step 3 - Setup python and pip aliases](#step-3---setup-python-and-pip-aliases)
      - [Step 4 - pip configuration](#step-4---pip-configuration)
      - [Step 5 - Require virtual environments](#step-5---require-virtual-environments)
    - [dbt Setup](#dbt-setup)
      - [Virtual Environment dbt Installation](#virtual-environment-dbt-installation)
      - [Connection Profile Setup](#connection-profile-setup)
- [Running dbt](#running-dbt)
- [dbt Code Generation](#dbt-code-generation)
  - [Generating Source YAML from the command line](#generating-source-yaml-from-the-command-line)
  - [Generating Staging Model for a source from the command line](#generating-staging-model-for-a-source-from-the-command-line)
  - [Generating Model YAML from the command line](#generating-model-yaml-from-the-command-line)

## Minimum Requirements

- [git](https://git-scm.com/)

There are two options to run dbt locally - you can download the dbt client directly or run dbt in a container. In either path, you must install git.

## Getting Started

The following are basic instructions for getting started with dbt.

### Get the Code

Clone the project locally in order to run dbt and make changes using [git](https://git-scm.com/).

Navigate to the local directory you wish to clone this project and issue the following:

```shell
git clone https://github.com/sfc-gh-dgillis/dbt-demo.git
```

A `dbt-demo` directory will be created. This is now your project root.

### Local dbt Installation (MacOS)

#### Python Setup

##### Step 1 - Download and install python

Install [python3](https://www.python.org/downloads/)

- `python3` comes with the [pip3](https://en.wikipedia.org/wiki/Pip_(package_manager)) package manager

##### Step 2 - Install SSL root certificates

Per the installation instructions:

- To verify the identity of secure network connections, this Python needs a set of SSL root certificates.  You can download and install a current curated set from [the Certifi project](https://pypi.org/project/certifi/) by double-clicking on the `Install Certificates` icon in [the Finder window](file://localhost/Applications/Python%203.12/).  See the [ReadMe](file://localhost/Applications/Python%203.12/ReadMe.rtf) file for more information.

> Note: The above instructions are for a Mac. Windows is likely similar - they will be given at the end of the installation.

##### Step 3 - Setup python and pip aliases

All python and pip commands should start with `python3` or `pip3`, but if you prefer to just use `python` and `pip`, create an alias using your preferred user shell startup file (`~/.bashrc` for [bash](https://www.gnu.org/software/bash/), `~/.zshrc` for [zsh](https://zsh.sourceforge.io/), etc.).

###### Modify your preferred user startup file with nano (~/.zshrc in this example)

> type your password at the prompt

```shell
$ sudo nano ~/.zshrc
  UW PICO 5.09                                 File: /Users/dgillis/.zshrc

export GOPATH=$HOME/go
PATH="$GOPATH/bin:$PATH"                                                                       
```

###### Add alias to user shell startup file

Add python and pip alias to the bottom of your shell startup file

```shell
$ sudo nano ~/.zshrc
  UW PICO 5.09                                 File: /Users/dgillis/.zshrc

# alias python
alias python=python3

# alias pip
alias pip=pip3
```

`control o` to write to the file
`control x` to save to the file

###### Load the user startup file into current shell

```shell
source ~/.zshrc
```

> This only needs to be done in your current shell -- in subsequent shell initializations, the alias is set permanently.

###### Validate the aliases

```shell
$ which python
python: aliased to python3
```

```shell
which pip
pip: aliased to pip3
```

To see which Python installation these aliases are pointing to:

```shell
$ which python3
/Library/Frameworks/Python.framework/Versions/3.13/bin/python3
```

```shell
$ which pip3
/Library/Frameworks/Python.framework/Versions/3.13/bin/pip3
```

##### Step 4 - pip configuration

###### Ensure `pip`, `wheel` and `setuptools` are using the latest version

```shell
$ pip install --upgrade pip wheel setuptools
Requirement already satisfied: pip in /Library/Frameworks/Python.framework/Versions/3.13/lib/python3.13/site-packages (25.1.1)
Collecting pip
  Using cached pip-25.2-py3-none-any.whl.metadata (4.7 kB)
Collecting wheel
  Downloading wheel-0.45.1-py3-none-any.whl.metadata (2.3 kB)
Collecting setuptools
  Using cached setuptools-80.9.0-py3-none-any.whl.metadata (6.6 kB)
Using cached pip-25.2-py3-none-any.whl (1.8 MB)
Downloading wheel-0.45.1-py3-none-any.whl (72 kB)
Using cached setuptools-80.9.0-py3-none-any.whl (1.2 MB)
Installing collected packages: wheel, setuptools, pip
  Attempting uninstall: pip
    Found existing installation: pip 25.1.1
    Uninstalling pip-25.1.1:
      Successfully uninstalled pip-25.1.1
Successfully installed pip-25.2 setuptools-80.9.0 wheel-0.45.1
```

If you receive an error like `pip install fails with "connection error: [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed (_ssl.c:598)` re-run the command as such:

```shell
pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org pip wheel setuptools virtualenv
```

After completing these upgrades, your python system package list should look something like this (likely with newer versions):

```shell
$ pip list -v
Package    Version Location                                                                        Installer
---------- ------- ------------------------------------------------------------------------------- ---------
pip        25.2    /Library/Frameworks/Python.framework/Versions/3.13/lib/python3.13/site-packages pip
setuptools 80.9.0  /Library/Frameworks/Python.framework/Versions/3.13/lib/python3.13/site-packages pip
wheel      0.45.1  /Library/Frameworks/Python.framework/Versions/3.13/lib/python3.13/site-packages pip
```

##### Step 5 - Require virtual environments

Best practice dictates that when installing python packages through `pip`, use a virtual environment. Add the `require-virtualenv` to `pip` to ensure this is always the case.

```shell
$ pip config set global.require-virtualenv True
Writing to /Users/dgillis/.config/pip/pip.conf
```

If you choose, validate the output to see how/where `pip` wrote the config (replace with your user/home directory name):

```shell
vi /Users/dgillis/.config/pip/pip.conf
```

You should see the following in the pip config file:

```text
[global]
require-virtualenv = True
```

Enter `:q` to exit `vi`

#### dbt Setup

##### Virtual Environment dbt Installation

As mentioned before, it's best practice to work in python using [virtual environments](https://docs.python.org/3/library/venv.html#how-venvs-work). Where to put the virtual environment is user choice really, but a common place is in your user home directory in a folder called `.virtualenvs`. This way, the virtual environment stays outside the project tree.

If you prefer, you can also place the virtual environment under the project directory itself in a directory called `.venv/`, which is already in the `.gitignore` file. The instructions below assume you're using `.venv/` at the project root.

###### Step 1 - Navigate to project root and create .venv directory

Navigate to the project root of wherever you have cloned this repo and create the `.venv` directory (replace with your path):

```shell
cd ~/dev/github/dbt-demo
python -m venv ./.venv
```

###### Step 2 - Activate virtual environment

Activate the virtual environment in your current shell

```shell
$ source ./.venv/bin/activate
(.venv) dgillis@mylaptop dbt-demo %
```

> Most IDEs will automatically activate the virtual environment for you when you open the project.

###### Step 3 - Install dbt-snowflake and dbt-core

Install dbt-snowflake and dbt-core with `pip`

```shell
(.venv) dgillis@mylaptop dbt-demo % python -m pip install dbt-core dbt-snowflake
Requirement already satisfied: dbt-core in ./.venv/lib/python3.12/site-packages (1.9.4)
Requirement already satisfied: dbt-snowflake in ./.venv/lib/python3.12/site-packages (1.9.4)
Requirement already satisfied: agate<1.10,>=1.7.0 in ./.venv/lib/python3.12/site-packages (from dbt-core) (1.9.1)
Requirement already satisfied: Jinja2<4,>=3.1.3 in ./.venv/lib/python3.12/site-packages (from dbt-core) (3.1.6)
Requirement already satisfied: mashumaro<3.15,>=3.9 in ./.venv/lib/python3.12/site-packages (from mashumaro[msgpack]<3.15,>=3.9->dbt-core) (3.14)
Requirement already satisfied: click<9.0,>=8.0.2 in ./.venv/lib/python3.12/site-packages (from dbt-core) (8.2.1)
Requirement already satisfied: networkx<4.0,>=2.3 in ./.venv/lib/python3.12/site-packages (from dbt-core) (3.4.2)
Requirement already satisfied: protobuf<6.0,>=5.0 in ./.venv/lib/python3.12/site-packages (from dbt-core) (5.29.4)
Requirement already satisfied: requests<3.0.0 in ./.venv/lib/python3.12/site-packages (from dbt-core) (2.32.3)
Requirement already satisfied: snowplow-tracker<2.0,>=1.0.2 in ./.venv/lib/python3.12/site-packages (from dbt-core) (1.1.0)
Requirement already satisfied: pathspec<0.13,>=0.9 in ./.venv/lib/python3.12/site-packages (from dbt-core) (0.12.1)
Requirement already satisfied: sqlparse<0.6.0,>=0.5.0 in ./.venv/lib/python3.12/site-packages (from dbt-core) (0.5.3)...
```

##### Connection Profile Setup

dbt uses [connection profiles](https://docs.getdbt.com/docs/core/connect-data-platform/connection-profiles) to enable database connections. When developing dbt locally, in your user home directory (`/Users/yourusername` on a Mac or `C:\Users\yourusername\` on Windows), do the following:

###### Create the .dbt directory

```shell
mkdir ~/.dbt
```

###### Create the profiles.yml file

```shell
touch ~/.dbt/profiles.yml
```

dbt supports multiple [targets](https://docs.getdbt.com/docs/core/connect-data-platform/connection-profiles#understanding-targets-in-profiles) (prod, dev, qa, etc.). These targets are configured in the `profiles.yml` file.

###### Add targets

Below are two example targets that could be in your `profiles.yml` file. Configure appropriately for your environment (use your account, user, etc.). This gives examples of two different Snowflake authentication methods - key pair authentication and **P**rogrammatic **A**ccess **T**oken (PAT) authentication. You can use either or both methods. If using PAT authentication, ensure you have created a PAT in Snowflake and stored it in an environment variable called `DBT_ENV_SECRET_PAT`.

```yaml
default:
  target: dev-keypair-auth
  outputs:
    dev-keypair-auth:
      type: snowflake
      # snowflake account identifier
      account: sfsenorthamerica-dgillis_aws_useast1_v1
      # snowflake username
      user: bmeyer
      #snowflake role
      role: dbt_demo_data_engineer

      # Keypair config
      private_key_path: /Users/dgillis/.ssh/demo_dgillis_keypair_auth_rsa_key.p8
      # private_key_passphrase: [passphrase for the private key, if key is encrypted]

      database: dbt_demo
      warehouse: dbt_demo_s_wh
      schema: curated
      threads: 8
      client_session_keep_alive: False
      query_tag: test_query_tag # optional, used for query tagging in Snowflake

      # optional
      connect_retries: 0 # default 0
      connect_timeout: 10 # default: 10
      retry_on_database_errors: False # default: false
      retry_all: False  # default: false
      reuse_connections: True # default: True if client_session_keep_alive is False, otherwise None

    dev-pat-auth:
      type: snowflake
      # snowflake account identifier
      account: sfsenorthamerica-dgillis_aws_useast1_v1
      #snowflake role
      role: dbt_demo_data_engineer

      # User/password auth
      user: tastyb
      password: "{{ env_var('DBT_ENV_SECRET_PAT') }}"

      database: dbt_demo
      warehouse: dbt_demo_s_wh
      schema: curated
      threads: 8
      client_session_keep_alive: False
      query_tag: test_query_tag # optional, used for query tagging in Snowflake

      # optional
      connect_retries: 0 # default 0
      connect_timeout: 10 # default: 10
      retry_on_database_errors: False # default: false
      retry_all: False  # default: false
      reuse_connections: True # default: True if client_session_keep_alive is False, otherwise None
```

###### Test your connection

1. Ensure your python virtual environment is activated.

```shell
% source ./.venv/bin/activate
(.venv) dgillis@mylaptop dbt-demo %
```

From your project root. Use the `dbt debug` command to validate your connection

```shell
(.venv) dgillis@mylaptop dbt-demo % ./cmd/build/dbt/local/debug.sh 
03:31:02  Running with dbt=1.9.4
03:31:02  dbt version: 1.9.4
03:31:02  python version: 3.12.7
03:31:02  python path: /Users/dgillis/Documents/dev/github/dbt-demo/.venv/bin/python
03:31:02  os info: macOS-15.7-arm64-arm-64bit
03:31:02  Using profiles dir at /Users/dgillis/.dbt
03:31:02  Using profiles.yml file at /Users/dgillis/.dbt/profiles.yml
03:31:02  Using dbt_project.yml file at ./dbt_project.yml
03:31:02  adapter type: snowflake
03:31:02  adapter version: 1.9.4
03:31:02  Configuration:
03:31:02    profiles.yml file [OK found and valid]
03:31:02    dbt_project.yml file [OK found and valid]
03:31:02  Required dependencies:
03:31:02   - git [OK found]

03:31:02  Connection:
03:31:02    account: sfsenorthamerica-dgillis-aws-useast1-v1
03:31:02    user: tastyb
03:31:02    database: dev_dbt_demo
03:31:02    warehouse: dbt_demo_s_wh
03:31:02    role: dbt_demo_data_engineer
03:31:02    schema: modeled
03:31:02    authenticator: None
03:31:02    oauth_client_id: None
03:31:02    query_tag: test_query_tag
03:31:02    client_session_keep_alive: False
03:31:02    host: None
03:31:02    port: None
03:31:02    proxy_host: None
03:31:02    proxy_port: None
03:31:02    protocol: None
03:31:02    connect_retries: 0
03:31:02    connect_timeout: 10
03:31:02    retry_on_database_errors: False
03:31:02    retry_all: False
03:31:02    insecure_mode: False
03:31:02    reuse_connections: True
03:31:02  Registered adapter: snowflake=1.9.4
03:31:03    Connection test: [OK connection ok]

03:31:03  All checks passed!
```

## Running dbt

TODO - document running models, etc.

## dbt Code Generation

A key part of dbt development is creating models and their associated YAML files. This can be tedious and time-consuming. The [dbt-codegen package](https://github.com/dbt-labs/dbt-codegen) provides tools for generating model YAML and SQL.

### Generating Source YAML from the command line

The `generate_source` command can take a list of table names to include in the source definition. If no table names are provided, all tables in the specified schema will be included.

This command will generate a [source YAML file](https://docs.getdbt.com/reference/source-configs#configuring-sources) for the specified schema and tables. The `generate_columns` argument, when set to true, will include column definitions in the generated YAML

```shell
dbt --quiet run-operation generate_source --target dev-tastyb --args '{"schema_name": "raw", "table_names":["country","franchise","location","menu","order_detail","order_header","truck"], "generate_columns": true}' > models/staging/pos/_source_pos.yml
```

> Note: The `--target` flag is optional. If not provided, the default target in your `profiles.yml` file will be used. The output is redirected to a file in this example, but you can also just run the command and copy/paste the output.

This will generate a source YAML file like the following:

```yaml
version: 2

sources:
  - name: raw
    tables:
      - name: customer_loyalty
        columns:
          - name: customer_id
            data_type: number
          - name: first_name
            data_type: varchar
          - name: last_name
            data_type: varchar
...
```

### Generating Staging Model for a source from the command line

The `generate_base_model` command can be used to generate a [basic staging model](https://docs.getdbt.com/best-practices/how-we-structure/2-staging) for a specified source table.

```shell
dbt --quiet run-operation generate_base_model --args '{"source_name": "raw", "table_name": "customer_loyalty"}' > models/staging/loyalty/stg_loyalty__customer_loyalty.sql
```

This will generate a basic staging model SQL file like the following:

```sql
with source as (

    select * from {{ source('raw', 'customer_loyalty') }}

),

renamed as (

    select
        customer_id,
        first_name,
        last_name,
        city,
        country,
        postal_code,
        preferred_language,
        gender,
        favourite_brand,
        marital_status,
        children_count,
        sign_up_date,
        birthday_date,
        e_mail,
        phone_number

    from source

)

select * from renamed
```

### Generating Model YAML from the command line

The `generate_model_yaml` command can be used to generate a [model YAML file](https://docs.getdbt.com/docs/building-a-dbt-project/building-models/configuring-models) for one or more specified models. The `upstream_descriptions` argument, when set to true, will include descriptions for upstream models in the generated YAML. The `include_data_types` argument, when set to true, will include data types for columns in the generated YAML.

```shell
dbt run-operation generate_model_yaml --args '{"model_names": ["prep_f_cep_bdc_scheduler_extl_api_appointment"], "upstream_descriptions": True, "include_data_types": True}'
```
