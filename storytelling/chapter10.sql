-- STATISTICAL FUNCTIONS IN SQL
CREATE TABLE acs_2011_2015_stats(
    geoid VARCHAR(14) CONSTRAINT geoid_key PRIMARY KEY,
    county VARCHAR(50) not null,
    st VARCHAR(20) NOT NULL,
    pct_travel_60_min NUMERIC(5,3) NOT NULL,
    pct_bachelors_higher NUMERIC(5,3) NOT NULL,
    pct_masters_higher NUMERIC(5,3) NOT NULL,
    median_hh_income INTEGER,
    CHECK (pct_masters_higher <= pct_bachelors_higher)
);

\COPY acs_2011_2015_stats FROM 'C:\Users\julie\Desktop\Machuche\acs_2011_2015_stats.csv' WITH (FORMAT csv, HEADER TRUE, DELIMITER ',');

SELECT * FROM acs_2011_2015_stats;



-- watching the correlation
-- between two different variables,
-- using the CORR(x, y), as the value gets closer to 1,
-- the relationship between two variables gets closer
SELECT
    Round(corr(pct_bachelors_higher, median_hh_income)::NUMERIC,2),
    CORR(pct_travel_60_min, pct_bachelors_higher  ),
    CORR(pct_bachelors_higher, pct_masters_higher),
    Corr(pct_travel_60_min, median_hh_income) 
    FROM acs_2011_2015_stats;



-- PREDICTING VALUES WITH REGRESSION
-- standard SQL have functions that performs linear regression
to get the approximate change in one variable given the certain change in another,
Using linear regression with the function say Y = mX + B
where m is the slope, and B is the intercept
-- sql uses the linear regression functions to solve this problem
SELECT ROUND(
    REGR_SLOPE(median_hh_income, pct_bachelors_higher)::numeric, 2 
    ) as Slope,
    ROUND(
        REGR_INTERCEPT(median_hh_income, pct_bachelors_higher)::numeric, 2
    ) as Intercept
    FROM acs_2011_2015_stats;

-- This means, for every 1 increase in degree percentage, we expect an increase of 926.95 in the household_income,
-- The place where the pct_bachelors_hiher is 0, the household_income is 27901.15
now we use the result to get our result, for a percentage increase of 30% in degree holders and higher,
-- How much increase in others should we expect?

select (ROUND(
    REGR_SLOPE(median_hh_income, pct_bachelors_higher)::numeric, 2 
    ) * 30) + ROUND(
        REGR_INTERCEPT(median_hh_income, pct_bachelors_higher)::numeric, 2
    )
FROM acs_2011_2015_stats;

-- in a country where 30% of people have degree or higher, we expect that their income level
-- is around 55,709.65$

-- the correlation of 0.68 proves that education is not the only metrics, other factors also align up for the net median_hh_income



-- FINDING THE EFFECT OF AN INDEPENDENT VARIABLE WITH R-SQUARED
-- using standard deviation it means
-- R squared is called the coefficient of Determination of a data value

-- eg: if r-squared is 1, we would say the independent variable explains 10% of the variation in the dependent variable or not much at all,
-- finding the r-squared, we use the REGR_R2(Y, X ) in SQL


SELECT ROUND(
    REGR_R2(median_hh_income, pct_bachelors_higher)::NUMERIC, 3
) from acs_2011_2015_stats;


SELECT ROUND(
    CORR(median_hh_income, pct_bachelors_higher)::NUMERIC, 3
) from acs_2011_2015_stats;

-- this means, the 47% of variation in the median_hh_income can be explained by using data from people with a bachelors degree
-- what about the rest 53%? should be explained by other values and constituents
-- Staticians will test a numerous number of values to determine what they are which explains the rest 53% of data


-- POINTS ON CORRELATION VALUES
1. Correlation doesn't prove casualty'
2. Statisticians always employ other regression analysis techniques and analysis techniques
-- to make the value acceptable



-- CREATING RANKINGS WITH SQL
-- Ranks helps in creating data which are useful for reporting, from sport teams positions to
-- school grading systems
-- RANKS helps creating reports which translates more to the ears of the Users

-- RANKING with RANK() AND DENSE_RANK()
-- standard ANSI includes a lot of ranking functions but we will focus more on RANK() and DENSE_RANK()
-- which performs calculations across a set of rows we specify using the OVER clause
-- These are called window functions, they present result for each row in the table

-- difference between RANK() and DENSE_RANK()
-- the difference is on the ways they handle data,
--



