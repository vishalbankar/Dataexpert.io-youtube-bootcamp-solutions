create table actors(
	actor TEXT,
	actorid TEXT,
	films films[],
	current_year Integer,
	quality_class quality_class,
	is_active BOOLEAN,
	primary key(actorid,current_year)
);

