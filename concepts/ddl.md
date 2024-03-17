# Managing Schema Objects in Oracle

In oracle there are more than 8 database objects, but here we are just using tables. Tables are used to store data in the database.

## Types of Database Objects in Oracle

In the lsit here below, listed with a star are the included in the exam.

- Constraints
- Tables
- Sequences
- `Roles`
- Indexes
- `Users`
- Views
- Private Synonyms
- `Public Synonyms`

The following are objects that are not covered in the exam :-

- Clusters
- Object Tables
- Object Views
- Object Types
- `Contexts`
- Database Links
- Operators
- Database Triggers
- Packages
- Dimensions
- `Restore Points`
- `Directories`
- `Editions`
- `Rollback Segments`
- External Procedure Libraries
- Stored Function/Procedures
- Index Organized Tables
- Indextypes
- Java classes etc.
- Materialized Views
- Materialized View Logs
- `Tablespaces`
- Mining Models

Non schema objects are those marked differently

## A Brief Description of Database Objects

1. **TABLE** - a structure that can store data. All data are stored as columns and rows, each column data type is explicitly defined.
2. **INDEX** - an object defined to support faster seaches in a table. how it works - like a table index, copies a portion of data, sorts them for faster reference, then tie them to locations of actual data in a table for faster reference or quick lookups.
3. **VIEW** - a filter through which you can search a table and interact with a table, it does not store data but you can use it as a gateway to interact with data. Serves as a window into one or more tables. They can be used to mask a portion of underlying table logic for various reasons. eg simplify business logic, or add the layer of security by hiding the real source of data. Can display some part of the table while hiding other parts.
4. **SEQUENCE** - a counter often used to generate unique numbers as identifiers for new rows as they are added to a table.
5. **SYNONYM** - an alias for another object in the database, often used to specify an alternative name for a table or view.
6. **CONSTRAINT** - A small bit of logic defined by DB developer to instruct a particular table on how it will accept, modify or reject incoming data
7. **USER** - The owners of database objects
8. **ROLES** - a set of one or more previleges that can be granted to a user

Each of above are considered to be schema objects or non-schema objects,

## A SCHEMA

`by Oracle` -> the schema is a logical collection of database objects.
a collection of certain database objects eg tables, indexes, and views all of which are owned by a user account.

`User Account` houses the objects owned by a user, and the schema is the set of those objects housed therein.
A user account should be seen and used as a logical collection of database objects, driven by business rules and collected into one organized entity - Schema.
as seen above, for synonyms, private synonyms are schema objects but public synonyms are nonschema objects.

### Schema and NonSchema Objects

`Schema Objects` are those objects that can be owned by a user account, `NonSchema Objects` can not be owned by a user account
eg a USER objects can not be owned by a user account, and cant be owned by another user account, hence it is a non schema object since it is owned by the database itself. also for roles.
for synonyms, private synonym is owned by a user account, but a public synonym is not owned.

`A PUBLIC SYNONYM` is owned by a special user account, **PUBLIC** and whose owned objects are available to all users, hence making it a nonschema object.

## Table Creation in Oracle

Requierements - be able to define the table's name, column names, data types, and any relevant constraints

The CREATE command structure, this is a command that can be used to create database objects mostly

```sql
    CREATE ObjectType ObjectName attributes;
```

- **ObjectType** is a ref to an object listed above, except you can't create `CONSTRAINT` in this way. also, though `CREATE PRIVATE SYNONYM` is correct, u just `CREATE SYSNONYM` for public synonyms.
- **ObjectName** is the name you specify according to naming rules and guidelines
- **Attributes** is anywhere from 0 to a series of clauses that are unique to each individual ObjectType.

most common usage is table creation lets create one.

```sql
CREATE TABLE work_schedule
    (
        work_schedule_id NUMBER,
        start_date DATE,
        end_date DATE
    );
```

in creating tables with SQL, there are two things to understand clearly:-

1. Rules of Naming Database Objects
2. A list of available data types

### Naming a Table or Other Objects

These rules applies to all database objects including tables, views, indexes, also table constraints and columns

- length at least 1 character and not more than 30 Characters
- First Character must be a letter
- After the first letter, it may include letters, numbers, also `$`, `_` , `#`, No other special characters are allowed anywhere in the name
- Names are not case-sensitive.
- Names can not be reserved words

