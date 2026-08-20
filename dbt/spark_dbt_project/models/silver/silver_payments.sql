{{
  config(
    materialized = 'incremental',
    alias = 'payments',
    unique_key = 'payment_id'
    )
}}

select
    payment_id,
    trip_id,
    customer_id,
    trim(payment_method)                                              as payment_method,
    trim(payment_status)                                              as payment_status,
    amount,
    cast(transaction_time as timestamp)                               as transaction_time,
    cast(last_updated_timestamp as timestamp)                         as last_updated_timestamp,
    current_timestamp()                                               as _dbt_loaded_at
from {{ source('bronze_source', 'payments') }}
{% if is_incremental() %}
  where last_updated_timestamp 
  >= coalesce((select max(last_updated_timestamp) from {{ this }}), '1900-01-01')
{% endif %}