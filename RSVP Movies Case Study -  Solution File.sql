USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT count(*) as Director_Mapping_Rows
FROM director_mapping;

SELECT count(*) as Genre_Rows
FROM genre;

SELECT count(*) as Movie_Rows
FROM movie;

SELECT count(*) as Names_Rows
FROM names;

SELECT count(*) as Ratings_Rows
FROM ratings;

SELECT count(*) as Role_Mapping_Rows
FROM role_mapping;

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- FIRST APPROACH USING IS NULL FUNCTION :

SELECT count(*) AS ID_NULL_COUNT
FROM   movie 
WHERE  id IS NULL;

SELECT count(*) AS TITLE_NULL_COUNT
FROM   movie 
WHERE  title IS NULL;

SELECT count(*) AS YEAR_NULL_COUNT
FROM   movie 
WHERE  year IS NULL;

SELECT count(*) AS DATE_PUBLISHED_NULL_COUNT
FROM   movie 
WHERE  date_published IS NULL;

SELECT count(*) AS DURATION_NULL_COUNT
FROM   movie 
WHERE  duration IS NULL;

SELECT count(*) AS COUNTRY_NULL_COUNT
FROM   movie 
WHERE  country IS NULL;

SELECT count(*) AS WORLWIDE_GROSS_INCOME_NULL_COUNT
FROM   movie 
WHERE  worlwide_gross_income IS NULL;

SELECT count(*) AS LANGUAGES_NULL_COUNT
FROM   movie 
WHERE  languages IS NULL;

SELECT count(*) AS PRODUCTION_COMPANY_NULL_COUNT
FROM   movie 
WHERE  production_company IS NULL; 

-- SECOND APPROACH USING CASE FUNCTION:

SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS ID_NULL_COUNT,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS title_NULL_COUNT,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS year_NULL_COUNT,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS date_published_NULL_COUNT,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS duration_NULL_COUNT,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS country_NULL_COUNT,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS worlwide_gross_income_NULL_COUNT,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS languages_NULL_COUNT,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS production_company_NULL_COUNT
FROM   movie; 

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- To Find the Total Number of Movies Year Wise :

SELECT Year,
       count(id) as number_of_movies
FROM   movie
GROUP BY Year
ORDER BY Year;

-- To Find the Total Number of Movies Month Wise :

SELECT month(date_published) as month_num,
       count(id) as number_of_movies
FROM   movie
GROUP BY month_num
ORDER BY month_num; 



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT year,
       count(id) as Total_Movies_Produced
FROM movie
WHERE (country REGEXP 'USA' or country REGEXP 'INDIA') and year=2019;



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre 
FROM genre; 







/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre, 
	   count(movie_id) as Highest_Number_of_Movies
FROM  genre
GROUP BY genre
ORDER BY Highest_Number_of_Movies DESC limit 1; 










/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH Total_One_Genre_Movies AS
     (SELECT movie_id
	  FROM   genre
	  GROUP BY movie_id
	  HAVING count(DISTINCT genre) = 1)
SELECT count(*) as Total_Movies_By_Genre
FROM   Total_One_Genre_Movies;








/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT     genre,
           round(avg(duration),2) as avg_duration
FROM       genre g
INNER JOIN movie m
ON         m.id = g.movie_id
GROUP BY   genre
ORDER BY   avg_duration DESC;






/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


WITH Thriller_Movies_Rank AS 
(SELECT genre, 
	   count(movie_id) as movie_count,
       RANK() OVER (ORDER BY count(movie_id) DESC) as genre_rank
FROM  genre
GROUP BY genre)

SELECT *
FROM Thriller_Movies_Rank
WHERE genre = 'Thriller';








/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT min(avg_rating) as min_avg_rating,
       max(avg_rating) as max_avg_rating,
       min(total_votes) as min_total_votes,
       max(total_votes) as max_total_votes,
       min(median_rating) as min_median_rating,
       max(median_rating) as max_median_rating
FROM   ratings; 





    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH Top_10_Movies AS
(SELECT title,
		avg_rating,
		DENSE_RANK() OVER(ORDER BY avg_rating DESC) as movie_rank
FROM    movie m
	    INNER JOIN ratings r
		ON m.id = r.movie_id)
        
SELECT * 
FROM Top_10_Movies
WHERE movie_rank<=10;







/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
       count(movie_id) as movie_count
FROM   ratings
GROUP BY median_rating
ORDER BY movie_count DESC; 








