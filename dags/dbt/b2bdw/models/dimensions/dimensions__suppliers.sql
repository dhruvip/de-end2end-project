with final as (
    select t.*,
    cc.country_name 
    from {{ source('staging','raw_suppliers') }} t
    left join {{ ref('dimensions__country_codes') }} cc on t.country_code=cc.code        
)
select * from final