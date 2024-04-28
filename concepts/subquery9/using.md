# Using Subqueries

Using subqueries to solve SQL problems

Subquery - a select statement that exists within another sql statement, (sub-SQL)

SELECT, INSERT, UPDATE, DELETE and MERGE all accepts subqueries. But also SUBQUERIES can also be used with Create table and Create View statements

Most subqueries are syntactically autonomous, ie it can be executed on its own as a query.
Some are correlated subqueries meaning you can not execute it on its own, but u can execute it as part of a big query binded to it
A subquery can return one or more columns and one or more rows. Most common use is to return data that is useful for main query.
A statement that includes a subquery as part of its code, is considered a parent query to that subquery.
a parent query may include one or more subqueries, and which in turn may have other subqueries within themselves, a parent query may also be refered to as an outer query.

any valid select statement can qualify as a subquery to another statement. a select statement can use tables views and other objects to be used as a subquery. also aggregate functions can be used too.
A subquery is not restricted to data within the main query tables, there may be relationships between subquery tables and parent query tables but is not a must to be there.

## Problems A subquery can Solve

- Creating Complex mutlistage queries - find answers to questions, use those answers to ask new questions
- Creating populated tables - can be incorporated into a create table to quickly create and populate a table with data
- Manipulating Large Data sets - can be used with INSERT and UPDATE statements to move large amounts of data or update many rows
- Creating Named Views - Is used to create view objects at a time of creation
- Defining dynamic views - Can be used to replace a table refence in the FROM clause, (known as INLINE VIEWS)
- Defining Dynamic Expressions with Scalar Subqueries - those returning only one row and one column, the value can be used as an expression

## Describe Types of Problems Subqueries Can Solve

eg you have a sales table for different years, 2016-2018, you want to know the sales_reps who suparsed average sales amount for the year, you have to first get the average and then get the names, a subquery groups these two steps int a single query

```sql
SELECT ROUND(AVG(SQR_FT), 1) FROM SHIP_CABINS;
SELECT * FROM SHIP_CABINS WHERE SQR_FT >= (
    SELECT ROUND(AVG(SQR_FT), 1) FROM SHIP_CABINS -- the subquery
    );
```

### You can use a subquery for many purpose

Including the following:-

- Populate a table with data
- Create a view
- Specify values assigned to an update statement
- Perfom comparison against aggregate results
- Create Inline Views- No limit of how deep you can go here
- As an alternative to expressions
- To nest other queries - passed in the where clause, and you can nest up to 255 subqueries
- To have correlated subqueries with SELECT, UPDATE and DELETE

## TYPES OF SUBQUERIES

The following are the major types of subqueries

- `Single-row subquery` -
- `Mutliple-row subquery` -
- `Multiple-column subqueries` -
- `Correlated subqueries`-
- `Scalar subqueries` -

NOTE: different types of subqueries are not mutually exclusive, one subquery can fall into multiple categories of subqueries

## Using CORRELATED SUBQUERIES

Correlated subquery - a query that is integrated with a parent query. Includes references to elements of the parent query, and do not exists as standalone queries.

one of the main use of subquery is to reduce hardcoding data

consider the following example, in ship_cabins, we have different windows, and for all rows, we need the result or a row that have a sqr_ft value greater than the average value for its window
there are several approaches

- Select the averages first
- Use the averages to compare

or the other is use a subquery but correlate the row with its window using the subquery

consider

```sql
SELECT A.ID, A.WINDOW, A.SQR_FT
FROM SHIP_CABINS A
WHERE A.SQR_FT < (SELECT AVG(SQR_FT) FROM SHIP_CABINS WHERE WINDOW = A.WINDOW)
```

in the above example there is a name conflict between two tables thats why we needed an alias for one specific table, if no column name conflict, then we could not have used the alias

NOTE: correlated subqueries may introduce perfomance degradation,and may consume resources, however they can perfom tasks not other form of query may accomplish.

## UPDATE and DELETE rows using CORRELATED SUBQUERIES

You could perform both update and delete using correlated subqueries, here is how

### UPDATE with a Correlated Subquery

an update statement can have a correlated subquery in these places

- in the SET clause
- in the WHERE clause

the best way is to assign a table alias, and use that alias in the subquery

CASE: we need to give a 10% discount to the invoices table for those who had the biggest purchase of each quarter for each year

- get the max price for each quarter
- Update wherever the price is that price for each quarter
- combine the two eqn

```sql
SELECT MAX(inv.price), TO_CHAR(INV.PURCHASE_DATE, 'RRRR Q') FROM INVOIVES INV GROUP BY TO_CHAR(INV.PURCHASE_DATE, 'RRRR Q');

UPDATE INVOICES INV SET DISCOUNT = '10 PCT' WHERE
INV.PRICE = (SELECT MAX(PRICE) FROM INVOICES WHERE TO_CHAR(INV.PURCHASE_DATE, 'RRRR Q') = TO_CHAR(PURCHASE_DATE, 'RRRR Q'));
```

