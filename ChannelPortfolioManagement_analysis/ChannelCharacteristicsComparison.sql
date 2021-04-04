-- % of traffic coming on Mobile & comparison to gsearch
select
	utm_source,
	count(distinct website_session_id) as sessions,
	count(case when device_type = 'mobile' then website_session_id else NULL end) as mobile_sessions,
	count(case when device_type = 'mobile' then website_session_id else NULL end)/
	count(distinct website_session_id) as mobile_sessions_ratio
from website_sessions
where created_at > '2012-08-22' and created_at < '2012-11-30'
	and utm_campaign = 'nonbrand'
group by
	utm_source;
