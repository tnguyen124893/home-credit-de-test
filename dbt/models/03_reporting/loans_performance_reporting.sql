with import_installment_repayments_reporting as (
    select
        *
    from {{ ref('installment_repayments_reporting') }}
),

agg_installment_repayments_reporting as (
    select
        contract_number,
        contract_principal_amount,
        contract_fee_amount,
        contract_total_amount,
        contract_tenor,
        contract_status,
        contract_last_status_change_date,
        contract_start_date,
        product_name,
        product_is_active,
        product_type_name,
        client_name,
        client_region_name,
        client_join_date,
        client_credit_score,
        sum(installment_is_repayment_overdue) as contract_count_overdue_repayments,
        count(installment_id) - sum(installment_is_repayment_overdue) as contract_count_due_repayments,
        sum(case when installment_is_repayment_overdue = 1 and installment_is_repayment_full_paid = 1 then 1 else 0 end) as contract_count_overdue_full_paid_repayments,
        sum(case when installment_is_repayment_overdue = 1 and installment_is_repayment_partial_paid = 1 then 1 else 0 end) as contract_count_overdue_partial_paid_repayments,
        sum(case when installment_is_repayment_overdue = 1 and installment_is_repayment_non_paid = 1 then 1 else 0 end) as contract_count_overdue_non_paid_repayments,
        {% for day in [30, 60, 90] %}
          sum(case when installment_is_repayment_overdue = 1 and installment_overdue_days >= {{day}} then 1 else 0 end) as contract_count_overdue_repayments_past_{{day}}_days,
        {% endfor %}
    from import_installment_repayments_reporting
    group by all
)

select * from agg_installment_repayments_reporting