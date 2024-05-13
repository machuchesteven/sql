
-- SUMMARIZING AND AGGREGATING TO TELL DATA SUMMARIES
-- We here use the AGGREGATE and ORDER BY functions to tell stories about data
-- GROUP FUNCTIONS are useful and will be used in this chapter 8

-- we use the public library survey dataset for US bundled with book components
-- due to encoding error using utf8 encoding, we change the encoding to win1252


SHOW server_encoding;

SET client_encoding TO 'WIN125252';


CREATE TABLE pls_fy2014_pupld14a (
    stabr VARCHAR(10) NOT NULL,
    fscskey VARCHAR(6) CONSTRAINT fscskey2014_key PRIMARY KEY,
    libid VARCHAR(20) NOT NULL,
    libname VARCHAR(100) NOT NULL,
    obereg VARCHAR(20) NOT NULL,
    rstatus INTEGER NOT NULL,
    statstru VARCHAR(2) NOT NULL,
    statname VARCHAR(2) NOT NULL,
    stataddr VARCHAR(2) NOT NULL,
    wifisess INTEGER NOT NULL,
    yr_sub INTEGER NOT NULL
);

DROP TABLE pls_fy2014_pupld14a;

CREATE TABLE pls_fy2014_pupld14a (
    stabr varchar(2) NOT NULL,
    fscskey varchar(6) CONSTRAINT fscskey2014_key PRIMARY KEY,
    libid varchar(20) NOT NULL,
    libname varchar(100) NOT NULL,
    obereg varchar(2) NOT NULL,
    rstatus integer NOT NULL,
    statstru varchar(2) NOT NULL,
    statname varchar(2) NOT NULL,
    stataddr varchar(2) NOT NULL,
    longitud numeric(10,7) NOT NULL,
    latitude numeric(10,7) NOT NULL,
    fipsst varchar(2) NOT NULL,
    fipsco varchar(3) NOT NULL,
    address varchar(35) NOT NULL,
    city varchar(20) NOT NULL,
    zip varchar(5) NOT NULL,
    zip4 varchar(4) NOT NULL,
    cnty varchar(20) NOT NULL,
    phone varchar(10) NOT NULL,
    c_relatn varchar(2) NOT NULL,
    c_legbas varchar(2) NOT NULL,
    c_admin varchar(2) NOT NULL,
    geocode varchar(3) NOT NULL,
    lsabound varchar(1) NOT NULL,
    startdat varchar(10),
    enddate varchar(10),
    popu_lsa integer NOT NULL,
    centlib integer NOT NULL,
    branlib integer NOT NULL,
    bkmob integer NOT NULL,
    master numeric(8,2) NOT NULL,
    libraria numeric(8,2) NOT NULL,
    totstaff numeric(8,2) NOT NULL,
    locgvt integer NOT NULL,
    stgvt integer NOT NULL,
    fedgvt integer NOT NULL,
    totincm integer NOT NULL,
    salaries integer,
    benefit integer,
    staffexp integer,
    prmatexp integer NOT NULL,
    elmatexp integer NOT NULL,
    totexpco integer NOT NULL,
    totopexp integer NOT NULL,
    lcap_rev integer NOT NULL,
    scap_rev integer NOT NULL,
    fcap_rev integer NOT NULL,
    cap_rev integer NOT NULL,
    capital integer NOT NULL,
    bkvol integer NOT NULL,
    ebook integer NOT NULL,
    audio_ph integer NOT NULL,
    audio_dl float NOT NULL,
    video_ph integer NOT NULL,
    video_dl float NOT NULL,
    databases integer NOT NULL,
    subscrip integer NOT NULL,
    hrs_open integer NOT NULL,
    visits integer NOT NULL,
    referenc integer NOT NULL,
    regbor integer NOT NULL,
    totcir integer NOT NULL,
    kidcircl integer NOT NULL,
    elmatcir integer NOT NULL,
    loanto integer NOT NULL,
    loanfm integer NOT NULL,
    totpro integer NOT NULL,
    totatten integer NOT NULL,
    gpterms integer NOT NULL,
    pitusr integer NOT NULL,
    wifisess integer NOT NULL,
    yr_sub integer NOT NULL
);

