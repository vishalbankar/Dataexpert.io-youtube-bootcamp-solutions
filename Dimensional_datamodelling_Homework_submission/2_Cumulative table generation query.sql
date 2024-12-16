----- Cumulative table generation query -------------------

INSERT INTO actors
WITH yesterday AS (
    SELECT *
    FROM actors
    WHERE current_year = 1969
),
today AS (
    SELECT actor, 
		   actorid, 
		   year,
		   Avg(rating) as avg_rating,
		   count(film) as no_of_films,
           ARRAY_AGG(row(film, votes, rating, filmid)::films) AS films
    FROM actor_films
    WHERE year = 1970
    GROUP BY actorid, actor, year
)
SELECT
    COALESCE(t.actor, y.actor) AS actor,
    COALESCE(t.actorid, y.actorid) AS actorid,


	CASE 
        WHEN t.films IS NULL THEN y.films
        WHEN t.films IS NOT NULL THEN y.films || t.films
        ELSE y.films 
    END AS films,

	CASE
        WHEN t.year IS NULL THEN y.current_year + 1  -- Adjust the current_year to next year
        ELSE t.year
    END AS current_year,
	
	---- quality class --
	
	CASE WHEN t.year is not null then 
			case
			  when t.avg_rating > 8 then 'star'
			  when t.avg_rating > 7 then 'good'
			  when t.avg_rating > 6 then 'avg'
			  else 'bad'
			end::quality_class
		else y.quality_class
	END as quality_class ,

	------------------ is_active ----------------
	
	case when t.year is NULL then False
	else True 
	end as is_active
	
FROM today AS t
FULL OUTER JOIN yesterday AS y 
ON t.actorid = y.actorid;