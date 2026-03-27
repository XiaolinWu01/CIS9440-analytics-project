WITH source AS (

    SELECT * 
    FROM {{ source('nyc_raw', 'source_dot_service_requests_history') }}

),

renamed AS (

    SELECT

        unique_key AS complaint_id,
        created_date,
        closed_date,
        agency,
        complaint_type,
        descriptor,
        location_type,
        incident_zip,
        incident_address,
        city,
        borough,
        latitude,
        longitude

    FROM source

)

SELECT * FROM renamed