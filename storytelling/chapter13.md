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
select substring(original_text from '.{0,1}\d{1,2}\/\d{1,2}\/\d{2}') from crime_reports;

-- selecting the hrs of crimes
select substring(original_text from '\d{4} [hrs]') from crime_reports;

-- selecting streets, city and description
-- this is the most difficult in this basic part but once completed,
-- we miht find something useful later

```

Here we matched values using the substring funtion but we are using regexp_match(string, pattern) which is verys similar to the substring function with a few exceptions

```sql
SELECT SUBSTRING(original_text from '\d{4} [h].+') from crime_reports;

SELECT REGEXP_MATCH(original_text, '.{2}\d{8,10}.+') FROM crime_reports;

SELECT REGEXP_MATCH(original_text, '.+\d{8,10}.+') FROM crime_reports;

SELECT REGEXP_MATCH(original_text, '.{0,2}\d{8,10}.+') FROM crime_reports; -- gives all the crime ids from the original texT it only comes as An Array of Text

-- now we can convert all of our previous statements to using a regexp_match function
SELECT REGEXP_MATCH(original_text, '(.{0,2}\d{8,10}.+)') AS case_number FROM crime_reports;

-- SELECTING THE FIRST AND THE SECOND HOURS
SELECT REGEXP_MATCH(original_text, '\d{4}-{0,1}\d{0,4}.{4}') FROM crime_reports;

-- select only the first hour
SELECT REGEXP_MATCH(original_text, '\d{4}') AS case_time FROM crime_reports
```

Starting with the first date from regexp_match

```sql
-- this matches both patterns of dates including dd/MM/YYYY and dd-mm-yyyy
SELECT crime_id, regexp_match(original_text, '\d{1,2}.{0,1}\d{1,2}.{0,1}\d{2}')from crime_reports;

-- Using the 'g' flag with REGEXP_MATCH function returns all the matches instead of the original just first match
-- case insensitive flag
SELECT crime_id, regexp_match(original_text, '\d{1,2}.{0,1}\d{1,2}.{0,1}\d{2}', 'i')from crime_reports;

-- using the global flag, using the
SELECT crime_id, regexp_matches(original_text, '\d{1,2}\/\d{1,2}\/\d{2}', 'g')from crime_reports;

-- selecting the second match
SELECT crime_id, regexp_match(original_text, '[-]\d{1,2}\/\d{1,2}\/\d{2}')from crime_reports;

-- USE THE \/\ to imply '/'; the preceding \/\ are the escape characters in regular expressions

select regexp_match('Here we@mail', '.{0,2}\@.{0,2}');

-- extracting individual rows into strings using the UNNEST function

SELECT crime_id, UNNEST(regexp_match(original_text, '\d{1,2}.{0,1}\d{1,2}.{0,1}\d{2}')) from crime_reports;

-- updating the dates based on the match of the regular expression


update crime_reports set
date_1 = ()


-- SELECTING THE FIRST HOUR FROM THE ORIGINAL TEXT
-- this matches the pattern
SELECT REGEXP_MATCH(original_text, '\d{2}\n\d{4}') from crime_reports;

-- this extracts the data
SELECT REGEXP_MATCH(original_text, '\d{2}\n(\d{4})') from crime_reports;

-- the values with only the specified match can be extracted using brackets operator '(pattern)' will reurn the values matching the pattern

-- matching the second hour
SELECT REGEXP_MATCH(original_text, '\/\d{2}\n\d{4}-(\d{4})') FROM crime_reports;


-- SELECTING THE STREET VALUES
-- the street follows the following pattern
hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))
-- meaning the stret follows the hrs. and the newline, and the patterns for block, Plaza, Square,Dr Ter or Rd. respectively
-- in the above query we are extracting the value of the street resprectively

SELECT REGEXP_MATCH(original_text, 'hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))') from crime_reports;
-- ?: negates the effect of parentheses acting as a capture group

-- assuming the street extends in two lines
SELECT REGEXP_MATCH(original_text, 'hrs.\n(.+).\n') from crime_reports;

-- this doesn't match the pattern as expected
SELECT REGEXP_MATCH(original_text, 'hrs.\n(.+ (?:.\n))') from crime_reports;
SELECT REGEXP_MATCH(original_text, 'hrs.\n(.+ .\n)') from crime_reports;

-- the above pattern too, does not match the pattern