/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH Production_Company_Hit_Movies AS
(SELECT production_company,
	 count(movie_id) as movie_count,
	 DENSE_RANK() OVER(ORDER BY count(movie_id) DESC) AS prod_company_rank
FROM movie m
	 INNER JOIN ratings r
	 ON m.id = r.movie_id
WHERE avg_rating > 8 and production_company IS NOT NULL
GROUP BY production_company)

SELECT *
FROM   Production_Company_Hit_Movies
WHERE  prod_company_rank = 1; 







-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
       count(m.id) as movie_count
FROM   movie m
       INNER JOIN genre g
	   ON m.id = g.movie_id
       INNER JOIN ratings r
	   ON m.id = r.movie_id
WHERE  month(date_published) = 3 and year = 2017 and total_votes > 1000 and country REGEXP 'USA'
GROUP BY genre
ORDER BY movie_count DESC; 







-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title,
       avg_rating,
       genre
FROM   movie m
       INNER JOIN genre g
	   ON m.id = g.movie_id
       INNER JOIN ratings r
	   ON m.id = r.movie_id
WHERE  avg_rating > 8 and title LIKE 'The%'
ORDER BY avg_rating DESC;







-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT count(*) as number_of_movies
FROM   movie m
       INNER JOIN ratings r
	   ON m.id = r.movie_id
WHERE  median_rating = 8 and date_published BETWEEN '2018-04-01' AND '2019-04-01';






-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT country, 
	   sum(total_votes) as Votes_By_country
FROM   movie m
	   INNER JOIN ratings r 
       ON m.id=r.movie_id
WHERE  country in ('Germany','Italy')
GROUP BY country
ORDER BY Votes_By_country DESC;





-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


SELECT Sum(CASE
             WHEN name IS NULL THEN 1
             ELSE 0
             END) AS name_nulls,
       Sum(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
             END) AS height_nulls,
       Sum(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
             END) AS date_of_birth_nulls,
       Sum(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
             END) AS known_for_movies_nulls
FROM   names; 





/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH Top_Three_Genres AS
(SELECT g.genre,
        count(m.id) as movie_count
FROM    genre g 
        INNER JOIN movie m 
        ON g.movie_id = m.id 
        INNER JOIN ratings r 
        ON m.id = r.movie_id  
WHERE avg_rating > 8
GROUP BY genre
ORDER BY movie_count DESC limit 3) 

SELECT name as director_name, 
       count(movie_id) as movie_count
FROM   director_mapping d 
       INNER JOIN names n
       ON n.id = d.name_id
       INNER JOIN genre g 
       using (movie_id) 
       INNER JOIN ratings r 
       using (movie_id) 
       INNER JOIN Top_Three_Genres 
       using (genre)
WHERE  avg_rating > 8
GROUP BY name
ORDER BY movie_count DESC limit 3;







/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT n.name as actor_name,
       count(rm.movie_id) as movie_count
FROM   role_mapping rm
       INNER JOIN names n
	   ON n.id = rm.name_id
       INNER JOIN movie m 
       ON m.id = rm.movie_id
       INNER JOIN ratings r
       ON m.id = r.movie_id
WHERE  category = 'ACTOR' and median_rating >= 8
GROUP BY actor_name
ORDER BY movie_count DESC limit 2;





/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company,
       sum(r.total_votes) as vote_count,
       DENSE_RANK() OVER (ORDER BY sum(r.total_votes) DESC) as prod_comp_rank
FROM   movie m 
       INNER JOIN ratings r 
       ON m.id = r.movie_id 
GROUP BY m.production_company 
ORDER BY prod_comp_rank limit 3;








/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.name as actor_name,
       sum(r.total_votes) as total_votes, 
       count(rm.movie_id) as movie_count,
       round (sum(avg_rating * total_votes)/sum(total_votes),2) as actor_avg_rating,
       DENSE_RANK() OVER (ORDER BY ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC) as actor_rank  
from   names n 
       INNER JOIN role_mapping rm 
       ON rm.name_id = n.id 
       INNER JOIN movie m 
       ON rm.movie_id = m.id 
       INNER JOIN ratings r 
       ON m.id = r.movie_id 
WHERE  category = 'Actor' AND country REGEXP 'India'
GROUP BY actor_name 
HAVING movie_count >=5;







-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT n.name as actress_name,
       sum(r.total_votes) as total_votes, 
       count(rm.movie_id) as movie_count,
       round (sum(avg_rating * total_votes)/sum(total_votes),2) as actress_avg_rating,
       DENSE_RANK() OVER (ORDER BY ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC) as actress_rank  
