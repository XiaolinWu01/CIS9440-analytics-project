WITH source AS (

    SELECT DISTINCT
        complaint_type,
        descriptor,
        status,
        open_data_channel_type
    FROM {{ ref('stg_311_school_complaints') }}

)

SELECT
    ABS(FARM_FINGERPRINT(
        CONCAT(
            COALESCE(complaint_type, ''),
            '|',
            COALESCE(descriptor, ''),
            '|',
            COALESCE(status, ''),
            '|',
            COALESCE(open_data_channel_type, '')
        )
    )) AS problem_id,

    complaint_type,
    descriptor,
    status,
    open_data_channel_type

FROM source