-- SELECTING THE CITY
-- pattern, (?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(|w+ w+ | w+)\n
-- this is because the city follows the street suffix,

SELECT REGEXP_MATCH(original_text, '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n') FROM crime_reports;


-- SELECTING CRIME_TYPE
-- the crime type in our dataset always precedes a colon ':'
-- and might consist one or more words
-- appears after the city

-- PATTERN \n(?:\w+ \w+|\w+)\n(.*):
-- the * gets the preceding match zero or more times
SELECT REGEXP_MATCH(original_text, '\n(?:\w+ \w+|\w+)\n(.*):') FROM crime_reports;

-- CRIME DESCRIPTION
-- crime description follows after the crime type and goes just before the case number

SELECT REGEXP_MATCH(original_text, ':(.*)') FROM crime_reports;

-- SELECTING THE CASE NUMBER
-- case number just falls after the crime description hence, being able to extract the case number makes it easy to extract the description without the case number

SELECT REGEXP_MATCH(original_text, '[A-Z]{1,2}\d{8,11}') FROM crime_reports;


-- NOW remove the case number
SELECT REGEXP_MATCH(original_text, ':(.*)(?:[S]{0,1}[A-Z]{1,2}\d{8,11})') FROM crime_reports;

-- MAKE IT BETWEEN THE DESC AND THE (?:C0|SO)
SELECT REGEXP_MATCH(original_text, ':(.*)(?:C0|SO)') FROM crime_reports;

-- remember the table data types
SELECT * FROM crime_reports;

SELECT REGEXP_MATCH(original_text, '(?:C0|SO)\d{8,10}') FROM crime_reports;
```

This is just a sample dataset, in a large and different dataset you will have to extract data in a different way based on diff prefix and suffix.

### Combining All the Logics into a Single Logic

selecting the CaseId, date_1, date_2, hour, and other

```sql
SELECT
    regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}') AS date_1,
    regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{2})') AS date_2,
    REGEXP_MATCH(original_text, '\n(?:\w+ \w+|\w+)\n(.*):') AS crime_type,
    REGEXP_MATCH(original_text, 'hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))') AS stret,
    REGEXP_MATCH(original_text, '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n') AS city,
    REGEXP_MATCH(original_text, ':(.*)(?:C0|SO)') AS case_description,
    REGEXP_MATCH(original_text, '(?:C0|SO)\d{8,10}') AS case_number
    FROM crime_reports;


SELECT
    regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}') AS date_1,
    regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{2})') AS date_2,
    REGEXP_MATCH(original_text, '\/\d{2}\n(\d{4})') AS first_hour,
    REGEXP_MATCH(original_text, '\/\d{2}\n\d{4}-(\d{4})') AS second_hour,
    REGEXP_MATCH(original_text, '\n(?:\w+ \w+|\w+)\n(.*):') AS crime_type,
    REGEXP_MATCH(original_text, 'hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))') AS stret,
    REGEXP_MATCH(original_text, '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n') AS city,
    REGEXP_MATCH(original_text, ':(.*)(?:C0|SO)') AS case_description,
    REGEXP_MATCH(original_text, '(?:C0|SO)\d{8,10}') AS case_number
    FROM crime_reports;

```

## Extracting the Result of the REGEXP_MATCH to a text and date values

the header above comes as the text[] instead of text meaning it is an array
We want to use the extracted values to extract the column which are not array types. Hence we should extract the text part from returned value arrays.

This can be done using the array notation as shown below:

```sql
-- in postgresql, the index 1 works like index 0, in other databases
SELECT crime_id,
        (REGEXP_MATCH(original_text, '(?:C0|SO)[0-9]+'))[1]
        AS case_number
    FROM crime_reports;

```

## Updating the Crime Table with Extracted Data

we do this using a scalar subquery that works with the values from the same column as the original one to be update.

```sql
-- updating the first date using date and time with the pipe operator

