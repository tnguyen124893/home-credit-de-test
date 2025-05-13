with import_raw as (
    select
        *
    from {{ source('raw', 'raw_repayments') }}
),

add_surrogate_key as (
    select
        repayment_id,
        installment_id,
        repayment_date,
        repayment_amount,
        {{ dbt_utils.generate_surrogate_key([
            "repayment_id",
            "installment_id",
            "repayment_date",
            "repayment_amount"
        ])}} as stg_repayments_sk
    from import_raw
),

deduplication as (
    select
        *
    from add_surrogate_key
    qualify row_number() over (partition by stg_repayments_sk) = 1
)

select * from deduplication 