SELECT * from nyc_yellow_taxi_trips_2016_06_01 where fare_amount >= (
    select PERCENTILE_CONT(0.9) WITHIN GROUP(ORDER BY fare_amount)
    FROM nyc_yellow_taxi_trips_2016_06_01
);

-- in above USES The subquery to get the top 10% charged trips
-- the inner subquery returns a value 29 on its own, this is useful in case of data change etc

-- DELETING VALUES USING A SUBQUERY
-- We can use a subquery to get the top 10% charged trips and create a table on its own

create table nyc_taxi_top_10 
as Select * from nyc_yellow_taxi_trips_2016_06_01


delete from nyc_taxi_top_10
where fare_amount < (
    select PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY fare_amount)
    from nyc_taxi_top_10
)

select count(*) from nyc_taxi_top_10;
select count(*) from nyc_yellow_taxi_trips_2016_06_01

-- the values for queries show that one is 100% and the next is only 10%


-- CREATING DERIVED TABLES FROM SUBQUERIES
-- a derived table is the one that is used as a comparison for other 
-- subqueries help us create a derived tables and use them for 
-- querying other tables directly
-- here we compare the median and average values,
-- we derive first a table with them and the use the table as a 
-- derived table to get the values
select ROUND(calcs.average, 1) - calcs.median
from (
    select avg(fare_amount) as average,
    PERCENTILE_CONT(.5) within GROUP (order by fare_amount) as median
    from nyc_yellow_taxi_trips_2016_06_01
) as calcs

select ROUND(calcs.average, 1) - calcs.median
from (
    select avg(fare_amount) as average,
    PERCENTILE_CONT(.5) within GROUP (order by fare_amount)::numeric(10,1) as median
    from nyc_yellow_taxi_trips_2016_06_01
) as calcs


-- SYNTAX
select [columns]
from (subquery) as alias

-- JOINING DERIVED TABLES SINCE THEY FUNCTION LIKE REGULAR TABLES

meat_poultry_egg_inspect

select * from state_regions

JOINING SUBQUERIES FOR DERIVED TABLES syntax

SELECT [columns]
FROM
(SUBQUERY) AS alias_one
JOIN (SUBQUERY) AS alias_two
ON alias_one.conditions = alias_two.conditions



-- selecting column values with subquery
select 
fare_amount,
(
    select PERCENTILE_CONT(.9) within group (order by fare_amount) from nyc_taxi_top_10
    ) as median_fare
from nyc_taxi_top_10


-- CHANGING IT TO GIVE MORE USEFUL INFORMATION, DIFF FROM MEDIAN
select 
fare_amount,
fare_amount - (
    select PERCENTILE_CONT(.9) within group (order by fare_amount) from nyc_taxi_top_10
    ) as median_fare_diff
from nyc_taxi_top_10


-- the us counties anfd census data for analysis due to query dependencies
CREATE TABLE us_counties_2000 (
    geo_name varchar(90),              -- County/state name,
    state_us_abbreviation varchar(2),  -- State/U.S. abbreviation
    state_fips varchar(2),             -- State FIPS code
    county_fips varchar(3),            -- County code
    p0010001 integer,                  -- Total population
    p0010002 integer,                  -- Population of one race:
    p0010003 integer,                      -- White Alone
    p0010004 integer,                      -- Black or African American alone
    p0010005 integer,                      -- American Indian and Alaska Native alone
    p0010006 integer,                      -- Asian alone
    p0010007 integer,                      -- Native Hawaiian and Other Pacific Islander alone
    p0010008 integer,                      -- Some Other Race alone
    p0010009 integer,                  -- Population of two or more races
    p0010010 integer,                  -- Population of two races
    p0020002 integer,                  -- Hispanic or Latino
    p0020003 integer                   -- Not Hispanic or Latino:
);

\COPY us_counties_2000 FROM 'C:\Users\julie\Desktop\Machuche\us_counties_2000.csv' WITH (FORMAT CSV, HEADER);