UPDATE crime_reports
SET
    date_1 =
        (
            (REGEXP_MATCH(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]
            || ' ' ||
            (REGEXP_MATCH(original_text, '\/\d{2}\n(\d{4})'))[1]
            || ' US/Eastern'
        )::timestamptz;

UPDATE crime_reports
SET
    date_1 =
        (TO_TIMESTAMP((
            (REGEXP_MATCH(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]
            || ' ' ||
            (REGEXP_MATCH(original_text, '\/\d{2}\n(\d{4})'))[1]
        ), 'MM/DD/YY HH24MI') AT TIME ZONE 'US/Eastern')

SELECT crime_id, date_1 FROM crime_reports;

-- special case in date_2, in case of the second hour but not the second date,
-- case second date and secod hour
-- also, case neither second date nor secod hour exists


-- accidentally, the street is limited to only 20 characters

ALTER TABLE crime_reports ALTER COLUMN street TYPE VARCHAR(100)

UPDATE crime_reports
SET
    date_1 =
        (TO_TIMESTAMP((
            (REGEXP_MATCH(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]
            || ' ' ||
            (REGEXP_MATCH(original_text, '\/\d{2}\n(\d{4})'))[1]
        ), 'MM/DD/YY HH24MI') AT TIME ZONE 'US/Eastern'),
    date_2 =
        CASE
            WHEN (regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{2})') IS NULL) AND
            (regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})') IS NOT NULL)
            THEN (TO_TIMESTAMP
            (
                (
                    (regexp_match(original_text, '(\d{1,2}\/\d{1,2}\/\d{2})'))[1]
                    || ' ' ||
                    (regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})'))[1]
            ), 'MM/DD/YY HH24MI') AT TIME ZONE 'US/Eastern')
            WHEN (regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{2})') IS NOT NULL) AND (regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})') IS NOT NULL)
            THEN (TO_TIMESTAMP
            (
                (
                    (regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{2})'))[1]
                    || ' ' ||
                    (regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})'))[1]
            ), 'MM/DD/YY HH24MI') AT TIME ZONE 'US/Eastern')
            ELSE NULL
        END,
    street = (
        REGEXP_MATCH(original_text, 'hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))')
    )[1],
    crime_type = (
        REGEXP_MATCH(original_text, '\n(?:\w+ \w+|\w+)\n(.*):')
    )[1],
    description = (
        REGEXP_MATCH(original_text, ':(.*)(?:C0|SO)')
    )[1],
    case_number = (
        REGEXP_MATCH(original_text, '(?:C0|SO)\d{8,10}')
    )[1],
    city = (
        REGEXP_MATCH(original_text, '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n')
    )[1]

SELECT * FROM crime_reports;


```

## Using Regular Expression with WHERE

more that using LIKE and ILIKE functions, there are more functions to be learnt with some several activities
and handling more complex matches

the following are some of the functions and symbols used for making comparisons

- `~` tilde - to make a case-sensitive match on a regular expression
- `~*` tilde-asterisk - case insensitive match
- `!` negate any expression as `!~\*' indicates not to match a regex that is case insensitive

example of the pattern matching in where are as below:

```sql
-- selecting using case insensitive matching

select geo_name from us_counties_2010
where geo_name ~* '(.+lade.+|.+lare.+)'
order by geo_name;


-- now negate the select expression
select geo_name from us_counties_2010
where geo_name !~* '(.+lade.+|.+lare.+)'
order by geo_name;

-- remove a certain pattern in the match

select geo_name from us_counties_2010
where geo_name !~* '(.+lade.+|.+lare.+)' and geo_name !~* '.+County'
order by geo_name;

```

above are just examples but we can do more than what is possible to be performed by normal wildcard operators in `LIKE` and `ILIKE` expressions

## Additional Regex Functions

the following functions are useful when working with regular expresions

```sql
SELECT regexp_replace('05/12/2018', '\d{4}', '2017');
-- regexp_replace(string, pattern, replacement text)

SELECT regexp_split_to_table('Four,Score,and,seven,years,ago', ',');
-- regexp_split_to_table(string, pattern)
-- splits delimited texts into rows

SELECT regexp_split_to_array('Phil Mike Steve', ' ');
SELECT regexp_split_to_array('Phil, Mike, Steve', ' ');
-- this shows you split the delimited texts into an array and you can use the array functions and other to work with arrays
-- eg counting the number of items in an array
select array_length(regexp_split_to_array('Phil, Mike, Steve', ','),1);

-- more array functions https://www.postgresql.org/docs/current/static/functions-array.html

```

## Full Text Search in PostgreSQL

Similar to function and functionalities in Searcg engines and more, Postgresql offers a search engine with multiple capabilities

in this dataset we deal with 35 presidential speeches for learning and using the search engine feature.
These are speeches from the archives.org database

Here we will use the SOTU file consisting of these speeches and several search engine functions

### Text Search Data Types

PostgreSQL implementation of text search data types includes two data types
as follows:-

- `tsvector` data types - that represents text to be searched and stored in an optimized form
- `tsquery` data types - that represents search query terms and operators

### Storing texts as Lexemes with tsvector

