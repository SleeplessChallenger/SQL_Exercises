-- branded or direct traffic speaks about how well brand is doing with consumers
-- and how well brand drives business

select
	CASE
		when http_referer is NULL then 'direct_typing'
		when http_referer = 'https://www.gsearch.com' then 'gsearch_organic'
		when http_referer = 'https://www.bsearch.com' then 'bsearch_organic'
		else 'other'
	end,
	count(distinct website_session_id) as sessions
from website_sessions
where website_session_id between 100000 and 115000
	and utm_source is NULL
group by 1
order by 2 desc;

-- utm_source is paid traffic if not NULL else (direct traffic)

-- Considering utm_source is NULL:
-- http_referer: the website that sent us the traffic. If NULL -> direct typing
-- if not NULL -> organic search


-- including paid search traffic

select
	CASE
		when http_referer is NULL then 'direct_typing'
		when http_referer = 'https://www.gsearch.com' and utm_source is NULL then 'gsearch_organic'
		when http_referer = 'https://www.bsearch.com' and utm_source is NULL then 'bsearch_organic'
		else 'other'
	end,
	count(distinct website_session_id) as sessions
from website_sessions
where website_session_id between 100000 and 115000
group by 1
order by 2 desc;
