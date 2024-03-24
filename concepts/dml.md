# Managing Data Using Oracle

## Table Truncating

Clears talble from the database without firing DML triggers and performs an explicit commit. The following are their features :-

- Performs an implicit commit, hence can't be rolled back
- Does not leverage the unused space from the database table
- Keeps the schema, indexes and constraints intact
- requires the DROP_ANY_TABLE privilege

```sql
    TRUNCATE TABLE table_name; -- the keyword TABLE must be specified, TRUNCATE can be used with CLUSTER (NOT IN EXAM)
```

Truncate clears data from the table and indexes built.

### Recursively Truncate `CHILD TABLES`

When there are Parent-Child relationships created, it is a bit difficult to truncate child table. But since 12c, we can truncate with child contents

```sql
TRUNCATE TABLE table_name CASCADE; -- child tables are those wuth the FOREIGN KEY constraint AND ON DELETE specified on them
```

The above operation works only for `ON DELETE CASCADE` and `ON UPDATE CASCADE` relationships.

## Insert Values to Table

During an INSERT operation, the following are perfomed by the insert statement

- Check for the presence of the table and the columns specified
- Check for expressions and values to be applied to the table
- Compare values with associated columns in the table and evaluate compatibility
- Apply constraints verification on those columns with constraints before insert

If all statement are validated above, the row is executed and get inserted into the table. Consider examples below:-

```sql
INSERT INTO CRUISES
(CRUISE_ID, CRUISE_TYPE_ID, CRUISE_NAME, CAPTAIN_ID,START_DATE, END_DATE, CRUISE_STATUS)
VALUES
(1, 1, 'Day At Sea', 101, '02-JAN-10', '09-JAN-10', 'Sched');

INSERT INTO CRUISES
VALUES
(2, 1, 'Another Day At Sea', 101, '02-JAN-10', '09-JAN-10', 'Sched');
```

If the statements are in the same order as the columns in the table, we could omit the table columns definintions like in the second example above

For the second statement, if the Table Structure changes the statement might fail. Hence leaving the first alternative the best way so far.

### Enumarated Columns List

As much as you specify which columns to insert data into, their order is not a must to match that in a table

The other feature is that, once you specify the columns to insert, you can ommit not mandatory columns in the columns list.

### Data Type Conversion

When inserting into a table, the data type are verified during the insert statement, It is a must for data types of columns to be compatible, **NOT IDENTICAL**. Eg this will work
`INSERT INTO CRUISES (CRUISE_ID, CAPTAIN_ID) VALUES (3, '101');`.

This is because Oracle is Smart enough to understand the value in quotes is an integer value. the feature is known as **`Implicit Data Type Conversion`**

oracle performs implicit data type conversion wherever possible, but it is adviced to rely on Explicit Conversion Functions to avoid problems with data types.

### Failures in Constraints

The statement might be syntaxically correct, but logically incorrect.
All failures in Constraints result into run-time errors.

using the following check for a column called city

```sql
CHECK (CITY IN ('New York', 'Atalanta', 'San Francisco', 'Miami', 'Indiana'));

insert into cities(ciry) values ('Dar es Salaama');
```

The above statement will fail becasue the city added is not in the list of cities provided in the check constraint above. This is correct by syntax but incorrect by logic. Hence run-time error is thrown here.

## Update Data in a Table

The `UPDATE` statement is used to modify data in a table, works on a single table at a time, and can be used to modify individual row or a list of rows in a table.

As with `INSERT`, the `UPDATE` statement can also work with some `VIEW` objects to update data in those tables which the view are built upon. We will see later.
