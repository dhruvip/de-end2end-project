with leads as (
    select     lead_id,
    uname as username,
    first_contact_date,
    campaign_channel,
    campaign_name,
    order_id,
    product_id
    from {{ref('dimensions__mkt_leads')}}
),
customer as (
    select customer_id,
    username,
    country_code as customer_country_code
    from {{ref('dimensions__customers')}}
),
sellers as (
    select     
    product_id,
    seller_id,
    seller_country_code,
    is_supplier
    from {{ref('dimensions__products_meta')}}
),
oli as (
    select oli.invoice_id,
    oli.order_id,
    oli.final_amount,
    oli.created_at as order_created_at,
    oli.product_id,
    delivery_status,
    payment_status
    from {{ref('dimensions__order_line_item')}} oli 
    left join {{ref('dimensions__orders')}} o on o.order_id=oli.order_id
    left join {{ref('dimensions__invoice')}} i on i.invoice_id=oli.invoice_id
),
final as (
    select l.*,
    c.customer_id,
    c.customer_country_code,
    s.seller_id,
    s.seller_country_code,
    s.is_supplier,
    oli.invoice_id,
    oli.final_amount,
    oli.order_created_at,
    oli.delivery_status,
    oli.payment_status
    from leads l 
    left join customer c on c.username=l.username 
    left join sellers s on s.product_id=l.product_id
    left join oli on oli.order_id=l.order_id
)
select * from final