RANK AND DENSE_RANK() QUERY STRUCTURE
SELECT RANK() OVER ( GROUP BY 


select CORR(pct_travel_60_min, pct_masters_higher) from acs_2011_2015_stats


select ROUND(CORR(pct_travel_60_min, pct_masters_higher)::numeric,2) from acs_2011_2015_stats


SELECT
round(
corr(median_hh_income, pct_bachelors_higher)::numeric, 2
) AS bachelors_income_r,
round(
corr(pct_travel_60_min, median_hh_income)::numeric, 2
) AS income_travel_r,
round(
corr(pct_travel_60_min, pct_bachelors_higher)::numeric, 2
) AS bachelors_travel_r
FROM acs_2011_2015_stats;


SELECT regr_slope(median_hh_income, pct_bachelors_higher),
regr_intercept(median_hh_income, pct_bachelors_higher) 
from acs_2011_2015_stats;

SELECT
round(
regr_r2(median_hh_income, pct_bachelors_higher)::numeric, 2
) AS bachelors_income_r
FROM acs_2011_2015_stats;

SELECT
round(
regr_r2(median_hh_income, pct_bachelors_higher)::numeric, 2
) AS bachelors_income_r,
round(
corr(median_hh_income, pct_bachelors_higher)::numeric, 2
) AS bachelors_income_corr
FROM acs_2011_2015_stats;

create table widget_companies(
    id bigserial,
    company varchar(30) not null,
    widget_output integer not null
)

INSERT INTO widget_companies (company, widget_output)
VALUES
('Morse Widgets', 125000),
('Springfield Widget Masters', 143000),
('Best Widgets', 196000),
('Acme Inc.', 133000),
('District Widget Inc.', 201000),
('Clarke Amalgamated', 620000),
('Stavesacre Industries', 244000),
('Bowers Widget Emporium', 201000);


SELECT company, widget_output,
rank() over (order by widget_output DESC),
dense_rank() over (order by widget_output DESC)

 from widget_companies;

    -- RANK() and DENSE_RANK() are used to create rankings for the widget companies
    -- rank() is used often since it reflects the total number of widgets and items in a collection

-- RANKING WITHIN SUBGROUPS USING PARTITION BY 
-- we can also use the PARTITION BY clause to create rankings within subgroups


CREATE TABLE store_sales(
    store varchar(30),
    category varchar(30) not null,
    unit_sales bigint not null,
    constraint store_category_key primary key(store, category)
);

insert into store_sales(store, category, unit_sales) 
values
('Broders', 'Cereal', 1104),
('Wallace', 'Ice Cream', 1863),
('Broders', 'Ice Cream', 2517),
('Cramers', 'Ice Cream', 2112),
('Broders', 'Beer', 641),
('Cramers', 'Cereal', 1003),
('Cramers', 'Beer', 640),
('Wallace', 'Cereal', 980),
('Wallace', 'Beer', 988);

SELECT category, unit_sales, store,
rank() over (PARTITION by category ORDER BY unit_sales DESC)
FROM store_sales;

--USING RATES IN DATA COMPARISON

CREATE TABLE fbi_crime_data_2015 (
st varchar(20),
city varchar(50),
population integer,
violent_crime integer,
property_crime integer,
burglary integer,
larceny_theft integer,
motor_vehicle_theft integer,
CONSTRAINT st_city_key PRIMARY KEY (st, city)
);

\COPY fbi_crime_data_2015
FROM 'C:\Users\julie\Desktop\Machuche\fbi_crime_data_2015.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');


SELECT * FROM fbi_crime_data_2015;

select city, st, population, property_crime, 
round(
    (property_crime::numeric / population) * 1000, 2
) as pc_per_1000
from fbi_crime_data_2015
where population > 500000
order by (property_crime::numeric / population) DESC;


select city, st, population, property_crime, 
round(
    (property_crime::numeric / population) * 100, 2
) as pc_per_100
from fbi_crime_data_2015
where population < 500000
order by (property_crime::numeric / population) DESC;


select corr(population, property_crime) from fbi_crime_data_2015;

select regr_slope(population, property_crime), regr_intercept(population, property_crime) from fbi_crime_data_2015;

select corr(median_hh_income, pct_masters_higher) from acs_2011_2015_stats;

select city, st, population, motor_vehicle_theft, 
round(
    (motor_vehicle_theft::numeric / population) * 1000, 2
) as mvt_per_100
from fbi_crime_data_2015
where population > 500000
order by (motor_vehicle_theft::numeric / population) DESC;


select city, violent_crime, population,
round(
    (violent_crime::numeric / population) * 1000, 2
) as vc_per_1000
from fbi_crime_data_2015
where population > 500000
order by (violent_crime::numeric / population) DESC;