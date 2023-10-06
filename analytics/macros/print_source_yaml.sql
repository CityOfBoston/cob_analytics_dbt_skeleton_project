{%- macro print_source_yaml(access_level, table_name) -%}
    {% set schema_name = access_level + '_stg'%}
    {% set source_yml = codegen.generate_source(schema_name=schema_name, table_names=[table_name], generate_columns=True, include_descriptions=True, include_data_types=True) %}
    {{ print(source_yml) }}
{%- endmacro %}