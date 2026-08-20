{{
  config(
    materialized = 'incremental',
    unique_key = 'vehicle_id',
    alias = 'vehicles',
    )
}}

select
    vehicle_id,
    upper(trim(license_plate))                    as license_plate,
    initcap(trim(model))                          as model,
    replace(initcap(trim(make)), ' And ', ', ')   as make,
    cast(year as int)                             as year,
    initcap(trim(vehicle_type))                   as vehicle_type,
    cast(last_updated_timestamp as timestamp)     as last_updated_timestamp,
    current_timestamp()                           as _dbt_loaded_at

from {{ source('bronze_source', 'vehicles') }}
{% if is_incremental() %}
  where last_updated_timestamp 
  >= coalesce((select max(last_updated_timestamp) from {{ this }}), '1900-01-01')
{% endif %}