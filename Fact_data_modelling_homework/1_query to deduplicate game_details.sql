-- A query to deduplicate game_details from Day 1 so there's no duplicates

with dedupe_game_details as(
		select g.game_date_est,
				g.season,
				g.home_team_id,
				g.visitor_team_id,
				
			   gd.* , 
		row_number() over (partition by gd.game_id , team_id, player_id ) as row_num
from game_details as gd join games as g on gd.game_id = g.game_id )

select 
	game_date_est as dim_game_date,
	season as dim_season,
	team_id as dim_team_id,
	player_id as dim_player_id,
	player_name as dim_player_name,
	team_id = home_team_id as dim_is_playing_at_home,
	start_position as dim_start_position,
	coalesce( position('DNP' in comment),0) >0 as dim_did_not_play, --> 0 because we want this to be boolean
	coalesce( position('NWT' in comment),0) >0 as dim_not_with_team,
	coalesce( position('DND' in comment),0) >0 as dim_did_not_dress,
	CAST(Split_part(min,':',1) as REAL) + CAST(Split_part(min,':',2) as REAL)/60 as m_minutes,
    fgm as m_fgm,
    fga as m_fga,
    g3m as m_fg3m,
    g3a as m_fg3a,
    ftm as m_ftm,
    fta as m_fta,
    reb as m_oreb,
    reb as m_dreb,
    reb as m_reb,
    ast as m_ast,
    blk as m_blk,
	"TO" as m_turnovers, --rename to as it's keyword
	pf as m_pf,
	pts as m_pts,
	plus_minus as m_plus_minus
	
from dedupe_game_details
where row_num = 1 ;