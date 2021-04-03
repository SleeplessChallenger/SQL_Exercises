-- average website session volume by hour of day & by day week

select
	hr,
	avg(case when wkday = 1 then website_sessions else NULL end) as tue,
	avg(case when wkday = 2 then website_sessions else NULL end) as wed,
	avg(case when wkday = 3 then website_sessions else NULL end) as thu,
	avg(case when wkday = 4 then website_sessions else NULL end) as fri,
	avg(case when wkday = 5 then website_sessions else NULL end) as sat,
	avg(case when wkday = 6 then website_sessions else NULL end) as sun
from
	(
	select
		date(created_at) as date,
		weekday(created_at) as wkday,
		hour(created_at) as hr,
		count(distinct website_session_id) as website_sessions
	from website_sessions
	where created_at > '2012-09-15' and created_at < '2012-11-15'
	group by 1,2,3
	) as date_table
group by 1
order by 1;
