WITH source AS (
    SELECT * FROM {{ ref('stg_cafeteria_inspections') }}
)

SELECT
    GENERATE_UUID()  AS inspection_id,

    d1.date_sk       AS inspection_date_sk,
    sch.school_sk,
    v.violation_id   AS violation_sk,
    cig.ci_geo_sk,
    cigov.ci_gov_sk,
    sg.geo_sk,

    s.inspection_date,
    CASE
        WHEN s.inspection_result = 'Pass' THEN 0
        ELSE 1
    END              AS has_violation,
    s.school_name,
    s.inspection_result,
    s.latitude,
    s.longitude,
    CURRENT_TIMESTAMP() AS ci_dw_inserted_at

FROM source s
LEFT JOIN {{ ref('dim_shared_date') }}     d1    ON d1.full_date     = CAST(s.inspection_date AS DATE)
LEFT JOIN {{ ref('dim_school') }}          sch   ON sch.school_name  = s.school_name
LEFT JOIN {{ ref('dim_violation') }}       v     ON v.violation_code = s.violation_code
                                                AND v.violation_level = s.inspection_result
LEFT JOIN {{ ref('dim_ci_geography') }} cig ON cig.number = s.number
                                            AND cig.street  = s.street
                                            AND cig.ci_city = s.city
LEFT JOIN {{ ref('dim_ci_government') }}   cigov ON cigov.community_board = s.community_board
                                                AND cigov.census_tract    = s.census_tract
LEFT JOIN {{ ref('dim_shared_geography') }} sg   ON sg.borough           = s.borough
                                                AND sg.zip_code          = s.zip_code