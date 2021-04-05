-- Product sales help to understand: how each product contributes to the business and how
-- product launches impact the overall portfolio

-- orders: count(order_id)
-- revenue: sum(price_usd)
-- margin: sum(price_usd - cogs_usd)
-- average order value: avg(price_usd)


select
	primary_product_id,
	count(order_id) as orders,
	sum(price_usd) as revenue,
	sum(price_usd - cogs_usd) as margin,
	avg(price_usd) as aov
from orders
where order_id between 10000 and 11000
group by 1
order by 2 desc;
