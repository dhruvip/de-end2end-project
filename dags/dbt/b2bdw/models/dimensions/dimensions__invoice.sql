with final as (
    select * from {{ source('staging','raw_invoice') }}
)
select * from final