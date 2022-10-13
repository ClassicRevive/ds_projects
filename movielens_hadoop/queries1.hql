-- Query 1, highest number of ratings
SELECT t1.movieId, title, n_rating
FROM movies t1 LEFT JOIN (
    SELECT movieId, COUNT(rating) as n_rating
    FROM ratings
    GROUP BY movieId) t2 on t1.movieId == t2.movieId
ORDER BY n_rating DESC LIMIT 3;

-- Query 2, most liked movie (here I got the top 3 movies in terms of number of 5-star ratings )
SELECT t1.movieId, title, n_fs
FROM movies t1 LEFT JOIN (
    SELECT movieId, COUNT(rating) as n_fs
    FROM ratings
    WHERE rating == 5
    GROUP BY movieId) t2 on t1.movieId == t2.movieId
ORDER BY n_fs DESC LIMIT 3;

-- Query 3, most liked movie (here I got the top 3 movies in terms of number of 5-star ratings )
SELECT userId, ROUND(AVG(rating), 4) as avg_rating
FROM ratings
GROUP BY userId
ORDER BY avg_rating DESC LIMIT 3;