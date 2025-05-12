with import_raw as (
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
        last_status_change_date
    from {{ ref('raw_contracts') }}
),

add_surrogate_key as (
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
        {{ dbt_utils.generate_surrogate_key([
            "contract_number",
            "client_id",
            "product_code",
            "principal_amount",
            "interest_amount",
            "fee_amount",
            "tenor",
            "start_date",
            "status",
            "last_status_change_date"
        ])}} as stg_contracts_sk
    from import_raw
),

deduplication as (
    select
        *
    from add_surrogate_key
    qualify row_number() over (partition by stg_contracts_sk) = 1
)

select * from deduplication 