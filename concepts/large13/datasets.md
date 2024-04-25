# Manipulating Large Datasets

this is a great point for working with large groups of data
They help use one INSERT statement to add data to a single or more tables, with or without conditional logic
Also the MERGE statement in SQL, which helps combine feature of multiple DML statements into a single SQL statement

## feature of multitable INSERTS

this insert repeats the INTO of the insert statement to insert data into more than one table.
each into clause applies to just one table, but repeating the into clause helps add data to multiple tables
multitable INSERT statements can accomplish a variety of tasks including

- Query data from one table, and insert them into multiple tables with conditional logic, such as transforming data into a series of achieve tables
- exchange data between two similar systems of different requirements, eg transaction based app and an analysis data warehouse
- support logical archiving at any level of detail with logical decision points embedded in the INSERT statements
- Integrate complex queries with GROUP BY, HAVING, set operators and more, all while moving any number of rows dynamically, distributing output into multiple data targets, and programmibg logical decision points to control data distribution
- transform data that is stored in rows and levels into a cross tabulation output type you would typically see in a spreadsheet application

There are two arrangements of multitable inserts

- `Unconditional Multitable Insert` - process each of the INSERT statement's on or more INTO clauses without conditions for all rows returned by the SUBQUERY.
- `Conditional Multitable Insert` - use WHEN conditions before into clause(s) to determine whether the INTO clause will execute for a returned row. Finally an optional ELSE clause can include an alternative INTO clause that can be executed if none WHEN condition is true.

Lets have a look at the syntax, first with UNCONDITIONAL Multitable INSERT

```sql
INSERT ALL
    INTO table1  VALUES (col_list_1)
    INTO table2 VALUES (col_list_2)
    INTO table3 VALUES (col_list_3)
    ...
    subquery;
```

this syntax assumes that

- the Keyword ALL is required in an unconditional multitable INSERT
- after ALL, there must be at least one INTO clause
- you can include multiple INTO clauses
- each values list is optional, if ommitted the select list from the subquery will be used
- a subquery is a select list that can stand alone

### Conditional Multitable Insert Syntax

The syntax is similar but add the WHEN conditions

```sql
INSERT option
    WHEN expressions THEN
        INTO tab1 VALUES (col_list_1)
    WHEN expressions THEN
        INTO tab2 VALUES (col_list_1)
    WHEN expressions THEN
        INTO tab3 VALUES (col_list_1)
    ...
    ELSE
        INTO tab4 VALUES (col_list4)
    subquery;
```

for each row returned by the subquery, each WHEN condition is evaluated to be either true or false
if none of the WHEN is true, the ELSE executes, and its associated set of one or more into clauses is executed
the syntax above has the following:-

- `option` - either ALL or FIRST. `ALL` is the default and may be ommitted, FIRST means only the INTO clauses that will execute are those falling under the first WHEN that evaluates to true
- each WHEN condition is followed by one or more INTO clauses
- each INTO clause has its own VALUES clause if ommitted the subquery select list must match the number and data types of the subquery
- each expression evaluates to true or false, and should involve one or more columns from the subquery
- optional ELSE .. INTO clause, if included must be last
- subquery must be a valid SELECT statement

for any multitable insert with the WHEN keyword, ALL is the default option
if there is no ANY, then the INSERT is unconditional, and the ALL keyword must be present
`MULTITABLE INSERTS requires a SUBQUERY`
and the INSERT statement executes as a single statement, and in case any of the rows fails in Multitable insert, then all rows fails for the entire subquery

## RESTRICTIONS for INSERT ALL

- can be used to insert data into tables only
- can not be used to insert data into remote tables
- number of `columns` in all the INSERT INTO clauses must not exceed `999`(sum of all columns across the whole INSERT ALL statement)
- a table collection expression can not be used with INSERT ALL
- subquery of the insert all can not use a sequence

## USING MULTITABLE INSERTS

Here we look at examples of multitable insert statement in action,
Conditional, Unconditional and Spreadsheet pivot feature

### UNCONDITIONAL INSERT

as we saw, it ommits the controll logic, let create a folder and add it to one of our external tables
consider, we have a txt file with the name of our kids and we turn it into an external table
then we load the data via unconditional multitable insert

```sql

create table kids_ext (id char(50), name char(50)) -- External tables recognized char not varchar2
organization external(
type oracle_loader
default directory book_files
access parameters(
    records delimited by newline
    fields terminated by '	' ( -- hear can add MISSING VALUE IS NULL AND OTHER FIELD FORMATING OPTIONS
    id char(50),
    name char(50)
    )
)
location ('kids.txt')
);
-- creating an external table
insert all into kid (id, house) values (to_number(id), trim(name))
            into family (id, house) values (to_number(id), trim(name))
        select id, name from kids_ext;
select * from family;

select rpad(to_char(id), 10) || lpad(house, 30) as summary from kid;
```

in the INSERT of an unconditional INTO clause, each tables values list is independent of other tables
and lets try inserting a value of a sequence,

`SEQUENCES ARE NOT ALLOWED IN MULTITTABLE INSERTS in both the values list or the subquery`

### CONDITIONAL INSERT

these use conditional logic to determine which INTO clause or clauses to process, each row is processed through a series of one or more WHEN condition
Here we either use the ALL(default) or the FIRST clause for inserting values into the tables
and once no condition is met, then the else is executed for each individual row returned by the subquery

