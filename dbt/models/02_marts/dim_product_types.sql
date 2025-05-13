with import_stg_product_types as (
    select
      *
    from {{ ref('stg_product_types') }}
)

select
  product_type_id,
  product_type_name,
  dbt_valid_from,
  ifnull(dbt_valid_to, '9999-12-31'::timestamp) as dbt_valid_to
from import_stg_product_types