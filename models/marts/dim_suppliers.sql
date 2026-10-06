with suppliers as (

    select * from {{ ref('stg_suppliers') }}

),

nations as (

    select * from {{ ref('stg_nations') }}

),

regions as (

    select * from {{ ref('stg_regions') }}

),

joined as (

    select
        suppliers.supplier_id,
        suppliers.supplier_name,
        suppliers.account_balance,
        nations.nation_id,
        nations.nation_name,
        regions.region_id,
        regions.region_name

    from suppliers
    left join nations
        on suppliers.nation_id = nations.nation_id
    left join regions
        on nations.region_id = regions.region_id

)

select * from joined
