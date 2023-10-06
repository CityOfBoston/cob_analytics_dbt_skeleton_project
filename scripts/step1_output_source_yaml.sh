# STEP 1: Create the YAML file for the source table in the _stg schema
#
# Each table in a staging schema is considered a "source", and must have a corresponding "source" YAML file.

access_level="" # open, internal, restricted
table_name="" # do not include the schema, only the table name

filepath="./models/${access_level}/stg/${table_name}.yml"

cd ../analytics
dbt --quiet run-operation print_source_yaml --args "{"access_level": "${access_level}", "table_name": "${table_name}"}" > $filepath
# note: need to change > to >> if modifying an existing source that other models depend on (and then manually delete previous text)
