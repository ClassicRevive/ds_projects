-- Create movie table
CREATE TABLE IF NOT EXISTS movies (
    movieId string,
    title string,
    year int,
    genre string)
COMMENT 'Movie Table'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t';

-- Create ratings table
CREATE TABLE IF NOT EXISTS ratings (
    userId string,
    movieId string,
    rating int)
COMMENT 'Ratings Table'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t';

-- Create movies-genre table
CREATE TABLE IF NOT EXISTS movies_genre (
    movieId string,
    title string,
    year int,
    genre string)
COMMENT 'Movie Table'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t';