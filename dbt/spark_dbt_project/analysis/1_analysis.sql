select 
    t.trip_id,
    t.customer_id,
    t.fare_amount,
    p.amount
from {{ ref('silver_trips') }} as t
inner join {{ ref('silver_payments') }} as p
on t.trip_id = p.trip_id