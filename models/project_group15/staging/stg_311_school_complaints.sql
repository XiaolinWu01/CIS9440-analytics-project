WITH source AS (

    SELECT *
    FROM {{ source('nyc_school_raw', 'source_doe-dohmh_311') }}

)

SELECT
    unique_key,

    SAFE_CAST(created_date AS TIMESTAMP) AS created_at,
    SAFE_CAST(closed_date AS TIMESTAMP) AS closed_at,

    UPPER(borough) AS borough,
    city,
    incident_zip AS zip_code,

    complaint_type,
    descriptor,
    status,

    agency,
    agency_name

FROM source