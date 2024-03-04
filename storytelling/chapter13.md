# Extracting and Mining Information from Texts

although it might not be obvious that most texts comes from speeches, press releases and other forms,we can still use sql to extract meaning from textual data.

Another more important part of this is transformative functions for textual data in sql.
Text mining functions are very useful in assurance of extracting texts like products names, search engines functionality and also ranking scores.

## Text Formatting

Changing the case formatting of text is among very important parts of text analysis

Most useful functions include lower(column_name), upper(column_name or value) and initcap(column_name or value) functions

There are several implementations and functions for specific DBMS but not all DBMS support the ones mentioned

## CHARACTER INFORMATION

this comprises returning data about strings rather than transforming them. eg length of the string, number of characters, etc.

```sql
select * from employees
```

## Removing Characters

using string functions to remove characters and characters sequences from a string, we can simply clean up the strings and values

## Extracting Character and Replacing Characters

we can be required to replace a certain character and obtain a more useful information

left(string, number)<br>
right(string, number)

the above functions either returns specified substring of number with a [number] lenght of characters on either the right or left side of the string
eg

```sql
select left('703-555-1212', 3);
select right('703-555-1212', 8);
```

returns the country code from the first characters of the string, in case of American phone numbers.

in case of subtituting characters, use the replace function. For example to change bat to cat
use

```sql
-- select replace(string, from, to); eg
select replace('bat', 'b', 'c');
```

## Matching Text Patterns with Regular Expressions

Using regular expressions, we can match and compare texts and extract more useful informations.

Regular Expressions is a type of notational language that is used to describe text pattern.

in more learning with Regular Expressions, sites like regxr.com and regexpal.com have a more comprehensive set of regular expressions for trials and references.

### Regular Expressions Noations

Matching letters and numbers is straightforward, because letters and numbers are literals that represents the same characters eg Al matches the first letters in Alicia,

Regexs notation basics

- `.` Finds any characters excepts a newline
- `[FGz]` Any character in square brackets for here, FGZ
- `[a-zA-Z]` FInds all letters both lower and upper case from a to z, and A to Z
- `[a-z]` FInds all lowercase letters
- `[^a-z]` Negates the find, and matches non lowercase letters
- `\w` Any Word, character or underscore `[a-zA-Z0-9_]`
- `\d` Any number/digit character
- `\s` A Space
- `\t` A tab
- `\n` A newline
- `\r` A carriage return character
- `^` Match at the start of the string
- `$` Match at the end of the string
- `?` Get the preceding match zero or one time
- `*` Get the preceding match zero or more times
- `+` Get the preceding match one or more times
- `{m}` Get the preceding match exactly m times
- `{m,n}` Get the preceding match between m and n times
- `a|b` Get the pipe denote alteration, find either a or b
- `( )` create and report the capture group or set precedence
- `(?: )` Negate reporting of a capture group

And many many more functions

Actual simplified examples

- `\d{4}` Matches 4 digits in a row
- `\d{1,4}` Matches digits in series from 1 to 4
- `\a+` Matches any a from 1 to all a'z in a series eg matches aa in aardvark

A more practical example is matching the `HH:MM:SS` in text to obtain the hour, we would use
`\d{2}:\d{2}:\d{2}` and extract that iseful part

Also, `\d{2}` matches the first characters and extract the hour from our string of time

`May|Jun` either may or June will be matched here

`May \d, d{4}` will match a calendar like May 2, 2019

`\d{1,2} (?:a.m.|p.m.)` will match the time for 7 a.m. or 12 p.m.

In database, we can use regular expressions to match text by using the syntax `substring(string from pattern)`

```sql
SELECT substring('The game starts at 7 p.m. on May 2, 2019.' from '\d{4}');
-- this returns 2019 since it the part that matches the pattern
SELECT substring('The game starts at 7 p.m. on May 2, 2019.' from '(:? a.m.|p.m.)');
```

## Turning Text To Data with Regular Expressions

We use the reports database to pick text into data to extract useful information

Here we are using the sherrif's report function to extract information from pdf extracted reports and convert them to data.

A raw pdf report looks more like this:-

```txt
    4/16/17-4/17/17
    2100-0900 hrs.
    46000 Block Ashmere Sq.
    Sterling
    Larceny: The victim reported that a
    bicycle was stolen from their opened
    garage door during the overnight hours.
    C0170006614
    04/10/17
    1605 hrs.
    21800 block Newlin Mill Rd.
    Middleburg
    Larceny: A license plate was reported
    stolen from a vehicle.
    SO170006250
```

There are several information we can see as a date range or date for a report on an incident, hours or hours range too, name of the reporter, Location of the incident,
Case Number, date of report, hour or time of reporting and report description

In analyzing reports, or rich text data, inconsistencies are anavoidable
These reports might help you answer questions like where do crimes occurs more often, whic type of crimes occur frequently, at which time and with which trend, do they get affected by the changes in climate or financial parameters, and more stories like those might be told from your data

Creating a table for crime reports

```SQL
CREATE TABLE crime_reports(
    crime_id BIGSERIAL PRIMARY KEY,
    date_1 TIMESTAMP WITH TIME ZONE,
    date_2 TIMESTAMP WITH TIME ZONE,
    street VARCHAR(20),
    city VARCHAR(100),
    crime_type VARCHAR(100),
    description TEXT,
    case_number VARCHAR(50),
    original_text TEXT NOT NULL
);
-- IMPORT DATA
COPY crime_reports(original_text)
FROM 'C:\Users\julie\Desktop\Machuche\crime_reports.csv'
WITH (FORMAT CSV, HEADER OFF, QUOTE '"')
```

Using PL/SQL to import data with PostgreSQL
\COPY crime_reports(original_text) FROM 'C:\Users\julie\Desktop\Machuche\crime_reports.csv' WITH (FORMAT CSV, HEADER OFF, QUOTE '"')

```sql
SELECT * FROM crime_reports
select substring(original_text from '\d{4}') from crime_reports;

-- selecting case listing strings based on their formatting
select substring(original_text from '\d{8,10}') from crime_reports;

-- selecting the date strings
select substring(original_text from '\d{1,2}\/\d{1,2}\/\d{2}') from crime_reports;

-- in case of two dates, select the second date
select substring(original_text from '-\d{1,2}\/\d{1,2}\/\d{2}') from crime_reports;

-- selecting the hrs of crimes
select substring(original_text from '\d{4} [hrs]') from crime_reports;

-- selecting streets, city and description
-- this is the most difficult in this basic part but once completed,
-- we miht find something useful later

```

Here we matched values using the substring funtion but we are using regexp_match(string, pattern) which is verys similar to the substring function with a few exceptions

```sql
SELECT REGEXP_MATCH(original_text, '\d{8,10}') FROM crime_reports;

-- now we can convert all of our previous statements to using a regexp_match function

```
