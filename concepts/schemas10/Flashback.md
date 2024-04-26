# Flashback Operations

these operations consist a number of features that enable access to database data and objects in their past state
Some of these features are:-

- FLASHBACK TABLE
- FLASHBACK DROP
- FLASHBACK QUERY
- and more

Understanding all FLASHBACK features is beyond the scope of the book, but we will look at some of them
Some of the features we will discuss might require oralce Enterprise Edition, hence, they might not be available for the Express edition like FLASHBACK TABLE,
but FLASHBACK QUERY, will work fine and some few others

## OVERVIEW

FLASHBACK OPERATIONS include a variety of statements you can use to recover objects and/or data contained with them, as well as dependent objects and data. Some of these tasks include the following:-

- Recovering complete tables you may have inadvertently dropped
- Recovering data changes within one or more tables, resulting from a series of DML
- Performing data analysis on data that's been changed over periods of time
- Comparing data that existed at one point in time with data that existed at another point in time
- Performing queries as of a prior time period

Flashback operations can support multiple user sessions gaining access to historical data dynamically, on any table (including same table) at the same time. with each session potentially accessing different points in the history of the table simultaneously, all while the database is up and running in full operational mode

Some features may requires special configuration steps, some configuration may be involved and might require intervention by the database administrator, coonfiguration required can affect system parameters, table clauses and a feature of the database known as the undo segments, which have a purpose going beyond flashback

## RECOVER DROPPED TABLE

In managing schema objects, we can use FLASHBACK TABLE since is the only one useful for that accord. You can recover a previously dropped table to a certain point in the past.However, There are some limitations, eg you can not flash back to a point prior to when the table's structure was altered

You can identify the point in time to fash back to in various ways:-

- Immediately prior to when the table was dropped
- A specific time identified by a value of data type TIMESTAMP
- specific transaction identified by the System Change Number`(SCN)`
- A predetermined event identified by a db object known as a RESTORE POINT

When you used to restore table, FLASHBACK TABLE restores the table with its original name or a new name you specify, It also recovers any indexes on the table `other than BITMAP JOIN INDEXES`
Also, constraints are recovered, except referencial integrity constraints that reference other tables, ie FOREIGN KEY constraints.
Granted privileges are also recovered

the syntax of the flashback table is as follows:-

```sql
FLASHBACK TABLE table_name(or names separated by commas) TO BEFORE DROP {RENAME TO new_table_name};
drop table kid;
flashback table kid to before drop;
select * from kid;
```

`NOTE`: you can not rollback a FLASHBACK TABLE statement

## RECYCE BIN

FLASHBACK statement recovers complete tables that are still in the recycle bin, it can do so in spite that change results from a DDL command, DROP TABLE that includes an IMPLICIT commit, inspite all those, we can recover a table if is still in the recycle bin
Tables are put there automatically, whenever a DROP TABLE statement is issued, the table's dependent objects are also put in the recycle bin(indexes), along with the tables constraints

The recycle bin is not counted as the space that is used by a given user account
The user account's dropped objects are retained in a separate recycle bin for each user, and there is on for the DBA

you can inspect the recycle bin using the following statement

```sql
SELECT * FROM USER_RECYCLEBIN; -- or the below statement which are actually equal to this one
SELECT * FROM RECYCLEBIN; -- RECYCLEBIN and USER_RECYCLEBIN are synonyms of each other
-- FOR THE GLOBAL RECYLEBIN
SELECT * FROM DBA_RECYCLEBIN;
```

the DBA RECYCLEBIN allow user accounts with DBA privileges to see all dropped things, if you account has access to an object, your user account will be able to see it when it is dropped then,
the recycle bin is affected by the recycle bin initialization parameters

```sql
ALTER SESSION SET RECYCLEBIN = ON;
ALTER SESSION SET RECYCLEBIN = OFF;
```

The initial global state of the recycle bin is dependent on the SETTING for recyclebin initializaiton file, controlled by the DBA.
Setting recyclebin to ON or OFF, takes effect immediately, and the objects in the recyclebin will remain either way, removing objects from the recyclebin use the PURGE command

## DEPENDENT OBJECTS

Once a table is recovered, its dependent objects are also recovered, including the following:-

- Indexes, except BITMAP JOIN indexes
- constraints execept REFERECIAL INTEGRITY CONSTRAINTS
- other objects that are not beneficial for the exam eg triggers

you can recover mutliple objects with the same name that have been dropped, last one dropped will be the first one retrieved.
Obejcts such as indexes will be recovered with system assigned names, you can rename each object using the RENAME TO clause of the FLASHBACK TABLE statement as they are being recovered. THOUGH for now, is not the subject of the exam

### FLASHBACK TABLE statement execution

Flashback works as a single statement, if there are 3 tables in the statement, and the last one fails, then nothing is recovered.

## PURGE

This permanently remove the latest version of a given item from the recycle bin, so that it can't be recovered
The table must first be dropped for purge to execute successfully
syntax

```sql
PURGE TABLE table_name; -- for a table
PURGE RECYCLEBIN; -- for the whole schema recycle bin
PURGE DBA_RECYCLEBIN; -- for the entire database RECYCLE BIN
```

the `PURGE DBA_RECYCLEBIN` will only execute if the schema have a `SYSDBA` privilege, for that you can also describe and SELECT \* FROM the recyclebin and DBA_RECYCLEBIN

## RECOVER DATA WITH EXISTING TABLES OVER TIME

apart from recovering a dropped table, you can recover to a certain point in time, showing its state prior any committed changes that may have been transacted since the point in time of interest.
there are 3 frms of the syntax

