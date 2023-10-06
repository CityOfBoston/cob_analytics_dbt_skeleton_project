{% docs __overview__ %}

# Analytics Data Catalog

Custom intro text, followed by the standard navigation text with some modifications.

---

## Navigation
You can use the `Project` and `Database` navigation tabs on the left side of the window to explore the models in this dbt project.

### Project Tab
The `Project` tab mirrors the directory structure of the dbt project. In this tab, you can see all of the models defined in the dbt project, as well as models imported from dbt packages.

#### Sources

You can see documentation for all Source tables under the Sources header, divided according to data access level (open, internal, and restricted).

#### Exposures

You can see documentation for all external downstream dependencies under the Exposures header. This includes Dashboards, CKAN datasets, and ArcGIS Online feature layers.

#### Projects

You can see documentation for all dbt projects under the Projects header. This includes the core Analytics Team project, `analytics`, as well as the dbt packages being used. 

Click `analytics`, and then `models` to see all dbt models (tables and views downstream of the source tables). `macros` contains documentation for custom macros (functions written in jinja) in the project.

### Database Tab
The `Database` tab also exposes your models, but in a format that looks more like a database explorer. This view shows relations (tables and views) grouped into database schemas. Note that ephemeral models are *not* shown in this interface, as they do not exist in the database.

### Graph Exploration
You can click the blue icon on the bottom-right corner of the page to view the lineage graph of your models.

On model pages, you'll see the immediate parents and children of the model you're exploring. By clicking the Expand button at the top-right of this lineage pane, you'll be able to see all of the models that are used to build, or are built from, the model you're exploring.

Once expanded, you'll be able to use the `--select` and `--exclude` model selection syntax to filter the models in the graph. For more information on model selection, check out the [dbt docs](https://docs.getdbt.com/docs/model-selection-syntax).

Note that you can also right-click on models to interactively filter and explore the graph.

---

## Data Warehouse Architecture

The Analytics Data Warehouse is a [PostgreSQL](https://getdbt.slack.com/archives/C01NH3F2E05/p1694461283130219) (+[PostGIS](https://postgis.net/)) database hosted on AWS by [Civis Analytics](https://www.civisanalytics.com/). You can query the database by either signing in to [Civis Platform](https://platform.civisanalytics.com/spa/) or by connecting directly to the database using your database credentials with an application like [DBeaver](https://dbeaver.io/).

If you do not have database credentials to connect directly to the database and would like access to the database, please contact the Engineering team at [etldevelopers@cityofboston.gov](mailto:etldevelopers@cityofboston.gov).

All production data ready for use is located in the production schemas, `open_prod`, `internal_prod`, and `restricted_prod`. If you do not have access to a dataset that you need access to, please submit a request to the Analytics Team at [analyticsteam@boston.gov](mailto:analyticsteam@boston.gov).

The following diagram illustrates how data moves through the new set of schemas to end up in the production schemas:

![Schema Design](assets/schema_design.png)

---

## Questions? Contact us!

If you have any questions about this documentation site or the data warehouse, please email the Analytics Team Engineering Team at [etldevelopers@cityofboston.gov](mailto:etldevelopers@cityofboston.gov). 

If you would like to request access to the database or a specific table, please email the Analytics team at [analyticsteam@boston.gov](mailto:analyticsteam@boston.gov).

If you have a project request for the Analytics team, including requests to add datasets to the data warehouse, please fill out the [project request form](https://app.smartsheet.com/b/form/be7fafeb89f0483e99f9f25ce9f1e661).

Curious about the [Analytics Team](https://www.boston.gov/departments/analytics-team) and what we do? Check out [Our 2020 Vision](https://www.boston.gov/sites/default/files/file/2020/02/5%20Years%20Analytics.pdf).

---

## About dbt
- [What is dbt](https://docs.getdbt.com/docs/introduction)?
- Read the [dbt viewpoint](https://docs.getdbt.com/docs/viewpoint)
- [Installation](https://docs.getdbt.com/docs/installation)
- Join the [dbt Community](https://www.getdbt.com/community/) for questions and discussion

{% enddocs %}