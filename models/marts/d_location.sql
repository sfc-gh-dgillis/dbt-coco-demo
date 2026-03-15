WITH pk_cte AS (SELECT l.location_id
                FROM {{ ref('stg_pos__location') }} l)

SELECT utilities.udf_generate_surrogate_key(o => OBJECT_CONSTRUCT_KEEP_NULL(pkc.*)) AS location_key,
       l.location_id,
       l.placekey,         -- foreign key to d_placekey
       l.location_name,
       l.city,             -- should this be city_id from d_country?
       l.region,           -- what to do with region?
       l.iso_country_code, -- use d_country iso_country_code?
       l.country
FROM {{ ref('stg_pos__location') }} l

         INNER JOIN pk_cte pkc
                    ON l.location_id = pkc.location_id
