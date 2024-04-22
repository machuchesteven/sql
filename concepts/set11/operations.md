# SET OPERATIONS

Set operations acts as one of the superpower to combine standalone SELECT statetements in ways that can not be done with joins
They are ideal for combining data for various output of SELECT statements
a series of SELECT statements can be combined with multiple SET operators and may include a single ORDER by clause to sort the whole output
Lets see

## DESCRIBE SET OPERATORS

SET operators combine two or more SELECT statements so their outputs is merged in some manner
there are four SET operators

- `UNION` -> combine row sets, eliminate duplicate rows
- `UNION ALL` -> combine all rows without eliminating duplicates
- `INTERSECT` -> include only rows that are present in both queries
- `MINUS` -> substract the rows in the second row set from the rows in the first row set, returns only those in the first set not in the second

The following are rules for a successful combination before using the SET operators

- number of expressions selected int eh select list statement must be identical in each select statement
- Data type must match so they share the same data type group with regard to their positions - (either identical data types or convertibe)
- large data types can not be used, such as BLOB and CLOB
- the order by clause can not be included in the select statement except after the last SELECT statement

We can combine complex SELECT statements with the set operators eg statements which include Multitable joins, subqueries, aggreate functions, and or GROUP BY clauses

The columns dont have to be named the same name, and they don't need any special relationship between them, as long as the number of columns are identical and the data group is the same, then they will perform as intended

## USE SET OPERATORS TO COMBINE MULTIPLE QUERIES INTO A SINGLE QUERY

The syntax is pretty simple,lets dive in

### UNION

Let have a table where we combine different email addresses from different tables

```sql
SELECT expressions FROM table1
UNION
SELECT expressions FROM table2
```

when the expression compares to remove duplicates, it just remove those in which the whole expressions rows are duplicated, not just a single expression of the expression rows in case of more than one column returned

### UNION ALL

the syntax is the same as UNION just add ALL after the UNION

```sql
SELECT expressions FROM source1
UNION ALL
SELECT expressions FROM source2;
```

### INTERSECT

this only returns common rows between the two sources of data
this will eliminate even duplicates within a single set if it happens to contain them,

```sql
SELECT expressions FROM source1
INTERSECT
SELECT expressions FROM source2;
```

### MINUS

```sql
SELECT expressions FROM source1
MINUS
SELECT expressions FROM source2;
```

## COMBINING SET OPERATORS

SET operators can be combined in any order as other operators, and they have equal precedence among themseves, ie they will execute as they are listed, to change the ORDER of precedence, we use brackets

```sql
SELECT ...
UNION
SELECT ...
INTERSECT
SELECT ...
MINUS
SELECT ...
```

when you use parentheses:-

- the code enclose is a standalone query and does not include an ORDER BY clause
- the enclodes code is place into the outer query as though it were a single, standalone SELECT statement, without the ORDER BY clause
  SET operators are useful for combining the data of two tables into one output result set when two tables have no primary/foreign key rekationship with each other.

## CONTROL THE ORDER OF ROWS RETURNED

The order by statement always determines the order of the returned rows. But when SET operators are used, there is a difference that the order by is a bit restricted,
How can you identify data in rows when there are multiple tables using different column names,
The answer is, in this case the order by clause is a bit restricted to identifying common expressions items in the select list
Here there are two ways to identify them, by reference and by position

### ORDER BY - using POSITION

for example u can order by using the positional reference digits and it will work fine since some columns are combinations of multiple columns and concatenation, while others are just solo columns
eg

```sql
SELECT exp1, exp2, exp3 FROM source1
UNION
SELECT exp4,exp5, exp6 FROM source2
ORDER BY 1; -- or 2 -- or 3
```

### ORDER BY REFERENCE

this is useful when you name one of the columns in the SELECT expressions list, using earlier examples, we can add column aliases that are alike and use them for sorting our results

```sql
SELECT exp1 as col1, exp2, exp3 FROM source1
UNION
SELECT exp4 as col1,exp5, exp6 FROM source2
ORDER BY col1;
```

The column you order by with must be specified in your list

Both two sorting approaches are fine, just make sure they are the last clause of the query

The column always takes the name of the first select's column
