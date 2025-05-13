with import_stg_installments as (
    select
        *
    from {{ ref('stg_installments') }}
)

select
  installment_id,
  contract_number,
  installment_number,
  due_date,
  inst_amt_principal,
  inst_amt_interest,
  inst_amt_fee,
  status,
  dbt_valid_from,
  ifnull(dbt_valid_to, '9999-12-31'::timestamp) as dbt_valid_to
from import_stg_installments