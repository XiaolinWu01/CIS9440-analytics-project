WITH all_dates AS (
    SELECT DISTINCT CAST(created_at AS DATE) AS full_date
    FROM {{ ref('stg_311_school_complaints') }}
    WHERE created_at IS NOT NULL

    UNION DISTINCT

    SELECT DISTINCT CAST(closed_at AS DATE)
    FROM {{ ref('stg_311_school_complaints') }}
    WHERE closed_at IS NOT NULL

    UNION DISTINCT

    SELECT DISTINCT CAST(inspection_date AS DATE)
    FROM {{ ref('stg_cafeteria_inspections') }}
    WHERE inspection_date IS NOT NULL
)

SELECT
    ABS(FARM_FINGERPRINT(CAST(full_date AS STRING))) AS date_sk,
    full_date,
    EXTRACT(YEAR    FROM full_date) AS year,
    EXTRACT(QUARTER FROM full_date) AS quarter,
    EXTRACT(MONTH   FROM full_date) AS month_num,
    FORMAT_DATE('%B', full_date)    AS month_name,
    EXTRACT(DAY     FROM full_date) AS day_num,
    FORMAT_DATE('%A', full_date)    AS day_name,
    EXTRACT(DAYOFWEEK FROM full_date) NOT IN (1, 7) AS is_school_day
FROM all_dates