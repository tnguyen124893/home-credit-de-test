with import_raw as (
    select
        region_id,
        region_name
    from {{ source('raw', 'raw_regions') }}
),

add_surrogate_key as (
    select
        region_id,
        region_name,
        {{ dbt_utils.generate_surrogate_key([
            "region_id",
            "region_name"
        ])}} as stg_regions_sk
    from import_raw
),

deduplication as (
    select
        *
    from add_surrogate_key
    qualify row_number() over (partition by stg_regions_sk) = 1
)

select * from deduplication 