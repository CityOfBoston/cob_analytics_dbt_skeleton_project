# STEP 4: Refactor an existing model SQL file by moving up all ref() functions to the top of the query
# NOTE: this will overwrite the existing file
#
# The SQL for a particular model may have been already written, but not according to the dbt style guide
# Rather than refactoring the SQL by hand, you can use this macro to make sure the "model import CTEs" are correctly generated. 
# Much like python imports indicate what library will be used, import CTEs indicate what models will be used and makes sure all ref() macros are called upfront.
#
# To use this macro, you should have a SQL file already saved and the model created, 
# for example `analytics/models/internal/test_table_joined.sql`, which joins together `test_table` with some other tables.
# This means you also should have already converted any FROM statements to use the ref() function instead of schema.table

access_level="" # open, internal, restricted
model_name="" # model name is both the table name (no schema) and the filename (before the .sql)

filepath="./models/${access_level}/${model_name}.sql"

cd ../analytics
dbt --quiet run-operation print_model_import_ctes_sql --args "{"model_name": "${model_name}"}" >> $filepath 
# note -- to append to the file instead, change the > to >>

