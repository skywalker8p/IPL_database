create table matches("id" int,
					 "city" varchar,
					 "date" date,
					 "player_of_match" varchar,
					 "venue" varchar,
					 "neutral_venue" int,
					 "team1" varchar,
					 "team2" varchar,
					 "toss_winner" varchar,
					 "toss_decision" varchar,
					 "winner" varchar,
					 "result" varchar,
					 "result_margin" int,
					 "eliminator" varchar,
					 "method" varchar,
					 "umpire1" varchar,
					 "umpire2" varchar) ;
					 
drop table matches;
copy matches from 'C:\Program Files\PostgreSQL\13\data\IPL_matches.csv' csv header;
select * from matches;

alter table matches alter column date type date;

create table deliveries(id int,
					    inning int,
					    over int,
						ball int,
						batsman varchar,
						non_striker varchar,
						bowler varchar,
						batsman_run  int,
					    extra_runs int,
						total_runs int,
						is_wicket int,
						dismissal_kind varchar,
						player_dismissed varchar,
						fielder varchar,
						extras_type varchar,
						batting_team varchar,
						bowling_team varchar
					   ) ;
copy deliveries from 'C:\Program Files\PostgreSQL\13\data\IPL_ball.csv' csv header;
 select * from deliveries;
 
 -- 5
 
 select * from deliveries limit 20;

--6
select * from matches limit 20;
--7
select * from matches where date = '2013-02-05';
--8
select * from matches;
select * from matches where result_margin > 100;
--9
select * from matches where result_margin = 0 order by date desc;
--10
select city, count(city) from matches group by city;
--11
create table deliveries_v02 as select *, case when total_runs > 3 then 'boundary'
												when total_runs = 0 then 'dot'
												else 'other' end as ball_result from deliveries;
select * from deliveries_v02;
--12
select ball_result, count(ball_result) from deliveries_v02 group by ball_result;
--13
select batting_team, count(ball_result)  from deliveries_v02  where ball_result = 'boundary' group by batting_team ;
--14
select bowling_team, count(ball_result) from deliveries_v02 where ball_result = 'dot' group by bowling_team order by;
--15
select dismissal_kind, count(dismissal_kind) from deliveries where not dismissal_kind = 'NA' group by dismissal_kind;
--16
select bowler, sum(extra_runs) from deliveries group by bowler order by sum(extra_runs) desc limit 5;
--17
drop table deliveries_v03;
create table deliveries_v03 as select deliveries_v02.* , m.venue, m.date from deliveries_v02 inner join matches as m on deliveries_v02.id = m.id;
select * from deliveries_v03;
--18
select venue, sum(total_runs) from deliveries_v03 group by venue order by sum(total_runs) desc;
--19

set datestyle to dmy;
select * from matches;
select extract(year from date) as year , sum(total_runs) from deliveries_v03 where venue = 'Eden Gardens' group by year order by sum(total_runs) desc;

--20
select distinct team1 from matches;

create table matches_corrected as select * , replace(team1, 'Rising Pune Supergiants', 'Rising Pune Supergiant') as team1_corr ,
          replace(team1, 'Rising Pune Supergiants', 'Rising Pune Supergiant') as team2_corr from matches;
		  
select * from matches_corrected;

--21
create table deliveries_v04 as select concat(id,'-',inning,'-',over,'-',ball) as ball_id , d.* from deliveries_v03 as d;
select * from deliveries_v04;
drop table deliveries_v04;
--22
select count(ball_id) from deliveries_v04;
select  count( distinct ball_id),count(ball_id) as c from deliveries_v04;
--23
create table deliveries_v05 as select *,  row_number() over (partition by ball_id) as r_num from deliveries_v04;
select * from deliveries_v05;
--24
select * from deliveries_v05 where r_num >1 ;
--25
select * from deliveries_v05 where ball_id in (select ball_id from deliveries_v05 where r_num>1);
select round(56.647,2);
