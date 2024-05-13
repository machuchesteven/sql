-- starting with case formatting

select 
lower('hello'),
lower('hey%%7773'),
lower('HELLO234');

select
upper('hello'),
upper('HELLO234'),
upper('joe %6364jmsmd');

select initcap('This is a speech message from Sr. JF Kennedy');
-- here even JF kennedy is converted into Capital case

-- CHARACTER INFORMATION
-- most functions returns data about strings
-- eg length(string),

select length('Heloon'); -- returns number of characters, in this case 6
select char_length('Heloon'); -- returns number of characters including spaces
select length('  hello  '), char_length('  hello  ');

-- when used with special characters, these functions especially length might returns different results


-- another functions is position(substring in string)

select position(' , ' in ' ) , char_') -- returns 3 meaning the first paramters starts at index 3
-- char_length and position are ANSI standards

trim(characters from string)
-- removes unwanted charcters from a string
-- characters to be removed are supplied within the characters part before the from clause

select trim(',' from 'Hello Mr, I have came to appologise')
select trim('s' from 'socks')
-- this only removes the charcaters and barely works well with spaces

-- leading and trailing options for end and start options for
-- characters

select trim(leading 'd' from 'my city of dodoma')

select trim(leading 's' from 'socks');
select trim(trailing 's' from 'socks');

-- if you dont specify charcters to trim, trim removes all the
-- whitespaces from the string
-- eg

select length(trim(' hello '))

-- postgre specific trimming functions

rtrim(string, characters) 
ltrim(string, charcaters)

-- eg
select ltrim('socks', 's');
select rtrim('socks', 's');

-- EXTRACTING AND REPLACING CHARACTERS


select substring(original_text from  '\d{1,2}\/\d{1,2}\/\d{2}' ) from crime_reports;

SELECT REGEXP_MATCH(original_text, '.{2}\d{8,10}.+') FROM crime_reports;

SELECT substring(original_text from '.{2}\d{8,10}.+') FROM crime_reports;


SELECT REGEXP_MATCH(original_text, '\d{1,2}\/\d{1,2}\/\d{2}') FROM crime_reports;

select '\/\'

