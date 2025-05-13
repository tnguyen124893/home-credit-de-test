with import_stg_contracts as (
    select
      *
    from {{ ref('stg_contracts') }}
)

select
  contract_number,
  client_id,
  product_code,
  principal_amount,
  interest_amount,
  fee_amount,
  tenor,
  start_date,
  status,
  last_status_change_date,
  dbt_valid_from,
  ifnull(dbt_valid_to, '9999-12-31'::timestamp) as dbt_valid_to
from import_stg_contracts