-- nonbrand conversion rates from session to order for gsearch & bsearch
-- + slice by device_type

select
	device_type,
	utm_source,
	count(distinct website_sessions.website_session_id) as sessions,
	count(distinct orders.order_id) as orders,
	count(distinct orders.order_id)/
	count(distinct website_sessions.website_session_id) as conversion_rate
from website_sessions
	left join orders
		on orders.website_session_id=website_sessions.website_session_id
where website_sessions.created_at > '2012-08-22' and website_sessions.created_at < '2012-09-18'
	and utm_campaign = 'nonbrand'
	and utm_source in ('gsearch', 'bsearch')
group by
	1,2;
