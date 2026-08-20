{{ config(
    alias='dim_customers',
    materialized='table',
    file_format='delta'
) }}

select
    customer_id,
    full_name,
    email,
    phone_number,
    city,
    signup_date,
    datediff(current_date(), signup_date) as days_since_signup,
    case
        when datediff(current_date(), signup_date) <= 30  then 'New'
        when datediff(current_date(), signup_date) <= 365 then 'Active'
        else 'Veteran'
    end as customer_segment,
    last_updated_timestamp,
    _dbt_loaded_at

from {{ ref('silver_customers') }}