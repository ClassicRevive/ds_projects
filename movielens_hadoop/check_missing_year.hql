-- Check missing years: should be 13 to align with Pig

SELECT COUNT(*) FROM movies
WHERE year is NULL;
