# Managing Schema Objects in Oracle

Here are some of the schema objects we will look at

- Views
- Sequences
- Indexes

Also we will look at the `FLASHBACK` syntax, flashback table, flasback drop and flashback query

## Describe How Schema Objects work

How the database work with each schema object

### Tables

All data are stored in tables. Data about created tables are alos stored in system tables called Data Dictionary anad are automatically managed by Oracle system. data about data(metadata) are stored in those tables.
Tables are stored in order of creation, though not always the case. When you create a new column to a table, it is added to the end of the column list of the table's structure

### Constraints

Is a rule on a table that restricts a value that can be added to a table's column. its not a database object but it is listed with dictionary views and can be named using the naming rules of an object,
If a statement try to add, modify or delete a column tied by a constraint, it will fail with an execution error. we have already looked at constraints including NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY AND CHECK.

### Views

a view act like a table, it has a name, and you can describe it the same way you would describe a table (using `DESC`). depending on the view, you migt be able to execute INSERT, UPDATE and/or DELETE on a view to manipulate content of the underlying table
A view is not a table, it is just a select statement saved in a db and assigned a name. Data types of columns are picked by the view from the underlying tables or the expression used to create a view.

### Indexes

the database index is a datastructure that increases efficiency in accessing table data based on one column or multiple column data.
Once you create an index, Oracle takes a copy of data of the indexed column and sorts them while creating a faster way of referencing the row data based on that column.
The result is any future queries on that table that happen to reference any index data will do the following:-

- Perform analysis to determine whether the query will benefit from the index
- If yes redirect the focus to the index temporarily, search for the index of the desired data, then obtain the direct location of the appropriate rows

The performance increase by using an index is significant, the more data stored,more beneficial the index is

### Sequences

is a counter, used for issuing numbers in a particular series, keeping track of whatever the next number should be.
How to use a sequence corrrectly is up to the developer. Though primary purppose of an index is to support addition of rows to a particular table by providing unique next value for a primary key. Theres nothing that ties a sequence to a table, and there's nothing that auomatically supports a table from the sequence

## Create Simple and Complex Views with Visible/Invisible Columns

a view, a select statement with a name, stored in the db, accessibe as though it were a table. As a WITH clause does, a view does it in a permanent manner, views resider inside a db with other db objects.
Anyone looking at a given select statement will not be able to determine the whether the select statement specifies a table or a view.
Views are beneficial,

- one benefit of views is security.
- Another, simplifying complex queries

### Creating Views

Consider you need to give access to only some of the information of the person table to other db user, but not all data, then its better to create a view with only the less sensitive information and expose it

You create a view with the same statement as used for populating data for a table, but instead of crete table, we replace with create view

```sql
CREATE VIEW view_name AS SELEC columns FROM tables and joins and conditons ;
-- OR ALTERNATIVELY
CREATE OR REPLACE VIEW view_name(COLUMNS NAMES FOR THE VIEW) AS SELECT another expressions as you need;
-- as here below
create view vw_employees as
    select employee_id,
    first_name || ' ' || last_name as Full_Name,
    hire_date as Hired_on,
    department_name as Department
    from employees natural join departments;

select * from vw_employees;
```

Column names are assigned by two means here

- From the columns names list given by the create view statement
- From the column names of expressions in the select statement
- From the alias names of expressions from the select statement

If the alias are not defined, the view will take the names of columns from the expressions

We can also use complex queries to create views
The `CREATE OR REPLACE` statement means you wont receive any error if your are trying to overwrite an existing view.

### Views and Constraints

You can create constraints on a view the same way you create them on a table. These are supported using some configurations for data warehousing. Not in the exams though

### Updatable Views

We can also INSERT, DELETE and UPDATE from a view, the answer is it depends.
If the view contains enough information to satisfy the constraints of the underlying tables, then you can delete from a view, or update or insert into a view.

You will be prevented from using INSERT, UPDATE and DELETE if you create a view based on a select statement that includes any of the following:-

- Ommission of any required columns (NOT NULL) in that underlying table
- GROUP BY or any other aggregation
- DISTINCT
- a FROM clause that reference more than one table (`It is possible to execute DML where all updatable columns of a view belong to a key-preserved table`)

Also for those views with values of columns which are delivered from multiple values, you can not update those views

consider a view with a columns from a table called id, first_name and last_name, and phone_book, and the table called my_table,

```sql
CREATE VIEW my_view AS SELECT id, first_name || ', ' || last_name || as full_name, phone_book from my_table;
```

we can't reference the columns first_name and last_name since they are delivered in our view, for our insert to execute successfully, we should completely omit those columns in our insert statement. If we try to reference them, our insert statement will fail,
Or if we try to insert into a view based on a table that have some constraints on the columns that we delivered from other columns, it will fail also

actual work below:-

```sql
create or replace view emp_phone_book as
select employee_id, last_name || ', '||  first_name as full_name, phone_number from employees;

insert into emp_phone_book (employee_id, phone_number) values (207, '590.423.7890'); -- this fail since first_name can't be null
delete emp_phone_book where employee_id = 206; -- this deletes the employee from the actual table
```

