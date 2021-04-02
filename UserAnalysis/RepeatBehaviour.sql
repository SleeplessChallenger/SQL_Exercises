-- min, max, avg time between the first and the second session


-- retrieve users with repeat sessions & created_at data
DROP TEMPORARY TABLE IF EXISTS first_second_sessions;

create temporary table first_second_sessions
select
	first_session.created_at as first_created,
	first_session.user_id,
	first_session.website_session_id as first_sessions,
	website_sessions.website_session_id as second_sessions,
	website_sessions.created_at as second_created
from
	(
	select
		website_session_id,
		user_id,
		created_at	
	from website_sessions
	where created_at >='2014-01-01'
		and created_at < '2014-11-03'
		and is_repeat_session = 0
	) as first_session
left join website_sessions
	on website_sessions.user_id=first_session.user_id
	and website_sessions.is_repeat_session = 1
	and website_sessions.website_session_id > first_session.website_session_id
	and website_sessions.created_at >=  '2014-01-01'
	and website_sessions.created_at < '2014-11-03';


-- analyzing 'created_at'
DROP TEMPORARY TABLE IF EXISTS pre_final;

create temporary table pre_final
select
	datediff(second_created, first_created) as days_first_second_session,
	user_id
from
	(
	select
		first_created,
		first_sessions,
		user_id,
		min(second_created) as second_created,
		-- first session that is not new (repeat one)
		min(second_sessions) as second_session
	from first_second_sessions
	where second_sessions is not NULL
	group by 1,2,3
	) as user_created;


-- result
select
	avg(days_first_second_session) as avg_days_first_second,
	min(days_first_second_session) as min_days_first_second,
	max(days_first_second_session) as max_days_first_second
from pre_final;
