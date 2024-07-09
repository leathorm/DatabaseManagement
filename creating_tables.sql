CREATE TABLE movies (
	movie_id SERIAL PRIMARY KEY,
	movie_title VARCHAR(255), 
	rel_date VARCHAR (255), 
	production_budget DOUBLE PRECISION, 
	worldwide_box_office DOUBLE PRECISION
);

CREATE TABLE directors (
	director_id SERIAL PRIMARY KEY, 
	director_name VARCHAR(255)
);

CREATE TABLE directedby (
	movie_id INT REFERENCES movies(movie_id),
    director_id INT REFERENCES directors(director_id)
);

CREATE TABLE genres (
	genre_id SERIAL PRIMARY KEY, 
	genre_name VARCHAR(255)
);

CREATE TABLE moviegenrelink (
	movie_id INT REFERENCES movies(movie_id),
    genre_id INT REFERENCES genres(genre_id)
);

CREATE TABLE actors (
	actor_id SERIAL PRIMARY KEY, 
	actor_name VARCHAR(255)
);

CREATE TABLE actedin (
	movie_id INT REFERENCES movies(movie_id),
    actor_id INT REFERENCES actors(actor_id)
);

CREATE TABLE ratings (
	rating_id SERIAL PRIMARY KEY, 
	rating_name VARCHAR(255)
);

CREATE TABLE movierating (
	movie_id INT REFERENCES movies(movie_id),
    rating_id INT REFERENCES ratings(rating_id)
);

CREATE TABLE studios (
	studio_id SERIAL PRIMARY KEY, 
	studio_name VARCHAR(255)
);

CREATE TABLE producedby (
	movie_id INT REFERENCES movies(movie_id),
    studio_id INT REFERENCES studios(studio_id)
);

CREATE TABLE reviews (
	rating_id SERIAL PRIMARY KEY,
	content VARCHAR (5000), 
	review_score DOUBLE PRECISION, 
	reviewer VARCHAR (255), 
	movie_id INT REFERENCES movies(movie_id)
);

 SELECT genres.genre_name, SUM(movies.worldwide_box_office) AS total_worldwide_box_office
    FROM genres
    JOIN moviegenrelink ON genres.genre_id = moviegenrelink.genre_id
    JOIN movies ON movies.movie_id = moviegenrelink.movie_id
    GROUP BY genres.genre_name
    ORDER BY total_worldwide_box_office DESC;

SELECT reviews.rating, SUM(movies.worldwide_box_office) as TOTAL_SALES 
    FROM reviews
    JOIN movies ON reviews.movie_id = movies.movie_id
    GROUP BY reviews.rating
    ORDER BY TOTAL_SALES DESC;

SELECT directors.director_name, AVG(m.worldwide_box_office) AS AVG_worldwide_box_office
    FROM movies m
    JOIN directedby db ON m.movie_id = db.movie_id
    JOIN directors ON db.director_id = directors.director_id
    GROUP BY directors.director_name
    ORDER BY AVG_worldwide_box_office DESC;

SELECT rel_date,
    SUM(worldwide_box_office) AS total_box_office,
    SUM(worldwide_box_office) / (SELECT SUM(worldwide_box_office) FROM movies) * 100 AS box_office_percentage
    FROM movies
    GROUP BY rel_date
    ORDER BY total_box_office DESC LIMIT(12)

SELECT rel_date, SUM(worldwide_box_office) AS SUM_worldwide_box_office
                FROM movies
                GROUP BY rel_date
                ORDER BY SUM_worldwide_box_office DESC
                LIMIT (12);

SELECT ratings.rating_name, AVG(movies.worldwide_box_office) AS average_worldwide_box_office
            FROM ratings
            JOIN movierating ON movierating.rating_id = ratings.rating_id
            JOIN movies ON movies.movie_id = movierating.movie_id
            GROUP BY ratings.rating_name
            ORDER BY average_worldwide_box_office DESC;

SELECT movie_title, production_budget, worldwide_box_office,
                (worldwide_box_office - production_budget) AS profit,
                CASE
                WHEN worldwide_box_office > 0 THEN (production_budget / worldwide_box_office) * 100
                ELSE 0
                END AS percentage_production_cost
                FROM movies;


SELECT movie_title, production_budget, worldwide_box_office, 
                (worldwide_box_office - production_budget) AS profit,
                CASE
                WHEN worldwide_box_office > 0 THEN (production_budget / worldwide_box_office) * 100
                ELSE 0
                END AS percentage_production_cost
                FROM
                    movies
                ORDER BY
                    profit DESC LIMIT (10);


SELECT actors.actor_name, SUM(movies.worldwide_box_office) AS total_worldwide_box_office
    FROM actors
    JOIN actedin ON actors.actor_id = actedin.actor_id
    JOIN movies ON movies.movie_id = actedin.movie_id
    GROUP BY actors.actor_name
    ORDER BY total_worldwide_box_office DESC;






