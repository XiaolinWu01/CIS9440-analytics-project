WITH geo_311 AS (
    SELECT DISTINCT
        borough,
        zip_code,
        council_district
    FROM {{ ref('stg_311_school_complaints') }}
    WHERE borough IS NOT NULL
       OR zip_code IS NOT NULL
       OR council_district IS NOT NULL
),

geo_cafeteria AS (
    SELECT DISTINCT
        borough,
        zip_code,
        council_district
    FROM {{ ref('stg_cafeteria_inspections') }}
    WHERE borough IS NOT NULL
       OR zip_code IS NOT NULL
       OR council_district IS NOT NULL
),

combined AS (
    SELECT * FROM geo_311
    UNION DISTINCT
    SELECT * FROM geo_cafeteria
)

SELECT
    ABS(FARM_FINGERPRINT(
        CONCAT(
            COALESCE(borough, ''), '|',
            COALESCE(zip_code, ''), '|',
            COALESCE(CAST(council_district AS STRING), '')
        )
    )) AS geo_sk,
    borough,
    zip_code,
    council_district
FROM combined