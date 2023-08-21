with events as (
    select ip as customer_ip,
    username as customer_uname,
    tstamp as first_contact_at,
    statuscode as status_code,
    refr_path as url_path,
    uagent as browser
    from {{ref('dimensions__events')}}
),
customer as (
    select username,
    customer_id,
    country_code
    from {{ref('dimensions__customers')}}
),
prod_seller_details as (
    select     product_id,
    seller_id,
    seller_country_code,
    is_supplier
    from {{ref('dimensions__products_meta')}}
),
final as (
    select e.*,
    c.customer_id,
    c.country_code as customer_country_code,
    ps.product_id,
    ps.seller_id,
    ps.seller_country_code
    from events e 
    left join customer c on e.customer_uname=c.username
    left join prod_seller_details ps on e.url_path LIKE '%'||ps.product_id||'%'
)
select  *
from final 