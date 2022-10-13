/* movies */
LOAD DATA INPATH '/user/hive/warehouse/movie_lens/movies_clean.txt' INTO TABLE movies;

/* ratings */
LOAD DATA INPATH '/user/hive/warehouse/movie_lens/ratings_headerless.txt' INTO TABLE ratings;

/* movies_genre cross */
LOAD DATA INPATH '/user/hive/warehouse/movie_lens/movies_genre.txt' INTO TABLE movies_genre;