```sql
INSERT FIRST
    WHEN  rem = 0  THEN
        INTO kid (id, house) values (id, clean_name)
    WHEN  rem = 1  THEN
        INTO family (id, house) values (id, clean_name)
    select mod(to_number(id), 2) rem, to_number(id) id, trim(name) clean_name  from kids_ext;

-- also for insert all
INSERT ALL
    WHEN  rem = 0  THEN
        INTO kid (id, house) values (id, clean_name || to_char(id))
    WHEN  rem = 1  THEN
        INTO family (id, house) values (id, clean_name || to_char(id))
    select mod(to_number(id), 2) rem, to_number(id) id, trim(name) clean_name  from kids_ext;
```

also, table alias are not recognized in the values of a multitable insert, its just a column alias

also you can not execute a multitable insert on a view, it can only be applied on tables,

alos, sequence generators behave differently in multitable isnert, consider that they might increment each time regardless of whether the row met a condition or not when passed, and they may or may not raise an error, hence it is suggested to avoid using sequence generators
oralce warns you can not use a multitable insert with a sequence generator and this is pretty strict now
the attempt to invoke the sequence generator from the WHEN or INTO clause of the inSERT may produce undesirable results

### PIVOT TABLES

here we can use a conditional MULTITABLE insert to transform data from a spreadsheet structure to a rows-and-columns structure.
The section describes the technique
the approach makes more sense in this context, when you have rows of data, and these rows are to be inserted into a certain table, in which there values have to be reflected in a row to column basis and you have defined types of columns which mostly categorize one or two values of data, using multitable insert, these values can be transformed into those rows to be inserted into the corresponding table

consider a speadsheet summary table below which is transformed into a table and it's values inserted

| ROOM_TYPE    | OCEAN | BALCONY | NO_WINDOW |
| ------------ | ----- | ------- | --------- |
| ROYAL        | 1745  | 1635    |           |
| SKYLOFT      | 722   | 722     |           |
| PRESIDENTIAL | 1142  | 1142    | 1142      |
| LARGE        | 225   |         | 211       |
| STANDARD     | 217   | 554     | 586       |

Lets call the table SHIP_CABIN_GRID, then the data above have to be moved to the table called SHIP_CABIN_STATISTICS

with the schema as follows:-

```sql
CREATE TABLE SHIP_CABIN_STATISTICS (
    SC_ID NUMBER(7),
    ROOM_TYPE VARCHAR2(20),
    WINDOW_TYPE VARCHAR2(10),
    SQ_FT NUMBER(8)
);
```

The data above have to be transformed that each individual column in the table is transformed into a single row into the database
we can do that using multitable insert with different logic and different conditions as below
once all the values are executed, columns are perfectly transformed into a single row value

```sql
INSERT ALL
    WHEN OCEAN IS NOT NULL THEN
        INTO SHIP_CABIN_STATISTICS (ROOM_TYPE, WINDOW_TYPE, SQ_FT) VALUES (ROOM_TYPE, 'OCEAN', OCEAN)
    WHEN BALCONY IS NOT NULL THEN
        INTO SHIP_CABIN_STATISTICS (ROOM_TYPE, WINDOW_TYPE, SQ_FT) VALUES (ROOM_TYPE, 'BALCONY',BALCONY)
    WHEN NO_WINDOW IS NOT NULL THEN
        INTO SHIP_CABIN_STATISTICS (ROOM_TYPE, WINDOW_TYPE, SQ_FT) VALUES (ROOM_TYPE, 'NO_WINDOW', NO_WINDOW)
    SELECT ROOM_TYPE, OCEAN, BALCONY, NO_WINDOW FROM SHIP_CABIN_GRID;
```

### MERGE WITH ORACLE

Merge helps perform multiple DML operations in a single query based on source and target tables comparison
is a sql DML that can combine the functionality of INSERT, UPDATE and DELETE, all into a single statement

there's nothing you can do with MERGE that can not be done with individual statements
in other words, MERGE is preffered since it performs more efficiently by combining all functionalities and perform them together
the MERGE syntax

```sql
MERGE INTO table
USING table | subquery
ON condition
WHEN MATCHED THEN
    UPDATE SET col = expression | DEFAULT
        WHERE condition
    DELETE WHERE condition
WHEN NOT MATCHED THEN INSERT (col1, col2)
    VALUES (expression1, expression2 | DEFAULT)
    where clause
WHERE condition;
```

- `INTO`- specifies the target where you are inserting or updating rows, it can be a table or an updatable view
- `USING`- identifies the source of data, can be a table, view, or a subquery
- `ON` - condition for merge and behave like a normal WHERE condition, determines how to compare each row in the USING data source with each row in the MERGE INTO data target, can use boolean operators and expressions to form complex comparison, In practice is mostly limited to comparing primary key values, though this is not required. the line is required
- Line 4 to 6, update condition, identify the logic for MERGE to update target rows, it can not update the column in the ON condition
- Line 7 to 9 are the INSERT clause, and specify the INSERT
- the WHERE clause, gives a condition for merge to take place

`NOTE` - MERGE, represents a combination of the UPDATE and INSERT DML statements and, to a lesser and somewhat limited extent, the DELETE statement

- when MERGING, you can not reference the `TARGET_TABLE` in where of the INSERT statement, when matched is not true, since you cannot reference to nothing

NOTE: DO NEVER REFERENCE THE TARGET_TABLE IN A NOT MATCHED STATEMENT OF THE MERGE
