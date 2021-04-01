-- pull entry pages and rank them on entry volume
DROP TEMPORARY TABLE IF EXISTS temp;

create temporary table temp
select
	website_session_id,
	min(website_pageview_id) as pvs
from website_pageviews
where created_at < '2012-06-12'
group by website_session_id;

select
	website_pageviews.pageview_url as landing_page,
	count(distinct temp.website_session_id) as sessions_hitting
from temp
	left join website_pageviews
		on website_pageviews.website_pageview_id=temp.pvs
group by landing_page;
/*One session (aka a "visit" from a user to a website) can contain multiple pageviews*/
