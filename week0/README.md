# This week startst this friday and ends next friday, on 24th Nov 2023

The first part is creating a database using a script
For postgresql, we create a database using `CREATE DATABASE <Db_NAME>;`
The database we created is TutApp, and created a table witgin it
The table is teachers
`create table teachers if not exists (
    id bigserial,
    first_name varchar(255),
    last_name varchar(255),
    school_name varchar(50),
    hire_date date,
    salary numeric
);`

All these should be made possible using a script that is a python script,
from creation to table data insertion.
The only item we need to use is create a random name generator from faker and insert the data into the table
