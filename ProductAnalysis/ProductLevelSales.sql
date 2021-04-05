-- monthly trends to date for number of sales, total revenue and total margin generated

select
	min(date(created_at)) as month_date,
	count(distinct order_id) as number_of_sales,
	sum(price_usd) as total_revenue,
	sum(price_usd - cogs_usd) as total_margin
from orders
where created_at < '2013-01-04'
group by
	month(created_at);
