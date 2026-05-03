WITH source AS (

    SELECT *
    FROM {{ ref('stg_cafeteria_inspections') }}

),

geo AS (

    SELECT *
    FROM {{ ref('dim_geography') }}

),

violation AS (

    SELECT *
    FROM {{ ref('dim_violation') }}

)

SELECT
    GENERATE_UUID() AS inspection_id,

    g.geography_id,
    v.violation_id,

    inspection_date,

    CASE
        WHEN inspection_result = 'Pass' THEN 0
        ELSE 1
    END AS has_violation,

    school_name,
    inspection_type,
    inspection_result

FROM source s
LEFT JOIN geo g
    ON s.borough = g.borough
   AND s.zip_code = g.zip_code

LEFT JOIN violation v
    ON s.violation_code = v.violation_code
   AND s.violation_description = v.violation_description
   AND s.inspection_result = v.violation_level