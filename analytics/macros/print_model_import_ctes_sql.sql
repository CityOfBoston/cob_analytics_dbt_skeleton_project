{%- macro print_model_import_ctes_sql(model_name) -%}
    {% set model_sql = codegen.generate_model_import_ctes(model_name = model_name) %}
    {{ print(model_sql) }}
{%- endmacro %}