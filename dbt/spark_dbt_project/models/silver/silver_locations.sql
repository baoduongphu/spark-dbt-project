{{
  config(
    materialized = 'incremental',
    alias = 'locations',
    unique_key = 'location_id',
    )
}}

select
    location_id,
    initcap(trim(city))                           as city,
    initcap(trim(state))                          as state,
    initcap(trim(country))                        as country,
    latitude,
    longitude,
    cast(last_updated_timestamp as timestamp)     as last_updated_timestamp,
    current_timestamp()                           as _dbt_loaded_at

from {{ source('bronze_source', 'locations') }}
{% if is_incremental() %}
  where last_updated_timestamp 
  >= coalesce((select max(last_updated_timestamp) from {{ this }}), '1900-01-01')
{% endif %}
