# STEP 2: Create the SQL for the base model, which selects from the _stg table and results in a _dev/_prod table
#
# Any model that references a source, rather than another model, is referred to as a "base model". 
# The next step after creating a source YAML file is to create the SQL to select from that source. 
# In our case, this resulting model will be considered the "production" table, and will go to the dev and prod schemas.

access_level="" # open, internal, restricted
table_name="" # do not include the schema, only the table name

filepath="./models/${access_level}/${table_name}.sql"

cd ../analytics
dbt --quiet run-operation print_base_model_sql --args "{"access_level": "${access_level}", "table_name": "${table_name}"}" > $filepath