CREATE TABLE us_counties_2010 (
    geo_name varchar(90),                    -- Name of the geography
    state_us_abbreviation varchar(2),        -- State/U.S. abbreviation
    summary_level varchar(3),                -- Summary Level
    region smallint,                         -- Region
    division smallint,                       -- Division
    state_fips varchar(2),                   -- State FIPS code
    county_fips varchar(3),                  -- County code
    area_land bigint,                        -- Area (Land) in square meters
    area_water bigint,                        -- Area (Water) in square meters
    population_count_100_percent integer,    -- Population count (100%)
    housing_unit_count_100_percent integer,  -- Housing Unit count (100%)
    internal_point_lat numeric(10,7),        -- Internal point (latitude)
    internal_point_lon numeric(10,7),        -- Internal point (longitude)

    -- This section is referred to as P1. Race:
    p0010001 integer,   -- Total population
    p0010002 integer,   -- Population of one race:
    p0010003 integer,       -- White Alone
    p0010004 integer,       -- Black or African American alone
    p0010005 integer,       -- American Indian and Alaska Native alone
    p0010006 integer,       -- Asian alone
    p0010007 integer,       -- Native Hawaiian and Other Pacific Islander alone
    p0010008 integer,       -- Some Other Race alone
    p0010009 integer,   -- Population of two or more races
    p0010010 integer,   -- Population of two races:
    p0010011 integer,       -- White; Black or African American
    p0010012 integer,       -- White; American Indian and Alaska Native
    p0010013 integer,       -- White; Asian
    p0010014 integer,       -- White; Native Hawaiian and Other Pacific Islander
    p0010015 integer,       -- White; Some Other Race
    p0010016 integer,       -- Black or African American; American Indian and Alaska Native
    p0010017 integer,       -- Black or African American; Asian
    p0010018 integer,       -- Black or African American; Native Hawaiian and Other Pacific Islander
    p0010019 integer,       -- Black or African American; Some Other Race
    p0010020 integer,       -- American Indian and Alaska Native; Asian
    p0010021 integer,       -- American Indian and Alaska Native; Native Hawaiian and Other Pacific Islander
    p0010022 integer,       -- American Indian and Alaska Native; Some Other Race
    p0010023 integer,       -- Asian; Native Hawaiian and Other Pacific Islander
    p0010024 integer,       -- Asian; Some Other Race
    p0010025 integer,       -- Native Hawaiian and Other Pacific Islander; Some Other Race
    p0010026 integer,   -- Population of three races
    p0010047 integer,   -- Population of four races
    p0010063 integer,   -- Population of five races
    p0010070 integer,   -- Population of six races

    -- This section is referred to as P2. HISPANIC OR LATINO, AND NOT HISPANIC OR LATINO BY RACE
    p0020001 integer,   -- Total
    p0020002 integer,   -- Hispanic or Latino
    p0020003 integer,   -- Not Hispanic or Latino:
    p0020004 integer,   -- Population of one race:
    p0020005 integer,       -- White Alone
    p0020006 integer,       -- Black or African American alone
    p0020007 integer,       -- American Indian and Alaska Native alone
    p0020008 integer,       -- Asian alone
    p0020009 integer,       -- Native Hawaiian and Other Pacific Islander alone
    p0020010 integer,       -- Some Other Race alone
    p0020011 integer,   -- Two or More Races
    p0020012 integer,   -- Population of two races
    p0020028 integer,   -- Population of three races
    p0020049 integer,   -- Population of four races
    p0020065 integer,   -- Population of five races
    p0020072 integer,   -- Population of six races

    -- This section is referred to as P3. RACE FOR THE POPULATION 18 YEARS AND OVER
    p0030001 integer,   -- Total
    p0030002 integer,   -- Population of one race:
    p0030003 integer,       -- White alone
    p0030004 integer,       -- Black or African American alone
    p0030005 integer,       -- American Indian and Alaska Native alone
    p0030006 integer,       -- Asian alone
    p0030007 integer,       -- Native Hawaiian and Other Pacific Islander alone
    p0030008 integer,       -- Some Other Race alone
    p0030009 integer,   -- Two or More Races
    p0030010 integer,   -- Population of two races
    p0030026 integer,   -- Population of three races
    p0030047 integer,   -- Population of four races
    p0030063 integer,   -- Population of five races
    p0030070 integer,   -- Population of six races

    -- This section is referred to as P4. HISPANIC OR LATINO, AND NOT HISPANIC OR LATINO BY RACE
    -- FOR THE POPULATION 18 YEARS AND OVER
    p0040001 integer,   -- Total
    p0040002 integer,   -- Hispanic or Latino
    p0040003 integer,   -- Not Hispanic or Latino:
    p0040004 integer,   -- Population of one race:
    p0040005 integer,   -- White alone
    p0040006 integer,   -- Black or African American alone
    p0040007 integer,   -- American Indian and Alaska Native alone
    p0040008 integer,   -- Asian alone
    p0040009 integer,   -- Native Hawaiian and Other Pacific Islander alone
    p0040010 integer,   -- Some Other Race alone
    p0040011 integer,   -- Two or More Races
    p0040012 integer,   -- Population of two races
    p0040028 integer,   -- Population of three races
    p0040049 integer,   -- Population of four races
    p0040065 integer,   -- Population of five races
    p0040072 integer,   -- Population of six races

    -- This section is referred to as H1. OCCUPANCY STATUS
    h0010001 integer,   -- Total housing units
    h0010002 integer,   -- Occupied
    h0010003 integer    -- Vacant
);

