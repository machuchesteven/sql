# Manage Objects with Data Dictionary Views

The Data dictionary views are real time reference source for all information about the applications that are built in the database.
With data dictionary views, you get information about what is in the database, who created them, when and much more

## Query Various Data Dictionary Views

Data dictionary is a collection of database tables and views. Automatically built and populated by Oracle Database
All database objects you create as part of your application are part of the data dictionary view
also, the result of each DDL statement is recorded in the dictionary, and the info is automatically mantained by Oracle system in real time as you change objects and their structures

Information stored in data dictionary views include but they are not limited to:-

- names of database objects, their owners and when they were created
- names of each tables columns, along with dt, precision and scale
- any constraints
- views, indexes, sequences

### STRUCTURE

Data dictionary consist of tables owned by the user account SYS,
SYS has full privileges over these tables and views. These tables are not to be altered otherwise the system integrity is compromised.
The SYS account is only used for database system maintenance, and only the system administrator(DBA) is having access to it exclusively.
All data dictionary info are stored in tables, but much are presented through views, which provide a limited access to protect db integrity.
These objects are renamed via public synonyms, and are the names by which we know the data
All DDL issued, causes an automatic update to the Data Dictionary, the update is handled by the system and applied to the tables that form foundation for the views
Based on these, user do not explicitly update any information in the Data Dictionary, except for comments where they are allowed to add
There are more than 2000 view in the data dictionary, one particular is the good starting point, the DICTIONARY view, that contains information about the views that compose the data dictionary. Contains a view name and exaplanation for each view

Some of other views are as follows:-

- USER_TABLES - Consists of information about tables owned by the current user, with a lot of columns but these are important ones - Table_name, status, row_movement, avg_row_len

in viewing data dictionary views, there are three prefixes that are useful, `USER_, ALL_` and `DBA_` most of these share the same data dictionary table, eg ALL_CONSTRAINTS, USER_CONSTRAINTS, and DBA_CONSTRAINTS share the constraints dicionary table but based on privileges and request, they model the results as asked

### Views prefixes chart

| Prefix                                   | No of Views | Description                                                                                            |
| ---------------------------------------- | ----------- | ------------------------------------------------------------------------------------------------------ |
| USER\_                                   |             | Views for the current user account                                                                     |
| DBA\_                                    |             | views about all objects to the database regardless of who own them and which privs are granted to them |
| ALL\_                                    |             | anything in the database that the current user has access to                                           |
| V\_$(for views) V$(for public synonyms)  |             |                                                                                                        |
| GV\_$(for view) GV$(for public synonyms) |             |                                                                                                        |

|Others SMS, AUDIT, CHANGE, TABLE, SESSION*, NLS*, ROLE\_
|||

### Some of the Selected Data Dictionary Views

The following are selected and shows for a specified user

| Suffix            | Description                                                           |
| ----------------- | --------------------------------------------------------------------- |
| USER_CATALOG      | all tables, views, synonyms and sequences owned by a user             |
| USER_COL_PRIVS    | grants on all columns owned by a user                                 |
| USER_CONSTRAINTS  | constraints on tables owned by a user                                 |
| USER_CONS_COLUMNS | accessible columns in constraint definitions for tables owned by USER |
| USER_DEPENDENCIES | Dependencies to and from a user objects                               |
| USER_ERRORS       | current errors on stored objects owned by a user                      |
| USER_INDEXES      | indexes owned by a user                                               |
| USER_IND_COLUMNS  | columns in user tables used in indexes owned by a user                |
| USER_OBJECRS      | objects owned by a user                                               |
| USER_SEQUENCES    | sequences owned by a user                                             |
| USER_SYNONYMS     | private synonyms owned by a user                                      |
| USER_TABLES       | tables owned by a user                                                |
| USER_TAB_COLUMNS  | Columns in user tables and views                                      |
| USER_TAB_PRIVS    | grants on objects owned by a user                                     |
| USER_VIEWS        | Views owned by a user                                                 |
| ALL_DIRECTORIES   | all directories in the user table                                     |

