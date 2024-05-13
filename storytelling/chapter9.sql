-- this is for inspecting, modifying and cleaning data basics
-- most of data comes as dirty data, with wrong data types in columns, wrong values and more
-- due to differences in most of files and databases, an analyst need the basics of cleaning and modifying data
-- lets first create the meat_poultry_egg_inspect tables

CREATE TABLE meat_poultry_egg_inspect (
    est_number VARCHAR(50) CONSTRAINT est_number_key PRIMARY KEY,
    company VARCHAR(100),
    street VARCHAR(100),
    city VARCHAR(30),
    st VARCHAR(2),
    zip VARCHAR(5),
    phone VARCHAR(14),
    grant_date DATE,
    activities TEXT,
    dbas TEXT
);

-- import data from a csv file using the copy statement
\COPY meat_poultry_egg_inspect FROM 'C:\Users\julie\Desktop\Machuche\MPI_Directory_by_Establishment_Name.csv' WITH (FORMAT CSV, HEADER, DELIMITER ',');

-- Create an index on the meat_poultry_egg_inspect table for the company column
CREATE INDEX company_idx ON meat_poultry_egg_inspect (company);



SELECT * FROM meat_poultry_egg_inspect;

SELECT * FROM meat_poultry_egg_inspect LIMIT 4;


SELECT * FROM meat_poultry_egg_inspect WHERE dbas is null;


SELECT COUNT(*) FROM meat_poultry_egg_inspect;

-- 6287 rows returned


select count(*), city FROM meat_poultry_egg_inspect GROUP BY city;


select count(*), city, company 
FROM meat_poultry_egg_inspect 
GROUP BY city, company 
ORDER BY count(*) DESC;

SELECT count(*) FROM meat_poultry_egg_inspect WHERE company IS NULL;


SELECT count(*) FROM meat_poultry_egg_inspect WHERE city IS NULL;
-- two data has no city, thats interesting


SELECT * FROM meat_poultry_egg_inspect WHERE city IS NULL;


-- select at least those within the same street where they appear at least twice
SELECT count(*), company, street, city, st
FROM meat_poultry_egg_inspect
GROUP BY company, street, city, st
HAVING count(*) > 1
ORDER BY company, city, st;


SELECT count(*), company
FROM meat_poultry_egg_inspect
GROUP BY company
HAVING count(*) > 1
ORDER BY company;

SELECT count(*), company, street
FROM meat_poultry_egg_inspect
GROUP BY company, street
HAVING count(*) > 1
ORDER BY company;


-- check for data without streets
SELECT st, count(*)
FROM meat_poultry_egg_inspect
group by st
ORDER BY st;


SELECT st, count(*)
FROM meat_poultry_egg_inspect
group by st
ORDER BY st NULLS first;

-- this returns null actually as a data row

SELECT *
FROM meat_poultry_egg_inspect
WHERE st IS NULL;

-- inspect the values we were told they had nulls
-- once you find which data are missing, you can search for the source to find the source of the error
-- using tools like grep, or findstr
-- or you can visually inspect the values and uncover what is inside them
-- this helps you get a list of cleanup tasks to run on the dataset

1. Add missing st lines to the rows with missing data
2. Format ZIP codes to use a 5 char string value instead of a number casted string
3. inconsistency in naming of companies
.. more to follow


-- check for the sa,e companies owning multiple establishments across the country

SELECT count(*), company
FROM meat_poultry_egg_inspect
GROUP BY company
ORDER BY company DESC;

-- this shows typos issues with the data during inspection
-- like mutliple names of companies with slight changes

SELECT count(*), zip
FROM meat_poultry_egg_inspect
group by zip
ORDER BY zip;



SELECT count(*), length(zip)
FROM meat_poultry_egg_inspect
group by length(zip)
ORDER BY count(*);

-- we have 86 3 chars rows, 496 4 chars row, and 5705 rows with correct information
-- lets check if we have null in zipcode

SELECT count(*)
FROM meat_poultry_egg_inspect
WHERE zip is NULL;

