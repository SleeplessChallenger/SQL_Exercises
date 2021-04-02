-- comparison of conversion rates and revenue per session
-- for repeat sessions vs new sessions

select
	is_repeat_session,
	count(distinct website_sessions.website_session_id) as sessions,
	count(distinct order_id)/count(distinct website_sessions.website_session_id) as conv_rate,
	sum(price_usd)/count(distinct website_sessions.website_session_id) as revenue_per_session
from website_sessions
	left join orders
		on orders.website_session_id=website_sessions.website_session_id
where website_sessions.created_at >= '2014-01-01'
	and website_sessions.created_at < '2014-11-08'
group by 1;
