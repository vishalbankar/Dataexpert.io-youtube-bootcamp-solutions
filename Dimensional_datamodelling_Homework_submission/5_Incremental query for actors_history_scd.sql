
------ created struct type actors_scd ------------ 

create type actors_scd as (
	     is_active boolean,
		 quality_class quality_class ,
		 start_date Integer,
		 end_date Integer
);

--------- Incremental query for actors_history_scd  ---------------------------


with last_year_data as(
 	select * from 
	 actors_history_scd 
	 where current_year = 2020 and end_date = 2020
),

historical_scd as(
    select actor,
		   actorid,
		   is_active,
		   quality_class,
		   start_date,
		   end_date
	 from 
	     actors_history_scd 
	 where current_year = 2020 and end_date < 2020
),

this_year_data as(
		select * from actors
		where current_year = 2021
),

unchanged_actor_records as(
		select ty.actor,
			   ty.actorid,
			   ty.is_active,
			   ty.quality_class,
			   ly.start_date,
			   ty.current_year as end_date 
		from this_year_data as ty
		join last_year_data as ly
		on ty.actorid = ly.actorid
		where (ty.quality_class = ly.quality_class or ty.is_active = ly.is_active)	
),

changed_records as(
		select ty.actor,
			   ty.actorid,
			   UNNEST(array[ROW(
					ly.is_active ,
		 			ly.quality_class,
		 			ly.start_date,
				 	ly.end_date 
			   )::actors_scd,
			   ROW(
					ty.is_active ,
		 			ty.quality_class,
		 			ty.current_year,
				 	ty.current_year 
			   )::actors_scd
			   ])AS records
		from this_year_data as ty
		left join last_year_data as ly
		on ty.actorid = ly.actorid
		where (ty.quality_class <> ly.quality_class or ty.is_active <> ly.is_active)	
),

unnested_changed_records as(
		select actor,
		actorid,
		(records::actors_scd).is_active,
		(records::actors_scd).quality_class,
		(records::actors_scd).start_date,
		(records::actors_scd).end_date
		from changed_records

),

new_records as(
 		select ty.actor,
			   ty.actorid,
			   ty.is_active,
			   ty.quality_class,
			   ty.current_year as start_date,
			   ty.current_year as end_date 
		from this_year_data as ty
		left join last_year_data as ly
		on ty.actorid = ly.actorid
		where ly.actorid is NULL
)

SELECT *
FROM historical_scd

UNION ALL

SELECT *
FROM unchanged_actor_records

UNION ALL

SELECT *
FROM unnested_changed_records

UNION ALL

SELECT *
FROM new_records;


