-- what % of sessions on those pages end up placing an order (/billing-2 vs /billing)

-- find when '/billing-2' was seen for the first time

select
	date(min(created_at)) as first_created_at,
	min(website_pageview_id)
from website_pageviews
where pageview_url = '/billing-2'
group by yearweek(created_at)
order by first_created_at asc;

-- from previous we got that '2012-09-23' is the first time '/billing-2' appeared
DROP TEMPORARY TABLE IF EXISTS billing_funnel;

create temporary table billing_funnel
select
	bill_variations.pageview_url,
	count(distinct bill_variations.website_session_id) as sessions,
	count(distinct bill_variations.order_id) as orders,
	count(distinct bill_variations.order_id)/count(distinct bill_variations.website_session_id) as billing_to_order_rate
from
	(
	-- if no JOIN between billing and order -> NULL will appear
	select
		website_pageviews.website_session_id,
		website_pageviews.pageview_url,
		orders.order_id
	from website_pageviews
		left join orders
			on orders.website_session_id=website_pageviews.website_session_id
	where website_pageviews.created_at > '2012-09-23' and website_pageviews.created_at < '2012-11-10'
			-- and website_pageviews.website_pageview_id >= 53550
		and website_pageviews.pageview_url in ('/billing', '/billing-2')
	) as bill_variations
group by bill_variations.pageview_url;

select *
from billing_funnel;