The following are reseved words

ACCESS, ADD, ALL, ALTER, AND, ANY, AS, ASC, AUDIT, BETWEEN, BY, CHAR, CHECK, CLUSTER, COLUMN, `COLUMN_VALUE`, COMMENT, COMPRESS,
CONNECT, CREATE, CURRENT, DATE, DECIMAL, DEFAULT, DELETE, DESC, DISTINCT,
DROP, ELSE, EXCLUSIVE, EXISTS, FILE, FLOAT, FOR, FROM, GRANT, FROUP, HAVING, IDENTIFIED, IMMEDIATE,
IN, INCREMENT, INDEX, INITIAL, INSERT, INTEGER, INTERSECT, INTO, IS, LEVEL, LIKE, LOCK, LONG,
MAXEXTENTS, MINUS, MLSLABLE, MODE, MODIFY, `NESTED_TABLE_ID`, NOAUDIT, NOCOMPRESS, NOT, NOWAIT,
NULL, NUMBER, OF, OFFLINE, ON, ONLINE, OPTION, OR, ORDER, PCTFREE, PRIOR, PUBLIC, RAW, RENAME, RESOURCE,
REVOKE, ROW, _ROWID_\*, ROWNUM, ROWS, SELECT, SESSION, SET, SHARE, SIZE, SMALLINT, START,
SUCCESSFUL, SYNONYM, SYSDATE, TABLE, THEN, TO, TRIGGER, UID, UNION, UNIQUE, UPDATE,
USER, VALIDATE, VALUES, VARCHAR, VARCHAR2, VIEW, WHENEVER, WHERE, WITH

These riles are absolute. Any violation, and you will receive an error codde

\* can't be used it its uppercase form
bolded - can be used as attribute names only

However the best practice is to avoid using them

### Quoted Names

It is not recommended but it is possible to create database objects that are quoted, Surrounded by Double quotes eg "Companies"

```sql
    CREATE TABLE "Companies" (company_id NUMBER);
    -- quoted names must be referenced with their quotes
    SELECT * FROM "Companies";
```

Quoted names may vary from quoted in several ways.

- They may begin with any character
- may include spaces
- They are case sensitive

```sql
    CREATE TABLE "Company Employees" (
        employee_id NUMBER,
        name VARCHAR2(35)
    );
    SELECT * FROM "Company Employees"; -- WILL WORK
    SELECT * FROM "COMPANY EMPLOYEES"; -- WILL NOT WORK
```

Quoted names may include reserved words. And to reiterate,
quoted names must always be referenced with their quotation marks.
Oracle advises against the use of quoted names identifiers

### Unique Names and Namespaces

`case` - what if you create an object with the same name as another in the database? will you be able to use it? what happens to the other object?

`simple answer` - depends on the namespaces for those objects

`NAMESPACES` - a logical boundary within the database, that encompasses a particular set of database objects.
There are several namespaces at work at any given time. Depending on the context you are working on.

Understanding namespaces help prevent duplication of names for any particular namespace

NOTE: for ojects in the same schema, namespaces are schema managed, for those non-sche,a objects, namespaces are global

NonSchema Namespaces:-

- Users, Roles
- Public Synonyms

Schema Namespaces

- `TABLES`, `VIEWS`, `SEQUENCES`, `PRIVATE SYNONYMS`, `USER-DEFINED TYPES`
- `INDEXES`
- `CONSTRAINTS`

The list above means objects in the same namespace will collide if given the same name in each given schema.

NOTE: Once you create a table and give it a constraint name for the primary key, it will create an index and name it as the name of the `constraint`, you can override this by assigning the constraint with a different using the INDEX clause of CREATE TABLE statement.

Tips When naming objects

- use descriptive names that can be pronounced
- If your tables include references to other tables make all column names all the same
- Name your tables in plural form since they are goint to hold records about many objects
- Consider using the prefix for every object thats associated with a particular application eg HR\_ for tables with the HR application
- Avoid using prefixes that Oracle Corp uses for its system-defined objects eg SYS\_, ALL\_, DBA\_, GV\$, NLS\_, ROLE\_, USER\_, V\$.

### Sytem Assigned Names

