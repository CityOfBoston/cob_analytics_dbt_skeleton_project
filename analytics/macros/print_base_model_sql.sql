{%- macro print_base_model_sql(access_level, table_name) -%}
    {% set schema_name = access_level + '_stg'%}
    {% set base_sql = codegen.generate_base_model(source_name=schema_name, table_name=table_name, case_sensitive_cols=True) %}
    {{ print(base_sql) }}
{%- endmacro %}