WITH source AS (

    SELECT *
    FROM {{ ref('stg_311_school_complaints') }}

),

geo AS (

    SELECT *
    FROM {{ ref('dim_geography') }}

)

SELECT
    -- primary key
    unique_key AS request_id,

    -- foreign key
    g.geography_id,

    -- timestamps
    created_at,
    closed_at,

    -- measures
    TIMESTAMP_DIFF(closed_at, created_at, DAY) AS days_to_close,

    -- attributes
    complaint_type,
    descriptor,
    status,
    agency

FROM source s
LEFT JOIN geo g
    ON s.borough = g.borough
    AND s.zip_code = g.zip_code