# Conversion functions

## Purspose of Conversion functions

the main purpose is to convert data values from one data type to another. This might enable some data to be used as input to other functions. Some conversion functions also feature formatting capabilities

## Explicit and Implicit conversions

SQL offers implicit conversions features on top of the provided explicitly converted data.
This happens when SQL determines that Data Types conversion is required but not specified. eg concatenate a numeric and a string value.

```sql
SELECT 'Chapters' || 1  ||'.... I am Born' FROM DUAL;
```

Implicit conversion works in most cases but does not work in others.
Best practice is to convert explicitly.
The following are rules for automatic conversion :-

- Numeric values will generally not convert to dates
- Numeric and text wont convert automatically to large objects
- Very large objects will not convert automatically to each other

Internal conversions sometimes might not be affected explicitly, but will always affect performance of the server.

## TO_CHAR, TO_NUMBER, TO_DATE functions

Sometimes some codes raises error when conversion fails,

## Conversion Functions

### TO_NUMBER `TO_NUMBER(e1, format_model, nls_params)`

`e1` - required expression, `format_model` - optional format model,
The following are the format models used

- `,(comma)` - returns a comma in a specified position
- `.(period)` - returns a period in a specified position[only one can be specified]
- `$` - returns a value with a leading dollar sign
- `0` - leading and trailing zeros are returnned
- `9` - Returns a value with a specified number of digits
- `D` - replaces decimal with D
- `EEEE` - returns value in scientific notation
- `G` - Used as a group separator
- `L` - returns in a specified position the local currency symbol `NLS_CURRENCY`

the nls numeric character comprises those in the documentation too

the nls_settings are three setings that can be used as follows:-

- NLS_NUMERIC_CHARACTER
- NLS_CURRENCY
- NLS_ISO_CURRENCY

Consider the following examples

```sql
SELECT TO_NUMBER('7873.83939') FROM DUAL;
-- WITH A SPECIFIC FORMAT, KNOWING THE VALUE EXACTLY
SELECT TO_NUMBER('78987.789', '99999.999') FROM DUAL;

SELECT TO_NUMBER('#787,898.34', 'L999G999D99', 'NLS_CURRENCY= ''#'' ') FROM DUAL;

SELECT TO_NUMBER('787-898.34' DEFAULT 0 ON CONVERSION ERROR, '999G999D99', ' NLS_NUMERIC_CHARACTERS = ''-.'' ' ) FROM DUAL;

SELECT TO_NUMBER('787,898.34', '999G999D99' ) FROM DUAL;

SELECT TO_NUMBER('2,00' DEFAULT 0 ON CONVERSION ERROR) "Value"
  FROM DUAL;
```

### TO_CHAR

converts data from various dts to characters
Syntax of conversion

```sql
-- {} indicate optional here
TO_CHAR(e { default to '' on conversion error}, {format_model}, {[nls_parameters]})
```

it might take a number, date or string

- for number, it uses the same parameters as in to number function
- for date, it uses the following parameters
  - for string, `RR`- Year in Century , `DD`- Day of the month, `D`- Day of the week - 1-7 , `MM`- Month Number , `HH`- Hour ,`HH` or `HH12`, also `HH24`- Hour format, `MI`- Minutes, `MON`- Month in 3 letters , `SS`- Seconds , `YYYY`- Year , `AD or A.D.`, `DL`- long date format, `DS`- short date format, `DY`- abbreviated day of week eg MON, `E` abbreviated era name, `EE` - full era name, `FF` - fractional seconds, `TS` - Short time presentation
- for chars, it uses the same parameters as in

### TO_DATE

syntax :-

```sql
TO_DATE(c, format_model, nls_params);
```

format model is like the one above,
process:-

- Transform the value contained within c into a valid date dt by structuring the format model do described how characters are represented
- identify the date accordingly

```sql
SELECT TO_DATE('2017-03-21', 'RRRR-MM-DD') FROM DUAL;
```

## OTHER FUNCTIONS

The above are the basic functions used for converting dts but there are more functions and also nesting is allowed

### TO_TIMESTAMP

syntax:

```sql
TO_TIMESTAMP(c, format_model, nls_params);
```

`c` -required -is a character data type, `format_model` - define the format of c corresponding to the timestamp model, optional, default requirement is c to be timestamp format.

```sql
SELECT TO_TIMESTAMP('2020-MAR-21 12:04:30:839200', 'RRRR-MM-DD HH24:MI:SS:FF') FROM DUAL;
SELECT TO_TIMESTAMP('21-03-20 12:04:30') FROM DUAL;
```

### TO_TIMESTAMP_TZ

`TO_TIMESTAMP_TZ(c, format_model, nls_params)`

c is required and a character data type, `format_model` - define the format of c corresponding to the timestamp {optional} if not defined, c should be in a timestamp form, and nls_params are the same overall

```sql
SELECT TO_TIMESTAMP_TZ('21-MAR-20 12:04:30', 'RR-MMM-DD HH24:MI:SS') FROM DUAL;
SELECT TO_TIMESTAMP('2021-03-20 12:04:30', 'RRRR-MM-DD HH24:MI:SS') FROM DUAL;
```

