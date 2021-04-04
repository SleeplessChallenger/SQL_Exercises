-- weekly trended session volume & comparision of gsearch to bsearch
select
	min(date(created_at)) as week_start_date,
	count(case when utm_source = 'gsearch' then website_session_id else NULL end) as gsearch_sessions,
	count(case when utm_source = 'bsearch' then website_session_id else NULL end) as bsearch_sessions
from website_sessions
where created_at > '2012-08-22' and created_at < '2012-11-29'
	and utm_campaign = 'nonbrand'
group by
	yearweek(created_at);
