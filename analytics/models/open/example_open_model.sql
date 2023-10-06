

with source as (

    select * from {{ source('open_stg', 'example_open_source') }}

),

renamed as (

    select
        objectid,
        name,
        shape_text,
        {{ generate_geom_column('shape_text', geom_type='multipolygon', input_srid=2249, output_srid=4326, is_wkt_input=true) }},
        _ingest_datetime

    from source

)

select * from renamed

