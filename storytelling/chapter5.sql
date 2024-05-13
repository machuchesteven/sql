-- unnest command helps return array values in a more reable way, individual lines

SELECT unnest (percentile_cont(array[.25, .5, .75])
     WITHIN GROUP (ORDER BY  spend_2014) ) 
     as "Quantiles" 
     FROM percentage_change;

-- creating a function now , MEDIAN function
-- by selecting the .5 percentile_cont

CREATE OR REPLACE FUNCTION _get_median(anyarray)
    RETURNS float8 AS
    $$
    WITH q AS
    (
        SELECT val
        FROM unnest($1) val
        WHERE VAL IS NOT NULL
        ORDER BY 1
    ),
    cnt AS (
        SELECT COUNT(*) AS c FROM q
    )
    SELECT AVG(val)::float8
    FROM(
        SELECT val FROM q
        LIMIT 2 - MOD ((SELECT c FROM cnt),2)
        OFFSET GREATEST(CEIL((SELECT c FROM cnt) / 2.0) -1.0 )
    )q2;
$$
LANGUAGE sql IMMUTABLE;

drop function get_median;


CREATE AGGREGATE median(anyelement) (
SFUNC=arrayappend,
STYPE=anyarray,
FINALFUNC=_get_median,
INITCOND='{}'
);

SELECT 3.14 * 7^2, 3.14 * 7 * 7;


-- now WE GO INTO TABLE JOINS IN SQL STATEMENTS

ALTER TABLE PEOPLE ADD COLUMN gender INTEGER;


-- select with join commmand structure

-- SELECT *
-- FROM table_a JOIN table_b
-- ON table_a.key_column = table_b.foreign_key_column;

-- this can do for mutliple tables with the join clause


CREATE TABLE departments(
    id bigserial,
    dept VARCHAR(100),
    city VARCHAR(100),
    CONSTRAINT dept_key PRIMARY KEY (id),
    CONSTRAINT dept_city_unique UNIQUE(dept, city)
);


CREATE TABLE employees (
    id bigserial,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    salary integer,
    dept_id INTEGER REFERENCES departments (id),
    CONSTRAINT emp_key PRIMARY KEY (id),
    CONSTRAINT emp_dept_kunique UNIQUE(id, dept_id)
);


INSERT INTO departments (dept, city) VALUES 
('Finance', 'Dar es Salaam'),
('Sales', 'Dar es Salaam'),
('IT', 'Dar es Salaam')
;



INSERT INTO employees (first_name, last_name, salary, dept_id) VALUES
('Adam','Heather',2034449,1),
('Lauren','Ernest',340293,3),
('Denise','Debra',58900,1),
('Marcus','Julia',469022,3),
('David','Jonathan',456000,1);

-- Here everything comes in even the dept id, comes twice

SELECT *
FROM employees
JOIN departments
ON employees.dept_id = departments.id;

-- this can do for mutliple tables with the join clause


-- JOIN TYPES

-- JOIN --- RETURNS ROWS FROM BOTH TABLES AND THE JOINED COLUMNS APPEAR BENEATH ONE ANOTHER
-- ALTNATIVE IS --- INNER JOIN ---

--LEFT JOIN --- 


-- RIGHT JOIN ---


-- FULL OUTER JOIN ---


-- CROSS JOIN ---

SELECT * 
FROM employees
JOIN gender
ON employees.id = gender.id
JOIN departments
ON gender.id = departments.id


-- LEFT JOIN ---
-- the ref tables goes on the left, the joined tables goes on the right ie select from A LEFT{A which goes LEFT} join B ON{joined B after A is left based on condition}
-- the remaining rows not satisfying the condition will be left behind
SELECT * 
FROM employees
LEFT JOIN gender
ON employees.id = gender.id
LEFT JOIN departments
ON gender.id = departments.id

-- marks the left tables/ original table non existent values null, and joins the overflowing tables rows of the right joined table
SELECT * 
FROM gender
RIGHT JOIN employees
ON gender.id = employees.id