-- create index for helping several search functions 
CREATE INDEX libname2014_idx ON pls_fy2014_pupld14a (libname);
CREATE INDEX stabr2014_idx ON pls_fy2014_pupld14a (stabr);
CREATE INDEX city2014_idx ON pls_fy2014_pupld14a (city);
CREATE INDEX visists2014_idx ON pls_fy2014_pupld14a (visits);
-- data are overflowing from the csv hence we need to fecth the actual db

-- for 2009 tables

CREATE TABLE pls_fy2009_pupld09a (
    stabr varchar(2) NOT NULL,
    fscskey varchar(6) CONSTRAINT fscskey2009_key PRIMARY KEY,
    libid varchar(20) NOT NULL,
    libname varchar(100) NOT NULL,
    address varchar(35) NOT NULL,
    city varchar(20) NOT NULL,
    zip varchar(5) NOT NULL,
    zip4 varchar(4) NOT NULL,
    cnty varchar(20) NOT NULL,
    phone varchar(10) NOT NULL,
    c_relatn varchar(2) NOT NULL,
    c_legbas varchar(2) NOT NULL,
    c_admin varchar(2) NOT NULL,
    geocode varchar(3) NOT NULL,
    lsabound varchar(1) NOT NULL,
    startdat varchar(10),
    enddate varchar(10),
    popu_lsa integer NOT NULL,
    centlib integer NOT NULL,
    branlib integer NOT NULL,
    bkmob integer NOT NULL,
    master numeric(8,2) NOT NULL,
    libraria numeric(8,2) NOT NULL,
    totstaff numeric(8,2) NOT NULL,
    locgvt integer NOT NULL,
    stgvt integer NOT NULL,
    fedgvt integer NOT NULL,
    totincm integer NOT NULL,
    salaries integer,
    benefit integer,
    staffexp integer,
    prmatexp integer NOT NULL,
    elmatexp integer NOT NULL,
    totexpco integer NOT NULL,
    totopexp integer NOT NULL,
    lcap_rev integer NOT NULL,
    scap_rev integer NOT NULL,
    fcap_rev integer NOT NULL,
    cap_rev integer NOT NULL,
    capital integer NOT NULL,
    bkvol integer NOT NULL,
    ebook integer NOT NULL,
    audio integer NOT NULL,
    video integer NOT NULL,
    databases integer NOT NULL,
    subscrip integer NOT NULL,
    hrs_open integer NOT NULL,
    visits integer NOT NULL,
    referenc integer NOT NULL,
    regbor integer NOT NULL,
    totcir integer NOT NULL,
    kidcircl integer NOT NULL,
    loanto integer NOT NULL,
    loanfm integer NOT NULL,
    totpro integer NOT NULL,
    totatten integer NOT NULL,
    gpterms integer NOT NULL,
    pitusr integer NOT NULL,
    yr_sub integer NOT NULL,
    obereg varchar(2) NOT NULL,
    rstatus integer NOT NULL,
    statstru varchar(2) NOT NULL,
    statname varchar(2) NOT NULL,
    stataddr varchar(2) NOT NULL,
    longitud numeric(10,7) NOT NULL,
    latitude numeric(10,7) NOT NULL,
    fipsst varchar(2) NOT NULL,
    fipsco varchar(3) NOT NULL
);


-- for 2016 dataset

