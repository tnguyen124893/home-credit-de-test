{% snapshot snapshot_raw_installments %}

{{
    config(
      target_schema='raw',
      unique_key='installment_id',
      strategy='check',
      check_cols='all'
    )
}}

select * from {{ source('raw', 'raw_installments') }}

{% endsnapshot %}
