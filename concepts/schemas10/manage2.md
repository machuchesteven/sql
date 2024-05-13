# Managing Sequences

A sequence is used for automatic number generation based on rules specified. Primarily used for generating PRIMARY KEY values, but there is nothing tied to that in a sequence
sequences can create sequencially increasing or decreasing numbers according to the rules specified

## Creating and Dropping sequences

general syntax - `CREATE SEQUENCE seq_name`
Note that nothing ties a sequence to a particular table or object

Once a sequence is created, it has to be initialized first before accessing some pseudocolumns,

```sql
select my_easy_seq.currval from dual; -- the sequence is not yet defined

select my_easy_seq.nextval from dual; -- sequence initialized and called

select my_easy_seq.currval from dual;
```

There is also a complex syntax for creating a sequence
`CREATE SEQUENCE sequence_name sequence_options`
a sequence can start at any number, and increment or decrement by any value, they can also be given a range to generate numbers, or generate without ceasing. Or they can be given a series of numbers to generate and after that cease generating numbers.
The following are some important sequence options:-

- `INCREMENT BY integer` - each new seq number requested will increase by this value, negative - seq is descending, default 1
- `START WITH integer` - first number if the seq, if not specified defaults to MINVALUE
- `MAXVALUE integer` - maximum number if the seq, if not specified defaults to NOMAXVALUE
- `NOMAXVALUE` - self explanatory, no max number
- `MINVALUE integer` - specifies the min number of the seq, if not specified defaults to 1
- `NOMINVALUE` - self explanatory, no min number of the seq, mostly for negative sequences
- `CYCLE` - When the seq generator reaches one end of the range, restart on the other end, for ascending `REACH MAXVALUE go to MINVALUE`
- `NOCYCLE` -

if cycle is specified, there is a cache value for the sequence, without cycle the default is `NOCACHE`. with cycle, the value might be a number of times less than or equal to the number of increments in one cycle, otherwise throws an error
hence

- `CACHE integer` - as explained, Without specifying it, goes to default
- `NOCACHE`

### Using a sequence

A sequence contains the following pseudocolumns:-

- `NEXTVAL` - when called, advances the sequence to the next available number, Returns that number. Must be called after sequence generation to allow for value to be available
- `CURRVAL` - Display the current number that the sequence is holding, it is only valid in a session from which nextval have already been invoked, you can't use CURRVAL in an initial call to any sequence generator within a session.

You may use a sequence as a primary key for the sequence,

```sql

create sequence seq_cruise_customer_id;

create table cruise_customer(
    id number primary key,
    customer varchar2(30));

insert into cruise_customer values ( seq_cruise_customer_id.nextval, 'Combinenga');
insert into cruise_customer values ( seq_cruise_customer_id.nextval, 'Man Water');
insert into cruise_customer values ( seq_cruise_customer_id.nextval, 'Catrimah Richie');

desc cruise_customer;

select * from cruise_customer;

select seq_cruise_customer_id.currval from dual;
```

### Points to Keep in Mind about Sequences

- You can't invoke CURRVAL in your first ref to a sequence within a session, NEXTVAL must be the first ref
- Whenever you attempt to execute a statement as an INSERT that include a sequence reference NEXTVAL, the sequence generator will advance even if the insert fails
- CURRVAL and NEXTVAL cannot be invoked in a default clause of CREATE TABLE or ALTER TABLE statements
- you can not invoke CURRVAL or NEXTVAL in a subquery of a CREATE VIEW statement, or of a SELECT, UPDATE or DELETE statement
- in a select statement, you can't combine CURRVAL or NEXTVAL with a DISTINCT operator
- you can not invoke CURRVAL or NEXTVAL in a WHERE clause
- you can not combine CURRVAL or NEXTVAL with SET operators UNION, INTERSECT and MINUS
- you can can call a sequence pseudocolumn from anywhere within a SQL statement that you can use any expression. `Any reference to a sequence must include its pseudocolumns`
- no NEXTVAL or CURRVAL in CHECK constraints

Sometimes you can call a sequence pseudocolumn, in a manner that do not make sense, but syntactically correct, SQL won't stop you since its your business rules

Rollback does not reverse the value of the sequence generator, hence before and after ROLLBACK statement, CURRVAL will be the same

`NOTE`: If you call a sequence generator from an invalid position based on the rules above, the statement will fail and the generator will not issue any advancement due to syntax errors

Other correct call in syntax, will advance the sequence generator

## ALTER SEQUENCE

you can use the ALTER SEQUENCE statement to change the increment, minimum and maximum values, cached numbers and behaviour of an existing sequence

the following options can follow the `ALTER SEQUENCE sequence_name`:-

- `INCREMENT BY integer`
- `MAXVALUE integer | NOMAXVALUE`
- `MINVALUE integer | NOMINVALUE`
- `CYCLE | NOCYCLE`
- `CACHE | NOCACHE`
- `ORDER | NOORDER`
- `KEEP | NOKEEP`
- `SESSION | GLOBAL`
