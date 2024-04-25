# Controlling User Access

A system privilege is the right to perform a task in the database, using a DDL, DCL or DML statement on objects in general
this explores the subject of user access and privileges associated with performing actions in the db.
every action performed by any user account, requires a special privilege or set of privileges to perform that action.
categories of privilege:-

- `System Privileges` - are required to perform a task in the database
- `Obejct privileges` - are required to use those system privileges on any given database object

privileges may be granted to a user account, or to another database object called a role.
a role can be granted to a user account
once granted, privileges and roles can later be revoked.

## DIFFERENTIATE SYSTSEM privileges from OBJECT privileges

before any user account execute any statement, it must be granted the privilege to execute that SQL statement
i.e once any db object has been created, any user that would use that object must be granted the privilege to do so.

General categories of privileges are as described below:-

| Type              | Description                                                                               |
| ----------------- | ----------------------------------------------------------------------------------------- |
| System Privileges | enable to perform a practical task on the database                                        |
| Object Privilege  | enable to perform a particular task on a particular database object                       |
| Role              | a collection of one or more system privileges and/or object privileges and/or other roles |

### system Privileges

ar ethe right to perform a task on the db, eg to log in to the db, a user account is granted a system privilege CREATE SESSION
to create a table, a user account is granted a system privilege CREATE TABLE

there are more than 100 system privs but the following are the most common ones

| System privilege           | Description                                                                                                                                       |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| CREATE SESSION             | connect to the database                                                                                                                           |
| CREATE TABLE               | Create a table in your user account, include the ability to use ALTER and DROP TABLE, Also the ability to CREATE, ALTER and DROP INDEX on objects |
| CREATE VIEW                | Create a view in your user account, include ALTER and DROP                                                                                        |
| CREATE SEQUENCE            | Create a sequence in your user account, ALTER and DROP                                                                                            |
| CREATE SYNONYM             | Create a synonym in your user account, ALTER and DROP (does not include public synonyms, see CREATE PUBLIC SYNONYM)                               |
| CREATE ROLE                | Create a role, include ALTER and DROP                                                                                                             |
| CREATE PUBLIC SYNONYM      | Create a synonym in a public account, does not include DROP                                                                                       |
| DROP PUBLIC SYNONYM        | Drop a synonym from the PUBLIC ACCOUNT                                                                                                            |
| CREATE ANY TABLE           | create a table within any user account                                                                                                            |
| ALTER ANY TABLE            | alter a table within any user account                                                                                                             |
| DELETE ANY TABLE           | delete from any table within any user account                                                                                                     |
| DROP ANY TABLE             | drop or TRUNCATE any table within any user account                                                                                                |
| INSERT ANY TABLE           | insert into any table within any user account                                                                                                     |
| SELECT ANY TABLE           | select from any table within any user account                                                                                                     |
| UPDATE ANY TABLE           | update any table within any user account                                                                                                          |
| CREATE ANY VIEW            | create a view in any user account                                                                                                                 |
| DROP ANY VIEW              | drop a view from any user account                                                                                                                 |
| CREATE ANY INDEX           | create an index in any user account                                                                                                               |
| ALTER ANY INDEX            | alter an index in any user account                                                                                                                |
| DROP ANY INDEX             | drop an index from any user account                                                                                                               |
| CREATE ANY SEQUENCE        | create a sequence in any user account                                                                                                             |
| ALTER ANY SEQUENCE         | alter a sequence in any user account                                                                                                              |
| DROP ANY SEQUENCE          | drop a sequence from any user account                                                                                                             |
| SELECT ANY SEQUENCE        | Select from a sequence in any user account                                                                                                        |
| CREATE ANY SYNONYM         | Create a synonym in any user account                                                                                                              |
| DROP ANY SYNONYM           | drop a synonym from any use account                                                                                                               |
| CREATE ANY DIRECTORY       | create a directory in any user account                                                                                                            |
| DROP ANY DIRECTORY         | drop a directory from any user account                                                                                                            |
| ALTER ANY ROLE             | alter a role in the database                                                                                                                      |
| DROP ANY ROLE              | drop any role in the database                                                                                                                     |
| GRANT ANY ROLE             | grant any role in the database                                                                                                                    |
| FALSHBACK ANY TABLE        | perform fashback operations in any table in the database                                                                                          |
| CREATE USER                | create a user account                                                                                                                             |
| ALTER USER                 | alter a user account                                                                                                                              |
| DROP USER                  | drop a user account                                                                                                                               |
| GRANT ANY PRIVILEGE        | grant any privilege to any user account in the database                                                                                           |
| GRANT ANY OBJECT PRIVILEGE | grant to any other user account in the database, any object privilege that the object owner is also able to grant                                 |

