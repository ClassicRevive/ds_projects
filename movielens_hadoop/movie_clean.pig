/*Data Cleaning using Pig */
Movies_raw = LOAD 'data/movies_headerless.txt' using PigStorage('\t') as (movieId:chararray, title:chararray, genres:chararray);

-- split genres into a tuple
Movies_1 = FOREACH Movies_raw GENERATE movieId, title, STRSPLIT(genres, '\\|') as genres;

-- separate year from title (note that some titles have brackets in them, but the year is always the last bracket)
Mov_year = FOREACH Movies_1 GENERATE movieId, SUBSTRING($1, 0, LAST_INDEX_OF($1, '(')) as title:chararray,
SUBSTRING($1, LAST_INDEX_OF($1, '(')+1, LAST_INDEX_OF($1, ')')) as year:chararray;

-- join year and title back into movies set
Movies_join = JOIN Movies_1 BY movieId, Mov_year BY movieId;

Movies_2 = FOREACH Movies_join GENERATE Movies_1::movieId as movieId, TRIM(Mov_year::title) as title, year, genres;

--DUMP Movies_2;
--DESCRIBE Movies_2;

-- check if the years are formatted correctly (years in form XXXX is considered valid)
-- Some movies don't have a year added. E.g., 171495, Cosmos 
Year_length = FOREACH Mov_year GENERATE movieId, title, SIZE(year) as yr_length;
Inv_year = FILTER Year_length BY yr_length is null or yr_length != 4;

Inv_year_group = Group Inv_year All;
Inv_year_len = FOREACH Inv_year_group GENERATE COUNT(Inv_year.movieId);
--DUMP Inv_year_len;

-- Create separate table with cross product on genres
Movies_1_cross = FOREACH Movies_raw GENERATE movieId, title, FLATTEN(TOKENIZE(genres, '\\|')) as genre:chararray;
Mov_year_cross  = FOREACH Movies_1_cross GENERATE movieId, SUBSTRING($1, 0, LAST_INDEX_OF($1, '(')) as title:chararray,
SUBSTRING($1, LAST_INDEX_OF($1, '(')+1, LAST_INDEX_OF($1, ')')) as year:chararray, genre;
Movies_join_cross = JOIN Movies_1_cross BY (movieId, genre), Mov_year_cross BY (movieId, genre);
Movies_2_cross = FOREACH Movies_join_cross GENERATE Movies_1_cross::movieId as movieId, TRIM(Mov_year_cross::title) as title, 
year, Movies_1_cross::genre as genre;

M_out = LIMIT Movies_2_cross 10;
--DUMP M_out;


/* Data Analysis using Pig */
-- Title of the movie with the highest number of ratings
Ratings = LOAD 'data/ratings_headerless.txt' using PigStorage('\t') as (userId:chararray, movieId:chararray, rating:int, timestamp);
Grouped = GROUP Ratings BY movieId;
N_ratings = FOREACH Grouped GENERATE group, COUNT(Ratings) as n_ratings;

-- join n_ratings into Movies table, outter join as we want to keep movies with no ratings
Movies_join = JOIN Movies_2 BY movieId LEFT OUTER, N_ratings BY group;
Movies_n_rating = FOREACH Movies_join GENERATE $0 as movieId, $1 as title, $2 as year, $3 as genres, 
$5 as n_ratings;
Sorted = ORDER Movies_n_rating BY n_ratings DESC;
Sorted = FOREACH Sorted GENERATE movieId, title, n_ratings;
Top3 = LIMIT Sorted 3;
--DUMP Top3;
--DESCRIBE Top3;

-- Title of the most liked movie. Movie with the most 5 star ratings
Five_star = FILTER Ratings By rating == 5;
Grouped = Group Five_star BY movieId;
N_fs = FOREACH Grouped GENERATE group, COUNT(Five_star) as n_five_star;
Movies_join = JOIN Movies_2 BY movieId LEFT OUTER, N_fs BY group;
Movies_n_fstar = FOREACH Movies_join GENERATE $0 as movieId, $1 as title, $2 as year, $3 as genres, $5 as n_five_star;
Sorted = ORDER Movies_n_fstar BY n_five_star DESC;
Sorted = FOREACH Sorted GENERATE movieId, title, n_five_star;
Top3 = LIMIT Sorted 3;
--DUMP Top3;
--DESCRIBE Top3;

-- User with the highest average rating
Grouped = GROUP Ratings by userId;
Avg_rating = FOREACH Grouped GENERATE group, ROUND_TO(AVG(Ratings.rating), 4) as avg_rating;
Sorted = ORDER Avg_rating BY avg_rating DESC;
Top3 =  LIMIT Sorted 3;
--DUMP Top3;
--DESCRIBE Top3;

/* Export movie table for use in Hive */
STORE Movies_2 INTO 'data/movies_clean' USING PigStorage('\t');
STORE Movies_2_cross INTO 'data/genre_clean' using PigStorage('\t');

--DUMP M_out;
--DESCRIBE M_out;
