WITH source AS (
    SELECT DISTINCT
        community_board,
        census_tract
    FROM {{ ref('stg_cafeteria_inspections') }}
)

SELECT
    ABS(FARM_FINGERPRINT(
        CONCAT(
            COALESCE(CAST(community_board AS STRING), ''), '|',
            COALESCE(CAST(census_tract AS STRING), '')
        )
    )) AS ci_gov_sk,
    community_board,
    census_tract
FROM source