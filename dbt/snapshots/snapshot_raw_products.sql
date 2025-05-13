{% snapshot snapshot_raw_products %}

{{
    config(
      target_schema='raw',
      unique_key='product_code',
      strategy='check',
      check_cols='all'
    )
}}

select * from {{ source('raw', 'raw_products') }}

{% endsnapshot %}