The USER_SYNONYMS only shows private synonyms and you can not see public synonyms even if you are logged in to the account that created them, you can find public synonyms in the ALL_SYNONYMS and DBA_SYNONYMS views only

### DYNAMIC PERFORMANCE VIEWS

include reference to views starting with the prefix V\_$ and GV\_$.
They are defined as Dynamic performance views and global dynamic performance views
Dynamic performance views display information about current database activity in real time. They receive data dynamically from the database through mechanism beyond the exam
The dynamic performance views starts with the prefix V\_$. There are public synonyms created for each of the views and they have similar names but starts with the prefix V$.
Simple queries on dynamic performance views are allowed but complex queries requires special attention
To create joins, it is advised you perfom the following to avoid read data inconsistencies:-

1. Create a set of temporary tables to mirror the views
2. Copying the data out of the views and into a set of temporary tables
3. Perform the join on temporary tables

By doing these things you are avoiding getting bad results caused by lack of data inconsistencies

Some of these dynamic performance views include the following:-

- `V$DATABASE` - include information about the database itself
- `V$INSTANCE` - include the instance name, host name, startup time and more
- `V$PARAMETER` - contains current settings for system parameters
- `V$SESSION` - contains many current settings for each individual user session, showing active conns, login timesm, machine names used for login and more
- `V$RESERVED_WORDS` - contains a list of reserved words, and info showing whether the keyword is always reserved or not
- `V$OBJECT_USAGE` - useful for monitoring of usage of INDEX objects - this view is deprecated
- `V$TIMEZONE_NAMES` - contains two cols, TZNAME and TZABBREV which is the time zone abbreviation

`NOTE`: only simple queries are recommended when querying the V$ and V\_$ views directly.

### READING COMMENTS

data dictionary are rich with comments, which describe the intent of various views of the data dictionary and columns within them.
in addition to comments provided in DICTIONARY view, we can also view comments about columns within those view or about any object stored anywhere in the database

- `ALL_TAB_COMMENTS` - Displays comments for all OBJECTS in the database
- `ALL_COL_COMMENTS` - Displays comments for all COLUMNS of all tables and views in the database
  example for reading comments is shown below:-

```sql
SELECT * FROM ALL_TAB_COMMENTS;
SELECT * FROM ALL_COL_COMMENTS ;
SELECT COUNT(*) FROM ALL_COL_COMMENTS WHERE OWNER = 'SYS' AND TABLE_NAME = 'USER_SYNONYMS'
```

### ADDING COMMENTS

you can add comments to the data dictionary to add notes and descriptions about the tables and columns you create.
the COMMENT statement is the one we use to add comments to the data dictionary and even our own objects in the database

syntax is:-

```sql
COMMENT ON objectType fullObjectName IS c1;
COMMENT ON objectType fullObjectName IS '';
```

you can't drop a comment from the data dictionary instead, we can change it to blank as see above, Once set to blank it changes to NULL

where

- ObjectType - is one of the keywords TABLE, COLUMN, or some other object that are not subject of the certification exam eg INDEXTYPE, OPERATOR, MATERIALIZED VIEW and others
- fullObjectName - is the name of the object that we add the comment, if is a table just name, for a column user TABLE.COLUMN syntax
- c1 - is the full text of the comment you want to add

### DICTIONARY

The view contains the following columns, the TABLE_NAME, and COMMENTS
You can run a simple query to show all of its contents in your own user account,

```sql
SELECT * FROM DICTIONARY;
SELECT * FROM DICTIONARY WHERE TABLE_NAME = 'USER_DEPENDENCIES';
SELECT COUNT(*) FROM DICTIONARY;
```

## IDENTIFYING USER'S OWNED OBJECTS

there are some views which gives information about your own user account's objects. These in particular are USER_CATALOGS and USER_OBJECTS.

### USER CATALOG (synonym is CAT)

