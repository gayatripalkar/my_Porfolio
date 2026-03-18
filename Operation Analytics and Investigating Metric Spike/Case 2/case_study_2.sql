#importing all the data tables first ---
use project3_case2;

#create table 1 - users --------------------------------------------------------------
create table users (
user_id int,
created_at varchar(100),
company_id int,
language varchar(50),
activated_at varchar(100),
state varchar(50));

show variables like 'secure_file_priv';

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users.csv"
into table users
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from users;

alter table users add column tmp_created_at datetime;
update users set tmp_created_at =  str_to_date(created_at, "%d-%m-%Y %H:%i");
alter table users drop column created_at;
alter table users change column tmp_created_at created_at datetime;

alter table users add column tmp_activated_at datetime;
update users set tmp_activated_at =  str_to_date(activated_at, "%d-%m-%Y %H:%i");
alter table users drop column activated_at;
alter table users change column tmp_activated_at activated_at datetime;

#------------------------------------------------------------
#create table 2 - events --------------------------------------------------------------
create table events (
user_id int,
occured_at varchar(100),
event_type varchar(50),
event_name varchar(100),
location varchar(50),
device varchar(50),
user_type int);

show variables like 'secure_file_priv';

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/events.csv"
into table events
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from events;

alter table events add column tmp_occured_at datetime;
update events set tmp_occured_at =  str_to_date(occured_at, "%d-%m-%Y %H:%i");
alter table events drop column occured_at;
alter table events change column tmp_occured_at occured_at datetime;


#------------------------------------------------------------
#create table 3 - email_events --------------------------------------------------------------
create table email_events (
user_id int,
occured_at varchar(100),
action varchar(100),
user_type int);

show variables like 'secure_file_priv';

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/email_events.csv"
into table email_events
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from email_events;

alter table email_events add column tmp_occured_at datetime;
update email_events set tmp_occured_at =  str_to_date(occured_at, "%d-%m-%Y %H:%i");
alter table email_events drop column occured_at;
alter table email_events change column tmp_occured_at occured_at datetime;


#qUERIES-----------------------------------
#TASK 1
SELECT YEAR(occured_at) AS year, WEEK(occured_at) AS week, user_id, COUNT(*) AS engagement_count
FROM events
GROUP BY YEAR(occured_at), WEEK(occured_at), user_id
ORDER BY year, week;


#TASK 2
SELECT YEAR(created_at) AS year, MONTH(created_at) AS month, COUNT(*) AS new_users
FROM users
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY year, month;


#TASK 3
WITH signup_weeks AS (
    SELECT user_id, YEAR(created_at) AS signup_year, WEEK(created_at) AS signup_week
    FROM users),
engagement_weeks AS (
    SELECT user_id, YEAR(occured_at) AS engagement_year, WEEK(occured_at) AS engagement_week
    FROM events)
SELECT s.signup_year, s.signup_week, e.engagement_year, e.engagement_week, 
	COUNT(DISTINCT e.user_id) AS retained_users
FROM signup_weeks s
JOIN engagement_weeks e ON s.user_id = e.user_id
WHERE 
    (e.engagement_year > s.signup_year OR 
    (e.engagement_year = s.signup_year AND e.engagement_week >= s.signup_week))
GROUP BY s.signup_year, s.signup_week, e.engagement_year, e.engagement_week
ORDER BY s.signup_year, s.signup_week, e.engagement_year, e.engagement_week;



#TASK 4
SELECT YEAR(occured_at) AS year, WEEK(occured_at) AS week, device,
    COUNT(*) AS engagement_count
FROM events
GROUP BY YEAR(occured_at), WEEK(occured_at), device
ORDER BY year, week, device;




#TASK 5
SELECT YEAR(occured_at) AS year, MONTH(occured_at) AS month, action,
    COUNT(*) AS action_count
FROM email_events
GROUP BY YEAR(occured_at), MONTH(occured_at), action
ORDER BY year, month, action;














