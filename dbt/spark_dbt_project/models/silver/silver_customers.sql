{{ config(
    alias='customers',
    materialized='incremental',
    unique_key='customer_id',
) }}

select
    customer_id,
    concat(initcap(trim(first_name)), ' ', initcap(trim(last_name))) as full_name,
    lower(trim(email))                                               as email,
    regexp_replace(trim(phone_number), '[^0-9]', '')                 as phone_number,
    initcap(trim(city))                                              as city,
    cast(signup_date as date)                                        as signup_date,
    cast(last_updated_timestamp as timestamp)                        as last_updated_timestamp,
    current_timestamp()                                              as _dbt_loaded_at

from {{ source('bronze_source', 'customers') }}
{% if is_incremental() %}
  where last_updated_timestamp 
  >= coalesce((select max(last_updated_timestamp) from {{ this }}), '1900-01-01')
{% endif %}
