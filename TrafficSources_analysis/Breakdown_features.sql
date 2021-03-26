-- breakdown by UTM source, campaign, referring domain
select 
	utm_source,
	utm_campaign,
	http_referer,
	count(distinct web.website_session_id) as sessions
from website_sessions as web
where created_at < '2012-04-12'
group by utm_source, utm_campaign, http_referer
order by 4 desc;
