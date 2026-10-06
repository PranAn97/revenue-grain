select
    order_line_id,
    gross_revenue,
    net_revenue
from {{ ref('fct_order_lines') }}
where net_revenue < 0
   or net_revenue > gross_revenue
