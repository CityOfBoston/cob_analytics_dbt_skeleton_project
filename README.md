# COB Analytics dbt Skeleton Project

This repo contains the structure (skeleton) of the City of Boston Analytics Team's dbt project repo, as well as the Civis workflows used to run them. This readme has been slightly modified from the original to account for this.

## Set up with VSCode

You should be prompted to install the suggested extensions if you do not already have them installed.

### Create a local environment

Generic instructions for creating a local development environment can be found [at this GitBook page](private_link_removed)

Commands specific for this repo:

```
python -m venv .dbtenv
source .dbtenv/Scripts/activate
pip install -r requirements.txt
```

If you have correctly set up your pip.ini file, you should not run into an SSL certification issue when running the pip install command. However, if you do, then you will need to follow the instructions in the "Fixing the SSL Certificate Issue" section on the GitBooks page (linked above) and copy the cert into `.dbtenv/Lib/site-packages/pip/_vendor/certifi/cacert.pem`

After running the pip install command, you must copy the cert into `.dbtenv/Lib/site-packages/certifi/cacert.pem`. dbt commands that require an internet connection will fail if you don't do this (e.g. `dbt deps`).

#### dbt deps

The first time you clone the repo, you will also need to install the dbt specific packages. Open up the gitbash terminal (there may be some issues running this in VS Code with dbt-power-user), navigate to the `analytics` directory in this repo, activate the .dbtenv environment, and then run:

```
dbt deps
```

You should only need to do this once. This will add the directory `dbt_packages`, which is ignored by git.

To update your packages to a new version, you should follow the same process, but add the dbt clean command:

```
dbt clean
dbt deps
```

If you get an error when doing this in VS Code and are doing this in Git Bash, you should make sure to close your VS Code workspace window first, run the commands in the Git Bash application, and then re-open the workspace in VS Code.

### Connect to the database

You should first create a file in the top-level directory called `.env` and copy these contents to it:

```
CIVIS_POSTGRES_CREDENTIAL_USERNAME=
CIVIS_POSTGRES_CREDENTIAL_PASSWORD=
```

You can then fill in your username and password.

To connect to the Civis database from your local computer, you will need to fill in the CIVIS_POSTGRES environment variables in BOTH the .env and .code-workspace files. Under `"settings": { "terminal.integrated.env.windows": {}}` fill in your database username and password, and add any other environment variables you may need. 

You will now need to close and re-open the workspace.

Make sure you don't commit your env variables!

You can test the connection with:

```
cd analytics
dbt debug
```

You can then also write a query in the `analyses/scratch.sql` file and then execute the sql.

## Create SQL & YAML files and documentation

With the dbt package codegen, you can automate the creation of SQL and YAML files, which saves a lot of time. There are two methods for doing this: running a command line operation or compiling a macro. Templates for the codegen macros are in `analytics/analyses/codegen_macros.sql`. Scripts for executing the command line operations are in the `scripts` directory. These scripts will create the file and fill in the content, so there is no need to copy and paste. To run these scripts, make sure you have a bash terminal open. Navigate to the `scripts` folder. Fill in the relevant variables at the start of the script. Then run the script by typing in the bash command line, for example, `bash step1_output_source_yaml.sh`. 

For the sake of convenience, the script `complete_output_source_model.sh` combines steps 1-3 to create the source YAML, model SQL, and model YAML files for a given source table. This assumes no changes to the column names, and if any changes are made to the column names in the model SQL file, step 3 to generate the model YAML file will need to be run again (after re-running the model creation).

## dbt run

To actually create a table in the database (via model SQL file), or create a source (via YAML file), you will need to do a `dbt run`. Like all dbt commands, you will need to make sure you are running the command from inside of the project folder (analytics). If you do a simple `dbt run`, it will run/recreate everything that can be run - all sources, models, etc. This can be disruptive if multiple people are working on the project and in the database at the same time. So it is best practice to run only the models/sources that you are working on. You can do this with the `--select` argument. To run a single model, do: `dbt run --select test_table`. To run a single model *and all downstream dependencies*, add the `+` after the model: `dbt run --select test_table+`. To run a single model *and all upstream dependencies*, add the `+` before the model: `dbt run --select +test_table`. Or, to run a model including all upstream and downstream dependencies (the safest and most efficient option) do: `dbt run --select +test_table+`.

dbt Labs has detailed documentation on this here: https://docs.getdbt.com/reference/node-selection/syntax

`dbt run` will recreate the table in the database. Before you do this, you can make sure that your code will run correctly with `dbt compile`.

For a useful cheatsheet of dbt commands, see: https://github.com/bruno-szdl/cheatsheets/blob/main/dbt_cheat_sheet.pdf