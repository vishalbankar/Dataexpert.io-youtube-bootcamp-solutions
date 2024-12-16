-- select * from devices limit 100;

-- drop table user_devices_cumulated;

-- create table user_devices_cumulated (
--  	user_id NUMERIC,
-- 		device_id NUMERIC,
-- 		browser_type TEXT,
-- 		device_type TEXT,
-- 		date DATE,
-- 		device_activity_datelist DATE[],
-- 		primary key (user_id,device_id,date)
-- );



---- cumulative query device_activity_datelist --------

insert into user_devices_cumulated
with yesterday as(
  select * 
  from user_devices_cumulated
  where date = DATE('2023-01-01')
),

---- dedup duplicate ----
dudup_dup_users as(
	select 
	e.user_id ,
	d.device_id,
	d.browser_type,
	d.device_type,
	DATE(CAST(e.event_time as timestamp)) as date ,
	row_number() over(partition by e.user_id,d.device_id,d.browser_type) as rnk
from devices d
join events e
on d.device_id = e.device_id
where DATE(CAST(e.event_time as timestamp)) = DATE('2023-01-02') 
	and e.user_id is not null 
	and e.device_id is not null
),

today as (
select 
	*
	from dudup_dup_users
    where rnk=1
)
-- today as(
-- 	select 
-- 	e.user_id ,
-- 	d.device_id,
-- 	d.browser_type,
-- 	d.device_type,
-- 	DATE(CAST(e.event_time as timestamp)) as device_activity_datelist
-- from devices d
-- join events e
-- on d.device_id = e.device_id
-- where DATE(CAST(e.event_time as timestamp))= DATE('2023-01-01') and e.user_id is not null 
-- )

select 
	COALESCE(t.user_id,y.user_id) as user_id,
	COALESCE(t.device_id,y.device_id) as device_id,
	COALESCE(t.browser_type,y.browser_type) as browser_type,
	COALESCE(t.device_type,y.device_type) as device_type,
	
	COALESCE(t.date, y.date + Interval '1 day') as date,
--  collecting list of dates when user is active 
	case
		when y.device_activity_datelist is null then array[t.date]
		when t.date is null then y.device_activity_datelist
		else array[t.date] || y.device_activity_datelist 
	end as device_activity_datelist
		
from 
today as t 
full outer join yesterday as y
on t.user_id = y.user_id 
and t.device_id = y.device_id
and t.browser_type = y.browser_type;


-- select * from user_devices_cumulated;