SELECT * FROM us_counties_2010;

-- Listing 4-3: Importing Census data using COPY
-- Note! If you run into an import error here, be sure you downloaded the code and
-- data for the book according to the steps listed on page xxvii in the Introduction.
-- Windows users: Please check the Note on page xxvii as well.

\COPY us_counties_2010 FROM 'C:\Users\julie\Desktop\Machuche\us_counties_2010.csv' WITH (FORMAT CSV, HEADER);


-- ADVANCED TEXT SEARCH TECHNIQUES

-- select to_tsquery('Matching & Walking')

-- select a single value from subqueries
SELECT 
geo_name,
state_us_abbreviation,
p0010001,
(SELECT PERCENTILE_CONT(0.5) within group(order by p0010001) FROM us_counties_2010) as US_MEDIAN
FROM us_counties_2010;

-- selecting and comparing to get a more useful result
SELECT 
geo_name,
state_us_abbreviation,
p0010001 - (SELECT PERCENTILE_CONT(0.5) within group(order by p0010001) FROM us_counties_2010) as US_MEDIAN
FROM us_counties_2010

--CHECK THOSE FALLING WITHIN A BOUND OF 1000 TO THE MEDIAN
SELECT 
geo_name,
state_us_abbreviation,
p0010001 - (SELECT PERCENTILE_CONT(0.5) within group(order by p0010001) FROM us_counties_2010) as US_MEDIAN
FROM us_counties_2010
WHERE (p0010001 - (SELECT PERCENTILE_CONT(0.5) within group(order by p0010001) FROM us_counties_2010)) BETWEEN -1000 AND 1000

-- SUBQUERY EXPRESSIONS
-- here we are going to use only two subquery expressions IN, and EXISTS
-- SUBQUERY EXPRESSIONS,
-- these are used for conditional checking and see whether conditions are true or false,


-- here we deal with only 2 subquery expressions

-- GENERATING VALUES FOR THE IN OPERATOR
SELECT [columns] FROM
TABLE WHERE [matching_column_value] IN 
(subquery that returns the same column dtype)