CREATE TABLE pls_fy2016_libraries (
    stabr text NOT NULL,
    fscskey text CONSTRAINT fscskey_16_pkey PRIMARY KEY,
    libid text NOT NULL,
    libname text NOT NULL,
    address text NOT NULL,
    city text NOT NULL,
    zip text NOT NULL,
    county text NOT NULL,
    phone text NOT NULL,
    c_relatn text NOT NULL,
    c_legbas text NOT NULL,
    c_admin text NOT NULL,
    c_fscs text NOT NULL,
    geocode text NOT NULL,
    lsabound text NOT NULL,
    startdate text NOT NULL,
    enddate text NOT NULL,
    popu_lsa integer NOT NULL,
    popu_und integer NOT NULL,
    centlib integer NOT NULL,
    branlib integer NOT NULL,
    bkmob integer NOT NULL,
    totstaff numeric(8,2) NOT NULL,
    bkvol integer NOT NULL,
    ebook integer NOT NULL,
    audio_ph integer NOT NULL,
    audio_dl integer NOT NULL,
    video_ph integer NOT NULL,
    video_dl integer NOT NULL,
    ec_lo_ot integer NOT NULL,
    subscrip integer NOT NULL,
    hrs_open integer NOT NULL,
    visits integer NOT NULL,
    reference integer NOT NULL,
    regbor integer NOT NULL,
    totcir integer NOT NULL,
    kidcircl integer NOT NULL,
    totpro integer NOT NULL,
    gpterms integer NOT NULL,
    pitusr integer NOT NULL,
    wifisess integer NOT NULL,
    obereg text NOT NULL,
    statstru text NOT NULL,
    statname text NOT NULL,
    stataddr text NOT NULL,
    longitude numeric(10,7) NOT NULL,
    latitude numeric(10,7) NOT NULL
);


CREATE INDEX libname2009_idx ON pls_fy2009_pupld09a (libname);
CREATE INDEX stabr2009_idx ON pls_fy2009_pupld09a (stabr);
CREATE INDEX city2009_idx ON pls_fy2009_pupld09a (city);
CREATE INDEX visits2009_idx ON pls_fy2009_pupld09a (visits);
-- copy and import the data, here we use PLSQL, since sql does not complete permission issues
\COPY pls_fy2014_pupld14a FROM 'C:\Users\julie\Desktop\Machuche\pls_fy2014_pupld14a.csv' WITH (FORMAT csv, HEADER TRUE, ENCODING 'utf8');


\COPY pls_fy2009_pupld09a FROM 'C:\Users\julie\Desktop\Machuche\pls_fy2009_pupld09a.csv' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'utf8');
-- due to encoding errors, we had to explicitly specify the encoding at the end of the copy statement

-- HERE THE ANALYSIS BEGINS: USING AGGREGATE FUNCTIONS
SELECT COUNT(*) AS count_2014 FROM pls_fy2014_pupld14a;


SELECT COUNT(*) FROM pls_fy2009_pupld09a;


SELECT COUNT(salaries) FROM pls_fy2014_pupld14a;


SELECT AVG(salaries) FROM pls_fy2014_pupld14a;

-- using distint with count

SELECT COUNT(libname) FROM pls_fy2014_pupld14a;

SELECT COUNT(DISTINCT libname) FROM pls_fy2014_pupld14a;

SELECT COUNT(DISTINCT city) FROM pls_fy2014_pupld14a;


-- finding Minimum and Maximum values using MIN() and MAX() functions

SELECT MIN(visits), MAX(visits) FROM pls_fy2014_pupld14a;

-- the worst case is above we get a negative value: removing the negative now


SELECT MIN(visits), MAX(visits) FROM pls_fy2014_pupld14a WHERE visits > 0;

-- NOTE: always dont mix information flags or codes with data in the same datafiles


SELECT sum(visits) FROM pls_fy2014_pupld14a;

SELECT sum(visits) FROM pls_fy2014_pupld14a  WHERE visits > 0;


-- using group by to eliminate duplicates
SELECT stabr
FROM pls_fy2014_pupld14a
GROUP BY stabr
ORDER BY stabr;

-- mutli column group by
SELECT stabr, city
FROM pls_fy2014_pupld14a
GROUP BY stabr, city;

SELECT stabr, city
FROM pls_fy2014_pupld14a
GROUP BY stabr, city
ORDER BY stabr, city;


SELECT COUNT(*)
FROM pls_fy2014_pupld14a
GROUP BY stabr, city
ORDER BY stabr, city;



