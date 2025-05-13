{% snapshot snapshot_raw_regions %}

{{
    config(
      target_schema='raw',
      unique_key='region_id',
      strategy='check',
      check_cols='all'
    )
}}

select * from {{ source('raw', 'raw_regions') }}

{% endsnapshot %}
