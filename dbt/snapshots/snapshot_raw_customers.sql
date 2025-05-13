{% snapshot snapshot_raw_customers %}

{{
    config(
      target_schema='raw',
      unique_key='client_id',
      strategy='check',
      check_cols='all'
    )
}}

select * from {{ source('raw', 'raw_customers') }}

{% endsnapshot %}