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

Is a rule on a table that restricts a value that can be added to a table's column.

### Views

### Indexes

### Sequences

## Create Simple and Complex Views with Visible/Invisible Columns

a view, a select statement with a name, stored in the db, accessibe as though it were a table
