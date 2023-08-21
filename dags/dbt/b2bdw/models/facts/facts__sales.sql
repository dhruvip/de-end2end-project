with invoice_details as (
    select invoice_id, 
    buyer_id,
    seller_id,
    amount as final_invoice_amt
    from {{ref('dimensions__invoice')}}
),
oli_details as (
    select order_id,
    invoice_id,
    product_id,
    no_of_items,
    -- final_amount as oli_final_amt,
    created_at as order_created_date 
    from {{ref('dimensions__order_line_item')}}
),
forders as (
    select o.order_id, o.invoice_id, o.payment_status, o.delivery_status,
    oli.product_id, oli.no_of_items, oli.order_created_date,
    i.buyer_id, i.seller_id, i.final_invoice_amt
    from {{ref('dimensions__orders')}} o 
    left join oli_details oli on o.order_id=oli.order_id and o.invoice_id=oli.invoice_id
    left join invoice_details i on o.invoice_id=i.invoice_id
),
seg_buyer_seller as (
    select order_id, invoice_id, payment_status, delivery_status,
    product_id, no_of_items, order_created_date,
    buyer_id, seller_id, final_invoice_amt,
    CASE WHEN buyer_id ilike 'CUST%' THEN 'customer'
        WHEN buyer_id ilike 'COM%' THEN 'company'
    ELSE null END as brought_by,
    CASE WHEN seller_id ilike 'SUP%' THEN 'supplier'
        WHEN seller_id ilike 'COM%' THEN 'company'
    ELSE null END as sold_by
    from forders
),
final as (
    select order_id, 
    invoice_id, 
    payment_status, 
    delivery_status,
    product_id, 
    no_of_items, 
    order_created_date,
    buyer_id, 
    seller_id, 
    final_invoice_amt,
    brought_by,
    sold_by
    from seg_buyer_seller
)

select * from final