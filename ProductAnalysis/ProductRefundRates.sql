-- Product refund rates analysis: control for quality and understanding where
-- business may have problems to be addressed for


/* intro */
select
	order_items.order_id,
	order_items.order_item_id,
	order_items.price_usd as price_paid_usd,
	order_items.created_at,

	order_item_refunds.order_item_refund_id,
	order_item_refunds.refund_amount_usd,
	order_item_refunds.created_at
from order_items
	left join order_item_refunds
		on order_item_refunds.order_item_id=order_items.order_item_id
where order_items.order_id in (3489, 32049, 27061);


-- pull monthly product refund rates, by product, and confirm quality issues are now fixed
select
	min(date(order_items.created_at)) as month_date,

	count(distinct case when order_items.product_id = 1 then order_items.order_item_id else NULL end) as p1_orders,

	count(distinct case when order_items.product_id = 1 then order_item_refunds.order_item_id else NULL end)/
	count(distinct case when order_items.product_id = 1 then order_items.order_item_id else NULL end) as p1_refund_rate,

	count(distinct case when order_items.product_id = 2 then order_items.order_item_id else NULL end) as p2_orders,

	count(distinct case when order_items.product_id = 2 then order_item_refunds.order_item_id else NULL end)/
	count(distinct case when order_items.product_id = 2 then order_items.order_item_id else NULL end) as p2_refund_rate,

	count(distinct case when order_items.product_id = 3 then order_items.order_item_id else NULL end) as p3_orders,

	count(distinct case when order_items.product_id = 3 then order_item_refunds.order_item_id else NULL end)/
	count(distinct case when order_items.product_id = 3 then order_items.order_item_id else NULL end) as p3_refund_rate,

	count(distinct case when order_items.product_id = 4 then order_items.order_item_id else NULL end) as p4_orders,

	count(distinct case when order_items.product_id = 4 then order_item_refunds.order_item_id else NULL end)/
	count(case when order_items.product_id = 4 then order_items.order_item_id else NULL end) as p4_refund_rate
from order_items
	left join order_item_refunds
		on order_item_refunds.order_item_id=order_items.order_item_id
where order_items.created_at < '2014-10-15'
group by
	year(order_items.created_at),
	month(order_items.created_at);
