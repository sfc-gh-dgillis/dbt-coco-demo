WITH pk_cte AS (SELECT f.franchise_id
                FROM {{ ref('stg_pos__franchise') }} f)

SELECT utilities.udf_generate_surrogate_key(o => OBJECT_CONSTRUCT_KEEP_NULL(pkc.*)) AS franchise_key,
       f.franchise_id,
       f.first_name,
       f.last_name,
       f.city,    -- should this be city_id from d_country?
       f.country, -- should this be country_key from d_country?
       f.e_mail,
       f.phone_number
FROM {{ ref('stg_pos__franchise') }} f

         INNER JOIN pk_cte pkc
                    ON f.franchise_id = pkc.franchise_id
