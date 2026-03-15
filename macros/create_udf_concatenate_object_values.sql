{% macro create_udf_concatenate_object_values(database, schema) %}

{% set relation = api.Relation.create(database=database, schema=schema) %}

{% set run_sp_operation %}
CREATE OR REPLACE FUNCTION {{ relation.database }}.{{ relation.schema }}.udf_concatenate_object_values(
    o OBJECT,
    default_null_value VARCHAR DEFAULT '_SURROGATE_KEY_NULL_'
  )
  RETURNS STRING
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
{% endset %}

{% do run_query(run_sp_operation) %}
{{ print("create_udf_concatenate_object_values completed successfully") }}
{% endmacro %}