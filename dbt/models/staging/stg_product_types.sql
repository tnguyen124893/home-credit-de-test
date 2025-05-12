with import_raw as (
    select
        product_type_id,
        product_type_name
    from {{ source('raw', 'raw_product_types') }}
),

add_surrogate_key as (
    select
        product_type_id,
        product_type_name,
        {{ dbt_utils.generate_surrogate_key([
            "product_type_id",
            "product_type_name"
        ])}} as stg_product_types_sk
    from import_raw
),

deduplication as (
    select
        *
    from add_surrogate_key
    qualify row_number() over (partition by stg_product_types_sk) = 1
)

select * from deduplication 