`tsvector` reduces texts to a sorted list of `Lexemes` which are units of meanings in a language.
the best way of representing Lexemes is as a words not created with variations by Suffixes.
eg washing, washes, washed and washing aas lexeme wash while noting each word's position in the original text.

Converting texts to tsvector also removes stop words that don't play a role in searching.

Let's look at tsvector in action

```sql
-- using the crime reports description

SELECT to_tsvector(description) from crime_reports;

SELECT to_tsvector('I am walking across the sitting room to sit with you.');

```

the ts_vector function reduces the number of words from 11 to 4, eliminating some words like I am, etc
and also maps the number of words which appeared more than once.

### Creating search terms with TSQuery

the tsquery data type represents the full text search query, again optimized as lexemes.
It also provides operators for controlling the search. Examples of operators include
ampersand (&) for AND, and pipe symbol for OR (|) and exclamation mark for NOT (!)

A special symbol <-> lets you search for adjacent words or words in a specified distance apart.

Consider an example below:-

```sql

SELECT to_tsquery('Walking & Sitting');
-- converts the string into lexemes walk and sit

```

the above example gives you the terms that can be used as tsquery to seacrh text optimized as tsvector

### Using the @@ Match operator for searching

Once text and search terms are converted into full text seach data types, you can use the double at sign (@@) match operator to check whether query matches a text

consider the following examples

```sql
select to_tsvector('I am walking across the sitting room') @@ to_tsquery('Walking & Sitting');
-- i used  and instead of & and it broke
SELECT to_tsvector('I am walking across the sitting room') @@ to_tsquery('Walking & running');
-- this returns a false since the run statement is not in the text to be searched
SELECT to_tsvector('I am walking across the sitting room') @@ to_tsquery('Walking | running');
-- returns true since walk is in the text to be searched

```

## Building a table for speech searching

Here we are building our speeches database and work against it to perform the basic search functionality of a text search search engine.

```sql

CREATE TABLE president_speeches (
    sotu_id SERIAL PRIMARY KEY,
    president VARCHAR(100) NOT NULL,
    title VARCHAR(255) NOT NULL,
    speech_date DATE NOT NULL,
    speech_text TEXT NOT NULL,
    search_speech_text TSVECTOR
);

COPY president_speeches (president, title, speech_date, speech_text)
FROM 'C:\Users\julie\Desktop\Machuche\sotu-1946-1977.csv'
WITH (FORMAT CSV, DELIMITER '|', HEADER OFF, QUOTE '@')

-- FOR PLSQL

\COPY president_speeches (president, title, speech_date, speech_text) FROM 'C:\Users\julie\Desktop\Machuche\sotu-1946-1977.csv' WITH (FORMAT CSV, DELIMITER '|', HEADER OFF, QUOTE '@');

SELECT * FROM president_speeches;

SELECT char_length(speech_text) FROM president_speeches;
-- this shows the masive lenght of the speeches


SELECT length(speech_text) FROM president_speeches;
```

now we have a sizeable amount of speech text in our table, a massive
To update the search speech text, we create a tsvector value for them in the column from the speech text

```sql

UPDATE president_speeches SET
search_speech_text = to_tsvector('english', speech_text);
-- the first option specifies the language for parsing lexemes into
-- as indicated, it took a long time to run
-- you can use Germany, Spanish or any other language
-- be careful since some languages require that you install their dictionaries

select search_speech_text from president_speeches;
-- there we see the lexemes created for the search column

```

### Creating the INDEX on the search column to speed up the searches

The search column need to have an index, first we were using common Binary tree index but here we are using a special index called a Generalized Inverted Index
we can add a GIN index using a special syntax by substracting the create index with additional specification on the index type

example of creating a different index

```sql
CREATE INDEX index_name ON table_name using gin (column name);

CREATE INDEX speeches_search_index ON president_speeches using gin(search_speech_text);

```

`GIN` creates a index that contains an entry for all lexeme and its location allowing the database to find matches more quickly.

