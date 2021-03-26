-- conversion rate from session to order with at least 4% CVR
select
	count(distinct a.website_session_id) as sessions,
	count(distinct b.order_id) as orders,
	count(distinct b.order_id)/count(distinct a.website_session_id) as session_order_conversion
from website_sessions as a
	left join orders as b
		on b.website_session_id=a.website_session_id
where a.created_at < '2012-04-14' and a.utm_source = 'gsearch'
	and utm_campaign = 'nonbrand';
