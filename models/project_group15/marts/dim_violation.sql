WITH source AS (

    SELECT DISTINCT
        violation_code,
        violation_description,
        inspection_result
    FROM {{ ref('stg_cafeteria_inspections') }}

)

SELECT
    ABS(FARM_FINGERPRINT(
        CONCAT(
            COALESCE(violation_code, ''),
            '|',
            COALESCE(violation_description, ''),
            '|',
            COALESCE(inspection_result, '')
        )
    )) AS violation_id,

    violation_code,
    violation_description,
    inspection_result AS violation_level

FROM source