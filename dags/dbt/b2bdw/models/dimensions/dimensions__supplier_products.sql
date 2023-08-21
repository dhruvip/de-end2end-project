with final as (
    select * from {{ source('staging','raw_supplier_products') }}
)
select * from final