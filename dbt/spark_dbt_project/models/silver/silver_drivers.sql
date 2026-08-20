{{
  config(
    materialized = 'incremental',
    unique_key = 'driver_id',
    alias = 'drivers',
    )
}}

select
    driver_id,
    concat(initcap(trim(first_name)), ' ', initcap(trim(last_name))) as full_name,
    regexp_replace(trim(phone_number), '[^0-9]', '')                 as phone_number,
    vehicle_id,
    cast(driver_rating as decimal(3, 2))                             as driver_rating,
    initcap(trim(city))                                              as city,
    cast(last_updated_timestamp as timestamp)                        as last_updated_timestamp,
    current_timestamp()                                              as _dbt_loaded_at

from {{ source('bronze_source', 'drivers') }}
{% if is_incremental() %}
  where last_updated_timestamp 
  >= coalesce((select max(last_updated_timestamp) from {{ this }}), '1900-01-01')
{% endif %}