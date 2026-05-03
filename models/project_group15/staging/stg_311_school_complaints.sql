WITH source AS (
    SELECT *
    FROM {{ source('nyc_school_raw', 'source_doe-dohmh_311') }}
)

SELECT
    unique_key,

    SAFE_CAST(created_date AS TIMESTAMP)                   AS created_at,
    SAFE_CAST(closed_date AS TIMESTAMP)                    AS closed_at,
    SAFE_CAST(resolution_action_updated_date AS TIMESTAMP) AS resolution_action_updated_date,

    UPPER(borough)  AS borough,
    city,
    incident_zip    AS zip_code,
    SAFE_CAST(council_district AS INT64) AS council_district,

    incident_address,
    street_name,
    cross_street_1,
    cross_street_2,
    intersection_street_1,
    intersection_street_2,
    address_type,
    landmark,
    bbl,

    complaint_type,
    descriptor,
    status,
    open_data_channel_type,

    agency,
    agency_name,
    community_board,
    police_precinct,

    resolution_description,
    SAFE_CAST(latitude AS FLOAT64)              AS latitude,
    SAFE_CAST(longitude AS FLOAT64)             AS longitude,
    x_coordinate_state_plane,
    y_coordinate_state_plane

FROM source