WITH source AS (

    SELECT *
    FROM {{ source('nyc_school_raw', 'nyc_cafeteriainspection') }}

)

SELECT
    schoolname AS school_name,
    SAFE_CAST(inspectiondate AS DATE) AS inspection_date,

    UPPER(borough) AS borough,
    zipcode AS zip_code,
    city,
    street,
    bbl,
    bin,

    code AS violation_code,
    violationdescription AS violation_description,
    CAST(NULL AS STRING) AS inspection_type,
    level AS inspection_result

FROM source