If we attempt to delete data as above from the view, then data will be deleted

with regard to the general question of using DML on any given view, ANSWER is as follows:-

- If the view provide row-level(not-aggregated) access to one and only one table and includes the ability to access the required columns in that table, then you can use DML (INSERT, UPDATE, and/or DELETE) on the view to effect changes to the underlying table, in accordance with the restrictions listed earlier.
- Otherwise, you may not be able to successfully execute a change to the view's data

NOTE `the INSTEAD OF trigger can cause a non-updatable view to behave as if it were updatable, but PL/SQL features are not in the exam`

### INLINE VIEWS

is a subquery that is contained within a larger SELECT statement that it replaces the _from CLAUSE table_.
eg

```sql
SELECT * FROM (SELECT * FROM DUAL);
```

There is no limit to a number of inline views you can nest;
Unlimited nesting is different from the limit of subqueries is 255 nested subqueries
Inline views can be combined with different various queries such as those in JOIN and GROUP BY clauses and more
An inline view can be any valid SELECT statement, placed into a SQL statement where the FROM clause would normally go.
Great usage is addressing an issue with pseudocolumn ROWNUM, the challenge with ROWNUM is it is assigned before the ORDER BY clause is processed, the result is you can't sort rows and use ROWNUM asa way of displaying, eg the line number of each row of output, the result will be mixed up since ROWNUM is determined before ORDER BY clause is processed. But you can use the ROWNUM in an inline view and use ROWNUM on the outer query to display row numbers correctly.

### ALTER VIEW

Is used to accomplish any of the following tasks

- Create, Modify or Drop Constraints on a view
- Recompile an invalid view - this is performed when you created a view, and later performed some modifications on the underlying table(s), in which depending on a change, a view may be rendered invalid as a result.

the subject of constraints on a view is not on the exam. Oracle does not allow view constraints without special configuration (see DISABLE NOVALIDATE in oracle documentation)

There are two possible outcomes when the view tables get modified:-

1. If the changes were made in a way the original CREATE VIEW statement would have successfully executed anyway, the subsequent statement on the view will cause the view to recompile and execute succesfully as nothing happened, since it didn't
2. If the changes were made in a way the original CREATE VIEW statement wouldn't have executed, subsequent attempts will fail, and the ALTER VIEW will have to be issued to drop columns in the view's column list

Later, we will view how to see a valid view and invalid one from the data dictionary view
An alternate to querying the data dictionary, is to issue an `ALTER VIEW view_name COMPILE` command,
If the view can't be recompiled an ALTER VIEW statement will successfully execute with a message declaring "Warning: View altered with compilation errors." - Here the data dictionary will show the view remaining invalid

```sql
ALTER VIEW emp_phone_book COMPILE;
```

NOTE: `you can't change the view's select statement with ALTER VIEW, you must drop and recreate the view instead.`

- Successful compilation returns the view into a working view
- if it does not compile, the underlying tables may have faced changes forcing RECREATION of a view, eg column rename

In addition, if you try to use an invalid view, it will compile automatically. if it can be compiled, the attempt to use will be successful, if it can't be compiled, contrary to the ALTER VIEW ... COMPILE, the attempt to use any view that can't automatically be compiled will cause an error.

## VISIBLE and INVISIBLE columns

Views are based on tables, and tables can have invisible and visible columns

### VISIBLE columns and tables

all table columns are visible by default. but with 12c you can specify one or more columns to be invisible, consider the sytnax

```sql
CREATE TABLE table_name (
    columns list,
    column_name DATA_TYPE INVISIBLE
);

CREATE TABLE ship_admins(
    ID NUMBER PRIMARY KEY,
    SHIP_ID NUMBER,
    CONSTRUCTION_COST NUMBER(14,2) INVISIBLE
);

DESC ship_admins
```

invisible columns are not displayed and described by default in Oracle. even with the (\*) asterisk for columns, it won't show unless you explicitly list it.
NOTE: using oracle SQL\* Plus Tool you can set the settion variable `SET COLINVISIBLE ON` to display invisible columns and desribe them as below

```sql
SET COLINVISIBLE ON;
DESC ship_admins;
select * from ship_admins;
select id, ship_id, construction_cost from ship_admins;
SET COLINVISIBLE ON; --RESTORE THE VALUE
```

you can only deal with invisible columns when you specify them, even in insert stament if just insert without specifying them, and you supply values for them, the insert will fail.

```sql
insert into ship_admins values (1, 3, 678000.00); -- too many values error
insert into ship_admins(id, ship_id, construction_cost) values (1, 3, 678000.00);
select * from ship_admins;
select id, ship_id, construction_cost from ship_admins;
```

INVISIBLE COLUMNS and VIEWs

- views from select \* from a table with invisible columns, won't include invisible columns, the wildcard ignores invisible columns
- views with select where invisible columns are explicitly specified, will create a view containing invisible columns
- When working with a table with invisible columns, you can create a view based on those columns only if they are specified, the invisible columns in the table will be visible to the view, both in the view structure and in interactions with the view
