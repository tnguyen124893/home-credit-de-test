with import_stg_customers as (
    select
      *
    from {{ ref('stg_customers') }}
)

select
  client_id,
  client_name,
  region_id,
  join_date,
  credit_score,
  dbt_valid_from,
  ifnull(dbt_valid_to, '9999-12-31'::timestamp) as dbt_valid_to,
  case when dbt_valid_to is null then true else false end as is_latest
from import_stg_customers