with final as (
    select com.*,
    cc.country_name 
    from {{ source('staging','raw_company') }} com
    left join {{ ref('dimensions__country_codes') }} cc on com.country_code=cc.code
)
select * from final