-- select all rows whether satify or not, those with null values are added as empty columns

SELECT * 
FROM gender
RIGHT JOIN employees
ON gender.id = employees.id
RIGHT JOIN departments
ON gender.id = departments.id


-- full outer join shows all rows regardless of them matching the condition or not
-- FULL OUTER JOIN, RESULT STRUCTURE BELOW
--gives first rows from the first table, followed by the leftover missing rows from the second table,
-- Left over rows comes after the central comparison table is executed first
SELECT *
FROM employees
FULL OUTER JOIN gender
ON gender.id = employees.id
FULL OUTER JOIN departments
ON gender.id = departments.id

-- full outer join is less used than inner, left and right joins

-- CROSS JOIN
-- GIVES THE CARTESIAN PRODUCT OF TWO TABLES
-- as the result it is pointless sometimes to use the ON clause,
-- SYNTAX
SELECT *
FROM employees
CROSS JOIN gender;

-- ie if a = {A, B, C} and b ={X, Y, Z} then a cross join b = {AX, BX, CX, AY, BY, CY, AZ, BZ, CZ}
-- NB: avoid cross joins at all costs since they are server intensive
-- Use them only when required,




-- USING NULL TO FIND ROWS WITH MISSING VALUES
-- this should return if therre are employee without gender
SELECT *
FROM employees
LEFT JOIN gender
ON employees.id = gender.id
WHERE employees.id IS NULL;

-- returns gender without employee candidate match in the db
SELECT *
FROM employees
LEFT JOIN gender
ON employees.id = gender.id
WHERE gender.name IS NULL; -- either any row with null will be returned

-- TYPES OF TABLE RELATIONSHIPS PRACTICALITY
-- 1.ONE TO ONE RELATIONSHIPS --
-- WHERE IN TABLE a HAS ONLY ONE ID RELATED TO TABLE b
-- eg student to user relationship, if each student has his own account, one student to one user account the using Join will be
SELECT * FROM students
JOIN users
ON students.user_id = users.id
-- will returns the students with the users relationship



-- 2.ONE-TO-MANY RELATIONSHIP
-- here selecting the data that relates to others in the next table, columns with null values will return null values
-- the right join to use here is the inner join, if we are selecting from the many table to join with the one table
-- also, the join full outer if from the one table to the many table
-- eg selecting all orders from a certain customer
SELECT * FROM orders
JOIN customers
ON orders.customer_id = customers.id -- here all orders will come with the customer information



-- 3. MANY TO MANY RELATIONSHIP
-- Eg in football, some players can be assigned to multiple positions, and each position can be played by multiple players
-- understanding this helps makes sure the structure of the query reflects the structure of the database



-- SELECTING SPECIFIC COLUMNS IN A JOIN
-- the asterisk wildcard selects everything from the tables given, but we need to be specific sometimes
-- in joins, we include both the columns and the table names


-- concept of using TABLES ALIASES helpes a lot here
SELECT em.id, em.first_name, em.last_name, g.id as gender_id, g.name
FROM employees AS em
LEFT JOIN gender AS g
ON em.id = g.id 
WHERE g.id < 4
ORDER BY em.salary;


-- Using AND or other operations on joins makes the select statement eliminated those data before join in a particular table.
-- forexample, you want to join but only want to select a specific gender, you will add that to the gender join on as a conditon too
SELECT em.id, em.first_name, em.last_name, g.id as gender_id, g.name
FROM employees AS em
LEFT JOIN gender AS g
ON em.id = g.id AND g.id < 3
ORDER BY g.name;

-- SORTING THE RESULTS AND PERFORMING FUNCTIONS ON
SELECT em.id, em.first_name, em.last_name, g.id as gender_id, g.name, em.salary
FROM employees AS em
LEFT JOIN gender AS g
ON em.id = g.id
ORDER BY em.salary DESC;


