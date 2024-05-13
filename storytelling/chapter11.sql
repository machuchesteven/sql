-- WORKING WITH DATE AND TIME
-- columns with dates and times can indicate when events happened and how long they took

select cast(now() as date) as todays_date, cast(now() as time) as current_time;

-- DATE AND TIME FUNCTIONS
-- date and time functions can be used to manipulate date and time values
select now()::timestamptz

-- getting the timezone from settings in pg
select current_setting('TIMEZONE');

-- extract date parts of a timestamptz
select date_part('week', now()) as week, date_part('year', now()) as year;


-- all parts of the todays date from the collection of the today


SELECT
    DATE_PART('year', NOW()) AS year,
    DATE_PART('month', NOW()) AS month,
    DATE_PART('day', NOW()) AS day,
    DATE_PART('hour', NOW()) AS hour,
    DATE_PART('minute', NOW()) AS minute,
    DATE_PART('second', NOW()) AS second,
    DATE_PART('millisecond', NOW()) AS millisecond,
    DATE_PART('microsecond', NOW()) AS microsecond,
    DATE_PART('timezone_hour', NOW()) AS timezone_hour,
    DATE_PART('timezone_minute', NOW()) AS timezone_minute,
    DATE_PART('quarter', NOW()) AS quarter,
    DATE_PART('week', now()) as week,
    DATE_PART('dow', now()) as day_of_week,
    DATE_PART('epoch', now()) as epoch;


SELECT EXTRACT('day' FROM NOW()) --EXTRACT USING THE EXTRACT FUNCTION
-- works like the date_part function

select now() + '5 months'::interval as next_moment

select now() + '5 days'::interval as next_splint

select now() - '5 months'::interval as prev_moment


select (now() - '2023-08-31'::timestamp)::interval


-- importing practice data
CREATE TABLE nyc_yellow_taxi_trips_2016_06_01 (
    trip_id bigserial PRIMARY KEY,
    vendor_id varchar(1) NOT NULL,
    tpep_pickup_datetime timestamp with time zone NOT NULL,
    tpep_dropoff_datetime timestamp with time zone NOT NULL,
    passenger_count integer NOT NULL,
    trip_distance numeric(8,2) NOT NULL,
    pickup_longitude numeric(18,15) NOT NULL,
    pickup_latitude numeric(18,15) NOT NULL,
    rate_code_id varchar(2) NOT NULL,
    store_and_fwd_flag varchar(1) NOT NULL,
    dropoff_longitude numeric(18,15) NOT NULL,
    dropoff_latitude numeric(18,15) NOT NULL,
    payment_type varchar(1) NOT NULL,
    fare_amount numeric(9,2) NOT NULL,
    extra numeric(9,2) NOT NULL,
    mta_tax numeric(5,2) NOT NULL,
    tip_amount numeric(9,2) NOT NULL,
    tolls_amount numeric(9,2) NOT NULL,
    improvement_surcharge numeric(9,2) NOT NULL,
    total_amount numeric(9,2) NOT NULL
);

SELECT * from nyc_yellow_taxi_trips_2016_06_01;


\COPY nyc_yellow_taxi_trips_2016_06_01 (
vendor_id,
tpep_pickup_datetime,
tpep_dropoff_datetime,
passenger_count,
trip_distance,
pickup_longitude,
pickup_latitude,
rate_code_id,
store_and_fwd_flag,
dropoff_longitude,
dropoff_latitude,
payment_type,
fare_amount,
extra,
mta_tax,
tip_amount,
tolls_amount,
improvement_surcharge,
total_amount
)
FROM 'C:\YourDirectory\yellow_tripdata_2016_06_01.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

-- data imported, now time to create an index on the pickup time column

create index idx_pickup_time ON nyc_yellow_taxi_trips_2016_06_01(tpep_pickup_datetime)


select count(*) from nyc_yellow_taxi_trips_2016_06_01;

select PERCENTILE_CONT(.5) WITHIN group (order by fare_amount ) from nyc_yellow_taxi_trips_2016_06_01

select PERCENTILE_CONT(.5) WITHIN group (order by fare_amount ),
    PERCENTILE_CONT(.5) WITHIN group (order by total_amount )