system privileges are different from object privileges, since system privileges are the ones required to create those objects, once object are created, object privileges can be granted to other user accounts in the database
OBJECT PRIVILEGE -> the right to do anything to a particular object

starting with the practice, we can use the command `SHOW USER` to display the current account USER we logged in to
though some of the commands here are not on the exam

### CREATE, ALTER and DROP USER

any user account with a CREATE USER system privilege can may execute the CREATE USER statement, the syntax is as below:-

```sql
CREATE USER username IDENTIFIED BY password;
CREATE USER JOAN IDENTIFIED BY JOAN; -- example of the syntax
ALTER USER JOAN IDENTIFIED BY NEW_PASSWORD;
DROP USER JOAN;
DROP USER JOAN CASCADE; -- if the user account owns any object, the syntax above won't work but this will
```

username is specified according to naming rules and tablespace object names
the syntax above also shows the syntax for changing password, and also dropping user
the CASCADE option drops a user account and all the objects it owns

`NOTE`: sometimes the create statement might fail, and `ALTER SESSION SET "\_oracle_script"=True`
this will remove restrictions on oracle database

#### CONNECT

this is a SQL\* Plus statement used for connecting with the database with a user account
when you are in a user account say SYS, you can use the sntax to connect to the database
with another use as `CONNECT USERNAME/PASSWORD`. a synonym for CONNECT is `CONN`
also semicolon termination is not required for SQL\* Plus, it is optional and only required for SQL statements,

#### TABLESPACES

they are beyond scope, but we address them - not in the exam
tablespaces are used for allocation the space amount and quotas for use with a created account, but for our learning case the following statement that allocated
UNLIMITED TABLESPACE to a user is adequate to remove some restrictions, it is more of a topic for database administrators
In real world,check with the DBA to be on the same page before allocation tablespaces and QUOTAS

```sql
GRANT UNLIMITED TABLESPACE TO username;
```

## GRANT and REVOKE

system privileges are granted using the GRANT statement, consider the grants used here for creating a user and granting some privileges

```sql
CONNECT SYS AS SYSDBA; -- WILL PROMPT FOR PASSWORD, and as the result will establish a user session with the SYS account
ALTER SESSION SET "\_oracle_script"=True; -- in case failure occurs
CREATE USER HARLOD IDENTIFIED BY HARLOD; -- Create a user HARLOD with password HARLOD
GRANT CREATE SESSION TO HARLOD; -- Grant the CREATE SESSION TO HARLOD so he can log into the system
GRANT UNLIMITED TABLESPACE TO HARLOD; -- Grant the unlimited tablespace to remove tablespace restrictions
GRANT CREATE TABLE TO HARLOD; -- Grant the CREATE TABLE TO HARLOD so he can create tables on his schema
```

After executing the above statements we can login into the system

```sql

CONNECT HARLOD/HARLOD
CREATE TABLE CLOCKTOWER(CLOCK_ID NUMBER(11));
CREATE SEQUENCE SEQ_CLOCK_ID;
```

The basic syntax for GRANT is

```sql
-- below the term privilege represents one of several dozens of privileges that are already defined in the database
GRANT privilege TO username options; -- multiple privilege can be granted by separating them with commas
```

the basic syntax for REVOKE is as follows:-

```sql
REVOKE privilege FROM username;
```

`we GRANT TO and REVOKE FROM`
once a system privilege is revoked, all actions that happened prior to revocation persist
If a user is granted a privilege to create database objects, then creates some of the objects, once is revoked the privilege, those objects remain in place

### ANY

Some privileges include the keyword `ANY` in the TITLE,example `CREATE ANY TABLE`,which is the ability to create a table in any user account in the database
this enables the account with the privilege to create a table on others accounts
consider the sql statements below

```sql
CREATE USER LISA IDENTITIFIED BY LISA;
CREATE USER ALI IDENTITIFIED BY ALI;
GRANT CREATE SESSION TO LISA;
GRANT CREATE SESSION TO ALI;
GRANT UNLIMITED TABLESPACE TO LISA;
GRANT UNLIMITED TABLESPACE TO ALI;

GRANT CREATE TABLE TO LISA;
GRANT CREATE TABLE TO ALI;

CONN LIST/LISA;
CREATE TABLE LISAZ_TEST(ID NUMERIC(3));

CONN ALI\ALI;
CREATE TABLE TO LISA.ALI_TEST(ID NUMERIC(10));

CONN SYS AS DBA
SELECT OWNER, TABLE_NAME FROM DBA_TABLES
WHERE OWNER IN ('LISA', 'ALI');
```

