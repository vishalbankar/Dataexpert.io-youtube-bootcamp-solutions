-- DDL for hosts_cumulated table 
-- host_activity_datelist which logs to see which dates each host is experiencing any activity

create table hosts_cumulated (
		host TEXT,
		start_date date,
		host_activity_datelist DATE[],
		primary key (host,start_date)
);

