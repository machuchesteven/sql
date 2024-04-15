# Displaying Data from Multiple Tables

Here we do that using table joins, identifying tables with data that relates.
A join is a query that associates data in one table with data in another table.
Most leaders says 5 tables is a limit for join, but i have known 9 tables join that made sense

`the most important part of all joins is the JOIN KEYWORD`

## Different Types of Joins and Their Features

There are several types of joins, most commonly used is the equijoin, less commonly used is the non-equijoin.

## TYPES OF Joins

Joins are characterised in many ways, one of them is identifying whether they are inner or outer joins

### INNER JOINS vs. outer joins

- Inner joins - Connect rows in two or more tables, if and only if there are matched rows in all tables being joined
- Outer joins - Connect rows in two or more tables, in a way that is more inclusive, whether there are rows that has no matching values, the unmatched rows will still be included

### EQUIJOINS vs. NON-EQUIJOINS

- EQUIJOINS - Connect rows in two or more table by looking for common data among table columns
- NON-EQUIJOJOINS - Connect data by looking for relationships that don't involve equality such as less than or greater than relationships, or situations where data in one table is within a range of values

### Other Joins

other joins like self and natural joins, we will review subsequent sections below

## Access Data from More than one table using Equijoins and Non-Equijoins

This section looks at inner joins, including natural joins, multitable joins, non-equijoins and the USING clause

### Inner Joins

Returns a merged row from two or more tables if there are matched column values among joined tables, those without a matched value, won't be returned

In order to join the tables

- identify the tables in the from clause, separated by the INNER JOIN keyword
- Define the column from each table that is being used to join the tables

Additional clauses like where, and order by are effective too
example and syntax:-

```sql
SELECT columns
FROM table INNER JOIN another_table ON condition -- ineer keyword is optional too
WHERE -- optional
ORDER BY ;-- optional too

SELECT ship_id, ship_name, port_name
FROM ships INNER JOIN ports
ON home_port = port_id
ORDER BY ship_id;

SELECT ship_id, ship_name, port_name
FROM ships JOIN ports
ON home_port = port_id
ORDER BY ship_id;
```

#### OLDER INNER JOIN syntax

The last join syntax is used for referencing individual columns by stating the columns and refenrencing them, it does not use the join stax and so it uses table names or aliases instead

```sql
SELECT table_n.column1, table_n.column2, table_n1.column3, table_n2.column1 ,...
FROM table_n, table_n1, table_n..
WHERE table_n.column_condition = table_nother.column_condition

SELECT s.ship_id, s.ship_name, p.port_name
FROM ships s, ports p
WHERE s.home_port = p.port_id;
```

The syntax still works but is inconsistent and less effective

### USING TABLE ALIASES

Consider two tables, EMPLOYEES and DEPARTMENTS
both with the column department_id, when we use the first syntax, after join on we could put
`DEPARTMENT_ID = DEPARTMENT_ID`, This brings an error back, column conflict during referencing
there are two solutions here

- write the full name of the table
- use table name alias instead

the scope of the alias is the statement itself, once the statement is over executing, a new alias should be defined

CONISDER BELOW

```SQL
SELECT employees.employee_id, employees.employee_name, departments.department_name FROM employees INNER JOIN departments ON employees.department_id = departments.department_id;

select employee_id, employee_name, department_name from employees e INNER JOIN department d ON e.department_id = d.department_id;
```

There is no answer which way, the name or alias you should use, Either way you should consider the following:-

- Whenever there are ambiguous names, you must identify the columns clearly
- The use of both table prefix and alias are on the exam

table alias is commonly used
also alias for table can be used with INSERT, UPDATE, MERGE and DELETE, as well as select statement

## NATURAL JOINS

one of the approach designers do is creating tables with common name upon which joins are built, natural joins points out working with tables that share the same name upon which our joins will be built.

Natural joins are inner joins by default, but can be a left outer join, or a right outer join or a full outer join, TO BE CALLED A NATURAL JOIN, THE NATURAL KEYWORD SHOULD BE THERE

natural join approach is to locate any columns in the two tables with a common name and use them to join tables eg

```sql
SELECT EMPLOYEE_ID, LAST_NAME, STREET_ADDRESS
FROM EMPLOYEES NATURAL JOIN ADDRESSES;
```

It doesnt require an explicit statement of these columns, provided these column names are identical

also, there are two columns employee_id from both tables, in a natural join there is no need to specify which one to use, in other cases it might need an alias or explicit declaration

finaly a natural join default to an inner join, but it works with a left outer join, right outer join and full outer joins

```sql
SELECT EMPLOYEE_ID, LAST_NAME, STREET_ADDRESS
FROM EMPLOYEES NATURAL JOIN ADDRESSES;

SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM EMPLOYEES NATURAL LEFT OUTER JOIN DEPARTMENTS;

SELECT EMPLOYEE_ID, FIRST_NAME, DEPARTMENT_NAME, STREET_ADDRESS
FROM EMPLOYEES NATURAL FULL OUTER JOIN DEPARTMENTS
NATURAL FULL OUTER JOIN ADDRESSES ORDER BY DEPARTMENT_NAME;
```

tips on joins:-

- if an inner join or a left outer join is used, the leftmost table is the source of the value
- if a right outer join is used, the rightmost table is the source of the value

If a full outer join is used, both tables will be combined to form the output, so the value will be taken from the combination of both tables