all tables will be listed with LISA as the owner even though ALI is the one created the ALI_TEST within LISAs schema
because of the ANY option, ALI can create a table in any user account, it provides the universal reach

### ADMIN OPTION

considering the `GRANT privilege TO username options` the options are the ones we look at now
here we have an additional clause that can be included with the `GRANT` statement

```sql
GRANT privilege TO username WITH ADMIN OPTION;
```

when the privilege is granted with the `WITH ADMIN OPTION` option, then the recipient receives the system privilege itself, along with the right to grant the system privilege to another user
if a user is granted the privilege with the `WITH ADMIN OPTION` option, and the user grants the privilege to another user with the `WITH ADMIN OPTION` option, then once the privilege is revoked,
those users granted are not revoked, meaning the user will retain the privilege until revoked directly from the user account
ie the `WITH ADMIN OPTION` option is not CASCADED
To revoke the privilege is easily, and no option is required, just a simple `REVOKE privilege FROM username`
will do the job

### ALL PRIVILEGES

as an alternative to granting specific system privileges, a qualified user account, eg SYSTEM or some other DBA can issue the following statement:-

```sql
GRANT ALL PRIVILEGES ON username;
```

the `WITH ADMIN OPTION` can be used with this as well
and can be revoked with

```sql
REVOKE ALL PRIVILEGES FROM username;
```

the revoke statment above will reverse all system privileges granted to the user assuming that all privileges have been granted to the user, in not an error message will occur

QNs

1. can revoke all privileges apply to a user with fewer privileges? ->
2. other questions

### PUBLIC

is the built in user account that represents all oracle users, any object owned by PUBLIC are treated as though they are owned by all users in the database, present and future
the GRANT will also work with PUBLIC in place of a user account's name

```sql
GRANT CREATE ANY TABLE TO PUBLIC;
```

when you want to grant a privilege to ALL users in the database, you do not use the ALL keyword, and instead, you use the PUBLIC account
Also, you can use any combination of valid syntax with the PUBLIC account as you could with other usernames
Consider

```sql
GRANT ALL PRIVILEGES TO PUBLIC;
ROVEKE ALL PRIVILEGES FROM PUBLIC;
```

also you can revoke from public, and still retain the privilege which were granted before, and will only affect the indicated privilege
You can also grant to public with the options `WITH ADMIN OPTION` and it remains syntactically right

## GRANT privileges on Tables and on User

any user with the system privilege CREATE TABLE can create a table, but only users with permission to perform DML on that table can either perform DML or select data from that table.
the exception is those users with the privilege on any object, like INSERT ANY TABLE and the likes of those
Any user who owns a table, and any other object may grant permission on that particular object to other users.
Also, whenever any DDL including GRANT and REVOKE are issued, an implicit commit occurs
the following is the way of adding object privileges to objects

```sql
GRANT privilege ON object TO username options;
REVOKE privilege ON object FROM username;
```

### SCHEMA prefixes

to reference a table owned by another object we must use a schema prefix, and the prefix is the name of the user account owning the object
a SYNONYM is a name that is an alternative name to the name of an object
a PUBLIC SYNONYM is a synonym that is owned by the PUBLIC account, and once owned by the PUBLIC, get's owned all user accounts, present and future, so for PUBLIC SYNONYMS
lets create a SYNONYM for LISA.LISA_TB as WEBINARS by allowing LISA to create PUBLIC SYNONYM objects
Sytax fo creating synonym objects is as follows:-

```sql
CREATE PUBLIC SYNONYM synonym_name FOR schema.object_name;
DROP PUBLIC SYNONYM synonym_name;
```

`NOTE`: No privilege are required to access the public SYNONYM since they are all serving the public account, however, privileges are required to access the underlying object which the synonym servers as an alias to,
privileges on those objects that the synonym serves should be granted explicitly.

#### Name Priority, Revisited

When a user makes a reference to an object, SQL will look for an object in this order

- first in the local namespace
- next, in the database namespace which contains, user, roles and public synonyms

### WITH GRANT OPTION

if we want to grant to a user a certain privilege and include the ability to that user to grant that privilege, we use with GRANT OPTION
`NOTE`: object permissions do not use `WITH ADMIN OPTION`, THEY ONLY USE `WITH GRANT OPTION`