-- all zipcodes are correct from the inserted data
-- select all those with malformed zipcodes

SELECT *
FROM meat_poultry_egg_inspect
WHERE LENGTH(zip /*CH CHAR*/) < 5;

-- lets see where does the majority of those columns comes from

SELECT count(*), st
FROM meat_poultry_egg_inspect
WHERE LENGTH(zip) < 5
GROUP BY st;

-- only 9 states,

SELECT count(*), st
FROM meat_poultry_egg_inspect
WHERE LENGTH(zip) < 5
GROUP BY st
ORDER BY count(*) DESC;

-- most are from NJ, MA, PR and least from VI



-- NOW, MODIFYING TABLES, COLUMN AND DATA
-- there are no perfection in databases, this makes it hard to just assume something would ever
-- come the way you anticipate it, now, let's clean the data
-- to modify tables we use the ALTER TABLE command, with options like ADD COLUMN, ALTER COLUMN AND DROP COLUMN
-- among other options
-- the second command is for modifying data in the column, we use the UPDATE command to change values in a column,
-- paired with a WHERE statement, we can select which data to modify
-- BAD DATA LEADS TO FAULTY CONCLUSIONS

-- MODIFYING TABLES WITH ALTER TABLE
-- adding a column to a table command structure

ALTER TABLE table_name ADD COLUMN column_name data_type;


-- also removing a column from a table command structure
ALTER TABLE table_name DROP COLUMN column_name

-- change a data type of a column in a table
ALTER TABLE table_name ALTER COLUMN column_name SET DATA TYPE data_type;

-- adding a not null constraint,
ALTER TABLE table_name ALTER COLUMN column_name SET NOT NULL:

-- to remove a not null constraint/ make a column nullable
ALTER TABLE table_name ALTER COLUMN column_name DROP NOT NULL:

-- updating data in a table using the UPDATE statement
-- this updates all rows in a table, or only update those rows which meet conditions
-- structure is as follows:-
UPDATE table_name
SET column_name = value;

UPDATE table_name
SET column_name = value
WHERE condition;

-- the value can be a string, a number, a name of another column or even a query that returns a value,
-- also, update can work with multiple columns
UPDATE table_name
SET column_one = value,
    column_two = value,
    column_n = value,
WHERE condition;

-- USING MUTLIPLE TABLES AND QUERIES WITH UPDATE STATEMENT
UPDATE table
    SET column = (  SELECT column
            FROM table_b
            WHERE table.column = table_b.column
        )
    WHERE EXISTS (
        SELECT column
        FROM table_b
            WHERE table.column = table_b.column
        );

-- where exists acts as a filter for values in the other table


-- using mutli table updates we can use the from statement too
-- consider this example
UPDATE table_name
SET column_name = table_b.column_name_b
FROM table_b
WHERE table_name.column_name = table_b.column_name_b; --can be another criteria statement

-- after executing the update statement, the result is a message stating update, with a number of rows affected

-- CREATING BACKUP TABLES
-- Duplicating a table is easy using the CREATE TABLE statement
-- example, creating a backup gender table called gender_bk using the CREATE TABLE statement
CREATE TABLE gender_bk AS
SELECT * FROM gender;


SELECT * FROM gender;

SELECT * FROM gender_bk;

insert into gender(name, code) VALUES ('Binary', 'BI');

UPDATE gender_bk SET code = (select code from gender
    code WHERE id = 4)
    WHERE id = 3;

-- the above update from UNISEX to BI for the code, UN to BI,


-- confirming the results of create table for backup tables side by side


SELECT 
    (SELECT count(*) FROM gender) as Original,
    (SELECT count(*) FROM gender_bk) as Backup;

-- mutliple schema select also works for these data
SELECT
    (SELECT count(*) FROM gender) as Original,
    (SELECT count(*) FROM gender_bk) as Backup,
    (SELECT count(*) FROM zoo.gender) as Third;

-- this returns the results side by side with one another
-- on creating table copies, indexes are not created for the new table, hence if there is a plan for creating 
-- and using the new table for queries, we need to create new indexes for the new table


