WITH source AS (
    SELECT DISTINCT
        school_name,
        permittee,
        ptet,
        site_type
    FROM {{ ref('stg_cafeteria_inspections') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['school_name']) }} AS school_sk,
    school_name AS dbn,
    school_name,
    permittee,
    ptet,
    site_type,
    NULL AS facility_type,
    CASE
        WHEN UPPER(school_name) LIKE '%ELEMENTARY%' THEN 'ELEMENTARY'
        WHEN UPPER(school_name) LIKE '%MIDDLE%'     THEN 'MIDDLE'
        WHEN UPPER(school_name) LIKE '%HIGH%'       THEN 'HIGH'
        WHEN UPPER(school_name) LIKE '%PREP%'       THEN 'PREP'
        WHEN UPPER(school_name) LIKE '%ACADEMY%'    THEN 'ACADEMY'
        ELSE NULL
    END AS school_level,
    NULL AS total_enrollment,
    NULL AS economic_need_index,
    CURRENT_TIMESTAMP() AS dw_inserted_at
FROM source