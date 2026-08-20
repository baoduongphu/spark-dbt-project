{{
  config(
    materialized = 'table',
    alias = 'dim_locations',
    file_format = 'delta'
    )
}}

select
    location_id,
    city,
    state,
    country,
    latitude,
    longitude,
    last_updated_timestamp,
    _dbt_loaded_at
from {{ ref('silver_locations') }}