-- pull bounce rates for the two groups

-- find the first instance of /lander-1 to set analysis timeframe
select
	created_at as first_created_at,
	min(website_pageview_id) as first_pageview_id
from website_pageviews
where pageview_url = '/lander-1'
group by 1
order by first_created_at asc
limit 1;

/*equals to*/
select 
	min(created_at) as first_created_at,
	min(website_pageview_id) as first_pageview_id
from website_pageviews
where pageview_url = '/lander-1'
	and created_at is not NULL;

-- first website_pageview_id for relevant sessions
DROP TEMPORARY TABLE IF EXISTS first_pageviews;

create temporary table first_pageviews
select
	min(website_pageviews.website_pageview_id) as first_pageview_id,
	website_pageviews.website_session_id
from website_pageviews
	inner join website_sessions
	on website_sessions.website_session_id=website_pageviews.website_session_id
	and website_sessions.created_at between '2012-06-19' and '2012-07-28'
	and website_pageviews.website_pageview_id > 23504
	and website_sessions.utm_campaign = 'nonbrand'
	and website_sessions.utm_source = 'gsearch'
group by website_pageviews.website_session_id;

-- identify landing page for each session
DROP TEMPORARY TABLE IF EXISTS landing_pages;

create temporary table landing_pages
select
	website_pageviews.pageview_url as landing_pages,
	first_pageviews.website_session_id as sessions
from first_pageviews
	left join website_pageviews
		on website_pageviews.website_pageview_id=first_pageviews.first_pageview_id
where website_pageviews.pageview_url in ('/home', '/lander-1');

-- count pageviews
DROP TEMPORARY TABLE IF EXISTS bounces_count;

create temporary table bounces_count
select
	landing_pages.landing_pages as landing,
	landing_pages.sessions as sessions,
	count(distinct website_pageviews.website_pageview_id) as num_views
from landing_pages
	left join website_pageviews
		on website_pageviews.website_session_id=landing_pages.sessions
group by
	landing,
	sessions
having
	num_views = 1;

-- result
select
	landing_pages.landing_pages as landing_page,
	count(distinct landing_pages.sessions) as general_session,
	count(distinct bounces_count.sessions) as bounced_session,
	count(distinct bounces_count.sessions)/count(distinct landing_pages.sessions) as bounce_general_ratio
from landing_pages
	left join bounces_count
		on bounces_count.sessions=landing_pages.sessions
group by landing_page;
