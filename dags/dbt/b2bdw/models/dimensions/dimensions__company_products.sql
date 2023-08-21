with final as (
    select * from {{ source('staging','raw_company_products') }}
)
select * from final