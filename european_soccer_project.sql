use `european-soccer-database`;
show tables;

select * from country;
select * from league;
select * from `match`;
select * from player ;
select * from player_attributes  order by potential desc;
select * from team;
select * from team_attributes;

-- 1) How many teams played in each league during each season?
select trial_season_4 ,league_id,name, count(`match`.trial_home_team_api_id_8) as Teams from `match` join league on `match`.league_id = league.id
group by league_id,trial_season_4;


-- 2) What was the count and average goals scored in each league during each season?
select trial_season_4, name, sum(home_team_goal) as Total_Goals, round(sum(home_team_goal)/count(home_team_goal)) as AVERAGE_Goals from `match` join league on `match`.league_id = league.id
group by league_id,trial_season_4;


-- 3) How was the performance (home win, home tie, home loss, away win, away loss, away tie) of 
-- teams in each league during each season?
drop table if exists home_team_perf ;
create table if not exists home_team_perf as 
select trial_season_4, league_id, trial_home_team_api_id_8 as Home_team_id,
sum(case 
	when home_team_goal > trial_away_team_goal_11 
    then 1
    else 0
    end) as "Win",
sum(case 
	when home_team_goal = trial_away_team_goal_11 
    then 1
    else 0
    end) as "Draw",
sum(case 
	when home_team_goal < trial_away_team_goal_11 
    then 1
    else 0
    end )as "Loose"
from `match` group by league_id,home_team_id;
select * from home_team_perf;


drop table if exists away_team_perf ;
create table if not exists away_team_perf as 
select trial_season_4, league_id, away_team_api_id as away_team_id,
sum(case 
	when home_team_goal < trial_away_team_goal_11 
    then 1
    else 0
    end) as "Win",
sum(case 
	when home_team_goal = trial_away_team_goal_11 
    then 1
    else 0
    end) as "Draw",
sum(case 
	when home_team_goal > trial_away_team_goal_11 
    then 1
    else 0
    end )as "Loose"
from `match` group by league_id,away_team_api_id;
select * from away_team_perf;



-- 4) How to quantify the performance in terms of match results?
select home_team_perf.trial_season_4,home_team_perf.league_id, 
sum(case
	when home_team_perf.win > away_team_perf.win
    then 1
    else 0
    end
    )as Home_Wins,
sum(case
	when home_team_perf.win < away_team_perf.win
    then 1
    else 0
    end
    )as Away_Wins from home_team_perf join away_team_perf on home_team_perf.league_id = away_team_perf.league_id
    group by league_id ;
    

-- 5) Which players had the most penalties?
select  player.player_name as Player_Name, penalties from player
 join player_attributes on player.player_api_id = player_attributes.player_api_id order by penalties desc limit 1;

-- id 8981, player_api =39225 ,Rickie Lambert


-- 6) What player attributes lead to the most potential?
select player_attributes.player_api_id, player.player_name, potential, preferred_foot, finishing,trial_dribbling_15 
from player join player_attributes on player.player_api_id = player_attributes.player_api_id 
where preferred_foot in ("left","right") group by player_api_id,preferred_foot,potential order by potential desc ;


-- 7) Correlation between some player attributes and player potential
SELECT 
    (SUM((potential - avg_potential) * (finishing - avg_finishing)) 
    / 
    (COUNT(*) * stdev_potential * stdev_finishing)) AS correlation
FROM
    (SELECT 
        AVG(potential) AS avg_potential,
        AVG(finishing) AS avg_finishing,
        STDDEV(potential) AS stdev_potential,
        STDDEV(finishing) AS stdev_finishing,
        potential,
        finishing 
        FROM player_attributes) 
	AS stats;