```sql
GRANT privilege(s) ON object_name TO username WITH GRANT OPTION;
CONN LISA/LISA;
GRANT DELETE ON LISA_TB TO HARLOD WITH GRANT OPTION;
REVOKE DELETE ON LISA_TB FROM HARLOD;
```

on REVOKE
once a granted user with the `WITH GRANT OPTION` extends the privileges, once they are revoked from that user, they CASCADES to whoever they granted the privileges to, and REVOKE doesn't care whether the `WITH GRANT OPTION` was included or not

### Table - ALL PRIVILEGES

the `ALL PRIVILEGES` option works with granting and revoking object privileges in much the same way as in system privileges
just have some minor differences, in object privileges the term `PRIVILEGES` is optional, as both of these works

```sql
GRANT ALL PRIVILEGES ON object TO username options;
GRANT ALL ON object TO username options;
REVOKE ALL PRIVILEGES ON object FROM username;
REVOKE ALL ON object FROM username;
```

Here there is only one difference from the REVOKE ALL privileges used for systems,
The `REVOKE ALL ON object FROM username` can be used to revoke to a USER who don't have any permission, or have a single permission, and will remove all of the permissions granted, and none will remain
EVEN if there is no permission, the statement will execute successfully,

### Dependent Privileges

if a user A, owns a view, which is based on the table that user A also owns, and user A grants privileges on the view to user B, then user B can access the view without privileges on the underlying table.
if user A create a table and a public synonym for that table, the user B can access the synonym without privileges on the underlying table, but to perform anything on the underlying object, then user B should have explicit privileges on that particular table or object
for views, to access a view, we need privilege to the view, and not the underlying table
`NOTE`: If a user creates an object and grants privileges to some other users on that object, then once that object is dropped, the privileges are also dropped, and when recreated they should be assigned again,
`FLASHBACK ... BEFORE DROP` will recover the table, associated INDEXES, and the table's privilege, and you won't need to grant the privileges again

if you have a `CREATE PUBLIC SYNONYM` privilege, you can create a public synonym to any object in the database, even to those you don't own,
the matter of selecting from those objects will require other permissions but creating the public
synonym is not dependent on that

### VIEW PRIVILEGES IN THE DATA DICTIONARY

there are many views in the data dictionary that are associated with privileges
The table belows shows some of them

| Data Dictionary View | Explanation                                                                                                       |
| -------------------- | ----------------------------------------------------------------------------------------------------------------- |
| USER_SYS_PRIVS       | system privileges granted to the current user                                                                     |
| DBA_SYS_PRIVS        | system privileges granted to users and roles                                                                      |
| USER_TAB_PRIVS       | grants on objects in which the user is the grantor, grantee or owner                                              |
| ALL_TAB_PRIVS        | grants on objects for which the user is the grantor, grantee or owner or an enabled role or PUBLIC is the grantee |
| DBA_TAB_PRIVS        | grants on all objects on the database                                                                             |
| ALL_TAB_PRIVS_RECD   | grnats on objects for which the user, PUBLIC or granted role is the grantee                                       |
| SESSION_PRIVS        | privileges that are enabled to the user                                                                           |
| USER_COL_PRIVS       |                                                                                                                   |

some of the views can be seen as follows:-

```sql
SELECT PRIVILEGE, ADMIN_OPTION FROM DBA_SYS_PRIVS;
```

a privilege may be assigned to a user as `PRIVILEGE` or as part of a role, if you intend to drop a privilege from a user you should know whether it was assigned as part of a ROLE or as an individual privilege,
you might find the privilege you dropped directly is still granted to a user indirectly by a ROLE

when inspecting data dictionary views like DBA_SYS_PRIVS, or DBA_TAB_PRIVS, you can see what privileges have been granted to a particular user account, you can check the GRANTEE column for the appropriate username, however, dont forget to check for grantee ='PUBLIC' since the user is also granted those privileges

## GRANT ROLES

A `role` is a database object that you can create and to which you can assign system privileges and/or object privileges, and/or other roles.
Once created you can granta a role to user as much as you can grant privileges to a user, a user is automatically granted any privileges within a role
ROLES are perfect for organizing the way of revoking and granting privileges, on both objects and system privileges
you may grant a role to as many user accounts as you want
If any privilege is revoked from a role, it is also automatically revoked to all users granted that role `CHANGES TO ROLES CASCADES TO USERS TO WHOM THE ROLE IS GRANTED`

