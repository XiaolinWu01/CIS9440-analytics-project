WITH source AS (
    SELECT *
    FROM {{ source('nyc_school_raw', 'nyc_cafeteriainspection') }}
)

SELECT
    entityid                                      AS record_id,
    schoolname                                    AS school_name,
    SAFE_CAST(inspectiondate AS DATE)             AS inspection_date,
    SAFE_CAST(lastinspection AS DATE)             AS last_inspection_date,

    UPPER(borough)  AS borough,
    zipcode         AS zip_code,
    city,
    street,
    number,
    bbl,
    bin,
    nta,
    SAFE_CAST(borocode AS INT64)                  AS borocode,
    SAFE_CAST(communityboard AS INT64)            AS community_board,
    SAFE_CAST(censustract AS INT64)               AS census_tract,
    SAFE_CAST(councildistrict AS INT64)           AS council_district,
    state,

    permittee,
    ptet,
    site_type,

    code                                          AS violation_code,
    violationdescription                          AS violation_description,
    level                                         AS inspection_result,
    CAST(NULL AS STRING)                          AS inspection_type,

    SAFE_CAST(latitude AS FLOAT64)                AS latitude,
    SAFE_CAST(longitude AS FLOAT64)               AS longitude

FROM source