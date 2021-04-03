-- a) have a gander at monthly & weekly volume patterns of 2012
-- b) session volume & order volume

-- a
select
	year(website_sessions.created_at),
	month(website_sessions.created_at),
	count(distinct website_sessions.website_session_id) as sessions,
	count(distinct orders.order_id) as orders
from website_sessions
	left join orders
		on orders.website_session_id=website_sessions.website_session_id
where website_sessions.created_at > '2012-01-01' 
	and website_sessions.created_at < '2013-01-02'
group by
	1,2
order by 1,2;

-- b
select
	min(date(website_sessions.created_at)) as week_start_date,
	count(distinct website_sessions.website_session_id) as sessions,
	count(distinct orders.order_id) as orders
from website_sessions
	left join orders
		on orders.website_session_id=website_sessions.website_session_id
where website_sessions.created_at > '2012-01-01' 
	and website_sessions.created_at < '2013-01-02'
group by
	yearweek(website_sessions.created_at);