## USING keyword

this keyword is similar to the natural join since its use dependes on the presence of identically named column in the JOIN
like NATURAL, using can be used with both INNER and OUTER JOINs

consider the example below

```sql
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM EMPLOYEES JOIN DEPARTMENTS USING (DEPARTMENT_ID);

SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM EMPLOYEES LEFT JOIN DEPARTMENTS USING (DEPARTMENT_ID);

SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM EMPLOYEES LEFT OUTER JOIN DEPARTMENTS USING (DEPARTMENT_ID);
```

the USING keyword only works wherever there are matching columns in their names, otherwise it throws an error

Using can take in multiple columns also
`USING (col1, col2,.., coln)`

### MULTITABLE JOINS

Joins can connect more than two tables

```SQL
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.EMAIL, L.STREET_ADDRESS, D.DEPARTMENT_NAME
FROM EMPLOYEES E JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID;
```

the joinline can be repeated several times as per join requirements

## NON-EQUIJOINS

above we have used equal comparisons only, Non-equijoins can be used to join rows to another by ways of non equal comparisons, eg greater or lesser or a range of values, these joins are unusual but important

eg the scores table and grading system

```SQL
SELECT S.SCORE_ID, S.TEST_SCORE, G.GRADE
FROM SCORES S JOIN GRADES G ON
S.TEST_SCORE BETWEEN G.SCORE_MIN AND G.SCORE_MAX;
```

above the syntax of the ON condition of the NON-EQUIJOIN is similar to the syntax of the WHERE condition of the SELECT statement, given you the chance to use comparison expressions and boolean operators to connect a series of comparisons

NOTE: This can be used with all types of joins including INNER AND OUTER JOIN

## SELF JOINS

this is a table that is joined to itself
You can join a table to itself in the same table as opposed to the different column in the same table

Self join can use all the same variations like other joins, including inner joins, outer joins, equijoins and non-equijoins

### SELF REFERENCING FOREIGNKEYS

to create a self referencing foreign keys, we can use the following syntax:-

```sql
ALTER TABLE table_name
ADD CONSTRAINT constraint_name FOREIGN KEY (column_name) REFERENCES table_name (column_name2) ON DELETE SET NULL;
```

The foreign key is advised but not required in order to perform a self join

#### SELF JOIN SYNTAX

to create the self join we need to do the following-

- identify the table twice in the FROM clause
- Define our join criteria, mostly OUTER JOINS works well to see all details
- Apply table alias to all appropriate references

Consider an example below

```sql
SELECT E.FIRST_NAME || ' ' || E.LAST_NAME AS EMPL_NAME, M.FIRST_NAME, M.FIRST_NAME || ' ' || M.LAST_NAME AS MANAGER_NAME
FROM EMPLOYEES E JOIN EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID;

SELECT E.FIRST_NAME || ' ' || E.LAST_NAME AS EMPL_NAME, M.FIRST_NAME, M.FIRST_NAME || ' ' || M.LAST_NAME AS MANAGER_NAME
FROM EMPLOYEES E JOIN EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID;
```

## OUTER JOINS

Viewing data that does not meet a join condition,
they are of 3 types, LEFT, RIGHT and FULL

### LEFT OUTER JOINS

On the left outer join say table A left outer Join table B, the A will have all columns, but table B, that is attached to the primary table will only have columns associated or null, columns in the `left outer joined table` that are not associated with the primary table will not be shown
syntax

```sql
SELECT columns FROM A
LEFT OUTER JOIN B ON A.column = B.column -- OUTER keyword is optional
WHERE conditions
```

### RIGHT OUTER JOIN

In here, all columns of the joined table will be shown indicating they dont have sibling nodes with the primary table that meet requirements, on the right join, columns from the primary table will that does not meet condition will be left out
syntax:-

```sql
-- A rows not meeting conditions will be left out, but all B rows will be included
SELECT columns
FROM A RIGHT OUTER JOIN B -- OUTER keyword is optional
ON A.column = B.column
```

### FULL OUTER JOIN

if we want to combine the effect of left and right joins, we can use the full outer join, that will return all rows

This will return all rows merged together, even those not meeting conditions will be listed

```sql
SELECT columns
FROM A FULL OUTER JOIN B -- OUTER keyword is optional
ON A.column = B.column
```

## ORACLE OUTER JOIN SYNTAX

This is quite popular, though is not in the exam, it is worthy knowing

Oracle offers its own join syntax using the + symbol in parentheses `(+)`

consider :-
for a left outer join, put a plus to the right, includes the rows on the left not meeting the condition on the right

```sql
SELECT columns
FROM tableA, tableB
WHERE column_fromA = column_fromB(+) -- creates the left outer join
select ship_name, ship_id, port_name
from ships, ports
where home_port = port_id(+);
```

For a RIGHT OUTER JOIN, we move the plus to the left

```sql
SELECT columns
FROM tableA, tableB
WHERE column_fromA(+) = column_fromB
```

This syntax can not do a FULL OUTER JOIN, hence it is helped with set operators do accomplish that, using `UNION` operator

```sql
SELECT columns
FROM A, B
WHERE column_fromA = column_fromB(+)
UNION
SELECT columns
FROM A, B
WHERE column_fromA(+) = column_fromB;
```

oracle advises against the use of the plus operator in sql, and emphasize on using more the INNER JOIN and OUTER JOINS keywords
