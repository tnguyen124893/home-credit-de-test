with import_raw as (
    select
        *
    from {{ ref('snapshot_raw_products') }}
),

add_surrogate_key as (
    select
        product_code,
        product_name,
        product_type_id,
        base_interest_rate,
        processing_fee_percent,
        min_tenor,
        max_tenor,
        active_flag,
        {{ dbt_utils.generate_surrogate_key([
            "product_code",
            "product_name",
            "product_type_id",
            "base_interest_rate",
            "processing_fee_percent",
            "min_tenor",
            "max_tenor",
            "active_flag",
            "dbt_valid_from"
        ])}} as stg_products_sk
    from import_raw
),

deduplication as (
    select
        *
    from add_surrogate_key
    qualify row_number() over (partition by stg_products_sk) = 1
)

select * from deduplication 