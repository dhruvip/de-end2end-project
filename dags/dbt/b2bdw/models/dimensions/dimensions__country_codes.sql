with final as (
    select * from {{ source('staging','raw_country_codes') }}
)
select * from final