-- JOINING MUTLIPLE TABLES
-- join statements can be used to join more than one table, depending on a lot of factors including aliases and more
SELECT *
FROM * -- WITH TABLES AND ALIASES
JOIN * -- ANOTHER TABLE
ON [] -- TABLE JOIN CONDITIONS
JOIN * -- ANOTHER TABLE NAME
ON [] -- TABLE JOIN CONDITIONS
JOIN * -- ANOTHER TABLE
ON [] -- TABLE JOIN CONDITIONS
WHERE -- TABLES SELECT CONDITIONS AND TABLE DATA FILTRATION CONDITIONS
ORDER BY -- ORDERING CONDITION FOR TABLES AND ALIASES
LIMIT XX -- Limit THE NUMBER OF ROWS TO BE RETURNED


-- PERFOMRING MATH ON JOINED TABLES --
-- math can be performed using the same math operators
-- example: here let join the table while dividinng the salary to ID
SELECT em.id, em.first_name, em.last_name, g.id as gender_id, g.name, em.salary / em.id AS "salary ID ratio", dep.id, dep.dept
FROM employees AS em
LEFT JOIN gender AS g
ON em.id = g.id
LEFT JOIN departments AS dep
ON g.id = dep.id
ORDER BY em.salary DESC;

-- SELECTING PERCENTILE FROM THE EMPLOYEE -- median salary for all employees
SELECT percentile_cont(0.5) WITHIN GROUP ( ORDER BY salary), MIN(salary) FROM employees as em;


-- TABLE DESIGN THAT WORKS FOR YOU
-- here we dive deeper into the concept of table structures and database designing practically,
-- once this is over, we can go deeper into the other concepts

-- concepts around this includes the following concepts --
-- 1. Naming Tables, Columns, and Other Identifiers
-- you can't have two tables with same name unless you enclose the name with "" when creating the second and making it case difference
-- make sure you follow the pattern used at your organization when creating a new table and naming columns and Identifiers
-- 2. Control Column Values with Constraints
-- Use of Constraints helps prevent the Garbage in, Garbage Out phenomenon, it will help you controll the values verification in tables
-- like CHECK, UNIQUE, and NOT NULL constraints
select * from people
left join gender
on gender.id = people.id
order by people.id, gender.id;



CREATE TABLE attendance(
    student_id VARCHAR(10),
    school_day DATE,
    present BOOLEAN,
    CONSTRAINT student_key PRIMARY KEY (student_id, school_day)
)

SELECT * FROM attendance;

INSERT INTO attendance(student_id, school_day, present) VALUES ('2024-01-01', '23/1/2023', TRUE);
-- DATA INTEGRITY PROBLEM
-- if the table you are creating doesnt have a column that can be used as the primary key,
-- there you get the data integrity problem and you have to create a surrogate primary key,
-- this is a column that is created to be used as the primary key, it is not a real data but a generated data
-- in postgres, u can create uuid and also auto incrementing primary keys
-- For auto incrementing primary keys there are smallserial, serail and bigserial
-- data are created but the database does not fill any gap once data are deleted


-- FOREIGN KEYS
-- creating a table structure with foreign key
-- actions on deleting include the following
-- 1. ON DELETE NO ACTION - Take no action to the db, dont change the key
-- 2. ON DELETE RESTRICT - prevents deletion of the referenced row
-- 3. ON DELETE CASCADE - delete all inheriters once the parent key is deleted
-- 4. ON DELETE SET NULL - remove the value completely and set null
-- 5. ON DELETE SET DEFAULT - restores to the default value of the database


CREATE TABLE students(
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    CONSTRAINT student_full_name UNIQUE(first_name, last_name)
);

CREATE TABLE student_parents(
    parent_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(id) ON DELETE SET NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    CONSTRAINT parent_full_name UNIQUE(first_name, last_name)
);


