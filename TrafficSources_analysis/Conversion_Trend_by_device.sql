-- conversion rates from session to order by device type
select
	device_type,
	count(distinct web.website_session_id) as sessions,
	count(distinct ord.order_id) as orders,
	count(distinct ord.order_id)/count(distinct web.website_session_id) as session_order_conv
from website_sessions as web
	left join orders as ord
		on ord.website_session_id=web.website_session_id
where web.created_at < '2012-05-11'
	and web.utm_campaign = 'nonbrand'
	and web.utm_source = 'gsearch'
group by device_type;

-- weekly trends for both desktop and mobile
select
	min(date(web.created_at)) as week_start_date,
	count(distinct case when web.device_type = 'desktop' then web.website_session_id else NULL end) as dtop_sessions,
	count(distinct case when web.device_type = 'mobile' then web.website_session_id else NULL end) as mob_sessions
from website_sessions as web
where web.created_at < '2012-06-09'
	and web.created_at > '2012-05-19'
	and web.utm_source = 'gsearch'
	and web.utm_campaign = 'nonbrand'
group by yearweek(web.created_at);