-- RESTORING MISSING COLUMN VALUES IN A DATA SET
CREATE TABLE zoo.meat_poultry_egg_inspect AS
SELECT * FROM meat_poultry_egg_inspect;


-- this is created due to the need to make columns copy of these data
SELECT
    (SELECT count(*) FROM zoo.meat_poultry_egg_inspect) as Backup,
    (SELECT count(*) FROM meat_poultry_egg_inspect) as Original;

-- this verifies the data


-- before restoring data, lets make column copies of the data we want to modify
-- to create a column copy of the data as backup data
ALTER TABLE meat_poultry_egg_inspect ADD COLUMN st_copy varchar(2);

UPDATE meat_poultry_egg_inspect SET st_copy = st;

-- this updates the values and marks them to the copy of the data
-- confir the copied values are worthy using select statement
SELECT st, st_copy
FROM meat_poultry_egg_inspect
ORDER BY st NULLS FIRST;

-- once we have a copy of the og data, we can update those missing values
-- if anything happens, we can restore our original values

-- updating rows where values are missing
-- we can do
-- here we could update the rows below amybe with an assumption to remove a certain value

UPDATE meat_poultry_egg_inspect
SET st = 
WHERE st IS NULL;

-- 
SELECT est_number FROM meat_poultry_egg_inspect WHERE st IS NULL;
-- here we get their primary keys first
-- 
-- but we use the atlas to set their values as follows:-
UPDATE meat_poultry_egg_inspect
SET st = 'MN'
WHERE est_number = 'V18677A';


UPDATE meat_poultry_egg_inspect
SET st = 'AL'
WHERE est_number = 'M45319+P45319';


UPDATE meat_poultry_egg_inspect
SET st = 'WI'
WHERE est_number = 'M263A+P263A+V263A';

-- now, we have cleared null values

SELECT est_number FROM meat_poultry_egg_inspect WHERE st IS NULL;
-- now there are not columns, but with the backup column, we can find  them

SELECT est_number FROM meat_poultry_egg_inspect WHERE st_copy IS NULL;

-- in case we have added wrong data, lets restore the values we once had,
-- we can do that from our backup table or backup column
UPDATE meat_poultry_egg_inspect
SET st = st_copy;


SELECT est_number FROM meat_poultry_egg_inspect WHERE st IS NULL;

-- null values are back to the data set

UPDATE meat_poultry_egg_inspect original
SET st = backup.st
FROM zoo.meat_poultry_egg_inspect backup
WHERE original.est_number = backup.est_number;

-- it applies the same thing, backup restored


-- 2. UPDATING VALUES FOR CONSISTENCY
-- We remember having data with company names having a lot of spellings and typos
-- now, we deal with that
-- we create a column copy first, then we modify the data in our column, company

ALTER TABLE meat_poultry_egg_inspect ADD COLUMN company_standard VARCHAR(100);


UPDATE meat_poultry_egg_inspect
SET company_standard = company;


-- lets say we know all companies starting with Armour are the same company,
-- and we want to make the company name standard all over, we then select the companies Armour name to see we will select only what we want
SELECT DISTINCT company
FROM meat_poultry_egg_inspect
WHERE company LIKE 'Armour%';

SELECT company
FROM meat_poultry_egg_inspect
WHERE company LIKE 'Armour%';

-- hence we can use our where clause for updating the company name, since we are sure only these 7 columns
-- will be affected

UPDATE meat_poultry_egg_inspect
SET company = 'Armour-Eckrich Meats'
WHERE company LIKE 'Armour%';

SELECT company, company_standard
FROM meat_poultry_egg_inspect
WHERE company LIKE 'Armour%';


-- restore the values since company_standard is the one to be updated
UPDATE meat_poultry_egg_inspect
SET company = company_standard;


UPDATE meat_poultry_egg_inspect
SET company_standard = 'Armour-Eckrich Meats'
WHERE company LIKE 'Armour%';

SELECT company, company_standard
FROM meat_poultry_egg_inspect
WHERE company LIKE 'Armour%';

