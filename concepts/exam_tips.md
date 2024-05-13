# Sample Questions and Answers for OCA

1. `Describe the purpose of DDL` These are used for creating and manipulating data objects eg create, alter and delete tables and objects, add comments and associate them with database objects, issue privileges to users to perform tasks, initiate performance analysis using built-in tools
2. There is the oracle(q) operarator for allowing using ' inside quotation values
3. `CREATE TABLE table_name AS SELECT ...` can specify a default value for the columns specified
4. `REFERENCES PRIVILEGE`
5. `USING ... ON` can be used for tables with different column names but compatible data types
6. You can create an index inline as follows below

```sql
CREATE TABLE table_name(
    col1 dt1,
    col2 dt2,
    CONSTRAINT name_idx_for_col1 PRIMARY KEY (col1, col2)
        USING INDEX(CREATE INDEX idx_name_idx ON table_name (col1, col2))
);
```

the above statement works successfully based on the fact that the primary key will be based on the index created and named above
and only the named index will be created rather than another index on another object

also, you can update data in rows

```sql
UPDATE table_name SET
    (column_1, column_2) = (select value1, value2 from source_table)
    WHERE condition;
```

You can't delete from more than one table
