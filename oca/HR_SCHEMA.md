# Human Resources Management Schema

This schema contains demo information on how to configure and play with the oracle database

Consider the log path for the HR schema to be `$ORACLE_PATH/demo/log` this is the child file from the 21c schema path

```sql
-- FIRST RUN THIS SCRIPT TO CREATE A HR USER AND THE HR SCHEMA IN YOUR DATABASE
-- @ C:\app\softnet\product\21c\dbhomeXE\demo\schema\human_resources\hr_main.sql
-- THEN CREATE A NEW CONNECTION FOR HR USER AND RUN THE SCRIPTS BELOW

-- @ C:\app\softnet\product\21c\dbhomeXE\demo\schema\human_resources\hr_cre.sql

-- the above script creates table for the hr schema
-- check for the tables by
SELECT * FROM TAB;

-- the scrip below inserts rows into tables and constraints created by the hr schema
@ C:\app\softnet\product\21c\dbhomeXE\demo\schema\human_resources\hr_popul.sql

-- NOW CREATING INDEXES
@ C:\app\softnet\product\21c\dbhomeXE\demo\schema\human_resources\hr_idx.sql

-- CREATING PROCEDUREAL OBJECTS

@ C:\app\softnet\product\21c\dbhomeXE\demo\schema\human_resources\hr_code.sql

-- ADD COMMENTS TO TABLES AND COLUMNS

@ C:\app\softnet\product\21c\dbhomeXE\demo\schema\human_resources\hr_comnt.sql

-- GATHER SCHEMA STATISTICS

@ C:\app\softnet\product\21c\dbhomeXE\demo\schema\human_resources\hr_analz.sql


-- SO FAR ALL TABLES ARE CREATED, NOW LETS ANALYZE THEM

SELECT * FROM TAB;

-- WE GET THE TABLES REGIONS, COUNTRIES, LOCATIONS, DEPARTMENTS, JOBS, EMPLOYEES, JOB_HISTORY AND A VIEW 'EMP_DETAILS_VIEW'
SELECT * FROM REGIONS; -- gives REGION_ID, REGION_NAME,

SELECT * FROM COUNTRIES; -- GIVES COUNTRY_ID, ..NAME, AND REGION_ID

SELECT * FROM LOCATIONS;

SELECT * FROM DEPARTMENTS;

SELECT * FROM JOBS;

SELECT * FROM EMPLOYEES;

SELECT * FROM JOB_HISTORY;

SELECT * FROM EMP_DETAILS_VIEW;

```
