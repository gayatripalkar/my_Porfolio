#this file is for Project 3  - Operation and metric spike - Case study 1


use project3_metric;

select * from job_data;

#insert more recods into data
INSERT INTO job_data (job_id, actor_id, event, language, time_spent, org, ds)
VALUES
(101, 2001, 'skip', 'English', 30, 'A', '2020-11-01 01:00:00'),
(102, 2002, 'decision', 'Spanish', 25, 'B', '2020-11-01 02:00:00'),
(103, 2003, 'transfer', 'French', 20, 'C', '2020-11-01 03:00:00'),
(104, 2004, 'skip', 'English', 15, 'A', '2020-11-02 01:00:00'),
(105, 2005, 'decision', 'Spanish', 35, 'B', '2020-11-02 02:00:00'),
(106, 2006, 'transfer', 'French', 40, 'C', '2020-11-02 03:00:00'),
(107, 2007, 'skip', 'English', 45, 'A', '2020-11-03 01:00:00'),
(108, 2008, 'decision', 'Spanish', 50, 'B', '2020-11-03 02:00:00'),
(109, 2009, 'transfer', 'French', 55, 'C', '2020-11-03 03:00:00'),
(110, 2010, 'skip', 'English', 60, 'A', '2020-11-04 01:00:00');


INSERT INTO job_data (job_id, actor_id, event, language, time_spent, org, ds)
VALUES
(111, 2011, 'skip', 'German', 25, 'D', '2020-11-04 01:00:00'),
(112, 2012, 'decision', 'Italian', 30, 'E', '2020-11-05 01:00:00'),
(113, 2013, 'transfer', 'Russian', 35, 'F', '2020-11-06 01:00:00'),
(114, 2014, 'skip', 'German', 40, 'D', '2020-11-07 01:00:00'),
(115, 2015, 'decision', 'Italian', 45, 'E', '2020-11-08 01:00:00'),
(116, 2016, 'transfer', 'Russian', 50, 'F', '2020-11-09 01:00:00'),
(117, 2017, 'skip', 'German', 55, 'D', '2020-11-10 01:00:00'),
(118, 2018, 'decision', 'Italian', 60, 'E', '2020-11-11 01:00:00'),
(119, 2019, 'transfer', 'Russian', 65, 'F', '2020-11-12 01:00:00'),
(120, 2020, 'skip', 'German', 70, 'D', '2020-11-13 01:00:00');


INSERT INTO job_data (job_id, actor_id, event, language, time_spent, org, ds)
VALUES
(121, 2021, 'skip', 'Chinese', 75, 'G', '2020-11-14 01:00:00'),
(122, 2022, 'decision', 'Japanese', 80, 'H', '2020-11-15 01:00:00'),
(123, 2023, 'transfer', 'Korean', 85, 'I', '2020-11-16 01:00:00'),
(124, 2024, 'skip', 'Chinese', 90, 'G', '2020-11-17 01:00:00'),
(125, 2025, 'decision', 'Japanese', 95, 'H', '2020-11-18 01:00:00'),
(126, 2026, 'transfer', 'Korean', 100, 'I', '2020-11-19 01:00:00'),
(127, 2027, 'skip', 'Chinese', 105, 'G', '2020-11-20 01:00:00'),
(128, 2028, 'decision', 'Japanese', 110, 'H', '2020-11-21 01:00:00'),
(129, 2029, 'transfer', 'Korean', 115, 'I', '2020-11-22 01:00:00'),
(130, 2030, 'skip', 'Chinese', 120, 'G', '2020-11-23 01:00:00');



INSERT INTO job_data (job_id, actor_id, event, language, time_spent, org, ds)
VALUES
(131, 2031, 'skip', 'English', 30, 'A', '2020-11-23 01:00:00'),
(131, 2031, 'skip', 'English', 30, 'A', '2020-11-23 01:00:00'), -- Duplicate record
(132, 2032, 'decision', 'Spanish', 25, 'B', '2020-11-24 02:00:00'),
(132, 2032, 'decision', 'Spanish', 25, 'B', '2020-11-24 02:00:00'), -- Duplicate record
(133, 2033, 'transfer', 'French', 20, 'C', '2020-11-25 03:00:00'),
(133, 2033, 'transfer', 'French', 20, 'C', '2020-11-25 03:00:00'); -- Duplicate record



#task1
SELECT DATE(ds) AS date, HOUR(ds) AS hour, COUNT(*) AS jobs_reviewed
FROM job_data
WHERE ds BETWEEN '2020-11-01' AND '2020-11-30'
GROUP BY DATE(ds), HOUR(ds)
ORDER BY date, hour;




#task2
WITH daily_events AS (
    SELECT DATE(ds) AS date, COUNT(*) AS events
    FROM job_data
    GROUP BY DATE(ds)
)
SELECT date, events,
       AVG(events) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS 7day_avg_throughput
FROM daily_events;

#task2_2
SELECT DATE(ds) AS date, COUNT(*) AS daily_events
FROM job_data
GROUP BY DATE(ds)
ORDER BY date;

#task 2 complete  - both in one table
WITH daily_events AS (
    SELECT DATE(ds) AS date, COUNT(*) AS events
    FROM job_data
    GROUP BY DATE(ds)
)
SELECT date, 
       events AS daily_events,
       ROUND(AVG(events) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS 7_day_avg_throughput
FROM daily_events
ORDER BY date;



#task3
SELECT language, 
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),2) AS percent_share
FROM job_data
WHERE ds >= DATE_SUB((SELECT MAX(ds) FROM job_data), INTERVAL 30 DAY)
GROUP BY language
ORDER BY percent_share DESC;




#task4
SELECT job_id, actor_id, event, language, time_spent, org, ds, COUNT(*)
FROM job_data
GROUP BY job_id, actor_id, event, language, time_spent, org, ds
HAVING COUNT(*) > 1;
