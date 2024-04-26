# External Tables in Advance

External tables, stores the table structure in the database, but the schema outside the database, within a directory object.

## Using SQL Loader

This is a data import utility within Oracle.

TDAL for creating external tables

- TYPE data_loader_type
- DEFAULT DIRECTORY directory_name
- ACCESS PARAMETERS (Records delited by delimiter, skip \_skip_value, fields table_fields in bracket)
- LOCATION file_source_location

the syntax for creating external tables:-

```sql
    CREATE TABLE table_name (
        fields
    )
    ORGANIZATION EXTERNAL(
        TYPE _loader_type -- ORACLE_LOADER
        DEFAULT DIRECTORY directory_name -- must be created and the user should be granted the read access
        ACCESS PARAMETERS(
            RECORDS DELIMITED BY NEWLINE -- sometimes ','
            SKIP 2 -- SPECIFIES THE COLUMNS TO SKIP
            FIELDS( -- /fields terminated by ","/
                fields as above and their data types
            )
        )
        LOCATION file_source_location
    );
```

This is the actual example

```SQL

create or replace directory book_files AS 'C:\app\softnet\product\21c\invoices';

CREATE TABLE external_invoices(
    id number primary key,
    payment_ref varchar2(30),
    paid_date varchar2(12)
)
ORGANIZATION EXTERNAL(
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY invoices_directory
    ACCESS PARAMETERS(
        RECORDS DELIMITED BY NEWLINE
        SKIP 2
        FIELDS(
            id number primary key,
            payment_ref varchar2(30),
            paid_date varchar2(12)
        )
    )
    LOCATION 'my_invoices.txt'
)
-- optional `REJECT LIMIT UNLIMITED`;
```

other parameters after LOCATION includes,

- `REJECT LIMIT _LIMITVALUE -- UNLIMITED/NUMBER`
-

In external tables, nothing is separated with a Comma in statements.

## INLINE EXTERNAL TABLES

This helps you query data from an external table wihout creating it before, meaning querying data froma file into a table like structure without specifying the table before or without stroring it

example :-

```sql
SELECT col_name, col_name2
    FROM EXTERNAL (
        (Cols definition)
        TYPE ORACLE_LOADER
        DEFAULT DIRECTORY dir_name
        ACCESS PATAMETERS (
            RECORDS DELIMITED BY NEWLINE
            SKIP 1
            FIELDS (
                cols definition
            )
        )
        LOCATION location_file
    )
    REJECT LIMIT 100; -- Just example
```

## UNLOADING/LOADING data using Oracle External Tables

This is the support provided by the data dump technology using Oracle
eg

```sql
CREATE TABLE countries_xt
ORGANIZATION EXTERNAL(
    TYPE ORACLE_DATAPUMP
    DEFAULT DIRECTORY dir_name
    LOCATION ('location.dmp')
)
AS SELECT FROM table_name;
```

This will create a location.dmp file, this will be used to watch the data even after the table is dropped.
The `.DMP` file will have those table loaded into it.

We can even take the given dump file to another database and crete the table using it. And watch the data, consider

```sql
CREATE TABLE table_name_in_another_db(
    columns definition
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_DATAPUMP
    DEFAULT DIRECTORY dir_name
    LOCATION ('location.dmp')
);
```

### Enhancements in External Tables with Oracle

- The `FIELDS CSV` clause have been introduced
- You can provide a list of files in the location object, but they should be in the same directory
- You can Partition using a specified column

Partiotioning example

```sql
CREATE TABLE table_name_in_partitioned(
    col_1 dt1,
    col_2 dt2,
    col_3 dt3
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY dir_name
)
PARTITION BY col_x(
    PARTITION p1 VALUES LESS THAN (VAL) LOCATION ('file1.dat'),
    PARTITION p2 VALUES LESS THAN (VAL) LOCATION ('file2.dat'),
    PARTITION p3 VALUES LESS THAN (VAL) LOCATION ('file3.dat')
);
```

`NOTE:PARTITION` - this extend Oracle Partition features to allow partitions to reside in both Oracle Database Segments and in External Files and Sources. Helps for `Big Data SQL` where large portions can reside in external portions

with ORACLE_DATAPUMP even the structure of the table is stored outside the table
