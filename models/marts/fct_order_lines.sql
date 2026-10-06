with line_items as (

    select * from {{ ref('stg_line_items') }}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

joined as (

    select
        -- surrogate key for the grain: one row per order line
        line_items.order_id || '-' || line_items.line_number
                                          as order_line_id,

        -- foreign keys
        line_items.order_id,
        line_items.line_number,
        orders.customer_id,
        line_items.part_id,
        line_items.supplier_id,

        -- dates
        orders.ordered_at,
        line_items.shipped_at,
        line_items.committed_at,
        line_items.received_at,

        -- attributes
        orders.order_status,
        orders.order_priority,
        line_items.return_flag,
        line_items.line_status,
        line_items.ship_mode,

        -- measures
        line_items.quantity,
        line_items.extended_price                  as gross_revenue,
        line_items.discount_rate,
        line_items.extended_price
            * line_items.discount_rate             as discount_amount,
        line_items.extended_price
            * (1 - line_items.discount_rate)       as net_revenue,
        line_items.tax_rate,
        line_items.extended_price
            * (1 - line_items.discount_rate)
            * line_items.tax_rate                  as tax_amount,
        line_items.extended_price
            * (1 - line_items.discount_rate)
            * (1 + line_items.tax_rate)            as net_revenue_with_tax

    from line_items
    inner join orders
        on line_items.order_id = orders.order_id

)

select * from joined