-- Once we use the AGGREGATE function with an individual column, we must include the column in a GROUP BY clause,
-- otherwise we will get an error
SELECT stabr, COUNT(*)
FROM pls_fy2014_pupld14a
GROUP BY stabr
ORDER BY COUNT(*) DESC;

-- this runs
SELECT stabr, city, COUNT(*)
FROM pls_fy2014_pupld14a
GROUP BY stabr, city
ORDER BY COUNT(*) DESC;


-- this don't
SELECT stabr, city, COUNT(*)
FROM pls_fy2014_pupld14a
GROUP BY stabr
ORDER BY COUNT(*) DESC;


-- using group by for multiple columns with the count function
SELECT stabr, stataddr, COUNT(*)
FROM pls_fy2014_pupld14a
GROUP BY stabr, stataddr
ORDER BY stabr ASC, COUNT(*)


SELECT stabr, stataddr, COUNT(*)
FROM pls_fy2014_pupld14a
GROUP BY stabr, stataddr
ORDER BY stabr ASC, stataddr ASC;


SELECT stabr, stataddr, COUNT(*), sum(visits)
FROM pls_fy2014_pupld14a
GROUP BY stabr, stataddr
ORDER BY stabr ASC, sum(visits) ASC;

-- using multiple tables to tell stories
-- now we use both the 2014 and 2009 using joins

SELECT sum(visits) as Visits_2014
FROM pls_fy2014_pupld14a
WHERE visits >= 0;


SELECT sum(visits) as Visits_2009
FROM pls_fy2009_pupld09a
WHERE visits >= 0;

SELECT sum(visits) as Visits_2014_unclean
FROM pls_fy2014_pupld14a;


SELECT sum(visits) as Visits_2009_unclean
FROM pls_fy2009_pupld09a;


SELECT sum(pls09.visits) as visists_09, sum(pls14.visits) as visists_14
from pls_fy2009_pupld09a pls09 
join pls_fy2014_pupld14a pls14
on pls09.fscskey = pls14.fscskey
where pls09.visits >= 0 and pls14.visits >= 0;



SELECT sum(pls09.visits) as visists_09, sum(pls14.visits) as visists_14
from pls_fy2009_pupld09a pls09 
left join pls_fy2014_pupld14a pls14
on pls09.fscskey = pls14.fscskey
where pls09.visits >= 0 and pls14.visits >= 0;



-- finding the percentage_change for visits from each city
SELECT
pls14.stabr,
sum(pls09.visits) as visits_09,
sum(pls14.visits) as visists_14,
round(
    (
        CAST(sum(pls14.visits) AS DECIMAL(10,1)) - sum(pls09.visits)
        ) / sum(pls09.visits) * 100, 2) as pct_change
from pls_fy2009_pupld09a pls09
join pls_fy2014_pupld14a pls14
on pls09.fscskey = pls14.fscskey
where pls09.visits >= 0 and pls14.visits >= 0
group by pls14.stabr;


SELECT
pls14.stabr,
sum(pls09.visits) as visits_09,
sum(pls14.visits) as visists_14,
round(
    (
        CAST(sum(pls14.visits) AS DECIMAL(10,1)) - sum(pls09.visits)
        ) / sum(pls09.visits) * 100, 2) as pct_change
from pls_fy2009_pupld09a pls09
join pls_fy2014_pupld14a pls14
on pls09.fscskey = pls14.fscskey
where pls09.visits >= 0 and pls14.visits >= 0
group by pls14.stabr
ORDER BY 4 DESC;

-- these up and down are equivalent

SELECT
pls14.stabr,
sum(pls09.visits) as visits_09,
sum(pls14.visits) as visists_14,
round(
    (
        CAST(sum(pls14.visits) AS DECIMAL(10,1)) - sum(pls09.visits)
        ) / sum(pls09.visits) * 100, 2) as pct_change
