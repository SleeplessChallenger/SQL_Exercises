-- website_pageviews: website_pageview_id, created_at, website_session_id-FK, pageview_url

use mavenfuzzyfactory;

select 
	pageview_url,
	count(distinct website_pageview_id) as pageviews
from website_pageviews
where website_pageview_id < 1000
group by pageview_url
order by pageviews desc;


create temporary table first_pageview 
select
	website_session_id,
	min(website_pageview_id) as min_PV_id
from website_pageviews
where website_pageview_id < 1000
group by website_session_id;

select
	count(distinct first_pageview.website_session_id) as sessions_hitting_this_lander,
	website_pageviews.pageview_url as land_page
from first_pageview
	left join website_pageviews
		on website_pageviews.website_pageview_id=first_pageview.min_PV_id
group by land_page;
