with source as (select *
                from {{ source('raw', 'country') }}),

     renamed as (select country_id      as country_id,
                        country         as country_name,
                        iso_currency    as iso_currency_alpha_cd,
                        iso_country     as iso_country_alpha_2_cd,
                        city_id         as city_id,
                        city            as city_name,
                        city_population as city_population

                 from source)

select *
from renamed
