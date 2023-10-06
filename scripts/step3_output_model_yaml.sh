# STEP 3: Create the model YAML file. The model must exist in the database first
#
# Each model, in addition to having a SQL file, should also have a YAML file. 
# The next step after creating the model with SQL is to create the documentation in a YAML file.

access_level="" # open, internal, restricted
model_name="" # model name is both the table name (no schema) and the filename (before the .sql)

filepath="./models/${access_level}/${model_name}.yml"

cd ../analytics
dbt --quiet run-operation print_model_yaml --args "{"model_name": "${model_name}"}" > $filepath
