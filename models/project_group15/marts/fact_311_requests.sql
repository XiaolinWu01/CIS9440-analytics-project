WITH source AS (
    SELECT * FROM {{ ref('stg_311_school_complaints') }}
)

SELECT
    unique_key       AS request_id,

    d1.date_sk       AS created_date_sk,
    d2.date_sk       AS closed_date_sk,
    p.problem_id,
    srg.sr_gov_sk,
    srg2.sr_geo_sk,
    sg.geo_sk,

    s.created_at,
    s.closed_at,
    TIMESTAMP_DIFF(s.closed_at, s.created_at, DAY) AS days_to_close,
    s.agency,
    s.agency_name,
    CURRENT_TIMESTAMP() AS sr_dw_inserted_at

FROM source s
LEFT JOIN {{ ref('dim_shared_date') }}     d1   ON d1.full_date           = CAST(s.created_at AS DATE)
LEFT JOIN {{ ref('dim_shared_date') }}     d2   ON d2.full_date           = CAST(s.closed_at AS DATE)
LEFT JOIN {{ ref('dim_problem') }}         p    ON p.complaint_type       = s.complaint_type
                                               AND p.descriptor           = s.descriptor
                                               AND p.status               = s.status
                                               AND p.open_data_channel_type = s.open_data_channel_type
LEFT JOIN {{ ref('dim_sr_government') }}   srg  ON srg.agency             = s.agency
                                               AND srg.agency_name        = s.agency_name
                                               AND srg.sr_community_board = s.community_board
                                               AND srg.police_precinct    = s.police_precinct
LEFT JOIN {{ ref('dim_sr_geography') }}    srg2 ON srg2.incident_address  = s.incident_address
                                               AND srg2.street_name       = s.street_name
                                               AND srg2.sr_city           = s.city
LEFT JOIN {{ ref('dim_shared_geography') }} sg  ON sg.borough             = s.borough
                                               AND sg.zip_code            = s.zip_code