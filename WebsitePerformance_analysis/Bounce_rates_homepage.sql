-- bounce rates for traffic landing on the homepage

-- for every session I'll find first website_pageview_id as every session may have plethora of views
DROP TEMPORARY TABLE IF EXISTS first_pageviews;

create temporary table first_pageviews
select
	a.website_session_id,
	min(a.website_pageview_id) as view
from website_pageviews as a
where a.created_at < '2012-06-14'
group by a.website_session_id;

-- then identify the landing page for each session
DROP TEMPORARY TABLE IF EXISTS session_landing;

create temporary table session_landing
select
	r.pageview_url as landing_page,
	l.website_session_id as sessions
from first_pageviews as l
	left join website_pageviews as r
		on r.website_pageview_id=l.view
where r.pageview_url='/home';


-- now let's count pageviews per session
DROP TEMPORARY TABLE IF EXISTS bounced_sessions;

create temporary table bounced_sessions
select
	landing.landing_page as land,
	landing.sessions as session,
	count(distinct views.website_pageview_id) as num_views
from session_landing as landing
	left join website_pageviews as views
		on views.website_session_id=landing.sessions
group by
	landing.landing_page,
	landing.sessions
-- limit to those customers who have only 1 pageview
having
	num_views=1;
/*bounced session - session when user saw landing page and had no other views*/


select
	session_landing.landing_page,
	count(distinct session_landing.sessions) as num_sessions,
	count(distinct bounced_sessions.session) as num_bounce_sessions,
	count(distinct bounced_sessions.session)/count(distinct session_landing.sessions) as bounce_session_ration
from session_landing
	left join bounced_sessions
		on bounced_sessions.session=session_landing.sessions
group by session_landing.landing_page;
