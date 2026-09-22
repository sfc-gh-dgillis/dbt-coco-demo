-- =============================================================================
-- Post-Deploy: UDFs (Python + SQL functions not supported by DEFINE)
-- =============================================================================
-- Run after: snow dcm deploy
-- Execute:   snow sql -f post_deploy.sql -c demo_dgillis_keypair_auth
-- =============================================================================

-- 1. Python UDF: Concatenate object values (must be created first)
CREATE OR REPLACE FUNCTION DEV_DBT_DEMO_BACKUP.UTILITIES.UDF_CONCATENATE_OBJECT_VALUES(
    O OBJECT,
    DEFAULT_NULL_VALUE VARCHAR DEFAULT '_SURROGATE_KEY_NULL_'
)
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = '3.12'
HANDLER = 'concatenate_dict_values'
AS
$$
def concatenate_dict_values(input_dict, default_null_value="_SURROGATE_KEY_NULL_"):
    """
    Concatenate the values of a dict in key order, replacing empty values with a default, separated by '-'.
    All values are uppercased.
    Args:
        input_dict (dict): The dictionary whose values to concatenate.
        default_null_value (str): The value to use if a dict value is empty.
    Returns:
        str: Concatenated string of values in key order, separated by '-'
    """
    return '-'.join([
        str(input_dict[k]).upper() if input_dict[k] not in (None, '', []) else default_null_value.upper()
        for k in sorted(input_dict.keys())
    ])
$$;

-- 2. SQL UDF: Generate surrogate key (depends on UDF_CONCATENATE_OBJECT_VALUES)
CREATE OR REPLACE FUNCTION DEV_DBT_DEMO_BACKUP.UTILITIES.UDF_GENERATE_SURROGATE_KEY(
    O OBJECT,
    DEFAULT_NULL_VALUE VARCHAR DEFAULT '_dbt_utils_surrogate_key_null_'
)
RETURNS BINARY
LANGUAGE SQL
AS
$$
    MD5_BINARY(
        DEV_DBT_DEMO_BACKUP.UTILITIES.UDF_CONCATENATE_OBJECT_VALUES(
            O => O,
            DEFAULT_NULL_VALUE => DEFAULT_NULL_VALUE
        )
    )
$$;
