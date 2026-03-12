/* task 1 */

use db_course_conversions;


SELECT username, created_at
FROM users
ORDER BY created_at
LIMIT 5;


/* task 2 - joins users and photos*/
SELECT u.id, u.username
FROM users u
LEFT JOIN photos p ON u.id = p.user_id
WHERE p.id IS NULL;



/* task 3 - join photo and users and likes tables */

SELECT photo_id, COUNT(*) AS like_count
FROM likes
GROUP BY photo_id
order by like_count desc
limit 1;



SELECT u.id, u.username, p.id AS photo_id, MAX(photo_likes.like_count) AS max_likes
FROM users u
JOIN photos p ON u.id = p.user_id
JOIN (
    SELECT photo_id, COUNT(*) AS like_count
    FROM likes
    GROUP BY photo_id
) AS photo_likes ON p.id = photo_likes.photo_id
ORDER BY photo_likes.like_count DESC
LIMIT 1;

SELECT u.id, u.username, p.id AS photo_id, MAX(photo_likes.like_count) AS max_likes
FROM users u
JOIN photos p ON u.id = p.user_id
JOIN (
    SELECT photo_id, COUNT(*) AS like_count
    FROM likes
    GROUP BY photo_id
) AS photo_likes ON p.id = photo_likes.photo_id
GROUP BY u.id, u.username, p.id
ORDER BY max_likes DESC
LIMIT 1;



/* task 4 - join photo s, photo_tags and tags, check for count of tags used*/
select * from tags;

SELECT t.tag_name, COUNT(pt.tag_id) AS tag_count
FROM photo_tags pt
JOIN tags t ON pt.tag_id = t.id
GROUP BY t.tag_name
ORDER BY tag_count DESC
LIMIT 5;







/* task 5 -  */

SELECT 
    DAYNAME(created_at) AS registration_day,
    COUNT(*) AS number_of_registrations
FROM 
    users
GROUP BY 
    registration_day
ORDER BY 
    number_of_registrations DESC
LIMIT 1;





/* task 6 -  */


SELECT
    p.total_photos / u.total_users AS average_posts_per_user
FROM
    (SELECT COUNT(*) AS total_photos FROM photos) p,
    (SELECT COUNT(*) AS total_users FROM users) u;






/* task 7 -  */


SELECT l.user_id, COUNT(l.photo_id) AS likes_count
FROM likes l
GROUP BY l.user_id
HAVING COUNT(l.photo_id) = (SELECT COUNT(*) FROM photos);
