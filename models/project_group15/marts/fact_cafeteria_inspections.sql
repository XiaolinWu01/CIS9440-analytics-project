WITH source AS (

    SELECT *
    FROM {{ ref('stg_cafeteria_inspections') }}

),

geo AS (

    SELECT *
    FROM {{ ref('dim_geography') }}

)

SELECT
    GENERATE_UUID() AS inspection_id,

    g.geography_id,
    inspection_date,

    CASE
        WHEN inspection_result = 'Pass' THEN 0
        ELSE 1
    END AS has_violation,

    school_name,
    violation_code,
    violation_description,
    inspection_type,
    inspection_result

FROM source s
LEFT JOIN geo g
    ON s.borough = g.borough
   AND s.zip_code = g.zip_code