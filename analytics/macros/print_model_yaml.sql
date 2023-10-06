{%- macro print_model_yaml(model_name) -%}
    {% set model_yml = codegen.generate_model_yaml(model_names=[model_name], include_data_types=True, upstream_descriptions=True) %}
    {{ print(model_yml) }}
{%- endmacro %}