-- A monthly, reduced fact table DDL host_activity_reduced

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
