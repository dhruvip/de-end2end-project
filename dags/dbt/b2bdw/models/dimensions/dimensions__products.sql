with final as (
    select * from {{ source('staging','raw_products') }}
)
select * from final