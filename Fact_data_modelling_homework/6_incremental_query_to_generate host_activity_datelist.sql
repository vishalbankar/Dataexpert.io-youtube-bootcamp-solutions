create table hosts_cumulated (
		host TEXT,
		start_date date,
		host_activity_datelist DATE[],
		primary key (host,start_date)
);

-- drop table hosts_cumulated

-- select * from events limit 10;
-- select min(event_time), max(event_time) from events;

---------------------------------

-- The incremental query to generate host_activity_datelist

insert into hosts_cumulated
with yesterday as(
	select * from hosts_cumulated
	-- where start_date = DATE('2022-12-31')
	where start_date = DATE('2023-01-02')
),
today as(
	select 
	host,
	DATE(CAST(event_time as timestamp)) as date
	from events
	where DATE(CAST(event_time as timestamp)) = DATE('2023-01-03')
	and user_id is not null
	group by host,DATE(CAST(event_time as timestamp))
)
select 
	COALESCE(y.host,t.host) as host,
	COALESCE(t.date, y.start_date) as date,
-- collecting list of dates for host  
	case
		when y.host_activity_datelist is null then array[t.date]
		when t.date is null then y.host_activity_datelist
		else array[t.date] || y.host_activity_datelist 
	end as host_activity_datelist

	from today as t 
	full outer join yesterday as y
	on t.host = y.host	
	
-- ON CONFLICT (host, start_date)
-- DO 
--     UPDATE SET host_activity_datelist = EXCLUDED.host_activity_datelist;


select * from hosts_cumulated