WITH geo_311 AS (

    SELECT DISTINCT
        borough,
        zip_code,
        city
    FROM {{ ref('stg_311_school_complaints') }}

),

geo_cafeteria AS (

    SELECT DISTINCT
        borough,
        zip_code,
        city
    FROM {{ ref('stg_cafeteria_inspections') }}

),

combined AS (

    SELECT * FROM geo_311
    UNION DISTINCT
    SELECT * FROM geo_cafeteria

)

SELECT
    GENERATE_UUID() AS geography_id,
    borough,
    zip_code,
    city

FROM combined