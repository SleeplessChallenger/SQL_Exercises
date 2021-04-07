-- compare the month before vs the month after the change

-- CTR from the '/cart' page, AVG products per Order, AOV,
-- overall revenue per '/cart' page view


-- relevant '/cart' pageviews & pertinent sessions
DROP TEMPORARY TABLE IF EXISTS cross_sell;

create temporary table cross_sell
select
	website_pageview_id,
	website_session_id,
	CASE
		when created_at >= '2013-09-25' then 'post_cross_sell'
		when created_at < '2013-09-25' then 'pre_cross_sell'
		else 'Error'
	end as time_period
from website_pageviews
where created_at > '2013-08-25'
	and created_at < '2013-10-25'
	and pageview_url = '/cart';

-- check which '/cart' sessions reached another page
DROP TEMPORARY TABLE IF EXISTS ship_views;

create temporary table ship_views
select
	cross_sell.website_session_id,
	cross_sell.time_period,
	min(website_pageviews.website_pageview_id) as min_pageview
from cross_sell
	left join website_pageviews
		on website_pageviews.website_session_id=cross_sell.website_session_id
		and website_pageviews.website_pageview_id > cross_sell.website_pageview_id
		-- and website_pageviews.pageview_url = '/shipping'
group by 1,2
having
	min_pageview is not NULL;
-- so as to disect the ones who abandoned after '/cart'



-- find orders which are associated with above '/cart' sessions
DROP TEMPORARY TABLE IF EXISTS pre_post_sessions_orders;

create temporary table pre_post_sessions_orders
select
	orders.order_id,
	cross_sell.website_session_id,
	orders.items_purchased,
	orders.price_usd
from cross_sell
	inner join orders
		on orders.website_session_id=cross_sell.website_session_id;

-- final
select
	time_period,
	count(distinct website_session_id) as cart_sessions,
	sum(clicked_to_another_page) as clickthorugh,
	sum(clicked_to_another_page)/count(distinct website_session_id) as cart_clickthorugh_rate,
	sum(items_purchased)/sum(placed_order) as products_per_order,
	sum(price_usd)/sum(placed_order) as AOV,
	sum(price_usd)/count(distinct website_session_id) as revenue_per_cart_session
from
	(
	select
		cross_sell.time_period,
		cross_sell.website_session_id,
		(case when ship_views.website_session_id is NULL then 0 else 1 end) as clicked_to_another_page,
		(case when pre_post_sessions_orders.order_id is NULL then 0 else 1 end) as placed_order,
		pre_post_sessions_orders.items_purchased,
		pre_post_sessions_orders.price_usd
	from cross_sell
		left join ship_views
			on ship_views.website_session_id=cross_sell.website_session_id
		left join pre_post_sessions_orders
			on pre_post_sessions_orders.website_session_id=cross_sell.website_session_id
	order by
		cross_sell.website_session_id
	) as inner_table
group by 1;
