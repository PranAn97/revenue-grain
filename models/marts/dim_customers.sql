with customers as (

    select * from {{ ref('stg_customers') }}

),

nations as (

    select * from {{ ref('stg_nations') }}

),

regions as (

    select * from {{ ref('stg_regions') }}

),

joined as (

    select
        customers.customer_id,
        customers.customer_name,
        customers.market_segment,
        customers.account_balance,
        nations.nation_id,
        nations.nation_name,
        regions.region_id,
        regions.region_name

    from customers
    left join nations
        on customers.nation_id = nations.nation_id
    left join regions
        on nations.region_id = regions.region_id

)

select * from joined
