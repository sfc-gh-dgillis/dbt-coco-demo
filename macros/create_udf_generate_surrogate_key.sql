{% macro create_udf_generate_surrogate_key(database, schema) %}

{% set relation = api.Relation.create(database=database, schema=schema) %}

{% set run_sp_operation %}
CREATE OR REPLACE FUNCTION {{ relation.database }}.{{ relation.schema }}.udf_generate_surrogate_key(
    o OBJECT,
    default_null_value VARCHAR DEFAULT '_dbt_utils_surrogate_key_null_'
)
    RETURNS BINARY
AS
$$
    MD5_BINARY(
             {{ relation.database }}.{{ relation.schema }}.udf_concatenate_object_values(
                    o => o,
                    default_null_value => default_null_value)
    )
$$;
{% endset %}

{% do run_query(run_sp_operation) %}
{{ print("macro create_udf_generate_surrogate_key completed successfully") }}
{% endmacro %}