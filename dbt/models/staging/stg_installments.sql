with import_raw as (
    select
        installment_id,
        contract_number,
        installment_number,
        due_date,
        inst_amt_principal,
        inst_amt_interest,
        inst_amt_fee,
        status
    from {{ source('raw', 'raw_installments') }}
),

add_surrogate_key as (
    select
        installment_id,
        contract_number,
        installment_number,
        due_date,
        inst_amt_principal,
        inst_amt_interest,
        inst_amt_fee,
        status,
        {{ dbt_utils.generate_surrogate_key([
            "installment_id",
            "contract_number",
            "installment_number",
            "due_date",
            "inst_amt_principal",
            "inst_amt_interest",
            "inst_amt_fee",
            "status"
        ])}} as stg_installments_sk
    from import_raw
),

deduplication as (
    select
        *
    from add_surrogate_key
    qualify row_number() over (partition by stg_installments_sk) = 1
)

select * from deduplication 