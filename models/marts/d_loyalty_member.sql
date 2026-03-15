{{
    config(
        materialized='incremental',
        unique_key='customer_id'
    )
}}

SELECT customer_id,
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
       phone_number,
       last_update_ts
FROM {{ ref('stg_loyalty__customer_loyalty') }}

{% if is_incremental() %}
    -- this filter will only be applied on an incremental run
    -- (uses >= to include records arriving later on the same day as the last run of this model)
    WHERE last_update_ts >=
          (SELECT COALESCE(MAX(last_update_ts), '1900-01-01') FROM {{ this }})
{% endif %}
