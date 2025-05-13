{% snapshot snapshot_raw_product_types %}

{{
    config(
      target_schema='raw',
      unique_key='product_type_id',
      strategy='check',
      check_cols='all'
    )
}}

select * from {{ source('raw', 'raw_product_types') }}

{% endsnapshot %}
