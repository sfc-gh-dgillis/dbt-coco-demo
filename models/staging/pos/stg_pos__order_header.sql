

with source as (

    select * from {{ source('raw', 'order_header') }}

),

renamed as (

    select
        order_id,
        truck_id,
        location_id,
        customer_id,
        discount_id,
        shift_id,
        shift_start_time,
        shift_end_time,
        order_channel,
        order_ts,
        served_ts,
        order_currency,
        order_amount,
        order_tax_amount,
        order_discount_amount,
        order_total

    from source

)

select * from renamed