`converting timestamp with local time zone, use cast function to do that`

### TO_YMINTERVAL - `TO_YMINTERVAL('y-m')`

`y` and `m` are required numbers contained within a string

```sql
SELECT TO_YMINTERVAL('02,78') AS EVENT_TIME FROM DUAL;
```

### TO_DSINTERVAL - `TO_DSINTERVAL('sql_format', nls_params)`

converts the interval to day and hourly intervals

```sql
SELECT TO_DSINTERVAL('40 21:23:30') AS EVENT_TIME FROM DUAL;

SELECT TO_DSINTERVAL('0 21:23') AS EVENT_TIME FROM DUAL;
```

### NUMTOYMINTERVAL - `NUMTOYMINTERVAL(n, interval_unit)`

n is a number, and interval_unit is one of `YEAR` or `MONTH`.
n can be a fraction too

```sql
SELECT NUMTOYMINTERVAL(24,'month') AS EVENT_TIME FROM DUAL;
SELECT NUMTOYMINTERVAL(24.4,'YEAR') AS EVENT_TIME FROM DUAL;
```

### NUMTODSINTERVAL - `NUMTODSINTERVAL(n, interval_unit)`

n is a number, and interval_unit is one of `DAY, HOUR, MINUTE, SECOND`

```sql
SELECT NUMTODSINTERVAL(245000, 'SECOND') AS EVENT_TIME FROM DUAL;
```

here the interval is given in singular form.

### CAST - `CAST(e AS d)`

e is an expression, d is the data type. converts one datatype or results to the type d, is very useful for datetime formats usually like `TIMESTAMP WITH LOCAL TIME ZONE`

```sql
SELECT CAST('19-JAN-16 11:35:00' AS TIMESTAMP WITH LOCAL TIME ZONE) FROM DUAL;
-- in case of anything, you can first convert the time using the TO_TIMESTAMP before the datatype
SELECT CAST(TO_TIMESTAMP('19-JAN-16 11:35:00') AS TIMESTAMP WITH LOCAL TIME ZONE) FROM DUAL;
```

## APPLY GENERAL FUNCTIONS AND CONDITIONAL EXPRESSIONS

These helps in helping create a conditional check for certain conditions in operations
eg check if a certain employee is of a certain department, and if yes, apply a bonus, if not then pass

### CASE

checks for a condition and executes an expression or statement

syntax: `CASE expresion1 WHEN cond1 THEN result1 WHEN cond2 THEN result2 ... ELSE resultfinal END`
or `CASE WHEN cond1 THEN result1 WHEN cond2 THEN result2 ... ELSE resultfinal END`

```SQL
SELECT case 5
      when 5 then 'Hello'
      when 6 then 'World'
      else 'Unknown'
      end
    FROM DUAL;
SELECT case
      when 4 <= 5 then 'Hello'
      when 6 <= 5 then 'World'
      else 'Unknown'
      end
    FROM DUAL;
```

case can take in whatever data type and return a specified data type

### DECODE - `DECODE(e, search_expressions, d)`

e, search_expressions, d - are all epressions, d is optional, others are required,

PROCESS:
e - is the value, or column to be measured against
search_expressions - comes in a a series of exp1, val1, exp2, val2, exp3, val3, ...expn, valn, if ith expression is true, then the result should be ith value
d - is the value to be defaulted to, if not supplied, it returns NULL

```sql
SELECT DECODE(5, 5, 'GREATER', 'UNKNOWN') FROM DUAL;
SELECT DECODE(4, 8, 'eIGHT', 3, 'tHREE', 'NOT MENTIONED') FROM DUAL;

-- NULLS CANT BE COMPARED TO ANYTHING,  BUT FOR DECODE, NULLS ARE EQUAL
SELECT
  DECODE(NULL,NULL,'Equal','Not equal')
FROM
  dual;
```

### NVL - `NVL(e1, e2)`

Takes in two expressions, if e1 evaluates to null, then returns e2. Otherwise, returns e1.

```SQL
SELECT NVL(NULL,200) FROM DUAL;
SELECT NVL(EXTRACT(YEAR FROM SYSDATE), 2018) FROM DUAL;
```

### NVL2 - `NVL2(e1, e2, e3)`

if e1 is not null returns e2, otherwise returns e3.

```SQL
SELECT NVL2(NULL, 890, 230) FROM DUAL;
SELECT NVL2(1, 890, 230) FROM DUAL;
```

### COALESCE - `COALESCE(e1, e2)`

performs the checks as NVL but NVL evaluates both expressions, while coalesce evaluates one expression at a time

```SQL
SELECT COALESCE(NULL, 0), COALESCE(34, 0), COALESCE(NULL, NULL) FROM DUAL;
```

### NULLIF - `NULLIF(e1, e2)`

takes two arguments, returns a null if arguments are equal, else, it returns the first argument

when both values passed are NULL, it raises an an exception.Useful when comparing rows, in case of updated values to see which rows have not been updated, generally for checking discrepancies between data sets

```sql
SELECT NULLIF(20, 44) from dual;
select nullif(NULL, NULL) FROM DUAL; -- raises inconsistent data types error
```
