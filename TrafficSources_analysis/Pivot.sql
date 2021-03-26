--
select
	count(distinct website_session_id) as sessions,
	min(date(created_at)) as week_start,
	week(created_at),
	year(created_at)
from website_sessions
where website_session_id between 100000 and 115000
group by 4,3;

-- COUNT with CASE inside can help to mimick Excel's Pivot.
-- Use GROUP BY to define your row labels, and CASE to pivot to columns
-- Below we want to know number of orders where 1 or 2 items were purchased and total of orders
select
	primary_product_id,
	count(distinct case when items_purchased = 1 then order_id else NULL end) as orders_w_1_item,
	count(distinct case when items_purchased = 2 then order_id else NULL end) as orders_w_2_items,
	count(distinct order_id) as total_orders
from orders
where order_id between 31000 and 32000
group by 1;