displays a summary lsiting of tables, views, synonyms and sequences owned by the user
it can be described using
`DESC USER_CATALOG` as it contains two columns, Table_name and Table_type
TABLE_NAME gives the name of the object and TABLE_TYPE gives the type of the object eg SEQUENCE, TABLE, SYNONYM, VIEW

On the user catalog there should have at least a working knowledge of the basic views and what they basically contain

### USER OBJECTS (synonym is OBJ)

This contains information about all objects contained by the user
basic information including OBJECT_NAME, SUBOBJECT_NAME, OBJECT_ID, OBJECT_TYPE, CREATED, STATUS, ORACLE_MANTAINED and more

```sql
DESC OBJ;

SELECT * FROM OBJ;
SELECT * FROM ALL_OBJECTS;
SELECT * FROM DBA_OBJECTS;
```

### inspecting Tables and Columns

the user_tables and (synonym TABS) is contains table metadata, and `USER_TABS_COLUMNS`(synonyms COLS) contains the column names for the tables shown

you can select data types of columns in you tables and list them

```sql
SELECT COLUMN_NAME, DECODE(
    DATA_TYPE,
    'DATE', DATA_TYPE,
    'NUMBER', DATA_TYPE || DECODE(DATA_SCALE,
        NULL, NULL,
        '(' || DATA_PRECISION || ', ' || DATA_SCALE || ')'
        ),
    'VARCHAR2', DATA_TYPE || '(', DATA_LENGTH || ')', NULL
    ) DATA_TYPE
    FROM USER_TAB_COLUMNS
    WHERE TABLE_NAME = 'INVOICES' OR TABLE_NAME = 'KID';
```

### COMPLING VIEWS

one useful task for views is checking for the status of created views, if the table is altered in any way, the view might need recompilation, since these changes may change the status of the view to invalid
We can check the DATA dictionary user objects to check for the status of the view as follows

```sql
SELECT STATUS, OBJECT_TYPE, OBJECT_NAME
FROM USER_OBJECTS
WHERE STATUS = 'INVALID'
ORDER BY OBJECT_NAME;
```

also, to see the query used for creating a view, we can select the TEXT col of the USER_VIEWS data dictionary view and see the corresponding query.

```sql
SELECT TEXT FROM USER_VIEWS; -- the view contains VIEW_NAME, TEXT_LENGTH and TEXT
```

### CHECKING PRIVILEGES

privileges will be discussed later in deeper details, currently
we have to note that we can inspect privileges using the following views:-

- `USER_SYS_PRIVS` -> system privileges granted to the current user
- `USER_TAB_PRIVS` -> granted privileges on objects in which the user is the owner, grantor or grantee
- `USER_ROLE_PRIVS` -> Roles granted to the current user
- `DBA_SYS_PRIVS` -> System privileges granted to users and roles
- `DBA_TAB_PRIVS` -> All grants on objects in the database
- `DBA_ROLE_PRIVS` -> roles granted to users and roles
- `ROLE_SYS_PRIVS` -> system privileges granted to roles
- `ROLE_TAB_PRIVS` -> table privileges granted to roles
- `SESSION_PRIVS` -> session privileges that the current user currently has set

### INSPECTING CONSTRAINTS

The USER_CONSTRAINTS view is the most crucial piece here,
you can query it to check the current state of constraints on any table
It contains CONSTRAINT_TYPE, CONSTRAINT_NAME, OWNER, SEARCH_CONDITION, and more including the R_CONSTRAINT_NAME(for relationships since R is for FOREIGN constraints)
constraint types and their meaning are as follows:-

- `P` - PRIMARY KEY
- `R` -FOREIGN KEY(R stands for REFERENCIAL INTEGRITY)
- `U` - UNIQUE
- `C` - CHECK or NOT NULL (since a NOT NULL is a check with value Columns IS NOT NULL)

There are additional constraints and are beyond the context of the exam,
`NOTE`: check note of constraints which have a different character as their names including C for NOT NULL and R

### FINDING COLUMNS

there s another query useful for querying the list of columns in the tables and view

the dictionary looks for tables that have particular columns names and or certain tables with specified values
