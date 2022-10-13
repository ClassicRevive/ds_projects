SELECT genre, rating, count(*) as n_ratings
FROM movies_genre t1 LEFT JOIN ratings t2 on t1.movieId == t2.movieId
GROUP BY genre, rating
ORDER BY rating;