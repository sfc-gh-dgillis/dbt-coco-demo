SELECT
    -- Surrogate key (hash of natural key)
    utilities.udf_generate_surrogate_key(o => OBJECT_CONSTRUCT_KEEP_NULL('order_detail_id', order_detail_id)) AS order_line_key,

    -- Natural key
    od.order_detail_id,

    -- Parent fact FK
    utilities.udf_generate_surrogate_key(o => OBJECT_CONSTRUCT_KEEP_NULL('order_id', od.order_id)) AS order_key,

    -- Dimension FKs (natural keys - join to dims for surrogate keys)
    utilities.udf_generate_surrogate_key(o => OBJECT_CONSTRUCT_KEEP_NULL('menu_item_id', menu_item_id)) AS menu_item_key,

    -- Degenerate dimension
    od.line_number,

    -- Facts (additive)
    od.quantity,
    od.price AS line_amount,

    -- Facts (non-additive)
    od.unit_price

FROM {{ ref('stg_pos__order_detail') }} od
