

with source as (

    select * from {{ source('internal_stg', 'example_internal_source') }}

),

renamed as (

    select 
        id,
        email,
        _ingest_datetime as updated_timestamp
    from source

),

select * from renamed