# Create and Mantain INDEXES

INDEX is a database objects that optimize data access by helping the database execute queries faster. and index os am object of its own and is stored independent of the table and constantly mantained with every INSERT, UPDATE and DELETE performed on the table.
Index values are presorted, and index can be created for only one table, and can be created on one or more of that tables columns. The index also stores the address of that data from the source table
SQL can then use the index object to speed up querying of `WHERE` and `ORDER BY` clauses
For example, when a where statement reference any indexed column, the database (optimizer) will consider the index as it determines the optimal query stretagy for the statement. In result, queries may be significantly faster depending on the amount of data involved and depending to a number of indexes that may be applied to a table
May means query statement processing is performed by Oracle Database Optimizer, the optimizer determines how best to process any given query according to the combination of factors, in the end, there are two things

- As SQL developers, we have to help instruct the optimizer on working on things
- The more indexes we add, we will reach a point of diminishing returns, and each index added to a table can potentially increase workload on future INSERT, UPDATES and DELETES

Remember, the `WHERE` clause can appear in a SELECT, UPDATE or DELETE statement, Also a select statement can appear in a form of a subquery of statement that create objects such as TABLE or VIEW, an index object can benefit any of those situations

## ORACLE DATABASE OPTIMIZER

the reason for creating an index on a particular table is to ensure, Oracle DB optimizer can process SQL statements on that table faster

The Optimizer is a built-in feature in Oracle DB that is crucial to the processing of every SQL statement issued against the DB.
SQL statement gave the potential for great complexity, with instructions to join, filter and transform data in variety of ways, the amout of data to be processed ca vary dramatically, these complexity introduces a host of challenges that the optimizer is designed to handle, and it perfoms incredibly well

Forexample, consider you want to execute some scalar functions and a where clause, it would be ideal if the WHERE executes first, and then the scalar function, since the where clause will reduce the number of rows to work with

execution plans like the one above are available using the `EXPLAIN PLAN` statement, that is not in the exam but worthy understanding
For our current purpose it is important to understand that the optimizer is the built in function that processes sql statement, and that as part of the processing, is the decision point of whether and how to incporate an index in the execution of any given sql statement.

Our goal as developers, is to create a set of useful objects to be leveraged by the optimizer in its construction of the optimal execution plan for processing future SQL statements.
Our job us to anticipate typical usage of table and then create indexes that the optimizer will be able to use to best execute those SQL statements,- it is more than important for us to understand how indexes work

## IMPLICIT INDEX CREATION

If you create a constraint on a table, of type PRIMARY KEY or UNIQUE, automatically the table creates an index on that column to support that constraint.

consider the following sql block that explains two indexes created for primary key and unique constraint on a table implicitly, and they will have system assigned names as `SYS_CXXX` where X are integers

```sql
CREATE TABLE SEMINARS(
    SEMINAR_ID NUMBER(11) PRIMARY KEY,
    SEMINAR_NAME VARCHAR(30) UNIQUE
);

SELECT TABLE_NAME, INDEX_NAME FROM USER_INDEXES WHERE TABLE_NAME = 'SEMINARS';
-- you can also see COLUMN_NAME from the table USER_IND_COLUMNS

SELECT TABLE_NAME, INDEX_NAME, COLUMN_NAME FROM USER_IND_COLUMNS WHERE TABLE_NAME = 'SEMINARS';
```

## SINGLE COLUMN CREATION

syntax:
`CREATE INDEX index_name ON table_name ON (column_name);`
in the syntax that will create an index with a specified name on the specified table, and as a result, queries referencing the column specified by the index, may return results significantly faster
May refers to our previous discussion, the existence of an index does not guarantee its use, the Optimizer determines whether or not the index will be helpful

```sql
CREATE INDEX IDX_INVOICE_DATE ON INVOICES(INV_DATE);
SELECT * FROM INVOICES WHERE INV_DATE = '24-mar-12';
```

for example, when the invoice date above will have more unique values, then the index most likely will be used
If a column tend to include data that is less repetitive and more unique, then it is said to have higher degree of selectivity, and an index on such column would attract the optimizer

