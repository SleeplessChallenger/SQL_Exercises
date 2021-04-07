-- Cross selling analysis: understanding which products users are most 
-- likely to purchase together, and offering smart product recommendations


select
	count(distinct orders.order_id) as orders,
	orders.primary_product_id,
	count(distinct case when order_items.product_id = 1 then
			orders.order_id else NULL end) as cross_sell_product1,
	count(distinct case when order_items.product_id = 2 then
			orders.order_id else NULL end) as cross_sell_product2,	
	count(distinct case when order_items.product_id = 3 then
		orders.order_id else NULL end) as cross_sell_product3
from orders
	left join order_items
		on order_items.order_id=orders.order_id
		and order_items.is_primary_item = 0 -- cross sell only
where orders.order_id between 10000 and 11000
group by 2;