THREE ORALCE SUPER ROLES
Though their use are highly discouraged, oracle comes with three roles, CONNECT, RESOURCE and DBA. These roles consists of some privileges as you will see below, but note that oracle discourages there use and suggests that you create your own roles as per your requirements

classic roles table

| ROLE        | PRIVILEGE                          |
| ----------- | ---------------------------------- |
| CONNECT     | CREATE SESSION                     |
| ----------  | ----------------                   |
| RESOURCE    | - CREATE TRIGGER                   |
|             | - CREATE SEQUENCE                  |
|             | - CREATE TYPE                      |
|             | - CREATE PROCEDURE                 |
|             | - CREATE CLUSTER                   |
|             | - CREATE OPERATOR                  |
|             | - CREATE INDEXTYPE                 |
|             | - CREATE TABLE                     |
| ----------- | ----------------                   |
| DBA         | More that 100 privileges including |
|             | - CREATE ANY TABLE                 |
|             | - CREATE PUBLIC SYNONYM            |
|             | - CREATE ROLE                      |
|             | - CREATE SEQUENCE                  |
|             | - GRANT ANY PRIVILEGE              |
|             | - CREATE VIEW                      |

to create a role, the user account requieres the `CREATE ROLE` system privilege
You can create a role and grant those roles as below:-

```sql
CREATE ROLE CRUISE_OPERATOR;

GRANT SELECT, UPDATE, DELETE, INSERT ON HR.SHIPS TO CRUISE_OPERATOR;
-- Also you can GRANT WITH ADMIN OPTION;
GRANT privileges ON object TO username/role WITH ADMIN OPTION;
```

Data dictionary views about ROLES

| Data Dictionary View | Explanation                                  |
| -------------------- | -------------------------------------------- |
| DBA_ROLES            | all roles that exists on the database        |
| DBA_ROLE_PRIVS       | roles granted to users and roles             |
| DBA_SYS_PRIVS        | system privileges granted to users and roles |
| DBA_TAB_PRIVS        | all grants on objects to users and roles     |
| ROLE_ROLE_PRIVS      | Roles that are granted to roles              |
| ROLE_SYS_PRIVS       | system privileges granted to roles           |
| ROLE_TAB_PRIVS       | table privileges granted to rows             |
| SESSION_ROLES        | roles that are enabled to the user           |

Roles exist in the namespace out of views and tables, and hence you can create roles that are having the same name as objects, this is a bad choice,
but is possible

a user account may be granted multiple roles at once

In case you create a role, and then create an object, grant the role to the user, and grant the privilege on an object to the role.
in case you drop an object, you drop it's role, but you don't drop the role from the user,
once you recreate the object, you just grant the privilege on the object to the role, and you don't regrant the role to the user since that already exists

## Distinguish Between Privileges and Roles

a role doesn't represent privileges in and of itself. it's a collection of zero or more privileges.
a role exists independently of the privileges it may or may not contain,
also, granted privileges and granted roles exists in separate existence, if a user has a privilege, and is assigned a role that contains the same privilege, none overrides the other,
they both exists separately
when one is revoked, the other still remains
This means, you can revoke direct privileges on object, but a user might still have privileges on that object through a role

these statements falls on a category called DATA CONTROL LANGUAGE(DCL)
you can grant and also revoke from many users and many roles at once

consider

```sql
GRANT privilege(s) TO role, username, role2, username;

```

## SECURING AND SWITCHING ROLES

you can create a role with password
and you can disable a role using the set role none

```sql
CREATE ROLE role_name IDENTIFIED BY password;
GRANT role_name TO username;
CONN USERNAME/user_password;
SET ROLE role_name IDENTIFIED BY password; -- set the role to the role created above

ALTER ROLE role_name NOT IDENTIFIED;
SET ROLE role_name; -- now no password is required
SELECT * FROM SESSION_ROLES; -- will display which roles the current user session have
SET ROLE NONE;
```

the `SET ROLE` statement is used to set the role for the current user session

```sql
SET ROLE role_name; -- if a role is having a password you can do as above
```

also you can set multiple roles as follows;-
`SET ROLE role1, role2, role3, role4 IDENTIFIED BY role_password, role5;`
you can set multiple roles as above

also you can set to all roles granted to that account enabled, you use
`SET ROLE ALL`

if u want to set all except a certain role
`SET ROLE ALL EXCEPT role_name_to_except`

to remove all roles we use the
`SET ROLE NONE`
