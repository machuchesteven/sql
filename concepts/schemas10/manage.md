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
