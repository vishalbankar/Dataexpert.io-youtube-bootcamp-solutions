-- A monthly, reduced fact table DDL host_activity_reduced
-- 	month
-- 	host
-- 	hit_array - think COUNT(1)
-- 	unique_visitors array - think COUNT(DISTINCT user_id)

create table host_activity_reduced(
	month_start date,
	host TEXT,
	hit_array REAL[],
	unique_visitors_array REAL[],
	primary key (month_start, host)
);

-- drop table host_activity_reduced

insert into host_activity_reduced
with daily_aggregate as(
	select host,
	date(event_time) as date,
	count(1) as no_of_hits,
	count(distinct(user_id)) as unique_visitors
	from events
	where date(event_time) = DATE('2023-01-02') and user_id is not null
	group by host,date(event_time)
	-- order by date(event_time) asc
),

yesterday_array as(
	select * from  host_activity_reduced
	where month_start = DATE('2023-01-01')
)


select 
	COALESCE(ya.month_start,DATE_TRUNC('month', da.date)) as month_start,
	COALESCE(ya.host,da.host) as host,
	CASE 
        WHEN ya.hit_array IS NOT NULL THEN 
            ya.hit_array || ARRAY[COALESCE(da.no_of_hits,0)] 
        WHEN ya.hit_array IS NULL THEN
            ARRAY_FILL(0, ARRAY[COALESCE (date - DATE(DATE_TRUNC('month', date)), 0)]) 
                || ARRAY[COALESCE(da.no_of_hits,0)]
    END AS hit_arry,
	CASE 
        WHEN ya.unique_visitors_array IS NOT NULL THEN 
            ya.unique_visitors_array || ARRAY[COALESCE(da.unique_visitors,0)] 
        WHEN ya.unique_visitors_array IS NULL THEN
            ARRAY_FILL(0, ARRAY[COALESCE (date - DATE(DATE_TRUNC('month', date)), 0)]) 
                || ARRAY[COALESCE(da.unique_visitors,0)]
    END AS unique_visitors_array
	
from daily_aggregate da
full outer join yesterday_array ya
on da.host = ya.host
ON CONFLICT (host, month_start)
DO 
    UPDATE 
	SET hit_array = EXCLUDED.hit_array,
		unique_visitors_array = EXCLUDED.unique_visitors_array;


------------------
select * from host_activity_reduced;

SELECT cardinality(hit_array), COUNT(1)
FROM host_activity_reduced
GROUP BY 1;
----------
-- select host,
-- 	count(1) as no_of_hits,
-- 	count(distinct(user_id)) as unique_visitors
-- 	from events
-- 	where date(event_time) = DATE('2023-01-01') and user_id is not null
-- 	group by host