# Reporting Group Functions Using Aggregate Data

These are functions that returns one answer for many rows,
we will add two clauses `GROUP BY` and the `HAVING` clause

the following are the 4 places where aggregate functions can be called

1. select list
2. group by
3. having clause
4. order by clause

## DESCRIBE THE USE OF GROUP FUNCTIONS

Group functions returns a single value for each set of zero or multiple rows it encounters
Both AGGREGATE AND ANALYTIC ROWS ARE GROUP FUNCTIONS

many group functions will be used as ANALYTIC functions and AGGREGATE functions, a few are limited to only one type

Here is a table of commonly used AGGREGATE functions

| Functions                                                                                | Description                                                            | Aggregate | Analytic |
| ---------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- | --------- | -------- |
| COUNT,SUM,MIN,MAX, AVG, MEDIAN- `only median is not analytic`                            | more commonly used aggregate functions                                 | Yes       | Yes      |
| VARIANCE, VAR POP, VAR SAMP, COVAR_POP, COVAR_SAMP, STDDEV, STDDEV_POP, STDDEV_SAMP      | variance and std deviation for population and cumulative std deviation | Yes       | Yes      |
| RANK, DENSE_RANK, PERCENT_RANK, PERCENTILE_CONT, PERCENTILE_DISC, CUME_DIST, FIRST, LAST | ranking functions and associated keywords                              | Yes       | Yes      |
| GROUP_ID, GROUPING, GROUPING_ID                                                          | grouping features for use with GROUP BY and CUBE                       | Yes       | no       |

many aggregate functions are numeric, but they process data and return data, many process data with various data types including date and character dts

A SELECT STATEMENT MUST CHOSE WHETHER IT IS INVOKING SCALAR OR AGGREGATE FUNCTIONS, BUT CAN NOT INVOKE BOTH AT THE SAME TIME

we can use two types of functions in different levels of aggregation in the same expression or select statement, eg

```sql
SELECT ROUND(AVG(column), 2) FROM table; -- possible
SELECT AVG(ROUND(column, 2)) FROM table; -- possible
SELECT AVG(ROUND(column, 2)), ROUND(column) FROM table; -- impossible
```

we can nest scalar and aggregate functions but we can't apply them into different rows

## GROUP FUNCTIONS

### COUNT - `COUNT(ex1)` - no null value, then returns 0

determines the number of occurences of non null values for a column
the count if applied to a column, it ignore null values for that column, also using the asterisk operator (`*`) instead of a column, returns the number of occurences or rows in the table specified,
returns 0 if no non null values were found

```sql
SELECT COUNT(*) FROM SHIPS;
```

even if a row exists, but all of its columns are null values, COUNT(\*) will still count it
count uses the `DISTINCT` and `ALL` operators, ALL is the default - `DISTINCT AND ALL CANT BE USED WITH ASTERISK`

```sql
SELECT COUNT(DISTINCT WINDOW), COUNT(ALL WINDOW) FROM SHIPS;
```

### SUM- `SUM(e1)`

e1 -an expression with numeric data type, adds numeric values in a column or epression, it only takes numeric data, if one value is null, sum returns the non null values, if all values are null, it will return 0

```sql
-- we create the aggregate table to help us
select sum(items) from aggr;
```

### MIN, MAX - `MIN(e) or MAX(e)`

min returns a single minimum value and max returns a single maximum value, from a row specified by e
works with the following data types:-

- Numeric - low numbers are min, high numbers are max
- Date - Earlier dates are min, later dates are max
- Character - A is less than Z, 2 is greater than 100, 1 is less than 10

Null values are ignored unless all values are null, where null is returned

### AVG - `AVG(e)`

e is a numeric data type expression, the average is computed ignoring null values and their rows in the count.

```sql
select avg(items) from aggr;
select avg(nvl(items, 0)) from aggr;
```

For the case of nesting, you can nest any number of scalar functions with an aggregate function
`DISTINCT` and `ALL` are available to use with AVG, however the average is computed only for rows with DISTINCT values

### MEDIAN - `MEDIAN(e)`

e is a numeric or date data type expression, the median is computed ignoring null values,
it returns the MIDDLE value or an interoperated middle value within the middle, if odd number of items, the middle value, of even, it will perfom linear interpolation and locate the middle value given they are sorted, it ignores null values, unless all values are null

```sql
select median(items) from aggr;
```

### RANK - `RANK(e)`

sorts values and ranks them, if a tie happen, the tied values will be given the same rank, but the following after will take the rank of the count, not the following positions

there are two syntaxes for RANK

#### RANK - analytic function - `RANK() OVER (PARTITION BY p1 ORDER BY obj1)`

The use of partitioning is optional, but all others are required. The rank calculates a rank of values within a group of values