-- for other values also we would do the same and fix all recurring values for CONSISTENCY using the LIKE



-- 3. REPAIRING ZIP CODES using CONCATENATION
-- since the length of zipcodes were supposed to be fixed chars with 5 characters,
-- something is that is not, we have to fix that
-- as usual create a copy of zip_codes first

ALTER TABLE meat_poultry_egg_inspect ADD COLUMN zip_copy VARCHAR(5);


UPDATE meat_poultry_egg_inspect
SET zip_copy = zip;

SELECT zip, zip_copy FROM meat_poultry_egg_inspect;

SELECT zip, zip_copy FROM meat_poultry_egg_inspect where LENGTH(zip /*CH CHAR*/) < 5;

SELECT count(*) FROM meat_poultry_egg_inspect where LENGTH(zip /*CH CHAR*/) < 5;

-- here we use the update to add leading zeros to the data,
-- CONCATENATION can be achieved using the || double pipe operator that acts as a string CONCATENATION operator
-- meaning 123||abc will give 123abc as the result of concatenation.
-- in america the only states with 00 starting strings are PR and VI, hence we modify our data, as follows:
UPDATE meat_poultry_egg_inspect
SET zip = '00' || zip
WHERE st IN ('PR', 'VI') AND length(zip) = 3;

-- here maybe some rows might not be updated, since we consider the states too,

-- lets update the remaining with 0 prefix when zip < 5 and > 3, ie 4
UPDATE meat_poultry_egg_inspect
SET zip = '0' || zip
WHERE st IN ('CT', 'MA', 'ME', 'NH', 'NJ', 'RI', 'VT') AND length(zip) = 4;

-- now lets check if there are missing zip values with < 5 chars

SELECT * from meat_poultry_egg_inspect
WHERE length(zip) < 5;

-- all zipcodes are clean now, lets proceed
-- there are a lot of string stuffs for db but for now, thats enough


-- UPDATING VALUES ACROSS TABLES
-- In mutliple tables statements, we use values from one table to update another, and use the keys in another as criteria, or condition for changing them
-- mostly used in mapping relationships
-- is useful for updating when data in one table is useful for updating other tables,
-- like adding a regional column, to a table with district values,
-- now, we create a table for state_regions with st and region as primary key and region name,

-- in the task below we want to add the updated date to our database after a certain time, and we want to use the name of a certain region as the condition for the data we modified,
-- then we, add a table, state_regions, we add a column update date, we update the values of update_date based on the name of the region comparing the rows for st in meat_poultry_egg_inspect and st in state_regions

CREATE TABLE state_regions(
    st VARCHAR(2) CONSTRAINT st_key PRIMARY KEY,
    region VARCHAR(20) NOT NULL
);


DROP TABLE state_regions;

\COPY state_regions FROM 'C:\Users\julie\Desktop\Machuche\state_regions.csv' WITH (FORMAT CSV, HEADER, DELIMITER ', ');


-- now we add the column into our meat_poultry_egg_inspect table,

ALTER TABLE meat_poultry_egg_inspect ADD COLUMN inspection_date DATE;


UPDATE meat_poultry_egg_inspect inspect
SET inspection_date = '2019-12-01'
WHERE EXISTS (
        SELECT state_regions.region
        FROM state_regions
        WHERE inspect.st = state_regions.st
            AND state_regions.region = 'New England'
    );

SELECT state_regions.region, inspect.st
        FROM state_regions, meat_poultry_egg_inspect inspect
        WHERE inspect.st = state_regions.st
            AND state_regions.region = 'New England'

SELECT *
        FROM state_regions, meat_poultry_egg_inspect inspect
        WHERE inspect.st = state_regions.st
            AND state_regions.region = 'New England'

SELECT st, inspection_date
FROM meat_poultry_egg_inspect
group by st, inspection_date
ORDER BY st;

SELECT region from state_regions
GROUP BY region;


