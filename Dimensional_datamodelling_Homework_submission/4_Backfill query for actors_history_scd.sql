--------- Backfill query for actors_history_scd --------------

insert into actors_history_scd
with prev_year_films as(
		select actor,actorid,
		current_year,
		quality_class,
		lag(quality_class, 1) over(partition by actorid order by current_year) as prev_quality_class,
		is_active,
		lag(is_active, 1) over(partition by actorid order by current_year) as prev_is_active
        from actors 
		where current_year <=2020
),

with_indicators as(
select *,
		case 
			when quality_class <> prev_quality_class then 1
			when is_active <> prev_is_active then 1
		    else 0
		end as change_indicator
from prev_year_films),

with_strick as(
select *,
	sum(change_indicator) over(partition by actorid order by current_year) as streak_identifier
from with_indicators
)

select  actor,
		actorid,
		is_active,
		quality_class,
		min(current_year) as start_date,
		max(current_year) as end_date,
		2020 as current_year
from with_strick
group by actor, actorid,streak_identifier,is_active,quality_class
order by actor,streak_identifier;



