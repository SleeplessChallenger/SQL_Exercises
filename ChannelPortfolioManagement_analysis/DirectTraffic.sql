-- pull organic search, direct type in, paid brand search sessions by month
-- + % of paid search nonbrand

select
	min(date(created_at)) as month_year,
	count(case when utm_campaign = 'nonbrand' then website_session_id else NULL end) as nonbrand,
	count(case when utm_campaign = 'brand' then website_session_id else NULL end) as brand,
	count(case when utm_campaign = 'brand' then website_session_id else NULL end)/
	count(case when utm_campaign = 'nonbrand' then website_session_id else NULL end) as br_perc_nonbr,

	count(case when http_referer is NULL and utm_source is NULL then website_session_id else NULL end) as direct,
	count(case when http_referer is NULL and utm_source is NULL then website_session_id else NULL end)/
	count(case when utm_campaign = 'nonbrand' then website_session_id else NULL end) as direct_perc_nonbrand,

	count(case when http_referer is not NULL and utm_source is NULL then website_session_id else NULL end) as organic,
	count(case when http_referer is not NULL and utm_source is NULL then website_session_id else NULL end)/
	count(case when utm_campaign = 'nonbrand' then website_session_id else NULL end) as organic_perc_nonbrand
from website_sessions
where created_at < '2012-12-23'
group by
	month(created_at);

/* roughly equals to below query. In below one I specify in particular which 'http_referer' to use */

select
	min(date(created_at)) as month_year,
	count(distinct case when channel_group = 'paid_nonbrand' then website_session_id else NULL end) as nonbrand,
	count(distinct case when channel_group = 'paid_brand' then website_session_id else NULL end) as brand,
	count(distinct case when channel_group = 'paid_brand' then website_session_id else NULL end)/
	count(distinct case when channel_group = 'paid_nonbrand' then website_session_id else NULL end) as br_perc_nonbr,

	count(distinct case when channel_group = 'direct_type' then website_session_id else NULL end) as direct,
	count(distinct case when channel_group = 'direct_type' then website_session_id else NULL end)/
	count(distinct case when channel_group = 'paid_nonbrand' then website_session_id else NULL end) as direct_perc_nonbrand,

	count(distinct case when channel_group = 'organic_search' then website_session_id else NULL end) as organic,
	count(distinct case when channel_group = 'organic_search' then website_session_id else NULL end)/
	count(distinct case when channel_group = 'paid_nonbrand' then website_session_id else NULL end) as organic_perc_nonbrand
from
	(
	 select
	 	website_session_id,
	 	created_at,
	 	case
	 		when utm_source is NULL and http_referer in ('https://www.gsearch.com', 'https://www.bsearch.com')
	 		then 'organic_search'
	 		when utm_source is NULL and http_referer is NULL then 'direct_type'
	 		when utm_campaign = 'nonbrand' then 'paid_nonbrand'
	 		when utm_campaign = 'brand' then 'paid_brand'
	 	end as channel_group
	 from website_sessions
	 where created_at < '2012-12-23'
	) as inner_table
group by
	month(created_at);