```sql
FLASHACK TABLE table_name TO SCN scn_expression;
FLASHACK TABLE table_name TO TIMESTAMP timestamp_expression;
FLASHACK TABLE table_name TO RESTORE POINT restore_point_expression;
```

the recommended is using the SCN, is the mechanism for identifying points in time in the database

On thing, the capability to restore a tables to a certain state, doesnt exists by default, its only exists for tables where ROW Movement is enabled

Creating a table with row movement enabled, Heres how

```sql
CREATE TABLE table_name (options and constraints) ENABLE ROW MOVEMENT;

-- OR
ALTER TABLE table_name ENABLE ROW MOVEMENT;
```

Data restoration is permanent, it performs an implicit commit, ROW MOVEMENT is not required for TO BEFORE DROP flashback option
consider the example below

```sql
select * from kid;
delete kid where house = 'Kemmie';
commit;
alter table kid enable row movement;
flashback table kid to timestamp systimestamp - interval '0 00:10:00' day to second;
select * from kid;
```

### LIMITATIONS

You can't use FLASHBACK TABLE to restore older data to the table if it has been structurely altered with the ALTER TABLE statement in a way that a column name or a column data type has been changed, the flashback won't succesfully restore the data

## MARKING TIME

there are several ways to identify the point to which you want to restore data to in the database, as we saw three above, lets discuss them

### SCN

is a numeric stamp that the db automatically creates for every committed transaction that occurs in the database. Its for both explicit and implicit commits, for external and internal transactions
SCN is automatically managed by the database in real time. every committed transaction is assigned a SCN
Get the SCN at any given point we run the

```sql
SELECT DBMS_FLASHBACK.GET_SYSTEM_CHANGE_NUMBER FROM DUAL;
-- OR YOU CAN USE A DATA DICTIONARY
SELECT CURRENT_SCN FROM V$DATABASE;
```

The system change number for a given row, is stored with a
a presudocolumn ORA_ROWSCN for each row, and available with other presudocolumn during querying

```sql
SELECT ORA_ROWSCN, ID, HOUSE FROM KID;
```

### TIMESTAMP

this specifies a point in time, storing the year, montth, day, hour, minute,second and fractional seconds. the literal may be converted to timestamp using the TO_TIMESTAMP function and a format model, fractonal seconds goes to 6 points
If you attempt to FLASHBACK to a point in time where the DB didn't exist before, you get an error indication `invalid timestamp specified`
FLASHBACK can use the point in time for a database towards 3 seconds of accuracy.
If a specific point is needed, use SCN, don't use a TIMESTAMP
If the time you are referencing closely align with the time at which the object or data didn't exist, and the SCN/timestamp correlation misses your target, and overshoots into a timeframe in which the object or data didn't exist, you may get an oracle error
You can use one or more conversion to address the issue

- SCN_TO_TIMESTAMP(s1) -> takes in a numeric SCN value and returns a timestamp that is most likely to occur from that point in time
- TIMESTAMP_TO_SCN(s1) -> takes in a timestamp value and returns a SCN number

Any time referenced must be relevant to the DB, ie the time in which the db has been in existence
also TIMESTAMP_TO_SCN(SCN_TO_TIMESTAMP(number)) might not always return the same value, so oracle advises on using SCN and obtaining them through DBMAS_FLASHBACK.GET_SYSTEM_CHANGE_NUMBER package function
Also, if it is up for using restore point, it is advised that you get that point right, using the RESTORE POINT OBJECT

## RESTORE POINT

is a point in the DB created to represent a given moment in a database. It can be identified by a TIMESTAMP or a SCN
syntax creation of RESTORE POINT, and using it to restore to a certain point, and also how to drop the point

```SQL
CREATE RESTORE POINT point_name;
FLASHBACK TABLE table_name TO RESTORE POINT point_name;
DROP RESTORE POINT point_name;
```

User accounts does not own restore point objects, their scope is the entire database, they exist until they are dropped or age out of control file
you can find restore point objects using the V$RESTORE_POINT dictionary view scoped to the whole database,

Also, restore points executions are DDL hence they commit an implicit commit

from a normal stand point, you can not recover a purged table normal unles table achieve is enabled

## FLASHBACK `AS OF` statement

use of select statement with an AS OF clasue, retrieves data as it existed on an earlier time
a query explicitly references a past time as through a time stamp or system change number. It returns data as was current at that point in time

consider the queries below

```sql
SELECT * FROM table_name AS OF TIMESTAMP (timestamp expression);
```

the view FLASHBACK_TRANSACTION_QUERY consists of all flashback operations that have ever happened
including TABLE_NAME and commit_scn, user, and more

also you can perform maneuvers to insert the deleted rows with the current rows together in case of failure of data integrity

```sql
INSERT INTO ARCHIVE_TABLE
(SELECT * FROM table_name AS OF timestamp(expression)
UNION SELECT * FROM table_name
)
```

### RESTRICTIONS ON FLASHBACK QUERY

- the value specified must not be a subquery
-

## FLASHBACK ARCHIVE

These store flashaback data and retain them for as much as it is specified using the RETENTION parameter
you create a flashback archive and assign a quota to it, later you can create table and assign them to the flashback archive as below

```sql
CREATE FLASHBACK ARCHIVE {DEFAULT} archieve_name TABLESPACE tbs1 QUOTA XXG|XXM RETENTION X YEAR; -- You can specify an other timestamp
ALTER FLASHBACK ARCHIVE SET DEFAULT;
ALTER TABLE FLASHBACK ARCHIVE archieve_name;
CREATE TABLE table_name (parameters) ENABLE ROW MOVEMENT FLASHBACK ARCHIVE archieve_name;
-- disable

ALTER TABLE table_name NO FLASHBACK ARCHIVE;
```
