{{
  config(
    materialized = 'table',
    alias = 'fact_payments',
    file_format = 'delta'
    )
}}

select
    payment_id,
    trip_id,
    customer_id,
    payment_method,
    payment_status,
    amount as payment_amount,
    transaction_time,
    last_updated_timestamp,
    _dbt_loaded_at
from {{ ref('silver_payments') }}