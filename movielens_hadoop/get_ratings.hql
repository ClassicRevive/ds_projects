SELECT rating, COUNT(*)
FROM ratings
GROUP BY rating
ORDER BY rating;