from nyc_yellow_taxi_trips_2016_06_01


select corr(trip_distance, total_amount) from nyc_yellow_taxi_trips_2016_06_01



select regr_r2(trip_distance, total_amount) from nyc_yellow_taxi_trips_2016_06_01


select regr_slope(trip_distance, total_amount) as slope,
    regr_intercept(trip_distance, total_amount) as slope
 from nyc_yellow_taxi_trips_2016_06_01


select PERCENTILE_CONT(.5) WITHIN group (order by trip_distance ) from nyc_yellow_taxi_trips_2016_06_01

-- here was a simple recap of the previous chapters functions


-- GET THE BUSIEST TIME OF THE DAY
SELECT
 date_part('hour', tpep_pickup_datetime) AS trip_hour,
 count(*)
FROM nyc_yellow_taxi_trips_2016_06_01
GROUP BY trip_hour
ORDER BY trip_hour;

-- GET THE BUSIEST DAY OF THE WEEK
SELECT
 date_part('dow', tpep_pickup_datetime) AS trip_day_of_week,
 count(*) AS trip_count
FROM nyc_yellow_taxi_trips_2016_06_01
GROUP BY trip_day_of_week
ORDER BY trip_day_of_week;

-- most arrival times
SELECT
 date_part('hour', tpep_dropoff_datetime) AS trip_hour,
 COUNT(*) AS trip_count
 FROM nyc_yellow_taxi_trips_2016_06_01
    GROUP BY trip_hour
    ORDER BY trip_hour;


select * From pg_timezone_names;

-- using minutes as comparison unit

select date_part('minute', tpep_pickup_datetime) as trip_minute,
count(*)
 from
nyc_yellow_taxi_trips_2016_06_01
group by trip_minute
order by trip_minute;

-- export the data for the BUSIEST hour for visualization
copy (
    SELECT date_part('hour', tpep_pickup_datetime) AS trip_hour,
    count(*)
    from nyc_yellow_taxi_trips_2016_06_01
    GROUP BY trip_hour
    order by trip_hour
) to 'C:\Users\julie\Desktop\data_time.csv' with (format csv, header, delimiter ',');


select PERCENTILE_CONT(1) within group (order by fare_amount) as median_fare from nyc_yellow_taxi_trips_2016_06_01;


select max(fare_amount) as max_fare, min(fare_amount) as min_fare from nyc_yellow_taxi_trips_2016_06_01;

-- Here the maximum amount gives 750 but minimum amount is negative, -175


-- calculating median trip time
select PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY tpep_dropoff_datetime - tpep_pickup_datetime) as median_trip_time,
COUNT(*) AS total_sample,
Sum(fare_amount) as total_fare,
date_part('hour', tpep_pickup_datetime) as trip_hour
 from nyc_yellow_taxi_trips_2016_06_01
 Group by trip_hour
 Order by trip_hour;


-- USING THE RAILWAY DATA TO LEARN PATTERN
-- here we deal with intervals more than anything else
-- we use on eof the railway route to learn dealing with intervals

-- armtrack data comes in different timezones,
-- we need to set the timezone to US/Central first before further processing


select * from pg_timezone_names where name like '%Dar%laam%'

-- reset the timezone, we use
set Timezone to 'Africa/Dar_es_Salaam';

-- set the timezone to US/Central first before further processing
set Timezone to 'US/Central';

CREATE TABLE train_rides(
    trip_id BIGSERIAL PRIMARY KEY,
    segment VARCHAR(50) NOT NULL,
    departure TIMESTAMP WITH TIME ZONE NOT NULL,
    arrival TIMESTAMP WITH TIME ZONE NOT NULL
);

INSERT INTO train_rides(segment, departure, arrival)
VALUES
    ('Chicago to New York', '2017-11-13 21:30 CST', '2017-11-14 18:23 EST'),
('New York to New Orleans', '2017-11-15 14:15 EST', '2017-11-16 19:32 CST'),
('New Orleans to Los Angeles', '2017-11-17 13:45 CST', '2017-11-18 9:00 PST'),
('Los Angeles to San Francisco', '2017-11-19 10:10 PST', '2017-11-19 21:24PST'),
('San Francisco to Denver', '2017-11-20 9:10 PST', '2017-11-21 18:38 MST'),
('Denver to Chicago', '2017-11-22 19:10 MST', '2017-11-23 14:50 CST');