```sql
select id, rank() over (partition by window order by sqr_ft) from ships;
select id, rank() over (partition by window order by sqr_ft),rank() over (order by sqr_ft) from ships;
```

#### RANK - aggregate - `RANK(c1) WITHIN GROUP (ORDER BY e1)`

c1 and e1 are expressions and they can be a list of expressions, data type of c1 must match that of e1, c2 to e2 and so on

```sql
RANK(c1, c2, c3) WITHIN GROUP (ORDER BY e1, e2, e3) FROM table;
SELECT RANK(533) WITHIN GROUP (ORDER BY SQR_FT) FROM SHIPS; -- THE VALUE TO RANK MUST BE A CONSTANT AT THE TIME OF THE CHECK
```

### DENSE_RANK -

Is similar to rank the only difference is in rank we lose positions due to ties, in dense rank, we dont lose positions due to ties. It resumes the next rank with the next number regardless of how many ties have happened.

#### DENSE_RANK - analytic - `DENSE_RANK() OVER (PARTION BY p1 ORDER BY exp1)`

p1 is a partition window, and exp1 is the ranking expression

```sql
SELECT DENSE_RANK() OVER (ORDER BY SQR_FT) FROM SHIPS;

SELECT DENSE_RANK() OVER (ORDER BY SQR_FT) FROM SHIPS;
SELECT DENSE_RANK() OVER (PARTITION BY WINDOW ORDER BY SQR_FT) FROM SHIPS;
```

#### DENSE_RANK - aggregate - `DENSE_RANK(c1) WITHIN GROUP (ORDER BY e1)`

c1 is an expression with a data type corresponding to e1 data type

As explained, there are not reserved positions, as if 5 ties happened for the 2nd position, the next will be the 3rd position, regardless.

```sql
SELECT DENSE_RANK(500) WITHIN GROUP(ORDER BY SQR_FT) FROM SHIPS;

```

### FIRST/LAST

they are very similar funtions, both analytic and aggregate, `they offer better performance than MIN and MAX functions`

```sql
SELECT MAX/MIN(COLUMN) KEEP (DENSE RANK FIRST/LAST) FROM TABLE;
SELECT MAX(SQR_FT) keep (DENSE_RANK FIRST ORDER BY sqr_ft desc) OVER (PARTITION BY sqr_ft) from ships;
SELECT MAX(SQR_FT) KEEP (DENSE_RANK LAST ORDER BY SQR_FT) FROM SHIPS;
```

Once you add the OVER part after keep, the function performs as analytic function.

this performs faster than just using MIN or MAX,

## GROUPING USING GROUP BY - after the where clause if it exists

the group by is an optional clause and is used to group data set and treat each set as a whole. It indentifies rows groups and like create min rows over a larger group

Group by is unique to select, and does not exists in other statements.

when we need to get the group example for average windows in the ships table, for one and the other type of windows, there are two ways

- Get an average for each window - `cumbersome approach`
- Run a select window, avg() the group by - best approach

Rules for forming group clauses are as follows:-

- GROUP BY can specify any number of valid expressions, including columns in the table
- Generally used to specify columns in the table that will contain data in order to group rows in order to perfom some some sort of aggregate manipulation
- In the select list that include a GROUP BY clause, the following are the only allowed items
  - Expressions that are specified in the GROUP BY
  - aggregate functions applied to those GROUP BY expressions
- Expressions that are specified in the GROUP BY, is not a must for them to be in the SELECT'S statement list.

```sql
select window, avg(sqr_ft), count(*) from ships group by window;
```

a group by can also be applied to multiple columns, but the order of precedence first group by the first column, then the second and so on

### ORDER BY Revisited

when a GROUP BY is used with SELECT, when there is an ORDER BY clause, it will be restricted by the following:-

- Expressions specified in the GROUP BY clause
- Expressions in the SELECT'S list referenced by position, name of alias
- AGGREGATE functions, regardless of whether the function is specified anywhere in the SELECT statement
- the functions USER, SYSDATE and UID

### NESTING AGGREGATE FUNCTIONS

some aggregate funcitons can be nested, thanks to the group by, which will fast perfom aggregate on grouped data,then collect the aggregate value once those mutliple to single rows have been turned into single rows

`ONLY TWO LEVELS OF NESTING ARE ALLOWED FOR SQL STATEMENTS, THERE CAN BE ANY NUMBER OF SCALAR FUNCTIONS NESTED INTO STATEMENTS`

TO SUM UP

- MAX of 2 levels for aggregate functions nesting
- Each time we introduce an aggregate function, we roll up lower level data to higher level summary data
- your select statements list must always respect the level of aggregation
- Scalar functions can be nested any time, and has no effect on the level of aggregation

## HAVING clause - INCLUDE AND EXCLUDE AGGREGATE ROWS

The having clause performs as the `WHERE` clause for aggregate data, is unique for the select statement, not available for other clauses.

