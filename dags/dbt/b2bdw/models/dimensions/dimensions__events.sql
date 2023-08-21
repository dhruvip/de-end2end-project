with final as (
    select * from {{ source('staging','raw_events') }}
)
select * from final