-- also inverted using NOT IN OPERATOR
SELECT [columns] FROM
TABLE WHERE [matching_column_value] NOT IN 
(subquery that returns the same column dtype)
-- the challenge with IN and NOT IN OPERATORS is only the way to deal with NULL values
-- 

SELECT * FROM employees


select * from retirees

select * from employees
where id in (select id from employees where id < 3)

-- the presence of NULL values affect the in operator
-- using the NOT IN operator

select * from employees
where id not in (select id from employees where id < 3)


-- the presence of NULL values affect the in operator
select * from employees
where id not in (select id from employees where id < 3 union select null as dept_id)


-- The presence of NULL values in a subquery result set will cause a query with a
-- NOT IN expression to return no rows. If your data contains NULL values, use the
-- WHERE NOT EXISTS expression described in the next section.


select * from employees
where id exists (select id from employees where id < 3 union select null as dept_id)


select first_name, last_name from employees
where exists (
    select id from employees 
)


create table retirees as select * from employees where id < 3

select * from retirees


select first_name, last_name from employees
where exists (select id from retirees)


-- now filter conditionally, something inlinke in IN operator
select first_name, last_name from employees
where exists (
    select id from retirees
    where id = employees.id )

-- using the NOT EXISTS operator
-- useful for accessing data completeness
select first_name, last_name from employees
where not exists (
    select id from retirees
    where id = employees.id )

-- CTE / common table expressions
-- help us create temporary tables for data assessment in sql
-- also known as a WITH clause, it creates derived tables to be used
-- in sql statements and other data calculations

-- CTE syntax

WITH 
    [alias_table_name]
    ([columns to be selected or alias for column names])
    AS
    (
        SUBQUERY
    ) -- END OF THE TABLE DEFINITION
SELECT
[COLUMNS TO SELECT IN THE MAIN QUERY]
FROM [alias_table_names for both cte and main table]
WHERE [CONDITIONS] -- OPTIONALS FOLLOWING
JOIN
[TABLES OR CTES]
ON
[JOIN CONDITIONS]
-- other params to end the main query

-- in CTES there is no need to provide data types for tables, they inherit from
-- the subquery
-- the subquery must return the same number of columns, but columns names
-- must not match the ones in the CTE

WITH large_counties (geo_name, st, p0010001)
as
    (
        select geo_name, state_us_abbreviation, p0010001  from us_counties_2010 where p0010001 > 100000 
    )
select st, count(*)
from large_counties
group by st;

WITH large_counties (geo_name, st, p0010001)
as
    (
        select geo_name, state_us_abbreviation, p0010001  from us_counties_2010 where p0010001 > 100000 
    )
select *
from large_counties;

-- the column list is optional too if your are not renaming the columns

WITH large_counties 
as
    (
        select geo_name, state_us_abbreviation as st, p0010001  from us_counties_2010 where p0010001 > 100000 
    )
select st, count(*)
from large_counties
group by st
order by count(*) desc

-- why use CTE
--1. clean programming
--2. Allows to reuse the table in multle statements
--3. We gather the data before we do further calculations and we deal with our derived table easily

-- using multiple table CTES
with first_table
as (subquery1),
second_table
as (subquery2),
---
---,
nth_table
as (sunqueryN)
[main statement with joins and other invokations]

-- using CTE with scalar values
-- here we use the cross join to bind the value to each statement
-- this is easy since there are no a lot of data to work with
-- NB: Be careful whenever you apply cross joins
WITH
median_value AS
    (
        select percentile_cont(0.5) within group (order by p0010001 desc) as median_pop from us_counties_2010
    )
select * from us_counties_2010 cross join median_value
where p0010001 > median_pop;


-- CROSS TABULATIONS OR PIVOT TABLES
-- helps summarize data by placing them in a table or a matrix layout,
-- rows represent one variable and columns represent another variable
-- and in each row where they intersect, the cell holds a particular value
-- eg percentage or summation

