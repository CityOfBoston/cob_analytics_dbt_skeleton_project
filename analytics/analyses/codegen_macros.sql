{# For use when developing new models in dbt Cloud

Copy the macro that you need, fill in the correct schema and table names, and then compile the macro. 
The output should be copied and pasted into the appropriate file.

{{ codegen.generate_source(schema_name='internal_stg', table_names=['test_table'], generate_columns=True, include_descriptions=True) }}

{{ codegen.generate_base_model(source_name='internal_stg', table_name='test_table') }}

{{ codegen.generate_model_yaml(model_names=['test_table'], upstream_descriptions=True, include_data_types=True) }}

{{ codegen.generate_model_import_ctes(model_name = 'test_table_joined') }}

#}