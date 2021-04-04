-- analysis of marketing channels porfolio helps to bid efficiently and use data to max
-- the effectiveness of the marketing budget

use mavenfuzzyfactory;

select
	utm_content,
	count(distinct website_sessions.website_session_id) as sessions,
	count(distinct orders.order_id) as orders,
	count(distinct orders.order_id)/
	count(distinct website_sessions.website_session_id) as session_order_conversion
from website_sessions
	left join orders
		on orders.website_session_id=website_sessions.website_session_id
where website_sessions.created_at between '2014-01-01' and '2014-02-01'
group by 1
order by sessions desc;
