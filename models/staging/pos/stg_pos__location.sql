

with source as (

    select * from {{ source('raw', 'location') }}

),

renamed as (

    select
        location_id,
        placekey,
        location as location_name,
        city,
        region,
        iso_country_code,
        country

    from source

)

select * from renamed

