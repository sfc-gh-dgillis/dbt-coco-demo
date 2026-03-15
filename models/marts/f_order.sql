SELECT
    -- Surrogate key (hash of natural key)
    utilities.udf_generate_surrogate_key(o => OBJECT_CONSTRUCT_KEEP_NULL('order_id', oh.order_id)) AS order_key,

    -- Natural key
    oh.order_id,

    -- Dimension FKs (natural keys - join to dims for surrogate keys)
    utilities.udf_generate_surrogate_key(o => OBJECT_CONSTRUCT_KEEP_NULL('truck_id', oh.truck_id)) AS truck_key,
    utilities.udf_generate_surrogate_key(o => OBJECT_CONSTRUCT_KEEP_NULL('location_id', oh.location_id)) AS location_key,
    utilities.udf_generate_surrogate_key(o => OBJECT_CONSTRUCT_KEEP_NULL('customer_id', oh.customer_id)) AS customer_key,

    -- Degenerate dimensions
    oh.shift_id,
    oh.order_currency,

    -- Date/time attributes
    oh.order_ts,
    oh.shift_start_time,
    oh.shift_end_time,

    -- Facts (additive)
    oh.order_amount,
    oh.order_total

FROM {{ ref('stg_pos__order_header') }} oh