-- eg. is when election results are tarried by geographic locations
-- eg Candidate name | Location1 | Location 2 | Location 3 | etc
--    candidate 1    | 288,3884  | 812        | 8983       | ..
--    candidate 2    | 3,3884    | 812        | 8983       | ..
--    candidate 3    | 14,3884   | 2,345      | 8983       | ..

-- in the actual table it might look like this
-- candidatename | LocationId | TotalVotes|


-- tabulations gives us a summary on the structure of data in the database
-- USING THE ICE CREAM TABLE TO LEARN CROSS TABULATIONS
CREATE TABLE ice_cream_survey(
    response_id INTEGER PRIMARY KEY,
    office VARCHAR(20),
    flavor VARCHAR(20)
);

-- IMPORT THE DATA
\COPY ice_cream_survey FROM 'C:\Users\julie\Desktop\Machuche\ice_cream_survey.csv' WITH (FORMAT CSV, HEADER)

SELECT * FROM ice_cream_survey LIMIT 5;

-- assess the report easily
select office,flavor, count(*)
from ice_cream_survey GROUP BY flavor, office
order by office, flavor
-- maybe we can present this more nicely

-- getting the flavor codes
SELECT flavor
FROM ice_cream_survey
GROUP BY flavor
ORDER BY flavor

-- now transform the flavors into columns and office into rows
-- using the crosstab FUNCTION
select *
from crosstab(
    'select 
    office, --row-names
    flavor, -- column values
    count(*) -- data for each cell
    from ice_cream_survey GROUP BY flavor, office
    order by office, flavor', 
    'SELECT flavor
    FROM ice_cream_survey
    GROUP BY flavor
    ORDER BY flavor' -- the second subquery is required to provide only a single column
    -- this column is required be the header provider
)
as(
    office varchar(20),
    Chocolate bigint,
    Strawberry bigint,
    vanilla bigint
); -- The definition of the columns list since this returns type record

-- diving into a more complex scenario
-- TEMPERATURE READINGS USING CROSSTAB FUNCTION

CREATE TABLE temperature_readings (
    reading_id bigserial,
    station_name varchar(50),
    observation_date date,
    max_temp integer,
    min_temp integer
);

-- import the data 
COPY 
temperature_readings 
(station_name, observation_date, max_temp, min_temp) 
FROM 'C:\Users\julie\Desktop\Machuche\temperature_readings.csv'
WITH (FORMAT CSV, HEADER);

-- get the monthly maximum temperature_readings
select 
    station_name, 
    date_part('month', observation_date),
    percentile_cont(0.5) within group (order by max_temp),
    from temperature_readings
    group by station_name, date_part('month', observation_date)
    order by station_name

-- generating a series of characters for month
select month from generate_series(1,12) month


select *
from crosstab(
    'select 
    station_name, 
    date_part(''month'', observation_date),
    percentile_cont(0.5) within group (order by max_temp)
    from temperature_readings
    group by station_name, date_part(''month'', observation_date)
    order by station_name',
    'select month from generate_series(1,12) month'
)
as(
    station varchar(50),
    jan numeric(3,0),
    feb numeric(3,0),
    mar numeric(3,0),
    apr numeric(3,0),
    may numeric(3,0),
    jun numeric(3,0),
    jul numeric(3,0),
    aug numeric(3,0),
    sep numeric(3,0),
    oct numeric(3,0),
    nov numeric(3,0),
    dec numeric(3,0)
);

-- do not that crosstab is very cpu intensive hence take caution
-- try with mininmum

select 
    station_name, 
    date_part('month', observation_date),
    percentile_cont(0.5) within group (order by max_temp) as max_temp,
    percentile_cont(0.5) within group (order by min_temp) as min_temp
    from temperature_readings
    group by station_name, date_part('month', observation_date)
    order by station_name

select month from generate_series(1,12) month

