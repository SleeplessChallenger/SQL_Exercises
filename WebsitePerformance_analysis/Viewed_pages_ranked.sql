-- most-viewed website pages, ranked by session volume
select
	pageview_url,
	count(distinct session.website_session_id) as sessions
from website_pageviews as page
	left join website_sessions as session
		on session.website_session_id=page.website_session_id
where page.created_at < '2012-06-09'
group by pageview_url
order by sessions desc;

select  -- pageviews are better as they're more focused rather than plain sessions
	pageview_url,
	count(distinct website_pageview_id) as PVS
from website_pageviews as page
where page.created_at < '2012-06-09'
group by pageview_url
order by PVS desc;
