

with source as (

    select * from {{ source('raw', 'core_poi_geometry') }}

),

renamed as (

    select
        placekey,
        parent_placekey,
        safegraph_brand_ids,
        location_name,
        brands,
        store_id,
        top_category,
        sub_category,
        naics_code,
        latitude,
        longitude,
        street_address,
        city,
        region,
        postal_code,
        open_hours,
        category_tags,
        opened_on,
        closed_on,
        tracking_closed_since,
        geometry_type,
        polygon_wkt,
        polygon_class,
        enclosed,
        phone_number,
        is_synthetic,
        includes_parking_lot,
        iso_country_code,
        wkt_area_sq_meters,
        country

    from source

)

select * from renamed

