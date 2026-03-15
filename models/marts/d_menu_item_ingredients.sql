WITH array_cte AS (SELECT m.menu_item_id       AS menu_item_id,
                          hm.value:ingredients AS ingredient_array
                   FROM {{ ref('stg_pos__menu') }} m,
                        LATERAL FLATTEN(INPUT => m.menu_item_health_metrics_obj:menu_item_health_metrics) hm
                   WHERE ARRAY_SIZE(hm.value:ingredients) > 0),

     pk_cte AS (SELECT ac.menu_item_id,
                       ia.value::STRING AS ingredient_name
                FROM array_cte ac,
                     TABLE (FLATTEN(INPUT => ac.ingredient_array, OUTER => TRUE)) ia),

     final_cte AS (SELECT ac.menu_item_id,
                          ia.value::STRING AS ingredient_name
                   FROM array_cte ac,
                        TABLE (FLATTEN(INPUT => ac.ingredient_array, OUTER => TRUE)) ia)

SELECT utilities.udf_generate_surrogate_key(o => OBJECT_CONSTRUCT_KEEP_NULL(pkc.*))                           AS menu_item_ingredient_key,
       utilities.udf_generate_surrogate_key(o => OBJECT_CONSTRUCT_KEEP_NULL('MENU_ITEM_ID', fc.menu_item_id)) AS menu_item_key,
       fc.ingredient_name
FROM final_cte fc

         INNER JOIN pk_cte pkc
                    ON fc.menu_item_id = pkc.menu_item_id AND
                          fc.ingredient_name = pkc.ingredient_name