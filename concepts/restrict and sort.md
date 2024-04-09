# Restricting and Sorting Data

Chapter 4: ORACLE OCA - 55 pages

In this section, we are dealing with the SELECT statement from Oracle

```py
# data source script
from faker import Faker
fake = Faker()
def fake_address():
    address = fake.address()
    address = address.replace("\n", " ")
    return address
def fake_city():
    return fake.city()
def fake_country():
    return fake.country()

def add_addresses():
    with open("names.sql", "w") as f:
        for i in range(0, 100):
            f.write(f"INSERT INTO addresses (address_id, street_address, city, st, country) VALUES ({i+1}, '{fake_address()}', '{fake_city()}', '{fake_city()[:2].upper()}', '{fake_country()}');\n")
        print("Names Created:")
        f.close()
    return
add_addresses()
```

## Sort Rows Retrieving by a Query

This section looks at the select statement with the ORDER BY clause. **`ORDER BY is always the final clause of SELECT statement`**, it can take multiple expressions, the first is give first sorting priority, then the second, and so on.Order by sorts the results of the SELECT statement for display purposes only.

See it in action:-

```sql
create table ADDRESSES(
ADDRESS_ID NUMBER,
STREET_ADDRESS VARCHAR2(50),
CITY VARCHAR2(30),
ST CHAR(2),
COUNTRY VARCHAR2(30)
);
-- load data with the script above
SELECT ADDRESS_ID, STREET_ADDRESS, CITY, ST, COUNTRY
FROM ADDRESSES
ORDER BY ST;

SELECT * FROM ADDRESSES;

SELECT ST FROM ADDRESSES GROUP BY ST;
```

Without an ORDER BY clause, there is not guarantee that rows will be displayed in the same manner as they are in the database.

the ORDER BY clause ensures consistency to the database

### ASC AND DESC

Thesetwo reserved words specify the direction of sorting on a given column of the order by clause.

- ASC[DEFAULT PARAMETER] -Indicates that values will be sorted in ascending order, meaning least first, no need to specify it, only specify if you wish
- DESC - short for descending, indicates that values will be sorted in descending order, decreasing order,

```sql
SELECT ADDRESS_ID, ST FROM ADDRESSES ORDER BY ST, ADDRESS_ID DESC;

SELECT ADDRESS_ID, ST FROM ADDRESSES ORDER BY ST ASC, ADDRESS_ID DESC;

SELECT ADDRESS_ID, ST FROM ADDRESSES ORDER BY ST DESC, ADDRESS_ID DESC;
-- all these statements returns same results, but in different order
```

### EXPRESSIONS

Any table expression can be used for sorting data.

example a table called project with project_id, project_name, project_cost, days
we can sort by the result of project_cost / days

```sql
create table projects (
project_id number primary key,
project_name varchar2(50),
project_cost number(10,3),
days number);
```

You can include an alias of an expression only if it is stated in the select expression before

Rules for using column alias

- Each expression in the SELECT list may optionally be followed by a column alias
- The AS keyword is optional, when used, goes with an optional space
- If Alias is enclosed in double quotes, it can include spaces
- If not in double quotes, it follows standard naming rules
- Alias must be unique
- Can only be referenced with the ORDER BY clause, nowhwere else

### Reference By Position

The position of the expression in the SELECT statement can be marked with its position number be used in ordering the results.

### Combination of references and Alias and Column names

Order by can combine various techniques to sort the results, example an alias, reference position and column names can all be used

NOTE: FRepeating a column you want to order by wont throw an error, but the first rule will take effect as the primary rule

### Order By `NULL`

In SQL null values appear to be greater than all other values,
hence they appear in the end of the order by statement.

in managing where null values will appear we set the keyword `NULLS FIRST` OR `NULLS LAST` after the column we want the nulls values to appear either before others of after other values

## Limiting Rows Retrieved by a Query

The `WHERE` clause in select statement, limit the number of rows retrieved based on a certain criteria.

The where clause performs in both `SELECT`, `UPDATE`, and `DELETE` statements

The `WHERE` is optional, it is not required to follow the select statement, but **when included, it must follow the `FROM` clause**

The where starts with the `WHERE` clause followed by the condition to be met for a particular iteration. The ultimate goal is to determine the values of true and false for each row in the table( and or view). if the condition returns true, the row is included in the result set. If the row returns false, the row is ignored.

### Comparing Expressions

The whre clause can use a series of comparisons, The Expressions are first evaluated and then compared against a row,
consider the following example:-

```sql
SALARY >= 50889 * 1.12;
```

the expressions checks first for the value if the value is greater than or equal to the evaluated resulf of mutliplication, then the row is returned

