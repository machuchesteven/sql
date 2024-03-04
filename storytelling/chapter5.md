# Database for Storytelling with data

---

`sql
create table product (
id serial primary key,
name varchar(20),
price numeric(20, 3),
quantity int
);`

`insert into product (name, price, quantity) values ('Mayonaise', 24000.0008, 200);`

`alter table product add column added date null default current_date;`

`select \* from product`

---

## Postgre operators for Math and statistical functions

- `+` addition operator
- `-` subtraction operator
- `*` multiplication operator
- `/` division operator
- `%` modulus operator
- `^` exponentiation operator
- `|/` square root operator
- `||/` cube root operator
- `!` factorial operator

## Usage Selection promps with statistics

## Hadndling exceptions with stored procedures in postgresql

Exceptions handling plays a vital role in managing the execution of the postgresql commands and other sqls
Here we want to make sure the database does not accept anything that might cause it to break or crash during command execution.
Handling exceptions in postgresql is done in the following way.