SELECT * FROM train_rides;




SELECT segment, to_char(departure, 'YYYY-MM-DD HH12:MI a.m. TZ') as departure,
arrival - departure
FROM train_rides

-- ranking trips based on lenght
SELECT segment, to_char(departure, 'YYYY-MM-DD HH12:MI a.m. TZ') as departure,
arrival - departure,
sum(arrival - departure) OVER (ORDER BY trip_id) as cum_time
FROM train_rides;

-- this uses the cumulative function over the date, but the only limitation is id add days
-- and hours up to 2 days and 85hrs, unreadable and hard to decipher,
-- here comes another function, to get the correct value meaning to using epoch as we saw before

select segment,
to_char(departure, 'YYYY-MM-DD HH:MM TZ') as departure,
arrival - departure as seg_time,
sum(date_part('epoch', (arrival- departure))) over (order by trip_id) * interval '1 second' as trip_time
from train_rides;

-- wrapping up

select date_part('epoch', (arrival- departure)) as time_iterval from train_rides;

select date_part('epoch', (arrival- departure)) * interval '1 second' as time_iterval from train_rides;

-- the above query gives the time in seconds, but we need to convert it to a readable format
select * from train_rides;

-- we can use the extract function to get the time in seconds
select cast(extract(epoch from (arrival - departure)) as numeric(20,1)) as time_interval from train_rides;

select max(tpep_dropoff_datetime - tpep_pickup_datetime) as longest_time from nyc_yellow_taxi_trips_2016_06_01;

select min(tpep_dropoff_datetime - tpep_pickup_datetime) as shortest_time from nyc_yellow_taxi_trips_2016_06_01;

-- we can use the extract function to get the time in seconds
select cast(extract(epoch from (tpep_dropoff_datetime - tpep_pickup_datetime)) as numeric(20,1))* interval '1 second' as time_interval from nyc_yellow_taxi_trips_2016_06_01;

-- we can use the extract function to get the time in seconds
select * from 
pg_timezone_names where 
name in(select name from pg_timezone_names where 
name like '%London%' or 
name like '%Johannesburg%' or 
name like '%Moscow%' or 
name like '%Melbourne%' or 
name like '%New%York%');

select cast('1/1/2024 00:00:00 EST' as timestamptz);

select cast('1/1/2024 00:00:00 EST' as timestamptz) at time zone 'EST' as est_time;

select cast('1/1/2024 00:00:00 EST' as timestamptz) at time zone 'UTC' as utc_time;

-- creating custom intervals using postgresql

select make_interval(hours => 22)

syntax of make_interval functions

make_interval(years, months, days, hours, minutes, seconds)

-- creating a 30 days interval
select make_interval(days => 30);


-- creating a 2 years and 3 months make_interval

select make_interval(2, 3);


select corr(date_part( 'epoch', tpep_pickup_datetime - tpep_dropoff_datetime)::interval, total_amount),
regr_r2((tpep_pickup_datetime - tpep_dropoff_datetime)::interval, total_amount)
FROM
nyc_yellow_taxi_trips_2016_06_01;


select corr(extract(epoch from (tpep_pickup_datetime - tpep_dropoff_datetime)), total_amount)
FROM
nyc_yellow_taxi_trips_2016_06_01;


select corr(trip_distance, total_amount) as dist_fare,
regr_r2(trip_distance, total_amount) as regr2,
regr_slope(trip_distance, total_amount) as slope,
regr_intercept(trip_distance, total_amount) as intercept
FROM
nyc_yellow_taxi_trips_2016_06_01


select corr(trip_distance, total_amount) as dist_fare,
regr_r2(trip_distance, total_amount) as regr2,
regr_slope(trip_distance, total_amount) as slope,
regr_intercept(trip_distance, total_amount) as intercept
FROM
nyc_yellow_taxi_trips_2016_06_01
where 
(tpep_pickup_datetime - tpep_dropoff_datetime) < make_interval(0,0,0,3, 0)

