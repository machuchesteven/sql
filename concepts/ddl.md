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
   - `TIMESTAMP(n) WIH LOCAL TIME ZONE` here the offset is not stored but the system calculates the offset automatically with the user's time zone of the session. End user see the time in their local time zone.
   - `INTERVAL YEAR(n) TO MONTH` holds the span of time in only year and month values
   - `INTERVAL DAY(n1) TO SECOND(n2)` holds the span in days to second, n1 precision for days and n2 precision for seconds. n1 ranges from 0 - 9, defaults to 2, n2 defaults to 6
4. `LARGE OBJECTS` - the exam will test the knowledge to work with LARGE OBJECTS data types, or LOB in SQL syntax. **Tables can gave multiple columns with LOB but they cannot be Primary Key, and can't ne used with DISTINCT, GROUP BY, ORDER BY or JOINS**. LOBs include the following
   - `BLOB - BINARY LARGE OBJECT` - they acccept large binary objects, eg images and video files. Declaration is made without precision or scale. The max size is calculated by a formula not in exam with a starting size of 4GB, and CHUNK parameter, and setting of DB block size, affecting all storage in the database.
   - `CLOB - CHARACTER LARGE OBJECT` accepts large text data elements. Declared without precision or scale, same manner of max size calculations as BLOB.
   - `NCLOB` accepts CLOB data in Unicode, Mazimum size calculated in the same manner as in BLOB data type.

All the data types seen are Build in data types, but a user can create own data types using the `CREATE TYPE` command built in in sql.

## Creation of Constraints at The Time of Table Creation

You can create constraints to support other objects but there is no create constraint statement, but they are created as part of other statements as `CREATE TABLE` OR `ALTER TABLE` statements.
You can name the constraints yourself or leave it for the system to name it for you.
Some constraints like primary keys and foreign key once created, the database triggers the creation of corresponding index object of the same name.

Here is a create statement that triggers the syntax to create a constraint

```sql
CREATE TABLE positions(
    position_id NUMBER,
    position VARCHAR2(20),
    exempt CHAR(1),
    CONSTRAINT positions_pk PRIMARY KEY (position_id)
);
```

