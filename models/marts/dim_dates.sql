with date_spine as (

    select
        cast(range as date) as date_day
    from range(
        date '1990-01-01',
        date '2000-12-31',
        interval 1 day
    )

),

final as (

    select
        date_day,
        extract(year    from date_day)    as calendar_year,
        extract(quarter from date_day)    as calendar_quarter,
        extract(month   from date_day)    as calendar_month,
        extract(day     from date_day)    as day_of_month,
        extract(dayofweek from date_day)  as day_of_week,
        strftime(date_day, '%Y-%m')       as year_month,
        date_trunc('month',   date_day)   as month_start_date,
        date_trunc('quarter', date_day)   as quarter_start_date,
        case when extract(dayofweek from date_day) in (0, 6)
             then true else false
        end                               as is_weekend

    from date_spine

)

select * from final
