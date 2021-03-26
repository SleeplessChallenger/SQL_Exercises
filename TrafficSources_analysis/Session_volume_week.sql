-- gsearch nonbrand trended session volme by week
select 
	date_format(web.created_at, '%Y-%m-%d') as week_start_date,
	count(distinct web.website_session_id) as sessions
from website_sessions as web
where web.created_at < '2012-05-10' and web.utm_source = 'gsearch'
	and web.utm_campaign = 'nonbrand'
group by week_start_date
order by week_start_date asc;

select 
	min(date(web.created_at)) as week_start_date,
	count(distinct web.website_session_id) as sessions
from website_sessions as web
where web.created_at < '2012-05-10' and web.utm_source = 'gsearch'
	and web.utm_campaign = 'nonbrand'
group by year(web.created_at), week(web.created_at);
/* yearweek() can be used*/