here defined above, the line `CONSTRAINT positions_pk PRIMARY KEY (position_id)` we create a constraint and named it [something we don't neccessarily have to do], we have the following in our constraint:-

- Object type - `CONSTRAINT`
- constraint name - `positions_pk`
- constraint type - `PRIMARY KEY` CONSTRAINT
- column line applied - `POSITION_ID`

### Ways of Creating Constraints in Create Table Statements

There are two ways

- Inline constraint creation - during table creation
- Out of line, after columns definition

### Create inline constraint creation

Consider the example below

```sql
    CREATE TABLE ports(
        port_id NUMBER PRIMARY KEY,
        port_name VARCHAR2(20)
    );
```

in the above example, the `PRIMARY KEY` constraint will be created but without a name on the column port_id and oracle will give it an auto name.

The below example created the same constraint but provides a name for it

```sql
    CREATE TABLE ports(
        port_id NUMBER CONSTRAINT port_id_pk PRIMARY KEY,
        port_name VARCHAR2(20)
    );
```

All the above are called inline statements since the constraints are included in the same line as the one we are defining our columns

Consider another example for creating a not null constraint

```sql
    CREATE TABLE customers(
        customer_id NUMBER,
        customer_name VARCHAR2(20) NOT NULL
    );
```

Here the customers table will be created with enforcement restricting null values of the customer name, it is also no named. Lets name it

```sql
    CREATE TABLE customers(
        customer_id NUMBER,
        customer_name VARCHAR2(20) CONSTRAINT customer_name_nn NOT NULL
    );
```

Also we can include multiple constraints in a single table

```sql
    CREATE TABLE customers(
        customer_id NUMBER PRIMARY KEY,
        customer_name VARCHAR2(20) CONSTRAINT customer_name_nn NOT NULL
    );
```

### Creating Out of Line Constraints

Here we define the constraints after columns definition. Here, is an example of consraints defined with the out-of-line syntax

```sql
    CREATE TABLE ports(
        port_id NUMBER,
        port_name VARCHAR2(20),
        PRIMARY KEY (port_id)
    );
```

Also you can as well name columns in out-of-line constraints

```sql
    CREATE TABLE ports(
        port_id NUMBER,
        port_name VARCHAR2(20),
        CONSTRAINT PORT_ID_PK PRIMARY KEY (port_id)
    );
```

### Additional Ways To Create Constraints `ALTER TABLE`

You can alter a table to add constraints, or remove them without a need to enforce the constraints creation at the time of table creation.

example you can create a Posts table and later add a constraint to it

```sql
    CREATE TABLE ports(
        port_id NUMBER,
        port_name VARCHAR2(20)
    );
    -- THEN add constraint for the primary key
    ALTER TABLE ports MODIFY port_id PRIMARY KEY;
    -- You can use the data-dictionary to determine system generated name for the constraint
    SELECT CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'PORTS';
    -- once you capture the name, you can rename it as below
    ALTER TABLE ports RENAME CONSTRAINT SYS_CXXX TO PORT_ID_PK;
```

The used above is the inline equivalent of adding constraints

The out of line equivalent is as follows:-

```sql
    CREATE TABLE ports(
        port_id NUMBER,
        port_name VARCHAR2(20)
    );
    -- explicitly without naming the constraint
    ALTER TABLE ports ADD PRIMARY KEY (port_id);
    -- also you can name the constraint
    ALTER TABLE ports ADD CONSTRAINT PORT_ID_PK PRIMARY KEY (port_id);
```

## Working with NOT NULL constraints

The not null constraint is a bit different when it comes to syntax, it can not be created out of line meaning the **FOLLOWING ASSIGNMENTS ARE INVALID**

```SQL
    CREATE TABLE ports(
        port_id NUMBER,
        port_name VARCHAR2(20),
        NOT NULL(port_name)
    );
    CREATE TABLE ports(
        port_id NUMBER,
        port_name VARCHAR2(20),
        CONSTRAINT port_name_nn NOT NULL (port_name)
    );
    -- ALSO THIS WON'T WORK
    ALTER TABLE ports
        ADD NOT NULL (port_name);
    ALTER TABLE ports
        ADD CONSTRAINT port_name_nn NOT NULL (port_name);
    -- these two above wont work cause they are alter table out of line equivalent,
    -- but alter table in-line equivalent will worl

    -- Consider these valid ones
    ALTER TABLE ports
        MODIFY port_name NOT NULL;
    -- this one will work also

    ALTER TABLE ports
        MODIFY PORT_NAME CONSTRAINT port_name_nn NOT NULL;

```

## Types of Constraints

There are several types of constraints including:-

- PRIMARY KEY constraint
- FOREIGN KEY constraint
- NOT NULL constraint
- CHECK constraint
- UNIQUE constraint

Exploring one by one at a time

### 1. `NOT NULL` constraint

This makes sure, any row applied to be added to a table, the specified column will always be supplied with values.

We supply NOT NULL constraint to comstantly require data for a particular column.
The following example fails, since there are already null values

```sql
    CREATE TABLE ports(
        id number,
        name varchar2(30)
    );
    insert into ports(id) values (1);
    alter table ports modify name constraint port_name_nn not null;
```

If you apply a primary key constraint, you do not need to apply NOT NULL explicitly. The primary key contain the rules for the NOT NULL constraint

### 2. `UNIQUE` constraint

Enforces that any data added to the database will be unique from data already existing in the database,
The following are few tips on unique constraint:-

- Single UNIQUE constraint can be applied to a column or multiple columns
- by itself, it allows null values to be added to the column, it only restrict data added to be one of a kind

Primary key is a combination of NOT NULL and UNIQUE constraints

`composite UNIQUE constraint` you may create a unique constraint that applies to multiple columns simultaneously, this will enforce the combination of those columns to be unique, data can repeat for individual columns, but may not repeat for all columns under the constraint. For example:-

```sql
CREATE TABLE students (
    first_name VARCHAR2(30),
    last_name VARCHAR2(30),
    parent_id INTEGER,
    CONSTRAINT students_un UNIQUE(first_name, last_name, parent_id)
);
```

Mutliple columns clases must be assigned out of line

### 3. `PRIMARY KEY` constraint

Defines one or more coluns that will form a unique identifier for each row of data added to the table. `NOT NULL + UNIQUE = PRIMARY KEY`

- A table may have only one primary key
- A single column primary key is the most common form
- It enforces the data will always be unique

we have created multiple tables above with this clause

`COMPOSITE PRIMARY KEY` -> This is when more than one column is assigned as the primary key. The combination of these columns will have to be unique collectively and all columns will have to contain the values. They are asigned using the following syntax:-

```sql
CREATE TABLE helpdesk(
    hd_category VARCHAR2(20),
    hd_Year NUMBER,
    hd_ticket_no NUMBER,
    hd_title VARCHAR2(30),
    CONSTRAINT HelpDesk_PK PRIMARY KEY (hd_category, hd_year, hd_ticket_no)
)
```

This can only be assigned out of line

### 4. `FOREIGN KEY` constraint

aplies to one or more columns in a particular table and works in conjunction with referred table. **Is a feature that helps to make sure that two tables can related to each other**. The `FOREIGN KEY` constraint does the following:-

- identifies one or more columns in the current table, lets call it `child` table
- For each of those columns, it also identifies one or more columns in the correponding table, lets call it `parent` table
- It ensures the parent table already has either the primary key or a unique constraint on those correponding columns.
- It then ensure that any future values added to the foreign key constrained columns of the child table are already stored in the corresponding columns of parent

In simple words, the `FOREIGN KEY` constraint enforces `REFERENCIAL INTEGRITY` between two tables. The referenced table isn't forced to have primary key referenced, but just any column with a `UNIQUE` constraint. Since the primary key is a superset of the `UNIQUE` constraint, it satisfies the requirement.

Syntax and examples, Lets say you have two tables ports and Ships, but you want to assign a home port to each ship, then

```sql
CREATE TABLE PORTS(
    port_id NUMBER,
    port_name VARCHAR2(20),
    country VARCHAR2(40),
    capacity NUMBER,
    CONSTRAINT port_pk PRIMARY KEY (port_id)
);

CREATE TABLE ships(
    ship_id NUMBER,
    ship_name VARCHAR2(20),
    home_port_id NUMBER,
    CONSTRAINT ships_ports_fk FOREIGN KEY (home_port_id) REFERENCES PORTS (port_id)
);
-- INLINE FOREIGN KEY ASSIGNMENT - unnamed foreign key
CREATE TABLE ships(
    port_id NUMBER REFERENCES ports (port_id);
)
-- INLINE FOREIGN KEY ASSIGNMENT - NAMED foreign key
CREATE TABLE ships(
    port_id NUMBER CONSTRAINT ships_ports_fk REFERENCES ports (port_id);
)
-- OR, YOU CAN JUST USE THE ALTER TABLE TO ADD FOREIGN KEY TO THE TABLES YOU CREATE
ALTER TABLE ships
    ADD CONSTRAINT ships_ports_fk FOREIGN KEY (home_port_id) REFERENCES PORTS (port_id);
```

The most important line is `REFERENCES` since the line `FOREIGN KEY` only appears in Out of line assignments

### 5. `ON DELETE` constraint

This controls the behavior in foreign key constraints when parent rows are removed from the parent table. They define how columns should behave when those references rows are removed.
Here comes the `ON DELETE` clause when creating a foreign key constraint. Consider the syntax below and later the options:-

```sql
CREATE TABLE ships
(
    ship_id NUMBER,
    ship_name VARCHAR2(20),
    home_port_id NUMBER,
    CONSTRAINT ships_ports_fk FOREIGN KEY (home_port_id)
        REFERENCES PORTS (port_id) ON DELETE SET NULL
);
```

`ON DELETE` options:-

- `ON DELETE SET NULL` - All child rows referencing the deleted row will be set to NULL
- `ON DELETE CASCADE` - All child rows referencing the deleted row will be deleted too
- `ON DELETE NO ACTION` - leaves everything unchanged

### 6. `CHECK` constraint

Attaches an expression to be checked once a new row is inserted into the database. The following are limitations of the CHECK constraint, It can not include refs to the following:-

- Column in other tables
- Presudocolumns eg CURRVAL, NEXTVAL, LEVEL, ROWNUM
- Subqueries and Scalar Subqueries
- User-defined functions
- Certain functions whose values can not be known at time of the call eg SYSDATE, SYSTEMTIMESTAMP, DBTIMEZONE, LOCALTIMESTAMP, SESSIONTIMEZONE, USER, USERENV

for a row of data to be accepted as input to the given table, any CHECK constraint present must evaluate to either TRUE or unknown due to a NULL.

### Multiple Constraints

can declare table with multiple constraints
eg

```sqL
CREATE TABLE VENDORS(
    vendor_id NUMBER CONSTRAINT VENDOR_ID_PK PRIMARY KEY,
    VENDOR_NAME VARCHAR2(50) NOT NULL,
    STATUS NUMBER(1) CONSTRAINT STATUS_NN NOT NULL,
    CATEGORY VARCHAR2(20),
    CONSTRAINT STATUS_CK CHECK (STATUS IN (4,5)),
    CONSTRAINT CATEGORY_CK CHECK (CATEGORY IN ('ACTIVE', 'SUSPENDED', 'INACTIVE'))
);
```

### DATA TYPES Restrictions on Constraints

| Data Types               | NOT NULL | UNIQUE | PRIMARY KEY | FOREIGN KEY | CHECK |
| :----------------------- | :------- | :----- | :---------- | :---------- | :---- |
| TIMESTAMP WITH TIME ZONE | -        | NO     | NO          | NO          | -     |
| BLOB                     | -        | NO     | NO          | NO          | -     |
| CLOB                     | -        | NO     | NO          | NO          | -     |

## DROP COLUMNS AND SET COLUMNS UNUSED

### Dropping columns in Oracle

lets refer to our `PORTS` TABLE with port_id, port_name, country and capacity. Lets say we don't need the country column anymore.

There are two syntaxes for dropping columns in Oracle

```sql
ALTER TABLE PORTS DROP COLUMN CAPACITY; -- THE KEYWORD `COLUMN` IS REQUIRED HERE
-- OR
ALTER TABLE PORTS DROP (CAPACITY); -- THIS CAN WORK FOR MULTIPLE COLUMNS TOO
```

Restrictions when dropping columns:-

- A table must have at least one column, **you can't drop all columns**
- You can not drop a column referenced by a `FOREIGN KEY` constraint in another table

in order to delete the parent key column, we must address the constraint

```sql
ALTER TABLE TABLE_NAME DROP COLUMN COLUMN_NAME CASCADE CONSTRAINTS;
-- -CONSTRAINT OR CONSTRAINTS - BOTH WILL WORK
```

once you cascade or drop constraints in a parent column, child columns constraints will be dropped too.

### Dropping COMPOSITE FOREIGN KEY constraints

```SQL
CREATE TABLE CRUISE_ORDERS(
    CRUISE_ORDER_ID NUMBER,
    ORDER_DATE DATE,
    CONSTRAINT PK_CO PRIMARY KEY (CRUISE_ORDER_ID, ORDER_DATE)
);

CREATE TABE ORDER_RETURNS(
    ORDER_RETURN_ID NUMBER,
    CRUISE_ORDER_ID NUMBER,
    CRUISE_ORDER_DATE DATE,
    CONSTRAINT PK_CR PRIMARY KEY (ORDER_RETURN_ID),
    CONSTRAINT FK_CO_CR PRIMARY KEY (CRUISE_ORDER
    )
)
```
