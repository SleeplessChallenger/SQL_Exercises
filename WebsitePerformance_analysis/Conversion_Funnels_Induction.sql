-- Conversion funnels
DROP TEMPORARY TABLE IF EXISTS session_level_made_it_flags;

create temporary table session_level_made_it_flags

select
	website_session_id,
	max(products_page) as product_made_it,
	max(mrfuzzy_page) as mrfuzzy_made_it,
	max(cart_page) as cart_made_it
from
	(
		select
			website_sessions.website_session_id,
			website_pageviews.pageview_url,
			-- website_pageviews.created_at as pageview_created_at,
			case when pageview_url = '/products' then 1 else 0 end as products_page,
			case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mrfuzzy_page,
			case when pageview_url = '/cart' then 1 else 0 end as cart_page
		from website_sessions
			left join website_pageviews
				on website_pageviews.website_session_id=website_sessions.website_session_id
		where website_sessions.created_at between '2014-01-01' and '2014-02-01'
			and website_pageviews.pageview_url in ('/lander-2', '/products',
													'/the-original-mr-fuzzy', '/cart')
		order by
			website_sessions.website_session_id,
			website_pageviews.created_at
	) as pageview_level
group by
	website_session_id;

select
	count(distinct website_session_id) as sessions,
	count(distinct case when product_made_it = 1 then website_session_id else NULL end) as to_products,
	count(distinct case when mrfuzzy_made_it = 1 then website_session_id else NULL end) as to_mrfuzzy,
	count(distinct case when cart_made_it = 1 then website_session_id else NULL end) as to_cart
from session_level_made_it_flags;

-- next, translate those counts from above into click rates by dividing
-- from product by total_sessions to cart by mrfuzzy

-- lander_clickthrough_rate (==clicked_to_products); 
-- products_clickthrough_rate (==clicked_to_mrfuzzy);
-- mr_fuzzy_clickthrough_rate (==clicked_to_cart)

select
	count(distinct website_session_id) as sessions,

	count(distinct case when product_made_it = 1 then website_session_id else NULL end)/
	count(distinct website_session_id) as clicked_to_products,

	count(distinct case when mrfuzzy_made_it = 1 then website_session_id else NULL end)/
	count(distinct case when product_made_it = 1 then website_session_id else NULL end) as clicked_to_mrfuzzy,

	count(distinct case when cart_made_it = 1 then website_session_id else NULL end)/
	count(distinct case when mrfuzzy_made_it = 1 then website_session_id else NULL end) as clicked_to_cart
from session_level_made_it_flags;