from   names n 
       INNER JOIN role_mapping rm 
       ON rm.name_id = n.id 
       INNER JOIN movie m 
       ON rm.movie_id = m.id 
       INNER JOIN ratings r 
       ON m.id = r.movie_id
WHERE  category = 'Actress' AND languages REGEXP 'Hindi'
GROUP BY actress_name 
HAVING movie_count >=3
ORDER BY actress_rank limit 5;






/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:





 







/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


WITH Genre_Wise_Details AS 
(SELECT g.genre, 
       round(avg(m.duration),2) as avg_duration 
FROM   genre g 
       INNER JOIN movie m 
       ON g.movie_id = m.id 
GROUP BY genre) 

SELECT *, 
        sum(avg_duration) OVER w1 as running_total_duration, 
        avg(avg_duration) OVER w2 as moving_avg_duration 
FROM    Genre_Wise_Details 
WINDOW  w1 as (ORDER BY genre), 
        w2 as (ORDER BY genre);   






-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies


        

WITH Top_Three_Genres AS 
(SELECT genre,
		count(movie_id) AS movie_count 
FROM    genre
GROUP BY genre
LIMIT 3
), 
Grossing_Movies AS 
(SELECT genre,
        year,
        title as movie_name,
        CAST(REPLACE(REPLACE(IFNULL(worlwide_gross_income, 0), 'INR', ''), '$', '') AS DECIMAL(10)) AS worldwide_gross_income,
        DENSE_RANK() OVER (PARTITION BY year ORDER BY CAST(REPLACE(REPLACE(IFNULL(worlwide_gross_income, 0), 'INR', ''), '$', '') AS DECIMAL(10)) DESC) as movie_rank
FROM    movie AS m
        INNER JOIN genre AS g
        ON m.id = g.movie_id
        WHERE genre IN (SELECT genre FROM Top_Three_Genres)
)
SELECT *
FROM Grossing_Movies
WHERE movie_rank <= 5
ORDER BY year;







-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT  m.production_company, 
        count(r.movie_id) as movie_count,
        DENSE_RANK() OVER (ORDER BY count(r.movie_id) DESC) AS prod_comp_rank 
FROM    movie m 
        INNER JOIN ratings r 
        ON m.id = r.movie_id  
WHERE   median_rating >=8 and production_company IS NOT NULL and Position(',' IN languages) > 0
GROUP BY m.production_company 
ORDER BY prod_comp_rank limit 2;
        
        






-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.name as actress_name, 
       sum(r.total_votes) as total_votes, 
       COUNT(rm.movie_id) as movie_count,  
       round(sum(avg_rating * total_votes)/sum(total_votes),2) AS actress_avg_rating, 
       DENSE_RANK() OVER (ORDER BY count(rm.movie_id) DESC) AS actress_rank
FROM   names n 
       INNER JOIN role_mapping rm 
       ON n.id = rm.name_id 
       INNER JOIN movie m 
       ON m.id = rm.movie_id 
       INNER JOIN genre g 
       ON g.movie_id = m.id
       INNER JOIN ratings r 
       ON r.movie_id = m.id 
WHERE  avg_rating > 8 and genre = 'Drama' and category = 'Actress'
GROUP BY actress_name 
ORDER BY actress_rank limit 3;








/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH Date_Summary AS 
(SELECT  d.name_id, 
         name, 
         d.movie_id, 
         duration, 
         r.avg_rating, 
         total_votes, 
         m.date_published, 
         Lead(date_published,1) OVER(PARTITION BY d.name_id ORDER BY date_published,movie_id ) as next_date_published 
FROM     director_mapping d 
         INNER JOIN names n 
         ON n.id = d.name_id 
         INNER JOIN movie m 
         ON m.id = d.movie_id 
         INNER JOIN ratings r 
         ON r.movie_id = m.id), 
Top_9_Directors_Summary AS 
( SELECT *,
         Datediff(next_date_published, date_published) as date_difference 
FROM Date_Summary) 
SELECT name_id as director_id, 
       name as director_name, 
       count(movie_id) as number_of_movies, 
       round(avg(date_difference),2) as avg_inter_movie_days, 
       round(avg(avg_rating),2) as avg_rating, 
       sum(total_votes) as total_votes, 
       min(avg_rating) as min_rating, 
       max(avg_rating) as max_rating, 
       sum(duration) as total_duration 
FROM   Top_9_Directors_Summary 
GROUP BY director_id 
ORDER BY  number_of_movies DESC limit 9;





