{% macro generate_lat_long_cols(geom_input_col, input_srid, x_input_col=none, y_input_col=none, is_wkt_input=false, override_x_colname=none, override_y_colname=none) -%}
    {%- if override_x_colname -%}
        {%- set x_colname=override_x_colname -%}
    {%- else -%}
        {%- set x_colname='x_longitude' -%}
    {%- endif -%}        
    {%- if override_y_colname -%}
        {%- set y_colname=override_y_colname -%}
    {%- else -%}
        {%- set y_colname='y_latitude' -%}
    {%- endif -%}        
    {%- set transform=true if input_srid != 4326 -%}
    {%- if geom_input_col -%}
    ST_X({{"ST_Transform(" if transform}}{{"ST_GeomFromText(" if is_wkt_input}}{{ geom_input_col }},{{ input_srid }}{{")" if is_wkt_input}}{{",4326)" if transform}})::DOUBLE PRECISION AS {{ x_colname }},
    ST_Y({{"ST_Transform(" if transform}}{{"ST_GeomFromText(" if is_wkt_input}}{{ geom_input_col }},{{ input_srid }}{{")" if is_wkt_input}}{{",4326)" if transform}})::DOUBLE PRECISION AS {{ y_colname }}
    {%- else -%}
    ST_X({{"ST_Transform(" if transform}}ST_SetSRID(ST_MakePoint({{ x_input_col }}::DOUBLE PRECISION, {{ y_input_col }}::DOUBLE PRECISION),{{ input_srid }}){{",4326)" if transform}})::DOUBLE PRECISION AS {{ x_colname }},
    ST_Y({{"ST_Transform(" if transform}}ST_SetSRID(ST_MakePoint({{ x_input_col }}::DOUBLE PRECISION, {{ y_input_col }}::DOUBLE PRECISION),{{ input_srid }}){{",4326)" if transform}})::DOUBLE PRECISION AS {{ y_colname }}
    {%- endif -%}
{%- endmacro -%}
