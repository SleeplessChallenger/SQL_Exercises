-- bounce pages and landing pages tests

-- 1: find first website_pageview_id for relevant sessions
-- 2: identify the landing page of each session
-- 3: counting pageviews for each session, to identify 'bounces'
-- 4: summarizing total sessions and bounced sessions, by LP

-- find the min website pageview id associated with each session we care about
create temporary table first_pageviews_demo
select
	website_pageviews.website_session_id,
	min(website_pageviews.website_pageview_id) as min_pageview_id
from website_pageviews
	inner join website_sessions
		on website_sessions.website_session_id=website_pageviews.website_session_id
		and website_sessions.created_at between '2014-01-01' and '2014-02-01'
group by website_pageviews.website_session_id;

-- bring in the landing page to each session
create temporary table sessions_w_landing_page_demo
select
	first_pageviews_demo.website_session_id,
	website_pageviews.pageview_url as landing_page
from first_pageviews_demo
	left join website_pageviews
		on website_pageviews.website_pageview_id=first_pageviews_demo.min_pageview_id;

-- count of pageviews per session included

/*One-to-Many as above temp table has one session whilst website_pageviews
can include multiple ones*/
create temporary table bounced_sessions_only
select
	sessions_w_landing_page_demo.website_session_id,
	sessions_w_landing_page_demo.landing_page,
	count(website_pageviews.website_pageview_id) as count_pages_viewed
from sessions_w_landing_page_demo
	left join website_pageviews
		on website_pageviews.website_session_id=sessions_w_landing_page_demo.website_session_id
group by 
	sessions_w_landing_page_demo.website_session_id,
	sessions_w_landing_page_demo.landing_page
having
	count_pages_viewed = 1;


select
	sessions_w_landing_page_demo.landing_page,
	count(distinct sessions_w_landing_page_demo.website_session_id) as sessions,
	count(distinct bounced_sessions_only.website_session_id) as bounced_sessions,
	count(distinct bounced_sessions_only.website_session_id)/count(distinct sessions_w_landing_page_demo.website_session_id) as bounce_rate
from sessions_w_landing_page_demo
	left join bounced_sessions_only
		on sessions_w_landing_page_demo.website_session_id=bounced_sessions_only.website_session_id
group by sessions_w_landing_page_demo.landing_page
order by sessions_w_landing_page_demo.website_session_id;
