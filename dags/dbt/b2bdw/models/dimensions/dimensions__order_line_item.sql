with final as (
    select * from {{ source('staging','raw_order_line_item') }}
)
select * from final