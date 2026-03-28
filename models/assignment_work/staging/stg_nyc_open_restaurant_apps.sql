WITH source AS (
    SELECT *
    FROM {{ source('nyc_raw', 'source_nyc_open_restaurant_apps') }}
),

cleaned AS (
    SELECT
        CAST(objectid AS STRING) AS application_id,

        CAST(restaurant_name AS STRING) AS restaurant_name,
        CAST(legal_business_name AS STRING) AS legal_business_name,
        CAST(food_service_establishment AS STRING) AS food_service_establishment,

        CASE
            WHEN UPPER(TRIM(borough)) IN ('MANHATTAN', 'NEW YORK COUNTY') THEN 'Manhattan'
            WHEN UPPER(TRIM(borough)) IN ('BRONX', 'THE BRONX') THEN 'Bronx'
            WHEN UPPER(TRIM(borough)) IN ('BROOKLYN', 'KINGS COUNTY') THEN 'Brooklyn'
            WHEN UPPER(TRIM(borough)) IN ('QUEENS', 'QUEEN', 'QUEENS COUNTY') THEN 'Queens'
            WHEN UPPER(TRIM(borough)) IN ('STATEN ISLAND', 'RICHMOND COUNTY') THEN 'Staten Island'
            ELSE 'UNKNOWN'
        END AS borough,

        CAST(seating_interest_sidewalk AS STRING) AS seating_interest_sidewalk,
        CAST(approved_for_sidewalk_seating AS STRING) AS approved_for_sidewalk_seating,
        CAST(approved_for_roadway_seating AS STRING) AS approved_for_roadway_seating,

        CASE
            WHEN UPPER(TRIM(CAST(zip AS STRING))) IN ('N/A', 'NA', '') THEN NULL
            WHEN LENGTH(TRIM(CAST(zip AS STRING))) = 5 THEN TRIM(CAST(zip AS STRING))
            WHEN LENGTH(TRIM(CAST(zip AS STRING))) = 10
                 AND REGEXP_CONTAINS(TRIM(CAST(zip AS STRING)), r'^\d{5}-\d{4}$')
            THEN TRIM(CAST(zip AS STRING))
            ELSE NULL
        END AS zip_code,

        CAST(time_of_submission AS TIMESTAMP) AS time_of_submission,
        CAST(latitude AS FLOAT64) AS latitude,
        CAST(longitude AS FLOAT64) AS longitude,

        CURRENT_TIMESTAMP() AS _stg_loaded_at

    FROM source

    WHERE objectid IS NOT NULL
)

SELECT * FROM cleaned