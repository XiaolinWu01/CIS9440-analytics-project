WITH source AS (

    SELECT *
    FROM {{ ref('stg_311_school_complaints') }}

),

geo AS (

    SELECT *
    FROM {{ ref('dim_geography') }}

),

problem AS (

    SELECT *
    FROM {{ ref('dim_problem') }}

)

SELECT
    unique_key AS request_id,

    g.geography_id,
    p.problem_id,

    created_at,
    closed_at,

    TIMESTAMP_DIFF(closed_at, created_at, DAY) AS days_to_close,

    agency,
    agency_name

FROM source s
LEFT JOIN geo g
    ON s.borough = g.borough
   AND s.zip_code = g.zip_code

LEFT JOIN problem p
    ON s.complaint_type = p.complaint_type
   AND s.descriptor = p.descriptor
   AND s.status = p.status
   AND s.open_data_channel_type = p.open_data_channel_type