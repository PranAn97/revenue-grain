with fact as (

    select sum(net_revenue) as total
    from {{ ref('fct_order_lines') }}

),

source as (

    select sum(l_extendedprice * (1 - l_discount)) as total
    from {{ source('tpch', 'lineitem') }}

)

select
    fact.total   as fact_total,
    source.total as source_total
from fact
cross join source
where abs(fact.total - source.total) > 0.01
