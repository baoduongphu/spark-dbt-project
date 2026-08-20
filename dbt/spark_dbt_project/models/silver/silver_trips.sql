{{
  config(
    materialized = 'incremental',
    alias = 'trips',
    unique_key = 'trip_id',
    )
}}
select
    trip_id,
    driver_id,
    customer_id,
    vehicle_id,
    cast(trip_start_time as timestamp)                                as trip_start_time,
    cast(trip_end_time as timestamp)                                  as trip_end_time,
    initcap(trim(start_location))                                     as start_location,
    initcap(trim(end_location))                                       as end_location,
    distance_km,
    fare_amount,
    trim(payment_method)                                              as payment_method,
    trim(trip_status)                                                 as trip_status,
    cast(last_updated_timestamp as timestamp)                         as last_updated_timestamp,
    current_timestamp()                                               as _dbt_loaded_at
from {{ source('bronze_source', 'trips') }}
{% if is_incremental() %}
  where last_updated_timestamp 
  >= coalesce((select max(last_updated_timestamp) from {{ this }}), '1900-01-01')
{% endif %}
