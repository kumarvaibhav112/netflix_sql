create table netflix(
	show_id	varchar(10),
	type	varchar(10),
	title	varchar(150),
	director	varchar(220),
	casts	varchar(800),
	country	varchar(150),
	date_added	varchar(50),
	release_year	INT,
	rating	varchar(10),
	duration	varchar(15),
	listed_in	varchar(100),
	description	varchar(270)
);

SELECT * FROM netflix;

-- total number of movies and tv shows
SELECT type, count(*) as Total_set
from netflix
group by type;

-- checking top rating for movies and tv shows
select type,
rating
from(
select type,
rating,
rank() over(partition by type order by count(*) desc ) as ranking
from netflix
group by 1,2 
) as tp
where ranking = 1;

-- all the movies released in 2020
select * from netflix
where type = 'movie';

--top 5 countries with the most content on netflix
select 
	distinct(UNNEST(STRING_TO_ARRAY(country,','))) as new_country,
	count(*) as ct
	--count(show_id) as total
from netflix
group by 1
order by 2 desc
limit 5;
--longest movie

select * from netflix
	where 
	type = 'Movie'
	and 
	duration = (select max(duration) from netflix);

--content added in last 5 years 

select * from netflix 
where 
	TO_DATE(date_added, 'Month DD, YYYY') >= current_date - interval '5 years';

--select movies and tv shows done by 'Rajiv Chilaka'
select * from netflix 
where director like '%Rajiv Chilaka%';

--List all the Tv shows with more than 5 seasons
select * from netflix 
where 
	type = 'TV Show'
	and 
	split_part(duration,' ',1)::numeric > 5;

--count total number of content items in each genre
select 
 unnest(string_to_array(listed_in, ',')) as genre,
 count(show_id) as total_content
from netflix
group by 1;

--find each year the average number of content released by india and return top 5 year with avg content
select 
	extract(year from to_date(date_added, 'Month DD, YYYY')) as year,
	count(*) as yearly_content,
	round(count(*)::numeric / (select count(*) from netflix where country = 'India')::numeric * 100,2) as avg_content
	from netflix
where country = 'India'
group by 1;

--List all the movies that are documentareis
select
*
from netflix
where 
	listed_in ilike '%documentaries'

--find all the content without a director
select * from netflix
where director is Null;

--find how many movies salman khan acted in last 10 years 
select * from netflix 
where 
	casts ilike '%salman khan%'
	and
	release_year > extract(year from current_date) - 10;

--top 10 actors appeared in highest number of movies produced in india
select 
unnest(string_to_array(casts, ',')),
	count(*) as total_content
from netflix
where country ilike '%india'
group by 1
order by 2 desc
limit 10;














	

