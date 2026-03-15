with pk_cte as (select distinct
                       menu_type_id
                  from {{ ref('stg_pos__menu') }}),

     distinct_menu_types as (select distinct
                                    menu_type_id,
                                    menu_type
                              from {{ ref('stg_pos__menu') }})

select utilities.udf_generate_surrogate_key(o => object_construct_keep_null(pkc.*)) as menu_type_key,
       dmt.menu_type_id,
       dmt.menu_type
  from distinct_menu_types dmt

         inner join pk_cte pkc
                    on dmt.menu_type_id = pkc.menu_type_id