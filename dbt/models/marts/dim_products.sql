with import_stg_products as (
    select
      *
    from {{ ref('stg_products') }}
)

select
  product_code,
  product_name,
  product_type_id,
  base_interest_rate,
  processing_fee_percent,
  min_tenor,
  max_tenor,
  active_flag,
  dbt_valid_from,
  ifnull(dbt_valid_to, '9999-12-31'::timestamp) as dbt_valid_to
from import_stg_products