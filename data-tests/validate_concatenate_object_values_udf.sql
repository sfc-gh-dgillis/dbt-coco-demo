-- this test validates the udf_concatenate_object_values function
-- it assumes the function has already been created in the target database/schema
-- after dbt v1.11 is available in Snowflake, we can use the new udf features: https://docs.getdbt.com/docs/build/udfs
-- For now, I have hard-coded the db and schema names
select dev_dbt_demo.utilities.udf_concatenate_object_values(OBJECT_CONSTRUCT('key1', 'value1', 'key2', 'value2'))
