with import_raw as (
    select
        client_id,
        client_name,
        region_id,
        join_date,
        credit_score
    from {{ ref('raw_customers') }}
),

add_surrogate_key as (
    select
        client_id,
        client_name,
        region_id,
        join_date,
        credit_score,
        {{ dbt_utils.generate_surrogate_key([
            "client_id",
            "client_name",
            "region_id",
            "join_date",
            "credit_score"
        ])}} as stg_customers_sk
    from import_raw
),

deduplication as (
    select
        *
    from add_surrogate_key
    qualify row_number() over (partition by stg_customers_sk) = 1
)

select * from deduplication