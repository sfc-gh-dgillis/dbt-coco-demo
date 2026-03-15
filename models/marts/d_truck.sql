-- should this be named d_country_city or even split into d_country and d_city?
WITH pk_cte AS (SELECT spt.truck_id
                FROM {{ ref('stg_pos__truck') }} spt)

SELECT utilities.udf_generate_surrogate_key(o => OBJECT_CONSTRUCT_KEEP_NULL(pkc.*)) as truck_key,
       spt.truck_id                                                                 as truck_id,
       spt.year                                                                     as truck_year,
       spt.make                                                                     as truck_make,
       spt.model                                                                    as truck_model,
       spt.truck_type                                                               as truck_type,
       to_boolean(spt.ev_flag)                                                      as is_electric,
       spt.truck_opening_date                                                       as truck_opening_date
FROM {{ ref('stg_pos__truck') }} spt

     INNER JOIN pk_cte pkc
        ON spt.truck_id = pkc.truck_id
