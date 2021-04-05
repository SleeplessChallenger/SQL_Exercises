-- monthly order volume, overall conversion rate, revenue per seesion,
-- breakdown of sales by product

select
	min(date(website_sessions.created_at)) as month_date,
	count(distinct order_id) as orders,
	count(distinct order_id)/count(distinct website_sessions.website_session_id) as conv_rate,
	sum(price_usd)/count(distinct website_sessions.website_session_id) as revenue_per_session,
	count(distinct case when primary_product_id = 1 then order_id else NULL end) as product_one_orders,
	count(distinct case when primary_product_id = 2 then order_id else NULL end) as product_two_orders
from orders
	right join website_sessions
		on website_sessions.website_session_id=orders.website_session_id
where website_sessions.created_at > '2012-04-01'
	and website_sessions.created_at < '2013-04-05'
group by
	year(website_sessions.created_at),
	month(website_sessions.created_at);
