-- weekly session volume for gsearch & bsearch nonbrand, broken down by device, sinve Nov 4th
-- + comparison metric to show bsearch as a % of gsearch

select
	min(date(website_sessions.created_at)) as week_start_date,

	count(distinct case when website_sessions.utm_source = 'gsearch' and website_sessions.device_type = 'desktop'
	then website_sessions.website_session_id else NULL end) as g_desk_sessions,

 	count(distinct case when website_sessions.utm_source = 'bsearch' and website_sessions.device_type = 'desktop'
 	then website_sessions.website_session_id else NULL end) as b_desk_sessions,

 	count(distinct case when website_sessions.utm_source = 'bsearch' and website_sessions.device_type = 'desktop'
 	then website_sessions.website_session_id else NULL end)/
 	count(distinct case when website_sessions.utm_source = 'gsearch' and website_sessions.device_type = 'desktop'
	then website_sessions.website_session_id else NULL end) as b_perc_g_desk_sessions,

	count(distinct case when website_sessions.utm_source = 'gsearch' and website_sessions.device_type = 'mobile'
	then website_sessions.website_session_id else NULL end) as g_mob_sessions,

	count(distinct case when website_sessions.utm_source = 'bsearch' and website_sessions.device_type = 'mobile'
	then website_sessions.website_session_id else NULL end) as b_mob_sessions,

	count(distinct case when website_sessions.utm_source = 'bsearch' and website_sessions.device_type = 'mobile'
	then website_sessions.website_session_id else NULL end)/
	count(distinct case when website_sessions.utm_source = 'gsearch' and website_sessions.device_type = 'mobile'
	then website_sessions.website_session_id else NULL end) as b_perc_g_mob_sessions
from website_sessions
where website_sessions.created_at > '2012-11-02'
	and website_sessions.created_at < '2012-12-22'
	and website_sessions.utm_campaign = 'nonbrand'

group by yearweek(website_sessions.created_at);
