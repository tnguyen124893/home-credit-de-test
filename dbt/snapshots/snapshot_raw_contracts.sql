{% snapshot snapshot_raw_contracts %}

{{
    config(
      target_schema='raw',
      unique_key='contract_number',
      strategy='check',
      check_cols='all'
    )
}}

select * from {{ source('raw', 'raw_contracts') }}

{% endsnapshot %}
