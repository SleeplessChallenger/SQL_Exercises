-- Product-focused website analysis: learning how customers interact with each of your
-- products, and how well each product converts customers

select
	-- website_session_id,
	pageview_url,
	count(distinct website_pageviews.website_session_id) as sessions,
	count(distinct orders.order_id) as orders,
	count(distinct orders.order_id)/
	count(distinct website_pageviews.website_session_id) as viewed_product_order_rate
from website_pageviews
	left join orders
		on orders.website_session_id=website_pageviews.website_session_id
where website_pageviews.created_at between '2013-02-01' and '2013-03-01'
	and pageview_url in ('/the-original-mr-fuzzy', '/the-forever-love-bear')
group by 1;
