create table actors_history_scd (
		actor TEXT,
		actorid TEXT,
		is_active boolean,
		quality_class quality_class,
		start_date Integer,
		end_date Integer,
		current_year Integer,
		primary key(actorid,start_date)
)