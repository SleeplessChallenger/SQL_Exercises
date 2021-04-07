-- conversion funnels from each page to conversion

-- comparision between the two conversion funnels for all website traffic



-- select all pageviews for relevant sessions

DROP TEMPORARY TABLE IF EXISTS sessions_urls;

create temporary table sessions_urls
select
	website_pageviews.pageview_url as url,
	website_sessions.website_session_id,
	website_pageviews.website_pageview_id
from website_sessions
	left join website_pageviews
		on website_pageviews.website_session_id=website_sessions.website_session_id
where website_sessions.created_at > '2013-01-06'
	and website_sessions.created_at < '2013-04-10'
	and pageview_url in ('/the-original-mr-fuzzy', '/the-forever-love-bear');


-- scrutinize which pageview_url to look for (it'll be a demo which will be incorporated further)
select distinct
	website_pageviews.pageview_url
from sessions_urls
	left join website_pageviews
		on website_pageviews.website_session_id=sessions_urls.website_session_id
		and website_pageviews.website_pageview_id > sessions_urls.website_pageview_id;
		-- enables to see which pageviews (urls in select) to look for

-- => next 
DROP TEMPORARY TABLE IF EXISTS products;

create temporary table products
select
	website_session_id,
	CASE
		when url = '/the-original-mr-fuzzy' then 'mr_fuzzy'
		when url = '/the-forever-love-bear' then 'lovebear'
		else 'Error'
	end as product_seen,
	max(cart) as cart,
	max(shipping) as shipping,
	max(billing) as billing,
	max(thank_you) as thanks
from
	(
	select
		sessions_urls.website_session_id,
		sessions_urls.url,
		case when website_pageviews.pageview_url = '/cart' then 1 else 0 end as cart,
		case when website_pageviews.pageview_url = '/shipping' then 1 else 0 end as shipping,
		case when website_pageviews.pageview_url = '/billing-2' then 1 else 0 end as billing,
		case when website_pageviews.pageview_url = '/thank-you-for-your-order' then 1 else 0 end as thank_you
	from sessions_urls
		left join website_pageviews
			on website_pageviews.website_session_id=sessions_urls.website_session_id
			and website_pageviews.website_pageview_id > sessions_urls.website_pageview_id
	order by
		sessions_urls.website_session_id,
		website_pageviews.created_at
	) as inner_table
group by website_session_id,
		CASE
		when url = '/the-original-mr-fuzzy' then 'mr_fuzzy'
		when url = '/the-forever-love-bear' then 'lovebear'
		else 'Error'
		end;

-- final numbers

select
	product_seen,
	count(distinct website_session_id),
	count(distinct case when cart = 1 then website_session_id else NULL end) as to_cart,
	count(distinct case when shipping = 1 then website_session_id else NULL end) as to_shipping,
	count(distinct case when billing = 1 then website_session_id else NULL end) as to_billing,
	count(distinct case when thanks = 1 then website_session_id else NULL end) as to_thanks
from products
group by product_seen;


-- final ratio

select
	product_seen,
	count(distinct case when cart = 1 then website_session_id else NULL end)/
	count(distinct website_session_id) as product_page_clickthrough,

	count(distinct case when shipping = 1 then website_session_id else NULL end)/
	count(distinct case when cart = 1 then website_session_id else NULL end) as cart_clickthrough,

	count(distinct case when billing = 1 then website_session_id else NULL end)/
	count(distinct case when shipping = 1 then website_session_id else NULL end) as shipping_clickthrough,

	count(distinct case when thanks = 1 then website_session_id else NULL end)/
	count(distinct case when billing = 1 then website_session_id else NULL end) as billing_clickthrough
from products
group by 1;
