
-- DDL for an user_devices_cumulated

create table user_devices_cumulated (
 	user_id NUMERIC,
		device_id NUMERIC,
		browser_type TEXT,
		device_type TEXT,
		date DATE,
		device_activity_datelist DATE[],
		primary key (user_id,device_id,date)
);