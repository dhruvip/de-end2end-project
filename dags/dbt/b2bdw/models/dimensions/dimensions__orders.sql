with final as (
    select * from {{ source('staging','raw_orders') }}
)
select * from final