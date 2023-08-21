with final as (
    select * from {{ source('staging','raw_marketing_leads') }}
)
select * from final