-- injecting a CTE into a crosstab function
with my_table as
(
select *
from crosstab(
    'select 
    station_name, 
    date_part(''month'', observation_date),
    percentile_cont(0.5) within group (order by min_temp) as min_temp
    from temperature_readings
    group by station_name, date_part(''month'', observation_date)
    order by station_name',
    'select month from generate_series(1,12) month'
)
as(
    station varchar(50),
    jan numeric(3,0),
    feb numeric(3,0),
    mar numeric(3,0),
    apr numeric(3,0),
    may numeric(3,0),
    jun numeric(3,0),
    jul numeric(3,0),
    aug numeric(3,0),
    sep numeric(3,0),
    oct numeric(3,0),
    nov numeric(3,0),
    dec numeric(3,0)
))
select * from my_table

-- currently no many values can be aggregated above


select 
    station_name, 
    date_part('month', observation_date),
    percentile_cont(0.5) within group (order by max_temp),
    from temperature_readings
    group by station_name, date_part('month', observation_date)
    order by station_name

-- RECLASSIFYING VALUES WITH CASE
-- using the case statement to tell reports in a more summarized way,
-- and simple is more useful
-- here we use the case statement


-- sql CASE is a conditional statement letting you add IF .. THEN .. ELSE ..
-- conditional checks into the database queries
-- allows you to create categories in your data and classify data depending on those categories

-- the sql case syntax
CASE WHEN condition THEN result
    WHEN another_condition THEN result
    ELSE result
END

-- first, checks if the condition is is met, if yes, the THEN result is given as the output
-- condition is any expression the database can evaluate as true or false
-- without an else clause the condition will return a null when no condition evaluates
-- to true

SELECT max_temp,
CASE WHEN max_temp >= 90 THEN 'Hot'
    WHEN max_temp BETWEEN 70 AND 89 THEN 'Warm'
    WHEN max_temp BETWEEN 50 AND 69 THEN 'Pleasant'
    WHEN max_temp BETWEEN 33 AND 49 THEN 'Cold'
    WHEN max_temp BETWEEN 20 AND 32 THEN 'Freezing'
    ELSE 'Inhumane'
END AS temperature_group
FROM temperature_readings;

-- select from the employees table
select * from employees

select first_name, last_name,
CASE 
    WHEN salary < 60000 THEN 'Underpaid'
    WHEN salary < 400000 THEN 'paid'
    WHEN salary > 400000 THEN 'Overpaid'
END AS salary_group
from employees;

-- using the CTE with a case statement to see how many values fall into each group

with temperature_groups AS
(
    SELECT 
    station_name,
    max_temp,
    CASE WHEN max_temp >= 90 THEN 'Hot'
        WHEN max_temp BETWEEN 70 AND 89 THEN 'Warm'
        WHEN max_temp BETWEEN 50 AND 69 THEN 'Pleasant'
        WHEN max_temp BETWEEN 33 AND 49 THEN 'Cold'
        WHEN max_temp BETWEEN 20 AND 32 THEN 'Freezing'
        ELSE 'Inhumane'
    END AS temperature_group
    FROM temperature_readings
)
select station_name, temperature_group, count(*)
from temperature_groups
group by temperature_group, station_name
order by station_name


-- more works with cross tabulations
-- make flavor rows and office columns in ice_cream_survey table

select * from ice_cream_survey

select flavor, office, count(*) from ice_cream_survey
GROUP BY flavor, office
ORDER BY flavor

select office from ice_cream_survey
group by office

select *
from 
crosstab(
    'select flavor, office, count(*) from ice_cream_survey
    GROUP BY flavor, office
    ORDER BY flavor',
    'select office from ice_cream_survey
    group by office order by office'
)
as(
    Flavor VARCHAR(20),
    Downtown bigint,
    Midtown bigint,
    Uptown bigint
)
-- when you dont specify the order, the crosstab helps you rearrange the columns


select * from temperature_readings where station_name ilike '%kiki%'

select count(*) from temperature_readings where station_name ilike '%kiki%'

