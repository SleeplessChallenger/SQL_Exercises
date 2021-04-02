-- pull data on how many of business website visitors come back for another session


DROP TEMPORARY TABLE IF EXISTS repeat_sessions;

create temporary table repeat_sessions
select
	inner_table.user_id,
	inner_table.website_session_id as new_session_id,
	website_sessions.website_session_id as repeat_session_id
from
	(
	select
		user_id,
		website_session_id
	from website_sessions
	where created_at < '2014-11-03'
		and created_at >= '2014-01-01'
		and is_repeat_session = 0
	) as inner_table
	-- 'inner_table' will have only new queries
left join website_sessions
	on website_sessions.user_id=inner_table.user_id
	and website_sessions.is_repeat_session = 1 -- can be, but redundant
	and website_sessions.website_session_id > inner_table.website_session_id
	-- above one specifies that repeat session should be further than initial one
	and website_sessions.created_at < '2014-11-03'
	and website_sessions.created_at >= '2014-01-01';


-- result
select
	repeat_session_id,
	count(distinct user_id) as users
from
	(
	select
		user_id,
		count(distinct new_session_id) as new_session_id,
		count(distinct repeat_session_id) as repeat_session_id
	from repeat_sessions
	group by 1
	order by 3 desc
	) as users
group by 1;
