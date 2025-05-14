{{
  config(
    materialized = 'incremental',
    unique_key = 'repayment_id',
    )
}}

with import_stg_repayments as (
    select
        *
    from {{ ref('stg_repayments') }}
)

select
    repayment_id,
    installment_id,
    repayment_date,
    repayment_amount
from import_stg_repayments
where 1=1
{% if is_incremental() %}
and repayment_date >= coalesce((select max(repayment_date) - {{ var('backfill_days') }} from {{ this }}), '1900-01-01')
{% endif %}