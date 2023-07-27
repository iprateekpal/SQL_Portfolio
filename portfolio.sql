/*Easy Level:
Q1 Retrieve the list of all players and their countries from the "Player" table.*/ 
SELECT player_name as "Name", country as "Country"
FROM player; 



--Q2 Find the total number of matches played in each season from the "Match" table.
SELECT EXTRACT(YEAR FROM Match_Date) AS Year, COUNT(*) AS Total_Matches
FROM Match
GROUP BY Year
ORDER BY Year;



--Q3 Get the top 5 teams with the most wins across all seasons. 
SELECT t.team_name, count(*) as number_of_wins
from match m
join team t on
m.match_winner_id = t.team_id
where m.is_result = '1'
group by t.team_name
order by number_of_wins DESC LIMIT 5;



-- Medium Level:
--Q4 Calculate the total number of runs scored by each player in a specific season.
SELECT p.player_name, s.season_year, SUM(b.batsman_scored) AS Total_runs
from ball_by_ball b
join player p on b.striker_id=p.player_id
join match m on b.match_id= m.match_id
join season s on s.season_id=m.season_id
where s.season_year=2016
group by p.player_name, s.season_year
ORDER BY total_runs DESC;



-- Q5 Find the player who has won the most "Man of the Match" awards in a single season.
select p.player_name, s.season_year, count(*) as "MoM_Awards"
from match m
join player p on p.player_id=m.man_of_the_match_id
join season s on s.season_id=m.season_id
group by p.player_name, s.season_year
order by "MoM_Awards" DESC 
LIMIT 1;



-- Q6 Determine the average extras (Extra_Runs) conceded by each team in a specific season.
select t.team_name, s.season_year, round(avg(b.extra_runs), 2) as AVG_Extras
FROM ball_by_ball b
join team t ON b.team_bowling_id = t.team_id
join match m ON b.match_id=m.match_id
join season s on s.season_id=m.season_id
where s.season_year = 2015
group by t.team_name, s.season_year
order by AVG_Extras;



-- Q7 Find the top 5 players with the highest batting averages across all seasons. Batting average is calculated as (total_runs_scored / total_innings_played).
SELECT p.Player_Name, 
       ROUND(SUM(b.batsman_scored) / COUNT(DISTINCT m.Match_Id), 2) AS Batting_Average
FROM Player p
JOIN Player_Match pm ON p.Player_Id = pm.Player_Id
JOIN Match m ON pm.Match_Id = m.Match_Id
JOIN Ball_by_Ball b ON m.Match_Id = b.Match_Id AND (p.Player_Id = b.Striker_Id OR p.Player_Id = b.Non_Striker_Id)
GROUP BY p.Player_Name
ORDER BY Batting_Average DESC
LIMIT 5;



-- Q8 Calculate the win percentage for each team in a specific season.
SELECT t.Team_Name, 
       ROUND(COUNT(CASE WHEN m.Match_Winner_Id = t.Team_Id THEN 1 ELSE NULL END) * 100.0 / COUNT(m.Match_Id), 2) AS Win_Percentage
FROM Team t
JOIN Match m ON t.Team_Id = m.Team_Name_Id OR t.Team_Id = m.Opponent_Team_Id
WHERE m.Season_Id = 8
GROUP BY t.Team_Name
ORDER BY Win_Percentage DESC;