## USAGE

Oracle DB optmizer will consider the use of an index in any query that specifies an indexed column in the WHERE clause or ORDER BY clause, depending on how the indexed column is specified

The following are guidelines to make sure the optimizer will more likely apply the index

- For best results, indexed columns should be specified in a comparison of equality
- Greater than or some other comparison may work
- a `NOT EQUALS` will not invoke an index
- LIKE comparison may invoke an index as long as the wildcard character is not in the leading position
- a function on a column will prevent the use of an index - unless the index is a function based index(not in the exam)
- Also, certain types of data type conversion will eliminate the use of an index

Design of an indexing scheme falls into `performance tuning` category.
There is no single comprehensive approach to index design for a given database application

for example tips

- a system that will not be queried much, but will be populated with INSERTS would not benefit much from indexes, since all inserts will be slower as it update the table and all its INDEX objects
- On such tables, infrequent queries may not justify the creation of an index object and their associated performance tradeoff
- On the other hand, a system with more UPDATE statements will benefit from thoughfully designed indexes

`NOTE`: The optimizer will do everything it can to use an index for a given query where the index is beneficial,it avoids an index only if its use would be detrimental, eg a table with a large number of rows with an indexed column that has low selectivity

Old rule suggests no more than 5 indexes on the average table in a transaction-based application, and that still depends on the intended use

## INDEX MAINTENANCE

Indexes are automatically mantained on the background by SQL and require no effort on ur part to keep their lookup data consistent with the table, ie each future DML will have to work harder, each DML that modifies indexed data, will aslso perfom index maintenance,
This in turn puts more workload on all DML that affects indexed data

Build indexes that contribute to the application's overall performanc, and dont build indexes unless they are necessary.
Review indexes structure to know which indexes may no longer be needed, an existing application burdened by indexes, may benefit from removing indexes

## COMPOSITE INDEXES

is an index that is built on two or more columns of a table
syntax is

```SQL
CREATE INDEX IX_INV_INVOICE_VENDOR_ID ON INVOICES(INVOICE_ID, INV_DATE);
SELECT TABLE_NAME, INDEX_NAME, COLUMN_NAME FROM USER_IND_COLUMNS WHERE TABLE_NAME = 'INVOICES';
```

A composite index copies and sorts data from both columns into the composite index object, its data are sorted first by the first position column, then by the next position column

A sql statement where clause that references all columns in the composite index will cause the SQL optimizer to consider using the composite index for processing the query.
eg based on the index above, the query below will encourage the optimizer to use the query to maximum advantage

```sql
SELECT * FROM INVOICES WHERE invoice_id = 1 AND inv_date = '22-MAR-12';
```

the query that references the first column in the composite index also references the index, this is because the composite index sorts data by the first column first and the next column later.

The query that references the second column also may still consider using the index for that column beacuse of a feature known as `SKIP SCANNING`

## SKIP SCANNING

is an execution plan that allows Oracle to bypass leading-edge of a concatenated index and access the inside keys of a multi-value index.
Rather than restricting the search path using a predicate from the statement, skip scans are initiated by brobing the index for distinct values of the prefix column, each of these distinct values is the used as a sorting point for a regular index search.
How many indexes can be skipped? that depends on the level of selectivity that the results in the indexing of the first (or leading) column of the first object, if the first column contains only a few unique values within large number of rows, the index if used may be applied a relatively few number of times

The point is, a WHERE clause that references some, but not all of the columns in a composite index may invoke the index, even if the leading column is not referenced in the WHERE clause, HOWEVER, including the leading column may result in a more efficient application of the composite index and therefore, a faster query result

## UNIQUE INDEX

is the one that ensures a column in a table will always contain unique values. The syntax is as follows:-

```sql
CREATE UNIQUE INDEX index_name ON table_name(table_column);
```

Once you create a unique index on a column, it enforces a unique constraint on it even if you don't create the constraint on the table column itself. The unique constraint also once created uses the unique index, but you can have a unique index without a unique constraint, since these are two different entities.