from pls_fy2009_pupld09a pls09
join pls_fy2014_pupld14a pls14
on pls09.fscskey = pls14.fscskey
where pls09.visits >= 0 and pls14.visits >= 0
group by pls14.stabr
ORDER BY pct_change DESC;



-- filtering aggregate queries using having
-- refine data to tell story of subset of states and territories which share some characteristics
-- we have to tell story for data based on the volume of the visits, then we use aggregate function HAVING to sort them and filter them,
-- Aggregate works in the row level, and can work across multiple rows
-- for example, we need only the ones with visits more that 50 Mil

SELECT
pls14.stabr,
sum(pls09.visits) as visits_09,
sum(pls14.visits) as visists_14,
round(
    (
        CAST(sum(pls14.visits) AS DECIMAL(10,1)) - sum(pls09.visits)
        ) / sum(pls09.visits) * 100, 2) as pct_change
from pls_fy2009_pupld09a pls09
join pls_fy2014_pupld14a pls14
on pls09.fscskey = pls14.fscskey
where pls09.visits >= 0 and pls14.visits >= 0
group by pls14.stabr
HAVING sum(pls14.visits) >= 50000000
ORDER BY sum(pls14.visits) DESC;



SELECT
pls14.stabr,
sum(pls09.visits) as visits_09,
sum(pls14.visits) as visists_14,
round(
    (
        CAST(sum(pls14.visits) AS DECIMAL(10,1)) - sum(pls09.visits)
        ) / sum(pls09.visits) * 100, 2) as pct_change
from pls_fy2009_pupld09a pls09
join pls_fy2014_pupld14a pls14
on pls09.fscskey = pls14.fscskey
where pls09.visits >= 0 and pls14.visits >= 0
group by pls14.stabr
HAVING sum(pls14.visits) >= 50000000 and sum(pls14.visits) <= 100000000
ORDER BY sum(pls14.visits) DESC;


SELECT
pls14.stabr,
sum(pls09.visits) as visits_09,
sum(pls14.visits) as visists_14,
round(
    (
        CAST(sum(pls14.visits) AS DECIMAL(10,1)) - sum(pls09.visits)
        ) / sum(pls09.visits) * 100, 2) as pct_change
from pls_fy2009_pupld09a pls09
join pls_fy2014_pupld14a pls14
on pls09.fscskey = pls14.fscskey
where pls09.visits >= 0 and pls14.visits >= 0
group by pls14.stabr
HAVING sum(pls14.visits) >= 5000000 and sum(pls14.visits) <= 50000000
ORDER BY sum(pls14.visits) DESC;



SELECT
pls14.stabr,
sum(pls09.visits) as visits_09,
sum(pls14.visits) as visists_14,
round(
    (
        CAST(sum(pls14.visits) AS DECIMAL(10,1)) - sum(pls09.visits)
        ) / sum(pls09.visits) * 100, 2) as pct_change
from pls_fy2009_pupld09a pls09
join pls_fy2014_pupld14a pls14
on pls09.fscskey = pls14.fscskey
where pls09.visits >= 0 and pls14.visits >= 0
group by pls14.stabr
HAVING sum(pls14.visits) >= 5000000 and sum(pls14.visits) <= 30000000
ORDER BY sum(pls14.visits) DESC;

SELECT
pls14.stabr,
sum(pls09.visits) as visits_09,
sum(pls14.visits) as visists_14,
round(
    (
        CAST(sum(pls14.visits) AS DECIMAL(10,1)) - sum(pls09.visits)
        ) / sum(pls09.visits) * 100, 2) as pct_change
from pls_fy2009_pupld09a pls09
join pls_fy2014_pupld14a pls14
on pls09.fscskey = pls14.fscskey
where pls09.visits >= 0 and pls14.visits >= 0
group by pls14.stabr
HAVING sum(pls14.visits) <= 5000000 
ORDER BY sum(pls14.visits) DESC;


