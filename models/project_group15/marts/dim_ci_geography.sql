WITH source AS (
    SELECT DISTINCT
        number,
        street,
        city,
        state,
        bin,
        bbl,
        nta,
        borocode
    FROM {{ ref('stg_cafeteria_inspections') }}
)

SELECT
    ABS(FARM_FINGERPRINT(
        CONCAT(
            COALESCE(number, ''), '|',
            COALESCE(street, ''), '|',
            COALESCE(city, ''), '|',
            COALESCE(state, ''), '|',
            COALESCE(CAST(bin AS STRING), ''), '|',
            COALESCE(CAST(bbl AS STRING), ''), '|',
            COALESCE(nta, ''), '|',
            COALESCE(CAST(borocode AS STRING), '')
        )
    )) AS ci_geo_sk,
    number,
    street,
    city            AS ci_city,
    state,
    bin,
    bbl             AS ci_bbl,
    nta,
    borocode
FROM source