having does not defined the group of rows, the must be defined by the `GROUP BY` clause, `HAVING` clause defines the criteria in which the GROUP row will be included or excluded

it can only be where the `GROUP BY` clause is defined. and the `GROUP BY` and `HAVING` can be in any order.

| SEQUENCE | CLAUSE   | REQUIRED/OPTIONAL | NOTE                                                              |
| -------- | -------- | ----------------- | ----------------------------------------------------------------- |
| 1        | SELECT   | REQUIRED          |                                                                   |
| 2        | FROM     | REQUIRED          |                                                                   |
| 3        | WHERE    | OPTIONAL          |                                                                   |
| 4        | GROUP BY | OPTIONAL          |                                                                   |
| 4        | HAVING   | OPTIONAL          | is allowed only with group by and they can appear in either order |
| 6        | ORDER BY | OPTIONAL          |                                                                   |

Consider an example for the having clause

```sql
SELECT AVG(SQR_FT) FROM SHIPS GROUP BY WINDOW HAVING AVG(SQR_FT) > 500;

SELECT WINDOW, AVG(SQR_FT) FROM SHIPS GROUP BY WINDOW HAVING AVG(SQR_FT) < 500 AND LOWER(WINDOW) IN ('none') ;

```

HAVING can use the same operators as WHERE does, AND, OR and NOT, ther are just the following restrictions:-

- Can only be used in a select statement with the GROUP BY clause
- can only compare expressions that affect groups as defined in the aggregate function and GROUP BY expressions

`Having can include scalar functions, on ething to know is HAVING deals with group of rows, not individual rows

## GROUPING, ROLLUP, CUBE Functions

### ROLLUP

`It ROLLUP` the number of subtotals per each subgroup of the group by expression, for n expressions there will always be n +1 rows of subtotals

consider when you are having groups of students in classes and you want to know those students count by class, then by gender, and then the total,

you will use 2 levels of groups. class then gender, using rollup with them will return the total aggregate for those groups aper one level minimized, it will give another row with null last group but with the first group and their aggregate value, eg for count, will return null gender but returns the name of the class and the number of students in both genders, ignoring gender subgroup

syntax is as follows:-

```sql
SELECT expressions FROM table GROUP BY ROLLUP(expressions);
SELECT WINDOW, COUNT(*) FROM SHIPS GROUP BY ROLLUP(WINDOW);
```

### CUBE

This will provide subtotals for all combinations applied, for n combinations there will be 2 power n combinations of subtotals.

for our above example, it will give answers for both genders without classes too, after the count of classes without genders

syntax:-

```sql
SELECT expressions FROM table GROUP BY CUBE(expressions);
SELECT WINDOW, COUNT(*) FROM SHIPS GROUP BY CUBE(WINDOW);
```

its is possible to do a partial cube and a partial ROLLUP

```sql
SELECT expressions FROM table GROUP BY CUBE other expressions(only_cubed_expressions);
SELCT expresions FROM table GROUP BY ROLLUP other expressions(only_rolledup_expressions);
```

### GROUPING functions

the grouping function creates a presudocolumn for the groups created by the grouping function / aggregate functions

the grouping column returns 1 if the value for the grouped group specified is null, and 0 otherwise

eg when you use grouping(gender) as g_group then the line where the gender will be null, the g_group will be 1, this tells the grouping function in group by has returned the subtotal affecting that group

also you can use the grouping function in having clause as you can use the rowid column for scalar functions

### GROUPING_ID

with grouping usin functions like cube and rollup, GROUPING_ID returns a number representing the the identity if subtotal rows included in nesting

it takes in columns included in the CUBED OR ROLLED UP functions

```sql
SELECT WINDOW, COUNT(*), GROUPING_ID(WINDOW) FROM SHIPS GROUP BY ROLLUP(WINDOW);
```

### GROUP_ID - `GROUP_ID()`

is used to eliminate duplicates by assigning an identity value for each row when like data appears, all the first rows will be assigned 0, and other rows will be assigned values higher than o

```sql
SELECT WINDOW, COUNT(*), GROUPING_ID(WINDOW), GROUP_ID() FROM SHIPS GROUP BY ROLLUP(WINDOW)
```

### GROUPING SETS

Calculating many subtotals especially those with many dimensions can be a quite intensive process, hence we create grouping sets for columns that we need subtotals from

```sql
SELECT a, b, c, aggr(d),... FROM TABLE GROUP BY GROUPING SETS ((a, b), (b,c)), GROUPING SET(other_groups)
ORDER BY a, b, c, ...;
```

this groups a and b, AND b,c
for when we use THOSE GROUPING sets, the results is a cross products of those subgroups mentioned above eg
GROUPING SETS(a,b), GROUPING SETS(d,c)

(a,c)
(a,d)
(b,c)
(b,c)
