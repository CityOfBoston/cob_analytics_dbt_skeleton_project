{% macro generate_geom_column(geom_input_col, geom_type, input_srid, output_srid, x_input_col=none, y_input_col=none, is_wkt_input=false, override_colname=none) -%}
    {%- set geom_type=geom_type.lower() -%}
    {%- if override_colname -%}
        {%- set colname=override_colname -%}
    {%- else -%}
        {%- set colname='geom_' ~ geom_type ~ '_' ~ output_srid -%}
    {%- endif -%}        
    {%- set is_multi=true if geom_type[:5] == 'multi' -%}
    {%- set transform=true if input_srid != output_srid -%}
    {%- if geom_input_col -%}
        {%- set geom_sql=geom_input_col ~ ',' ~ input_srid -%}
        {%- if is_wkt_input -%}
            {%- if transform -%}
                {%- if is_multi -%} {# yes WKT, yes transform, yes multi #}
                    {%- set fin_sql="ST_Multi(ST_Transform(ST_GeomFromText(" ~ geom_sql ~ ")," ~ output_srid ~ "))" -%}
                {%- else -%} {# yes WKT, yes transform, not multi #}
                    {%- set fin_sql="ST_Transform(ST_GeomFromText(" ~ geom_sql ~ ")," ~ output_srid ~ ")" -%}
                {%- endif -%}
            {%- elif is_multi -%} {# yes WKT, not transform, yes multi #}
                {%- set fin_sql="ST_Multi(ST_GeomFromText(" ~ geom_sql ~ "))" -%}
            {%- else -%} {# yes WKT, not transform, not multi #}
                {%- set fin_sql="ST_GeomFromText(" ~ geom_sql ~ ")" -%}               
            {%- endif -%}
        {%- elif transform -%}
            {%- if is_multi -%} {# not WKT, yes transform, yes multi #}
                {%- set fin_sql="ST_Multi(ST_Transform(" ~ geom_sql ~ "," ~ output_srid ~ "))" -%}
            {%- else -%} {# not WKT, yes transform, not multi #}
                {%- set fin_sql="ST_Transform(" ~ geom_sql ~ "," ~ output_srid ~ ")" -%}
            {%- endif -%}
        {%- else -%}
            {%- if is_multi -%} {# not WKT, not transform, yes multi #}
                {%- set fin_sql="ST_Multi(" ~ geom_sql ~ ")" -%}
            {%- endif -%}
        {%- endif -%}
    {{ fin_sql }}::GEOMETRY({{ geom_type }},{{ output_srid }}) AS {{ colname }}
    {%- else -%} {# not geom_col, aka XY input #}
        {%- set geom_sql="ST_SetSRID(ST_MakePoint(" ~ x_input_col ~ "::DOUBLE PRECISION, " ~ y_input_col ~ "::DOUBLE PRECISION)," ~ input_srid ~ ")" -%}
        {%- if transform -%}
            {%- set fin_sql="ST_Transform(" ~ geom_sql ~ "," ~ output_srid ~ ")" -%}
        {%- else -%}
            {%- set fin_sql=geom_sql -%}
        {%- endif -%}
    {{ fin_sql }}::GEOMETRY(point,{{ output_srid }}) AS {{ colname }}
    {%- endif -%}
{%- endmacro -%}