SELECT
pls14.stabr,
sum(pls09.visits) as visits_09,
sum(pls14.visits) as visists_14,
round(
    (
        CAST(sum(pls14.visits) AS DECIMAL(10,1)) - sum(pls09.visits)
        ) / sum(pls09.visits) * 100, 2) as pct_change
from pls_fy2009_pupld09a pls09
join pls_fy2014_pupld14a pls14
on pls09.fscskey = pls14.fscskey
where pls09.visits >= 0 and pls14.visits >= 0
group by pls14.stabr
HAVING sum(pls14.visits) <= 1000000 
ORDER BY sum(pls14.visits) DESC;


SELECT
pls14.stabr,
sum(pls09.visits) as visits_09,
sum(pls14.visits) as visists_14,
sum(pls14.pitusr) as pitusr_14,
sum(pls09.pitusr) as pitusr_09,
round(
    (
        CAST(sum(pls14.visits) AS DECIMAL(10,1)) - sum(pls09.visits)
        ) / sum(pls09.visits) * 100, 2) as pct_change
from pls_fy2009_pupld09a pls09
join pls_fy2014_pupld14a pls14
on pls09.fscskey = pls14.fscskey
where pls09.visits >= 0 and pls14.visits >= 0 and pls09.pitusr >= 0 and pls14.pitusr >= 0
group by pls14.stabr
ORDER BY sum(pls14.visits) DESC;


SELECT
pls14.stabr,
sum(pls09.visits) as visits_09,
sum(pls14.visits) as visists_14,
sum(pls14.pitusr) as pitusr_14,
sum(pls09.pitusr) as pitusr_09,
sum(pls14.gpterms) as gpterms_14,
sum(pls09.gpterms) as gpterms_09,
round(
    (
        CAST(sum(pls14.visits) AS DECIMAL(10,1)) - sum(pls09.visits)
        ) / sum(pls09.visits) * 100, 2) as pct_change
from pls_fy2009_pupld09a pls09
join pls_fy2014_pupld14a pls14
on pls09.fscskey = pls14.fscskey
where pls09.visits >= 0 and pls14.visits >= 0 and pls09.pitusr >= 0 and pls14.pitusr >= 0 and pls14.gpterms >= 0 and pls09.gpterms >= 0 
group by pls14.stabr
ORDER BY sum(pls14.visits) DESC;
-- conditional checking helps in making sure that we do not include the negative values in our queries


SELECT
pls14.obereg,
pls14.stabr,
sum(pls09.visits) as visits_09,
sum(pls14.visits) as visists_14,
sum(pls14.pitusr) as pitusr_14,
sum(pls09.pitusr) as pitusr_09,
sum(pls14.gpterms) as gpterms_14,
sum(pls09.gpterms) as gpterms_09,
round(
    (
        CAST(sum(pls14.visits) AS DECIMAL(10,1)) - sum(pls09.visits)
        ) / sum(pls09.visits) * 100, 2) as pct_change
from pls_fy2009_pupld09a pls09
join pls_fy2014_pupld14a pls14
on pls09.fscskey = pls14.fscskey
where pls09.visits >= 0 and pls14.visits >= 0 and pls09.pitusr >= 0 and pls14.pitusr >= 0 and pls14.gpterms >= 0 and pls09.gpterms >= 0 
group by pls14.obereg, pls14.stabr
ORDER BY sum(pls14.visits) DESC;


SELECT
pls14.obereg,
pls14.stabr,
sum(pls09.visits) as visits_09,
sum(pls14.visits) as visists_14,
pls09.fscskey as key09,
pls14.fscskey as key14,
round(
    (
        CAST(sum(pls14.visits) AS DECIMAL(10,1)) - sum(pls09.visits)
        ) / sum(pls09.visits) * 100, 2) as pct_change
from pls_fy2009_pupld09a pls09
left join pls_fy2014_pupld14a pls14
on pls09.fscskey = pls14.fscskey
WHERE pls09.fscskey is null or pls14.fscskey is null 
group by pls14.obereg, pls14.stabr, pls14.fscskey, pls09.fscskey
ORDER BY sum(pls14.visits) DESC;