When you create an object and then assign constraints to it, without providing a name, Oracle will automatically create a name for a constraint for you.
It will be named as SYS_C followed by a number generated automatically by the system.

### SQL CREATE TABLE statement

There are a lot of constraints but the exam in this clause tests for:-

- How to create a table
- create columns and specify data types
- create constraints

```sql
    CREATE TABLE cruises (
        cruid_id NUMBER,
        cruise_type_id NUMBER,
        cruise_name VARCHAR2(20),
        captain_id NUMBER NOT NULL,
        start_date DATE,
        end_date DATE,
        status VARCHAR2(5) DEFAULT 'DOCK',
        CONSTRAINT cruise_pk PRIMARY KEY (cruid_id)
    );
```

`captain_id` is constrained to not be null, but the name has not been explicitly stated
, the name will be assigned from a system generated constraint.
The table above has 2 constraints, NOT NULL and PRIMARY KEY

## Review Table Structure

You can review the table structure with a `DESCRIBE` or `DESC` statement. It is not a ANSI statement, but SQL \*Plus statement

NOTE: SQL \*Plus statements do not require semicolon at the end

after the table is created. You can issue the

```sql
DESCRIBE cruises -- OR DESC cruises
```

this will return a 3 columns table with values

- NAME - stating the name of the column in the table
- NULL - stating whether the column can be filled with a null value
- TYPE - stating the data type of the column

## Data Types Available for Columns

A column data type describe what type of information is and is not accepted as input for the column.
Will determine how the values can be used and how they will behave when compare to other values in the database.

Most data types fall into the Numeric, Character or Dates

There are some otheer data types called Large objects which can not be included as Primary Keys, DISTINCT, GROUP BY, ORDER BY, or joins

1. `CHARACTER` DATA TYPE - are also known as TEXT or STRING data types, they include the following:-
   - `CHAR(n)` - Fixed length alphanumeric value, `n` is optional, default is 1, when created with n = 5, and only entered a single character, the retrieval will contain 4 blank spaces. maximum value for n is 2000.
   - `VARCHAR2(n)` - Variable length alphanumeric value, n is compulsory, maximum value for n is 4000, max length is actually 4000 bytes, not characters. To override this you can set parameter `MAX_STRING_SIZE` tO `EXTENDED` making the length to 32,767.
2. `NUMERIC` - Numeric data types include the following:-
   - `NUMBER(n,m)` - accepts numeric data, notnegative, 0, and positive, where n is precision(total number of digits in either sides of the decimal point), and m is scale ie numbers of digits on the right side of the decimal point. Both n and m are optional. default are n = 1 to 38, m can range from -84 to 127. if both are ommited they default to their maximum value, if m is ommited, default to 0. **when the number entered is more than what the maximum precision set can accept, it raises an error** eg defined NUMBER(3,2), entered 10.59, this will raise an error, but NUMBER(5,2) defined, entered 1059.34, will only store 1100.00
3. `DATE` DATA TYPE - sometimes referred to as DATETIMES, each date consist of a field and each field is a value for the date or time eg hours, minutes, seconds, month an so on. Constituent data types are:-
   - `DATE` accept date and time information - fields stored include YEAR, MONTH, DATE, HOUR, MINUTE and second. Date values may be stored as literals or using conversion functions. The default Oracle date format for a given calendar day is defined by parameter NLS_DATE_FORMAT. to see the value for the paramters use the command `SHOW PARAMETERS NLS_TERRITORY` or `SHOW PARAMETERS NLS_DATE_FORMAT`, or you can use the following command `SELECT SYS_CONTEXT('USERENV','NLS_DATE_FORMAT') FROM DUAL`, the format can be changed with `ALTER SESSION` OR `ALTER SYSTEM` commands, not in the exam. defaulf format is DD-MM-RR, where RR is century year, in ANSI - YYYY-MM-DD
   - `TIMESTAMP(n)` extension of date that adds fractional seconds precision. stores Year, Month, day, hour, minute, second, and fractional seconds. The value of n specifies the precision of fractional seconds.n ranges from 0 to 9, default is 6.
   - `TIMESTAMP(n) WIH TIME ZONE` a variation of `TIMESTAMP` that adds either time zone region naem or an offset for time zone. is used in tracking date information across different time zones and geographical areas.
   -
