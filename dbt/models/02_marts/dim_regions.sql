with import_stg_regions as (
    select
      *
    from {{ ref('stg_regions') }}
)

select
  region_id,
  region_name,
  dbt_valid_from,
  ifnull(dbt_valid_to, '9999-12-31'::timestamp) as dbt_valid_to,
  case when dbt_valid_to is null then true else false end as is_latest
from import_stg_regions