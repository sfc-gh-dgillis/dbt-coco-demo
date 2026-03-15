

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
        phone_number,
        last_update_ts
    from source

)

select * from renamed

