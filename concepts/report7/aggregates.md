# Reporting Group Functions Using Aggregate Data

These are functions that returns one answer for many rows,
we will add two clauses `GROUP BY` and the `HAVING` clause

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
