import duckdb

dev_con = duckdb.connect("home_financial_services_dev_dwh.duckdb")
prod_con = duckdb.connect("home_financial_services_prod_dwh.duckdb")

def create_table(sql, table_name, connection):
    try:
        connection.sql(sql)
        print(f"✅ Successfully created or replaced table: {table_name}")
    except Exception as e:
        print(f"❌ Failed to create table {table_name}: {e}")

# Ingest raw tables to dev database
if dev_con:
    print("Ingesting raw tables to dev database...")
    try:
        dev_con.sql("create schema if not exists raw;")
        print("✅ Schema 'raw' is ready.")
    except Exception as e:
        print(f"❌ Failed to create schema 'raw': {e}")

    create_table(
        """
            create or replace table raw.raw_customers 
            as 
            select
                *
            from 'data/raw_customers.csv'
        """,
        "raw.raw_customers",
        connection=dev_con
    )

    create_table(
        """
            create or replace table raw.raw_contracts 
            as 
            select
                *
            from 'data/raw_contracts.csv'
        """,
        "raw.raw_contracts",
        connection=dev_con
    )

    create_table(
        """
            create or replace table raw.raw_installments 
            as 
            select
                *
            from 'data/raw_installments.csv'
        """,
        "raw.raw_installments",
        connection=dev_con
    )

    create_table(
        """
            create or replace table raw.raw_product_types
            as 
            select
                *
            from 'data/raw_product_types.csv'
        """,
        "raw.raw_product_types",
        connection=dev_con
    )

    create_table(
        """
            create or replace table raw.raw_products
            as 
            select
                *
            from 'data/raw_products.csv'
        """,
        "raw.raw_products",
        connection=dev_con
    )

    create_table(
        """
            create or replace table raw.raw_regions
            as 
            select
                *
            from 'data/raw_regions.csv'
        """,
        "raw.raw_regions",
        connection=dev_con
    )

    create_table(
        """
            create or replace table raw.raw_repayments
            as 
            select
                *
            from 'data/raw_repayments.csv'
        """,
        "raw.raw_repayments",
        connection=dev_con
    )

# Ingest raw tables to prod database
if prod_con:
    print("Ingesting raw tables to prod database...")
    try:
        prod_con.sql("create schema if not exists raw;")
        print("✅ Schema 'raw' is ready.")
    except Exception as e:
        print(f"❌ Failed to create schema 'raw': {e}")

    create_table(
        """
            create or replace table raw.raw_customers 
            as 
            select
                *
            from 'data/raw_customers.csv'
        """,
        "raw.raw_customers",
        connection=prod_con
    )

    create_table(
        """
            create or replace table raw.raw_contracts 
            as 
            select
                *
            from 'data/raw_contracts.csv'
        """,
        "raw.raw_contracts",
        connection=prod_con
    )

    create_table(
        """
            create or replace table raw.raw_installments 
            as 
            select
                *
            from 'data/raw_installments.csv'
        """,
        "raw.raw_installments",
        connection=prod_con
    )

    create_table(
        """
            create or replace table raw.raw_product_types
            as 
            select
                *
            from 'data/raw_product_types.csv'
        """,
        "raw.raw_product_types",
        connection=prod_con
    )

    create_table(
        """
            create or replace table raw.raw_products
            as 
            select
                *
            from 'data/raw_products.csv'
        """,
        "raw.raw_products",
        connection=prod_con
    )

    create_table(
        """
            create or replace table raw.raw_regions
            as 
            select
                *
            from 'data/raw_regions.csv'
        """,
        "raw.raw_regions",
        connection=prod_con
    )

    create_table(
        """
            create or replace table raw.raw_repayments
            as 
            select
                *
            from 'data/raw_repayments.csv'
        """,
        "raw.raw_repayments",
        connection=prod_con
    )


