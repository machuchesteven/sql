# Ampersand Substitutions

These substitutions are used to Restrict and Sort output at runtime. It is a SQL\* Plus feature, included in the exam.

The aim is to provide a SQL script with support for runtime parameters feature when used within a SQL\* Plus Session.
The value of the parameter can be set via batch before or interactively during the script execution. This empowers an individual script to execute in various ways.

There are some configurations to do in order to deal with the ampersand substitution, and we get into that now.

## &

The ampersand will be used with the `&variable_name` so as to intake the variable at execution time. This variable will be asked and substituted to the place where the variable is placed in the query.

```sql
select * from good_projs where days = &dayz;
```

in the above example, the days will be asked., Let say ampersand for a table that does not exist, **It will ask for the value before executing the query**

The ampersand substitution variable consists of the following:-

- Substitution variable prefix( an ampersand)
- Substitution variable name (consists of any alphanumeric characters until the next blank or end of line character)

For text values the variable can be specified within single quotes in sql statements, or you can omit the quotes in the statement and provide them in runtime

```sql
SELECT * FROM GOOD_PROJS WHERE COMPANY_NAME LIKE '&COMPANY';
SELECT * FROM GOOD_PROJS WHERE COMPANY_NAME LIKE &COMPANY; -- ommitted quotes
```

You can replace virtually any section of SQL codes with a substitution variable.

```sql
select &cols_list from GOOD_PROJS;
```

SO far we have provided the value at runtime. But we can predefine it using the DEFINE command.

## DEFINE and UNDEFINE Commands

We define the variable on its own using the DEFINE statement so that when SQL code with a substitution variable is executed, the value you have already defined will be used.

Once you have defined the variable, You can use the `DEFINE` on its own to list all variables for the session.
Define is a SQL\* Plus Command. hence the semicolon is optional

```sql
DEFINE myDays = 8;
DEFINE;
UNDEFINE myDays;
```

The defined varibale will persist throughout the session, or until it is UNDEFINED

## SET and SHOW Commands

The ampersand substitution is a SQL\* Plus Command, and its operation is controlled by the settings of some of the SQL\* Plus system variables that can be configured using the `SET` command.

Current configurations can be displayed using the `SHOW` command,

show can be used with SQL\* Plus System Variables, and SHOW ALL can be used to display all configuration variables

```sql
SHOW DEFINE;
SHOW VERIFY;
SHOW ALL;
```

### VERIFY system variable

This is used when turned on to indicate for `new` and `old` lines of code. this shows the old before substitution and the new after substitution. can be set using the following statement:-

```sql
SET VERIFY ON;
SET VERIFY OFF;
```

### ACCEPT and PROMPT

These two are useful when working with substitution variables,

ACCEPT receives data from a User and stores it in a predefined variable. Provides the Input requester with PROMPT providing the information while asking.

PROMPT displays an interactive messgae to an end user. =

These two are used in interactive scripts where SQL\* Plus substitution variables are used;

```sql
PROMPT welcome to our script
PROMPT Using the information you provide, we will help you get deeper
ACCEPT vRoomNumber PROMPT "enter number: "
define;
select * from good_projs where days < &vRoomNumber;
prompt Remember you asked for the room number &vRoomNumber.; -- the period(.) after the variable will not display
```

Once a value is accepted, it can be used with substitution operator (&amp;)

`NOTE:`

- PROMPT does not require quotes when invoked as a stand-alone, but requires them when used with `ACCEPT`
- The period after our varibale could have displayed if it was separated by a space before the variable and after the variable, any additional text after the variable will display, provided it is separated by a space from the defined variable

You can create a script in that way and save it in a file ending with .SQL suffix, then calls the file using the syntax `@[folder_location]filename` or `@[folder_location]filename.sql`

### DEFINE system variable

Must be set to ON to use substitution variables, the default setting for DEFINE is ON for a given session, but you can ensure it is on before using substitution variables by issuing the following command: `SET DEFINE ON;`

This is important for batch scripts and you are not sure at the time of script execution what is DEFINE set to, it might be off.

to set the variable to OFF, `SET DEFINE OFF`

In the exam, substitution variables are reffered to as `AMPERSAND SUBSTITUTION VARIABLES`, but the variable can be changed from ampersand to another letter by issuing the `SET DEFINE <character>` command, eg `SET DEFINE *`
would let us use star instead of & for substitution variables

Here are some more variables to be set and their uses

- `ECHO`:- echos back our SQL script with the output so we see the effect of our script clearly `SET ECHO ON` and `SET ECHO OFF`. Is useful when executing a series of statements in batch

When you change the value for the substitution variable operator using `SET DEFINE`, the one with the old operator wont work at all

```sql
SET DEFINE *;
select * from good_projs where *col_name < 4;

select *d from good_projs where *col_name < 4 or days > &days; -- this throws an error
```

NOTE: the DEFINE command is limited to one character only, and if DEFINE is set to OFF, and you change the prefix, it will automatically set DEFINE to ON.
