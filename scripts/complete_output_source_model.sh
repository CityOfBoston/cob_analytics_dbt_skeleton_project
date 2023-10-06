# This script combines steps 1-3 to create the source YAML, model SQL, and model YAML files for a new source table
#
# This scripts is for the sake of convenience and to show how all commands chain together, but note that if any 
# columns need to be renamed in the model SQL file, step 3 will need to be run again to produce the correct model YAML file.
# Remember you can always comment out the lines that you don't want to be run.

access_level="" # open, internal, restricted
table_name="" # do not include the schema, only the table name

cd ../analytics &&

dbt --quiet run-operation print_source_yaml --args "{"access_level": "${access_level}", "table_name": "${table_name}"}" \
    > "./models/${access_level}/stg/${table_name}.yml" &&

dbt --quiet run-operation print_base_model_sql --args "{"access_level": "${access_level}", "table_name": "${table_name}"}" \
    > "./models/${access_level}/${table_name}.sql" &&

dbt run --select +${table_name} &&

dbt --quiet run-operation print_model_yaml --args "{"model_name": "${table_name}"}" \
    > "./models/${access_level}/${table_name}.yml" 