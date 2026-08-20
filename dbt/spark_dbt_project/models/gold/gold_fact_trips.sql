{{
  config(
    materialized = 'table',
    alias = 'fact_trips',
    file_format = 'delta'
    )
}}

select 
    trip_id,
    vehicle_id,
    driver_id,
    customer_id,
    start_location,
    end_location,
    trip_start_time,
    trip_end_time,
    datediff(minute, trip_start_time, trip_end_time) as trip_duration_minutes,
    distance_km,
    fare_amount,
    payment_method,
    trip_status,
    last_updated_timestamp,
    _dbt_loaded_at
from {{ ref('silver_trips') }}