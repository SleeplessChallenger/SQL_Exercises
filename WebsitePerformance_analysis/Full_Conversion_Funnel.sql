-- full conversion funnel with analysis of how many customers make it to each step
DROP TEMPORARY TABLE IF EXISTS conversion_funnel;

create temporary table conversion_funnel
select
	all_pages.website_session_id,
	-- max(landers) as landers,
	max(products) as products,
	max(mrfuzzy) as mrfuzzy,
	max(cart) as cart,
	max(shipping) as shipping,
	max(billing) as billing,
	max(thanks) as thanks
from
	(
	select
		website_sessions.website_session_id,
		website_pageviews.pageview_url,
		-- case when pageview_url = '/lander-1' then 1 else 0 end as landers,
		case when pageview_url = '/products' then 1 else 0 end as products,
		case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mrfuzzy,
		case when pageview_url = '/cart' then 1 else 0 end as cart,
		case when pageview_url = '/shipping' then 1 else 0 end as shipping,
		case when pageview_url = '/billing' then 1 else 0 end as billing,
		case when pageview_url = '/thank-you-for-your-order' then 1 else 0 end as thanks
	from website_sessions
		left join website_pageviews
			on website_pageviews.website_session_id=website_sessions.website_session_id
	where website_sessions.created_at > '2012-08-05' and website_sessions.created_at < '2012-09-05'
		and website_sessions.utm_source = 'gsearch'
		and website_sessions.utm_campaign = 'nonbrand'
	order by 
		website_sessions.website_session_id,
		website_pageviews.created_at
	) as all_pages

group by
	website_session_id;

-- number of landers to every page

select
	count(distinct website_session_id) as sessions,
	count(distinct case when products = 1 then website_session_id else NULL end) as to_products,
	count(distinct case when mrfuzzy = 1 then website_session_id else NULL end) as to_mrfuzzy,
	count(distinct case when cart = 1 then website_session_id else NULL end) as to_cart,
	count(distinct case when shipping = 1 then website_session_id else NULL end) as to_shipping,
	count(distinct case when billing = 1 then website_session_id else NULL end) as to_billing,
	count(distinct case when thanks = 1 then website_session_id else NULL end) as to_thanks
from conversion_funnel;


-- conversion funnel from every page

select
	count(distinct case when products = 1 then website_session_id else NULL end)/
	count(distinct website_session_id) as lander_click_rate,

	count(distinct case when mrfuzzy = 1 then website_session_id else NULL end)/
	count(distinct case when products = 1 then website_session_id else NULL end) as products_click_rate,

	count(distinct case when cart = 1 then website_session_id else NULL end)/
	count(distinct case when mrfuzzy = 1 then website_session_id else NULL end) as mr_fuzzy_click_rate,

	count(distinct case when shipping = 1 then website_session_id else NULL end)/
	count(distinct case when cart = 1 then website_session_id else NULL end) as cart_click_rate,

	count(distinct case when billing = 1 then website_session_id else NULL end)/
	count(distinct case when shipping = 1 then website_session_id else NULL end) as shipping_click_rate,

	count(distinct case when thanks = 1 then website_session_id else NULL end)/
	count(distinct case when billing = 1 then website_session_id else NULL end) as billing_click_rate

from conversion_funnel;
