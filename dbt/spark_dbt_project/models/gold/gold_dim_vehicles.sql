{{
  config(
    materialized = 'table',
    alias = 'dim_vehicles',
    file_format = 'delta'
    )
}}

select
    vehicle_id,
    license_plate,
    model,
    vehicle_type,
    make,
    year,
    year(current_date()) - year as vehicle_age,
        case
        when year(current_date()) - year <= 2  then 'New'
        when year(current_date()) - year <= 5  then 'Mid'
        else 'Old'
    end as vehicle_age_segment,
    last_updated_timestamp,
    _dbt_loaded_at
from {{ ref('silver_vehicles') }}