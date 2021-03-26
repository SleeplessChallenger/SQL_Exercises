-- website_sessions: website_session_id, created_at, user_id, is_repeat_session, utm_source,
-- utm_campaign, utm_content, device_type, http_referer

-- website_pageviews: website_pageview_id, created_at, website_session_id-FK, pageview_url

-- orders: order_id, created_at, website_session_id-FK, user_id, primary_product_id,
-- items_purchased, price_usd, cogs_usd

use mavenfuzzyfactory;

select * 
from website_sessions
where website_session_id between 1000 and 2000;

select 
	utm_content, 
	count(distinct website_session_id) as sessions
from website_sessions
where website_session_id between 1000 and 2000
group by utm_content
order by sessions desc;

select
	a.utm_content,
	count(distinct a.website_session_id) as sessions,
	count(distinct b.order_id) as orders,
	count(distinct b.order_id)/count(distinct a.website_session_id) as session_order_conversion
from website_sessions as a
	left join orders as b
		on b.website_session_id=a.website_session_id
where a.website_session_id between 1000 and 2000
group by a.utm_content
order by sessions desc;