`The Expressions can be on either side of the comparison operator` like `5 > SALARY` or `SALARY <= 50` are both valid expressions

#### Comparison Operators

There are several comparison operators including the following:-

- = Equal
- <= Less or Equal
- \> Greater Than
- \>= Greater Than or Equal
- < Less than
- != or <> or ^= NOT EQUAL
- IN - checks if a given values exists in the given list
- LIKE - checks for strings using wildcards
- IS compares for null
- NOT - Negates the expression

### Operator Precedence in SQL

Operators in SQL execute in the following order:-

1. +, - as UNARY operators
2. \* , / - mutliplication and division
3. +, -, || - plus, minus and concatenation

note: Oracle has no modulo operator

### Comparing Data Types

There are rules governing data types comparison. The first rule is data type comparison should be the same for the two expressions, sometimes implicit type conversion occurs, but sometimes it doesn't.

- `NUMERIC` - smaller numbers are less than larger numbers, 0 is greater than any negative number
- `CHARACTER` - A is less than Z, Z is less than a, uppercase are less than lowercase letters. When numbers are treated as characters, `2` is greater than `10`, comparisons are case sensitive by default.
- `DATE` - Yesterday is less than today, Earlier dates are less than later dates. `LATER DATES ARE GREATER DATES`
- `DIGITS vs STRING` - numbers as strings are less than characters and less than some special characters non alphabetic, but some symbols are less than numbers

#### `LIKE` OPERATOR

Is useful when performing comparisons using wildcards
The following wildcards are supported:-

- \_ - The underscore, represent single character
- % representing zero or more characters

Wildcards can be repeated as required

Consider the following examples:-

```sql
select * from good_projs where company_name like '%o%';

select * from good_projs where company_name like '_h%';

select * from good_projs where company_name like 'O%';

select * from good_projs where company_name like '%o_';

select * from good_projs where company_name like 'M%';

select * from good_projs where company_name like UPPER('m%');
```

### Boolean Logic

the where clause includes support for Boolean Logic, whereby Multiple expressions can be connected with a series of Boolean operators

#### AND and OR

when we want to compare for more than one condition, we use AND and OR for nesting conditions. For example:-

```sql
select * from good_projs where company_name like UPPER('m%') and days > 7;

select * from good_projs where company_name like UPPER('m%') or days > 7;

select * from good_projs where company_name like UPPER('m%') or days > 7 or company_name like UPPER('a%');

```

Booleans Rules:-

- For AND, both expressions must be true for the combination to be true
- For OR, at least one expression must be true for the combination to be true

#### NOT OPERATOR

This is used for negating boolean conditions. it can be placed in front of an expression to negate its conclusion from true to false

```sql
select * from good_projs where company_name not like UPPER('m%') and days > 7;

select * from good_projs where company_name not like UPPER('m%') and not days > 7;

select * from good_projs where not company_name not like UPPER('m%') and not days > 7;

select * from good_projs where not company_name like UPPER('m%') and not days > 7;
```

### Operators Precedence

In evaluating BOOLEAN operators, there are rules for evaluating them.

NOT is evaluated first, then AND is evaluated before OR

You can use parentheses to override the rules of precedence

### Additional `WHERE` Clause features

This includes features that are important to describe advanced WHERE clause usage

#### IN operator

This is useful when you are comparing one value against a series of values. Example:-

```sql
select * from good_projs where company_name = 'John' or company_name = 'Doe' and company_name = 'Alice' and company_name = 'Bob' and company_name = 'zena';

-- using where there IN operator we reduce it to
SELECT * FROM good_projs where company_name IN ('John', 'Doe', 'Alice', 'Bob', 'Zena');

```

Rules of the IN operator:-

- Can be used with Dates, Numbers and Text expressions
- List must be enclosed in a list of parentheses
- List values must be of the same data type
- List includes anywhere from one expression to several expressions, separated by commas.

In Addition the Boolean NOT operator may precede the IN operator

```sql
SELECT * FROM good_projs where company_name NOT IN ('John', 'Doe', 'Alice', 'Bob', 'Zena');
```

#### BETWEEN Operator

This helps compare values in a range of provided values.
Here is an example:-

```sql
SELECT * FROM good_projs where days between 1 and 4;
-- this is like days >= 1 and days <= 4

SELECT * FROM good_projs where days not between 1 and 4;
```

`between is inclusive and not exclusive`

#### IS NULL and IS NOT NULL

Is used to compare for NULL and Non NULL values

Using value = NULL; it will never return value

```sql
SELECT * FROM good_projs where days is null;

SELECT * FROM good_projs where days is not null;
```

#### additional concepts

You will use `SET OPERATORS` and `SUBQUERIES`, Which will be covered later
