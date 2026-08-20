{{ config(
    alias='dim_drivers',
    materialized='table',
    file_format='delta'
) }}

select
    driver_id,
    full_name,
    phone_number,
    vehicle_id,
    city,
    driver_rating,
    case
        when driver_rating >= 4.5 then 'Top'
        when driver_rating >= 4.0 then 'Good'
        when driver_rating >= 3.5 then 'Average'
        else 'Low'
    end as rating_segment,
    last_updated_timestamp,
    _dbt_loaded_at

from {{ ref('silver_drivers') }}