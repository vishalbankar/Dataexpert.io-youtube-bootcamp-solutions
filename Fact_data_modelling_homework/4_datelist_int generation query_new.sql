with users as(
 select * from user_devices_cumulated 
 	where date='2023-01-01'
),

series as(
 SELECT * from generate_series(DATE('2023-01-01'),DATE('2023-01-31'),Interval '1 day') as series_date
),

place_holder_int as(
select 
	
	case 
		when device_activity_datelist @> ARRAY[DATE(series_date)] 
		then CAST(POW(2,31 - (date - DATE(series_date))) as BIGINT)
		else 0
	end  as Placeholder_int_val, *
from users 
cross join series 
)

select user_id,
		
		CAST(CAST(SUM(Placeholder_int_val) as Bigint)as BIT(32)) as datelist_int ,
		bit_count(CAST(CAST(SUM(Placeholder_int_val) as Bigint)as BIT(32)))  as dim_monthly_active,
		-- checking if user is active in last seven days
		bit_count(CAST('11111100000000000000000000000000' as BIT(32)) & 
			CAST(CAST(SUM(Placeholder_int_val) as Bigint)as BIT(32)))  as dim_weekly_active
		
from place_holder_int
group by user_id
order by dim_monthly_active desc;