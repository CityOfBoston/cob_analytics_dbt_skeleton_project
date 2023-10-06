# This script combines steps 4 and 3 to refactor a new model (SQL file) to conform to dbt standards and then create the YAML file
#
# This scripts is for the sake of convenience and to show how all commands chain together, but note that if any 
# columns need to be renamed in the model SQL file, step 3 will need to be run again to produce the correct model YAML file.
# Remember you can always comment out the lines that you don't want to be run.
#
# NOTE: For print_model_import_ctes_sql to run correctly, you must use the ref() function instead of schema.table in the FROM statement

access_level="" # open, internal, restricted
model_name="" # do not include the schema, only the table name

cd ../analytics &&

dbt --quiet run-operation print_model_import_ctes_sql --args "{"model_name": "${model_name}"}" > "./models/${access_level}/${model_name}.sql" &&
# note -- to append to the file instead, change the > to >>

dbt run --select ${model_name} &&

dbt --quiet run-operation print_model_yaml --args "{"model_name": "${model_name}"}" > "./models/${access_level}/${model_name}.yml"