-- Analysis of business patterns will generate insights to help us 
-- maximize efficiency and anticipate future trends

select
	website_session_id,
	created_at,
	hour(created_at) as hr,
	weekday(created_at) as wkday, -- 0 is Mnd, 1 is Tues
	CASE
		when weekday(created_at) = 0 then 'Monday'
		when weekday(created_at) = 1 then 'Tuesday'
		else 'other day'
	end as clean_weekday,
	quarter(created_at) as qtr,
	month(created_at) as month,
	date(created_at) as date,
	week(created_at) as wk
from website_sessions
where website_session_id between 150000 and 155000;
