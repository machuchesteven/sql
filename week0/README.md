# This week startst this friday and ends next friday, on 24th Nov 2023

The first part is creating a database using a script
For postgresql, we create a database using `CREATE DATABASE <Db_NAME>;`
The database we created is TutApp, and created a table witgin it
The table is teachers

--- sql

CREATE TABLE teachers IF NOT EXISTS (
id BIGSERIAL,
first_name VARCHAR(255),
last_name VARCHAR(255),
school_name VARCHAR(50),
hire_date DATE,
salary NUMERIC(10, 2)

);

---

All these should be made possible using a script that is a python script,
from creation to table data insertion.
The only item we need to use is create a random name generator from faker and insert the data into the table

## Week 0 is for the dapper project

The week 0 consists of dapper context project within which the project is build using C#, with the following tables and schemas:-

1. Employees (tablename: employee)
2. category (tablename: categories)
3. Users (tablename: user)
4. Products (tablename: products)

### Employees Table

This table contains the employees of an imaginary faker company created through scripting with the following table structure

- id int indenity primary key <!-- which creates an auto incrementing attribute for SQL server database -->
- first_name varchar(50)
- last_name varchar(50)
- is_retired bit, <!-- which stands for boolean in sql server -->
- joined date <!-- indicating the date joined with the format -->
- salary int

### Users table

### Products table

create table [dbo].[categories](
id int identity primary key,
name varchar(50),
description text
);