UPDATE meat_poultry_egg_inspect inspect
SET inspection_date = '2019-12-23'
WHERE EXISTS (
        SELECT state_regions.region
        FROM state_regions
        WHERE inspect.st = state_regions.st
            AND state_regions.region = 'Middle Atlantic'
    );


UPDATE meat_poultry_egg_inspect inspect
SET inspection_date = '2019-09-14'
WHERE EXISTS (
        SELECT state_regions.region
        FROM state_regions
        WHERE inspect.st = state_regions.st
            AND state_regions.region = 'Mountain'
    );

UPDATE meat_poultry_egg_inspect inspect
SET inspection_date = '2019-02-14'
WHERE EXISTS (
        SELECT state_regions.region
        FROM state_regions
        WHERE inspect.st = state_regions.st
            AND state_regions.region = 'West South Central'
    );

-- DELETING DATA FROM TABLES
-- Using SQL, we have a a DELETE statement for deleting data from a table, we use that to make sure
-- we only delete data for a table , once used without a where clause, data are gone for good,
-- once used with a where clause, it checks for which data to delete based on the condition
STRUCTURE of the DELETE statement;
-- DELETE FROM table_name; -- for all data in a table
-- DELETE FROM table_name WHERE condition; -- for all data in a table meeting the condition,
-- DELETE FROM table_name where primary_key = value; for data with that primary key
-- here, we delete values from our backup table for gender

DELETE FROM gender_bk;

-- deletes our 3 rows

-- In case of removing a column from a table, we use the ALTER TABLE table_name DROP COLUMN column_name;

-- in deleting columns with constraints, we need to work around the constraint first,
-- based on how the data were defined, either, remove the column in another table first, remove the constraint first or anything else,
-- each case is unique and requires a different approach in solving it around the constraint


-- delete data from puerto rico and Virgin Island

DELETE FROM meat_poultry_egg_inspect
WHERE st IN ('PR', 'VI');


-- remove the column copy command
ALTER TABLE meat_poultry_egg_inspect
DROP COLUMN zip_copy;

-- deleting a table from a database
DROP TABLE gender_bk;


-- USING TRANSACTION BLOCKS TO SAVE AND REVERT CHANGES
-- transaction gives the chance for proofing the transaction or any database action, from modifying table, deleting and adding data
-- they give a basic way to revert changes when what intnded is not what is achieved by SQL

-- transaction blocks used
-- 1. START TRANSACTION - signals the start of the transaction block, in PostgreSQL, the non-ANSI Begin keyword can be used too
-- 2. COMMIT - signals the end of the block and saves all changes
-- 3. ROLLBACK - signals the end of the block and revert all changes

SELECT *
FROM meat_poultry_egg_inspect
WHERE company like '%AGRO%Merchants%Oakland%';

SELECT company, count(*)
FROM meat_poultry_egg_inspect
WHERE company like '%AGRO%Merchants%Oakland%'
GROUP BY company;
-- we want to clear that , typo using a transaction
-- we will update the company name, with UPDATE statement, but this time we approve for the result before we save changes


-- first learn the transaction basics from the youtube video on PostgreSQL
START TRANSACTION;


UPDATE meat_poultry_egg_inspect
SET company = 'AGRO MerchantsS Oakland LLC'
WHERE company = 'AGRO Merchants Oakland, LLC';

SELECT company
FROM meat_poultry_egg_inspect
WHERE company LIKE 'AGRO%';

ROLLBACK;


-- saving space when updating tables
CREATE TABLE meat_poultry_egg_inspect_bk AS
SELECT *, '2018-02-07'::date as reviewed_date
FROM zoo.meat_poultry_egg_inspect;

-- renaming tables
ALTER TABLE meat_poultry_egg_inspect
RENAME TO meat_poultry_egg_inspect_old;



ALTER TABLE meat_poultry_egg_inspect_bk
RENAME to meat_poultry_egg_inspect;

ALTER TABLE zoo.meat_poultry_egg_inspect
RENAME TO meat_poultry_egg_inspect_og;

-- when renaming a table in a different schema, you can just rename it without having to specify the schema name after the RENAME keyword

