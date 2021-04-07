-- pre-post analysis comparing the month before vs the month after
-- in regard to session-to-order conversion rate, AOV, products per order, revenue per session

select
	CASE
		when website_sessions.created_at >= '2013-12-12' then 'post_third_product'
		when website_sessions.created_at < '2013-12-12' then 'pre_third_product'
	 	else 'Error'
	end as time_period,
	count(distinct order_id)/count(distinct website_sessions.website_session_id) as conv_rate,
	sum(price_usd) as total_revenue,
	sum(items_purchased) as total_products_sold,
	sum(price_usd)/count(distinct order_id) as average_order_value,
	sum(items_purchased)/sum(case when order_id is not NULL then 1 else 0 end) as products_per_order,
	sum(price_usd)/count(distinct website_sessions.website_session_id) as revenue_per_session
from website_sessions
	left join orders
		on orders.website_session_id=website_sessions.website_session_id
where website_sessions.created_at > '2013-11-12'
	and website_sessions.created_at < '2014-01-12'
group by 
	CASE
		when website_sessions.created_at >= '2013-12-12' then 'post_third_product'
		when website_sessions.created_at < '2013-12-12' then 'pre_third_product'
	 	else 'Error'
	end;
