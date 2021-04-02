-- Analyze repeat behavior: allows to understand user behavior and identfy
-- some of business most valuable customers

-- datediff() allows to compare the time difference between two dates
-- Ex: datediff(now(), born_on_date); datediff(second_session, first_session);
-- 	   datediff(refund_at, order_at)/7
-- It subtracts the second date from the first date


select
	order_items.order_id,
	order_items.order_item_id,
	order_items.price_usd as price_paid_usd,
	order_items.created_at,

	order_item_refunds.order_item_refund_id,
	order_item_refunds.refund_amount_usd,
	order_item_refunds.created_at,
	datediff(order_item_refunds.created_at, order_items.created_at) as days_order_to_refund

from order_items
	left join order_item_refunds
		on order_item_refunds.order_item_id=order_items.order_item_id
where order_items.order_id in (3489, 32049, 27061);
