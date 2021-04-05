-- look at sessions which hit the '/products' page and see where they went next\

-- pull clickthrough rates from '/products' since the new product launch on
-- January 6th 2013 (by product) and compare to the 3 months leading up to
-- launch as a baseline



-- find relevant '/products' pageviews with website_session_id

DROP TEMPORARY TABLE IF EXISTS products_page;

create temporary table products_page
select
	website_session_id,
	website_pageview_id,
	created_at,
	case
		when created_at < '2013-01-06' then 'A. PRE_PRODUCT_2'
		when created_at >= '2013-01-06' then 'B. POST_PRODUCT_2'
		else 'wrong logic'
	end as time_period
from website_pageviews
where created_at < '2013-04-06'
	and created_at > '2012-10-06'
	and pageview_url = '/products';


-- find the next pageview id that occurs 'after' the product pageview
DROP TEMPORARY TABLE IF EXISTS sessions_next_pages;

create temporary table sessions_next_pages
select
	products_page.website_session_id,
	products_page.time_period,
	min(website_pageviews.website_pageview_id) as min_next_pageview_id
	-- this will give the pageview that happened straight after /products pageview
from products_page
	left join website_pageviews
		on website_pageviews.website_session_id=products_page.website_session_id
		and website_pageviews.website_pageview_id > products_page.website_pageview_id
		-- JOIN for only those pageviews that happen after '/products' pageview
group by 1,2;


-- find the pageview_url associated with any applicable next pageview id
DROP TEMPORARY TABLE IF EXISTS sessions_next_url;

create temporary table sessions_next_url
select
	sessions_next_pages.time_period,
	sessions_next_pages.website_session_id,
	website_pageviews.pageview_url as next_pageview_url
from sessions_next_pages
	left join website_pageviews
		on website_pageviews.website_pageview_id=sessions_next_pages.min_next_pageview_id;

-- summarize data & pre vs post periods analysis
select
	time_period,
	count(distinct website_session_id) as sessions,

	count(distinct case when next_pageview_url is not NULL then website_session_id else NULL end) as next_pg,
	
	count(distinct case when next_pageview_url is not NULL then website_session_id else NULL end)/
	count(distinct website_session_id) as perc_next_page,

	count(distinct case when next_pageview_url = '/the-original-mr-fuzzy' then website_session_id else NULL end) as to_mr_fuzzy,

	count(distinct case when next_pageview_url = '/the-original-mr-fuzzy' then website_session_id else NULL end)/
	count(distinct website_session_id) as perc_to_mr_fuzzy,

	count(distinct case when next_pageview_url = '/the-forever-love-bear' then website_session_id else NULL end) as to_love_bear,

	count(distinct case when next_pageview_url = '/the-forever-love-bear' then website_session_id else NULL end)/
	count(distinct website_session_id) as perc_to_mr_fuzzy

from sessions_next_url
group by time_period;