Oralce suggests creating unique indexes in creating indexes to enforce uniqueness in a column for better results in query performance

`WARNING`: for auto generated values like SSN, it is better to avoid using them since they come with a cost, and for places like in controll number system where enforcing uniqueness can be difficult since the same values can be applied as a primary key on other tables, that you dn't have control over

## DROPPING INDEXES

You can drop an index using the DROP INDEX statement

```sql
DROP INDEX index_name;
```

When you drop a table, it automatically drops the indexes too, if you recreate the table, you should recreate the index

## VISIBLE AND INVISIBLE INDEXES

an index can be made visible or invisible to the optimizer, only a visible index is visible and usable to the optimizer.
Once an index is made invisible, the optimizer will omit the index from consideration when creating the execution plan for the SQL statement
an index is visible by default, you must explicitly set it INVISIBLE

there is an initialization parameter (OPTIMIZER_USER_INVISIBLE_INDEXES) that can be set to true at the system or Session level, if set to true, the optimizer will consider all indexes regardless of visibility

Initialization parameters are not the subject of the exam

### WHY RENDER AN INDEX INVISIBLE

QUESTION: indexes are made to speed up queries performance,
why then create an index and render it invisible, so that it can't be used to speed up processing

`INDEX TESTING ON A TABLE` -> mature applications may have a number of indexes applied on a table, all these requires maintenance, that means every time an INSERT, UPDATE or DELETE is issued, all of the table indexes have to be updated also, with the same data for consistency, with the same data for consistency. Rendering an overhead in performance and storage.
To find out if these indexes are useful, one way is to render temprarily indexes visible and invisible to see their effect on query optimization

- if an index is invisible and performance is not degraded, then it is not improving performance
- If the performance cost when rendered invisible is seen, then the index helps in performance optimization

Depnding on the results, you may chose to drop the index altogether and reduce DML maintenance cost associated with the index

## VISIBLE AND INVISIBLE

these keywords does specify the visibility of an index in the create index , or alter INDEX statement

```sql
CREATE {UNIQUE} INDEX index_name ON table_name(column_name) {INVISIBLE or VISIBLE (default VISIBLE)};
ALTER INDEX index_name (VISIBLE | IINVISIBLE);
```

if the index is already visible and and you alter it to a state it is, the query will execute without complaint or indication that the ALTER INDEX was unnecessary
The data dictionary view USER_INDEXES includes a column called VISIBILITY that reports whether the index is currently visible or invisible

`NOTE`: data dictionary uses uppercase names for object unless the object name is enclode in Double Quotes when you created it

## INDEX ALTERNATIVES ON THE SAME COLUMN SET

we can create a number of indexes on a given table, but we are only limited when creating indexes on a particular COLUMN SET.
SET means one or more columns of a table.
but to create multiple indexes on a given column set, these indexes must differ with regard to one of a set of characteristrics. However, even if you create them, only on of those indexes may be visible at any given time

The following are varying characteristrics for these indexes:-

- DIFFERENT UNIQUENESS - you can create a unique index on a column set and a non-unique index on the same column set
- DIFFERENT TYPES - we looked at B-TREE indexes by default, you may also create a `BITMAP index` and other types of indexes as like BITMAP, and other as below
  - `BITMAP INDEX` - `CREATE BITMAP INDEX`- BITMAP index is often used in applications where heavier use of SELECT is anticipated
- DIFFERENT PARTITIONING - multiple indexes may exist on the same column set that provided that certain partitioning characteristics are different
  - PARTITIONING TYPE (hash or range)
  - LOCAL vs GLOBAL PARTITIONING
  - PARTITIONING vs NON-PARTITIONING

For the purpose of the exam, we just know that while multiple indexes may exist, only one should be visible at any given point, or else the ability to create a new visible index on the same column SET will fail

NOTES

- Creating an index on a column doesn't guarantee that it will be used
- Making it invisible guarantees that it won't be used
- Rendering indexes visible and invisible are beneficial for the perfomance-based applications performance tuning
- Application tuning is a useful reason to employ invisible indexes

Even if the index is invisible, it is still mantained
