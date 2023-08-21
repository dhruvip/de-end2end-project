with products as (
    select product_id,
    product_name,
    price,
    created_at as product_listed_at
    from {{ source('staging','raw_products') }}
),
supplier as (
    select sp.*,
    country_code as supplier_country_code
    from 
    {{ ref('dimensions__supplier_products') }} sp 
    left join {{ref("dimensions__suppliers")}} s on sp.supplier_id=s.supplier_id
),
company as (
    select cp.*,
    country_code as company_country_code
    from {{ref('dimensions__company_products')}} cp
    left join {{ref("dimensions__company")}} c on cp.company_id=c.company_id
),
final as (
    select 
    p.product_id,
    coalesce(supplier_id, company_id) as seller_id,
    coalesce(supplier_country_code, company_country_code) as seller_country_code,
    CASE
    WHEN s.supplier_id is null then 0 else 1
    END as is_supplier
    from products p 
    left join supplier s on p.product_id = s.product_id
    left join company c on c.product_id=p.product_id
)
select * from final