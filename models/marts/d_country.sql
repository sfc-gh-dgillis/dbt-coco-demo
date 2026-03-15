-- should this be named d_country_city or even split into d_country and d_city?
WITH pk_cte AS (SELECT country_id, city_id
                FROM {{ ref('stg_pos__country') }} spc)

SELECT utilities.udf_generate_surrogate_key(o => OBJECT_CONSTRUCT_KEEP_NULL(pkc.*)) AS country_key,
       spc.country_id,
       spc.country_name,
       spc.iso_currency_alpha_cd,  -- iso 4217 is the international standard for currency codes
       spc.iso_country_alpha_2_cd, -- iso 3166-1 alpha-2 is the international standard for country codes
       spc.city_id,
       spc.city_name,
       spc.city_population
FROM {{ ref('stg_pos__country') }} spc

         INNER JOIN pk_cte pkc
                    ON spc.country_id = pkc.country_id AND
                       spc.city_id = pkc.city_id