another way of creating an index for search is using the to_tsvector function as in [this example](https://www.postgresql.org/docs/current/textsearch-tables.html)

once the index is set. Now you are ready to use the search function

### Searching Speech Text

Lets start with the speech where the word Vietnam was mentioned

```sql

SELECT president, speech_date
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('Vietnam')
ORDER BY speech_date;

```

As seen above, we use the double colon operator to match a tsvector with a text that is transformed into a tsquery using the to_tsquery function

Before adding more search terms, lets add a method for showing the location of our search term in the text

### showing search term location

here we use the `ts_headline()` to see where our search term appears in the text
This display one or more highlighted search term surrounded by djancent words.
Options offered by the function gives the flexibility to format the display.

consider the following example:-

```sql
SELECT
    president,
    speech_date,
    ts_headline(
        speech_text,
        to_tsquery('Vietnam'),
        'StartSel = < ,
        StopSel = >,
        MinWords=5,
        MaxWords=7,
        MaxFragments=1'
    )
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('Vietnam');
```

the ts_headline function above comprises of a lot of options but we start by passing the

- StartSel and StopSel arguments - StartCharacter and EndCharacter to highlight the word with
- MinWords and MaxWords - minimum number of words to display
- MaxFragments - maximun number of matching fragments to show

the syntax for the ts_headline function is as follows:

```sql

ts_headline(column, matching_function, 'options')

```

### Using Multiple Search Terms

in another example we look for speeches where the president mentioned transportation but never mentioned roads

using multiple search terms might be useful for example in discussing broader policies than specific programs as above

```sql
SELECT
    president,
    speech_date,
    ts_headline(
        speech_text,
        to_tsquery('transportation & !roads'),
        'StartSel = <,
        StopSel = >,
        MinWords=4,
        MaxWords=10,
        MaxFragments=1'
    )
    from president_speeches
    where search_speech_text @@ to_tsquery('transportation & !roads');
```

### Searching for Adjacent words

We use `<->` to search for adjacent words or we can specify the exact number of words to between them.

forexample

```sql
select
    president,
    speech_date,
    ts_headline(
        speech_text,
        to_tsquery('military <-> defense'),
        'StartSel = <,
        StopSel = >,
        MinWords=5,
        MaxWords=8,
        MaxFragments=1' )
    from president_speeches
    where search_speech_text @@ to_tsquery('military <-> defense');

-- with a specified number of words between these words

select
    president,
    speech_date,
    ts_headline(
        speech_text,
        to_tsquery('military <1> defense'),
        'StartSel = <,
        StopSel = >,
        MinWords=5,
        MaxWords=8,
        MaxFragments=1' )
    from president_speeches
    where search_speech_text @@ to_tsquery('military <1> defense');

-- <-> and <1> plays the same role as they are just one word apart.

```

### Ranking Query matches by Relevance

In search engines and other systems, we are used to seeing the data which matches the search query on top the most of time,
This might be difficult to think about.
In PostgreSQL, we use the ts_rank() and ts_rank_cd() functions for matching the results depending on relevance.

The ts_rank() function does not perform equally on both datasets,
and a values of ts_rank() might be the same in different dataset but holds different meaning which are non-comparable.
the ts_rank() returns the rank value based on how the relexemes appear in the search query.

```sql

select
    president,
    speech_date,
    ts_headline(
        speech_text,
        to_tsquery('military <1> defense'),
        'StartSel = <,
        StopSel = >,
        MinWords=5,
        MaxWords=8,
        MaxFragments=1' ),
        speech_text,
        ts_rank(search_speech_text,
        to_tsquery('military <1> defense')) as score
    from president_speeches
    where search_speech_text @@ to_tsquery('military <1> defense')
    order by score desc;

```

the first speech shows the most relevant match, but it is also the longest of all.
When we use the rank_value differently, we can see the deviation of the value.

```sql

select
    president,
    speech_date,
    ts_headline(
        speech_text,
        to_tsquery('military <1> defense'),
        'StartSel = <,
        StopSel = >,
        MinWords=5,
        MaxWords=8,
        MaxFragments=1' ),
        speech_text,
        ts_rank(search_speech_text,
        to_tsquery('military <1> defense'))::numeric / char_length(speech_text) as score
    from president_speeches
    where search_speech_text @@ to_tsquery('military <1> defense')
    order by score desc;

-- using optional code

select
    president,
    speech_date,
    ts_headline(
        speech_text,
        to_tsquery('military <1> defense'),
        'StartSel = <,
        StopSel = >,
        MinWords=5,
        MaxWords=8,
        MaxFragments=1' ),
        speech_text,
        ts_rank(search_speech_text,
        to_tsquery('military <1> defense'), 2)::numeric as score
    from president_speeches
    where search_speech_text @@ to_tsquery('military <1> defense')
    order by score desc;

-- using the 2 flag instructs PostgreSQL to divide by the length of values

```

What we have done above is refered to as normalizing the score, which includes dividing by the length of the values.

There are several options available including using individual words while ignoring repeated words and so forth.