Dont use group by in terms like this, since you can get the data as a scalar value, and it is what we need

also, in the where clause, you can use a subquery like this:-

to update ports capacity based on number of ships that regard it as a home port

```sql
UPDATE PORTS
SET capacity = (SELECT COUNT(*) FROM SHIPS WHERE HOME_PORT =  PORTS.ID)
WHERE EXISTS (SELECT * FROM SHIPS WHERE HOME_PORT = PORTS.ID);
```

correlated means they depend on the main query table

### Using with a DELETE statement

Delete can use subquery to determine which rows to delete from the database,the syntax is similar with the one in the SELECT and UPDATE

```sql
delete ship_cabins s1 where sqr_ft = (select min(sqr_ft) from ship_cabins s2 where s1.window = s2.window);
```

## using EXISTS and NOT EXISTS operators

tests for existence of rows in a subquery, if no rows are found, the answer is false, `NOT EXISTS` reverse the result

its syntax is simple `WHERE EXISTS subquery`
sometimes the select with exists is called a _semijoin_

```sql
select * from ports p where exists (select * from ships s where s.home_port = p.port_id);
```

EXISTS is slower since for each exists condition, the engine executes,
and it can compare everything with nulls

and EXISTS ONLY works with a subquery, it cannot compare values directly like the IN operator.

## USING THE WITH clause

the WITH keyword is used to assign a name to the subquery block and use the name to reference the block in other clauses, as if it was a table.

syntax is as follows:-

```sql
WITH
    alias_name AS (subquery),
    another_name AS (subquery2), --you can repeat as many times as you want
    main_statement; -- in the main statement you can refer to the subquery alias_name as it is a table

with dense_table as ( select * from ship_cabins s where sqr_ft > (select avg(sqr_ft) from ship_cabins where s.window = window) )
select * from dense_table d full join ports p on p.port_id =d.id;
```

the WITH define more than one subquery before the SELECT clause, these subqueries are called SUBQUERY FACTORING clause, with can define more than one subquery factoring clause
the name for the alias is treated as an inline view or as a temporary table with oracle, `the only semicolon goes at the end of the entire statement`

you can use the table alias in the main query of within other subqueries,

## SINGLE ROW and MULTIPLE ROW subqueries

### SINGLE ROW SUBQUERY

a subquery that returns only one row. To use a single row function make sure you know that the result will be a single row

Ways to return a single row

- an aggregate function without a group by clause
- A value based on the primary key where the key is unique
- when results are limited to a single row, using rownum < 2 preudocolumn, or rowid < 2

You can use multiple subqueries within a where clause.

the following are used in single row subqueries for comparison

| Condition     | Description                                     |
| ------------- | ----------------------------------------------- |
| =             | Equal                                           |
| <> or != or ^ | Not Equal                                       |
| >             | Greater than                                    |
| >=            | Greater than or equal                           |
| <             | Less than                                       |
| <=            | Less than or equal                              |
| LIKE          | enables wildcard matching                       |
| IN            | compares against a tuple of value for existence |

The `IN` keyword can compare against a tuple of value for existence, or a subquery regarded, it can also return a mutlicolumn value, the IN allows to compare one value to a SET of values

### MULTIPLE ROWS SUBQUERY

may return more than one row of answers to the parent query. There are operators allowing for the possibility of multiple rows from a subquery. These operators that can be used with Multiple row results

| Operator | Description                                                                                                                                                   |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| IN       | compares a result or a row to a set of zero or more returned values                                                                                           |
| NOT      | Used with IN to reverse the result                                                                                                                            |
| ANY      | used in comparison with single row functions to compare a subject value with a multirow subquery returns                                                      |
| SOME     | same as any                                                                                                                                                   |
| ALL      | used with single row functions to compare values forexample `SELECT * FROM PRODUCTS WHERE PRICE > ALL (SELECT PRICE FROM PRODUCTS WHERE CATEGORY = 'LUXURY')` |

NOTE: `you can use greater or less than comparison operators with single row subquery but not multirow subquery unless those operators are combined with ALL, ANY or SOME`
examples and syntax for ANY, ALL, and SOME

```sql
-- for any
SELECT column(s) FROM table
WHERE column_name operator ANY (subquery);

-- for all
SELECT ALL column(s) FROM table;

-- with subquery
SELECT column(s) FROM table WHERE column_name operator ALL (subquery);

SELECT column(s) FROM table
WHERE column_name operator SOME (subquery);
```

### NOT IN and NULL values in the SUBQUERY

when a not in is used where there are null values, it will not return any row since the engine can handle whether the value is equal to i dont know or is not.

One approach is to exclude NULL values in the subquery
The result only with any makes sense when null are explicitly ommited in the subquery

tips

1. EXISTS does not compare to any value
2. IN compares exact number of values so columns compared must be as columns in the IN subquery
3. ALL works with comparison operators to get values
4. EXISTS is AKA a semijoin or extended outer join