CREATE TABLE student_parents(
    parent_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(id) ON DELETE NO ACTION,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    CONSTRAINT parent_full_name UNIQUE(first_name, last_name)
);

DROP TABLE student_parents;

SELECT * FROM student_parents;

select * from gender;
-- above shows the declaration of the fields
-- cascade helps remove orphaned rows after data deletion

-- DATA INTEGRITY CHECK USING THE 'CHECK CONSTRAINT'
-- this helps to check the data integrity of the data being inserted into the database
-- It helps prevent the grabage in, garbage out phenomenon
-- example, if you want to make sure there are only 3 genders specifications for clothers, are Male, Female and Unisex
-- u might make sure that there wont be more sex added than specified ones
-- or in a school system, Z is not a grade, but it might feel like one,
-- the check constraint helps us make sure that grades are only added from A-F

-- we can implement a check constraint as a table or as a column constraint

-- In a COLUMN CHECK CONSTRAINT, we declare it after a column_name and Data_type
-- eg column_name Data_type CHECK (logical condition)

-- for a TABLE CONSTRAINT, we declare it after table structure definition,
-- eg CONSTRAINT constraint_name CHECK (logical condition)

-- example for a grade to be within A - F,
CREATE TABLE student_subject_grade(
    student_id VARCHAR(10),
    subject_id INT,
    grade VARCHAR(2) CONSTRAINT check_valid_grade CHECK (grade IN ('A', 'B', 'C', 'D', 'E', 'F'))
);


-- CHECK CONSTRAINTS ON MULTIPLE COLUMNS
CREATE TABLE payments(
    id SERIAL PRIMARY KEY,
    paid_person INT REFERENCES people(id),
    amount INT,
    payment_date DATE,
    CONSTRAINT check_payment CHECK (amount > 0 AND payment_date <= CURRENT_DATE ),
    CONSTRAINT check_paid_person_is_active CHECK (paid_person IN (SELECT id FROM people WHERE active = TRUE))
);
-- it can be done this way

DROP TABLE payments;

-- the debate on whether the logical decision should recide on the app or db is still going on
-- the adv of keeping the logic with the database, is that we are sure of the db performance and integrity even if
-- the database application changes or users finds different ways of adding data to the DB

-- as seen above, we can combine several checks within the CHECK statement

-- ALSO, SPECIFYING THE UNIQUE CONSTRAINT WITHIN THE PRIMARY KEY FIELD
CREATE TABLE unique_constraint_example (
contact_id bigserial CONSTRAINT contact_id_key PRIMARY KEY,
first_name varchar(50),
last_name varchar(50),
email varchar(200),
CONSTRAINT email_unique UNIQUE (email)
);

-- here the primary key is assigned as the explicit constraint with constraint name given

-- NOT NULL constraint, helps prevent the acceptance of empty values by the database


-- REMOVING CONSTRAINTS OR ADDING THEM LATER AFTER TABLE CREATION 
-- in sql, some constraints might arise as the result of growing requirements as we keep on designing our database and Tables

-- REMOVING A CONSTRAINT IN A DATABASE 
-- ALTER TABLE table_name DROP CONSTRAINT constraint_name;
-- the alter command is always used in changing the structure of the database constraint, mostly in Tables

-- TO DROP A NOT NULL CONSTRAINT
-- dropping a not null constraint the commands operates on the column level hence we do it thta way 
-- ALTER TABLE table_name ALTER COLUMN column_name DROP NOT NULL;

CREATE TABLE grades(
    grade_id SERIAL CONSTRAINT grades_primary_key PRIMARY KEY,
    min_range numeric(5,2) NOT NULL,
    max_range numeric(5,2) NOT NULL,
    grade_value char(1) NOT NULL
);

-- removing the not null constraint for the grades column grade_value
ALTER TABLE grades ALTER COLUMN grade_value DROP NOT NULL;

-- setting the not null constraint for the grades column grade_value

ALTER table grades ALTER COLUMN grade_value SET NOT NULL;

