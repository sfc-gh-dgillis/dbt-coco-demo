

with source as (

    select * from {{ source('raw', 'order_detail') }}

),

renamed as (

    select
        order_detail_id,
        order_id,
        menu_item_id,
        discount_id,
        line_number,
        quantity,
        unit_price,
        price,
        order_item_discount_amount

    from source

)

select * from renamed

