-- pull overall paid search bounce rate trended weekly

-- first website_pageview_id
DROP TEMPORARY TABLE IF EXISTS first_pageview;

create temporary table first_pageview
select
	min(website_pageviews.website_pageview_id) as id,
	-- website_pageviews.website_session_id as session,
	website_sessions.website_session_id as session,
	count(website_pageviews.website_pageview_id) as count_pageveiws
from website_pageviews
	inner join website_sessions
		on website_sessions.website_session_id=website_pageviews.website_session_id
		and website_sessions.created_at between '2012-06-01' and '2012-09-01'
		-- to make the upper bound inclusive we need to make one date ahead
		and website_sessions.utm_campaign = 'nonbrand'
		and website_sessions.utm_source = 'gsearch'
group by session;

-- specifying landing pages
DROP TEMPORARY TABLE IF EXISTS landing_pages;

create temporary table landing_pages
select
	first_pageview.session,
	website_pageviews.pageview_url as landing_page,
	website_pageviews.created_at as session_created,
	first_pageview.count_pageveiws
	-- first_pageview.id
from first_pageview
	left join website_pageviews
		on website_pageviews.website_pageview_id=first_pageview.id
where website_pageviews.pageview_url in ('/home', '/lander-1');

-- count pageviews to identify 'bounces' and summarize by week
select
	min(date(session_created)) as week_start_date,
	-- COUNT + CASE is a Pivot method
	count(distinct case when count_pageveiws = 1 then session else NULL end)*1.0/count(distinct session) as bounce_rate,
	count(distinct case when landing_page = '/home' then session else NULL end) as home_session,
	count(distinct case when landing_page = '/lander-1' then session else NULL end) as lander_sessions
from landing_pages
group by
	yearweek(session_created);