-- removing and setting the primary key constraints for grades
ALTER TABLE grades DROP CONSTRAINT grades_primary_key;

-- setting the primary key constraint for grades
ALTER TABLE grades ADD CONSTRAINT grades_primary_key PRIMARY KEY (grade_id);

-- You can only add a constraint to an existing table if the data in the target
-- column obeys the limits of the constraint. For example, you can’t place a
-- primary key constraint on a column that has duplicate or empty values.


-- SPEEDING UP QUERIES WITH INDEXES
-- indexes works as book indexes which helps get to the contents more faster and specificly
-- In SQL too indexes plays a card in that too
-- In databases, indexes acts as shortcuts for finding data,
-- They help in tuning database performance.

-- B-Tree: Postgresql's default index, [Balanced Tree Index]
-- Each time you create a constraint, esp the primary key or a unique constraint we automatically add an index to the DB,
-- without even knowing, Indexes are stored separately from  table data, 
-- In PostgreSQL, the default index type is the B-Tree index. It’s created
-- automatically on the columns designated for the primary key or a UNIQUE
-- constraint, and it’s also the type created by default when you execute a
-- CREATE INDEX statement.
-- B-Tree index is useful for data that can be ordered
-- and searched using equality and range operators, such as <, <=, =, >=, >, and
-- BETWEEN.
-- Other indexes are Generalized Inverted Index (GIN) and the Generalized Search Tree (GiST).

-- here we use a 900k dataset by OpenAddresses project at
-- https://openaddresses.io/. The file with the data, city_of_new_york.csv, is
-- available for you to download along with all the resources for this book
-- from https://www.nostarch.com/practicalSQL/. https://github.com/anthonydb/practical-sql-2/blob/main/Chapter_08/city_of_new_york.csv

-- Create the table before importing the dataset
CREATE TABLE new_york_addresses(
    longitude numeric(9,6),
    latitude numeric(9,6),
    street_number VARCHAR(10),
    street VARCHAR(32),
    unit VARCHAR(7),
    postcode VARCHAR(5),
    id INTEGER CONSTRAINT new_york_key PRIMARY KEY
);
-- coping data from dataset to database,
COPY new_york_addresses
FROM 'C:\Users\julie\Desktop\Machuche\city_of_new_york.csv'
WITH (FORMAT CSV, HEADER); -- this does use the normal delimiter for values
-- since copying fails with SQL, then we use the psql command


\COPY new_york_addresses FROM 'C:\Users\julie\Desktop\Machuche\city_of_new_york.csv'WITH (FORMAT CSV, HEADER);

select * from new_york_addresses;

-- the main use of this data is using it to search for matches in the street column and explore
-- and explore the working of indexes in Postgresql
select count(*) from new_york_addresses;


-- benchmarking query performance with EXPLAIN
-- explain shows how the database is intended to execute the query, whether use an index or not,
-- by adding the ANALYZE keyword EXPLAIN will carry out the query and show the actual execution time it used in executing it.
EXPLAIN ANALYZE SELECT * FROM new_york_addresses WHERE street = 'BROADWAY';

EXPLAIN ANALYZE SELECT * FROM new_york_addresses WHERE street = '52 STREET';

EXPLAIN ANALYZE SELECT * FROM new_york_addresses WHERE street = 'ZWICKY AVENUE';

-- NOW: we create an index and add them to see how does it affect the performance.

CREATE INDEX street_idx ON new_york_addresses (street);
-- it takes a litter more time to create than normally.

-- the index changes from sequential scan to Bitmap Heap Scan,
-- another change is using the index instead of visiting each row


-- REMOVE INDEX FROM A TABLE
-- DROP INDEX index_name


-- WHEN TO USE INDEXES
-- they help in performance, but dont use them on every data column, they impose a maintenance cost in writing data
-- use them for columns which will happen often in the where clause and table joins
-- use indexes for foreign keys and tables which will happen in joins
