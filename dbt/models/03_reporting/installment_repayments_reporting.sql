with import_dim_installments as (
    select
        *
    from {{ ref('dim_installments') }}
    where 1=1
    and is_latest = true
     
),

import_fct_repayments as (
    select
        *
    from {{ ref('fct_repayments') }}
),

import_dim_contracts as (
    select
        *
    from {{ ref('dim_contracts') }}
    where 1=1
    and is_latest = true
    -- if requirements dictate that we need Point-in-time attributes this filter will be removed
    -- and SCD Type-2 dims will be merged
),

import_dim_products as (
    select
        *
    from {{ ref('dim_products') }}
    where 1=1
    and is_latest = true
    -- if requirements dictate that we need Point-in-time attributes this filter will be removed
    -- and SCD Type-2 dims will be merged
),

import_dim_product_types as (
    select
        *
    from {{ ref('dim_product_types') }}
    where 1=1
    and is_latest = true
    -- if requirements dictate that we need Point-in-time attributes this filter will be removed
    -- and SCD Type-2 dims will be merged
),

import_dim_regions as (
    select
        *
    from {{ ref('dim_regions') }}
    where 1=1
    and is_latest = true
    -- if requirements dictate that we need Point-in-time attributes this filter will be removed
    -- and SCD Type-2 dims will be merged
),

import_dim_customers as (
    select
        *
    from {{ ref('dim_customers') }}
    where 1=1
    and is_latest = true
    -- if requirements dictate that we need Point-in-time attributes this filter will be removed
    -- and SCD Type-2 dims will be merged
),

agg_fct_repayments as (
    select
        installment_id,
        sum(repayment_amount) as repayment_amount,
        max(repayment_date) as last_repayment_date
    from import_fct_repayments
    group by all
),

join_dim_fct_models as (
    select
        import_dim_installments.installment_id,
        import_dim_contracts.contract_number,
        import_dim_contracts.principal_amount as contract_principal_amount,
        import_dim_contracts.interest_amount as contract_interest_amount,
        import_dim_contracts.fee_amount as contract_fee_amount,
        (import_dim_contracts.principal_amount+import_dim_contracts.interest_amount+import_dim_contracts.fee_amount) as contract_total_amount,
        import_dim_contracts.tenor as contract_tenor,
        import_dim_contracts.status as contract_status,
        import_dim_contracts.last_status_change_date as contract_last_status_change_date,
        import_dim_contracts.start_date as contract_start_date,
        import_dim_products.product_name,
        import_dim_products.active_flag as product_is_active,
        import_dim_product_types.product_type_name,
        import_dim_customers.client_name,
        import_dim_customers.join_date as client_join_date,
        import_dim_customers.credit_score as client_credit_score,
        import_dim_regions.region_name as client_region_name,
        import_dim_installments.installment_number,
        import_dim_installments.due_date as installment_due_date,
        import_dim_installments.inst_amt_principal as installment_principal_amount,
        import_dim_installments.inst_amt_interest as installment_interest_amount,
        import_dim_installments.inst_amt_fee as installment_fee_amount,
        import_dim_installments.status as installment_status,
        agg_fct_repayments.last_repayment_date as installment_last_repayment_date,
        coalesce(agg_fct_repayments.repayment_amount, 0) as installment_repayment_amount

    from import_dim_installments
    left join agg_fct_repayments on import_dim_installments.installment_id = agg_fct_repayments.installment_id
    left join import_dim_contracts on import_dim_installments.contract_number = import_dim_contracts.contract_number
    left join import_dim_customers on import_dim_contracts.client_id = import_dim_customers.client_id
    left join import_dim_regions on import_dim_customers.region_id = import_dim_regions.region_id
    left join import_dim_products on import_dim_contracts.product_code = import_dim_products.product_code
    left join import_dim_product_types on import_dim_products.product_type_id = import_dim_product_types.product_type_id
),


add_new_columns_flag as (
    select
        *,
        case
            when current_date() >= installment_due_date
            then case
                    when installment_last_repayment_date is not null
                    then case
                            when installment_last_repayment_date <= installment_due_date
                            then 0
                            else 1
                            end
                    else 1
                    end
            else 0
            end as installment_is_repayment_overdue,
        case
            when installment_status = 'Paid'
            then 1 
            else 0 
            end as installment_is_repayment_full_paid,
        case
            when installment_status = 'Partially paid' 
            then 1 
            else 0 
            end as installment_is_repayment_partial_paid,
        case
            when installment_status = 'Non-paid'
            then 1 
            else 0 
            end as installment_is_repayment_non_paid
    from join_dim_fct_models
),

add_new_column_overdue_days as (
    select
        *,
        case
            when installment_is_repayment_overdue = 1
            then coalesce(installment_last_repayment_date, current_date()) - installment_due_date
            else 0
            end as installment_overdue_days
    from add_new_columns_flag
)

select * from add_new_column_overdue_days