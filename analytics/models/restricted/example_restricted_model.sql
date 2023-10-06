

with source as (

    select * from {{ source('restricted_stg', 'example_restricted_source') }}

),

renamed as (

    select
        dept_id::VARCHAR(6),
        effdt,
        eff_status,
        descr,
        (lastupddttm at time zone 'UTC')::TIMESTAMPTZ as lastupddttm,
        _ingest_datetime::TIMESTAMPTZ

    from source

)

select * from renamed

