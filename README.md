# How to run this project

## Overview
Raw data will be ingested into two DuckDB data warehouses, one for production and one for development. dbt will transform raw data through 3 layers: staging, marts and reporting.

## Install required packages
1. Create a python environment for your development
In the directory of the cloned repo home-credit-de-test
```bash
python3 -m venv .env
source .env/bin/activate
```
2. Install Python packages
```bash
python3 -m pip install -r requirements.txt
```
3. Create a dbt profile file
Go into folder `dbt/` and create a file named `profiles.yml` and copy the following config and paste into this file
```yml
home_financial_services_dbt:
  target: local
  outputs:
    prod:
      type: duckdb
      path: 'home_financial_services_prod_dwh.duckdb'
      schema: prod
    dev:
      type: duckdb
      path: 'home_financial_services_dev_dwh.duckdb'
      schema: dev
    local:
      type: duckdb
      path: 'home_financial_services_dev_dwh.duckdb'
      schema: dev_{add_your_name}
```
Test connection between dbt and DuckDB
```bash
dbt debug
```

## Ingest data to data warehouse dev and prod
Run the following
```bash
python3 dbt/ingest_to_duckdb.py
```
The raw data will be ingested to schema raw in both data warehouses

## Run dbt transformation
Run the following to build staging, marts and reporting models in your local schemas in dev data warehouse 
```bash
dbt build --target local
```
Change the flag to `--target dev` to run dbt in dev schemas in dev data warehouse. Change the flag to `--target prod` to run dbt in prod data warehouse.
Run the following to build documentation page
```bash
dbt docs generate
dbt docs serve
```