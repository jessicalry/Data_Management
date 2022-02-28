--1. Show the possible values of the year column in the country_stats table sorted by most recent year first.
select distinct year from country_stats order by year desc;

--2. Show the names of the first 5 countries in the database when sorted in alphabetical order by name.
select name from countries order by name asc limit 5;

--3. Adjust the previous query to show both the country name and the gdp from 2018, but this time show the top 5 countries by gdp.
select countries.name, country_stats.gdp
from countries inner join country_stats on (countries.country_id=country_stats.country_id)
where country_stats.year=2018
order by country_stats.gdp desc
limit 5;

--4. How many countries are associated with each region id?
select distinct regions.region_id, count(countries.name) as country_count
from countries inner join regions on (countries.region_id=regions.region_id)
group by regions.region_id
order by country_count desc;

--5. What is the average area of countries in each region id?
select region_id,round(avg(area)) as avg_area
from countries
group by region_id
order by avg_area;

--6. Use the same query as above, but only show the groups with an average country area less than 1000
select region_id,round(avg(area)) as avg_area
from countries
group by region_id
having round(avg(area))<1000
order by avg_area;

--7. Create a report displaying the name and population of every continent in the database from the year 2018 in millions.
select continents.name, cast(cast(sum(country_stats.population) as float)/1000000 as decimal(10,2)) as tot_pop
from continents
inner join regions on (regions.continent_id=continents.continent_id)
inner join countries on (regions.region_id=countries.region_id)
inner join country_stats on (countries.country_id=country_stats.country_id)
where country_stats.year=2018
group by continents.continent_id
order by tot_pop desc;

--8. List the names of all of the countries that do not have a language.
select countries.name
from countries
left join country_languages on (countries.country_id=country_languages.country_id)
group by countries.name
having count(country_languages.language_id)=0;

--9. Show the country name and number of associated languages of the top 10 countries with most languages
select countries.name, count(country_languages.language_id) as lang_count
from countries
left join country_languages on (countries.country_id=country_languages.country_id)
group by countries.name
order by lang_count desc
limit 10;

--10. Repeat your previous query, but display a comma separated list of spoken languages rather than a count (use the aggregate function for strings, string_agg. A single example row (note that results before and above have been omitted for formatting):
select countries.name, string_agg(languages.language,',')
from countries
left join country_languages on (countries.country_id=country_languages.country_id)
inner join languages on (country_languages.language_id=languages.language_id)
-- where countries.name='Kenya'
group by countries.name;
-- limit 10;

--11. What's the average number of languages in every country in a region in the dataset? Show both the region's name and the average. Make sure to include countries that don't have a language in your calculations. (Hint: using your previous queries and additional subqueries may be useful)
with n(region_name,country_language_count)
as (
    select regions.name,count(*)
    from country_languages
    inner join countries on (countries.country_id=country_languages.country_id)
    inner join regions on (countries.region_id=regions.region_id)
    group by regions.name
)
select r.name, round(cast(n.country_language_count as decimal)/count(c.name),1) as avg_lang_count_per_country
from countries c
inner join regions r on (c.region_id=r.region_id)
inner join n on (r.name=n.region_name)
group by r.name, n.country_language_count
order by avg_lang_count_per_country desc;


--12. Show the country name and its "national day" for the country with the most recent national day and the country with the oldest national day. Do this with a single query. (Hint: both subqueries and UNION may be helpful here).
select c.name, c.national_day
from countries as c
where c.national_day=(
    select max(c.national_day)
    from countries as c
)
UNION
select c1.name, c1.national_day
from countries as c1
where c1.national_day=(
    select min(c1.national_day)
    from countries as c1
)