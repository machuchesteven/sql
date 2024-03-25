# Transaction Control in Oracle - TCL

These include statement whic are used to control session and transaction engaged in any DML operations.

Here we will look at 3 if them:-

- COMMIT - perform as a `SAVE`, saves changes happened to the database within a session since the session began, or since the last `COMMIT` was issued, whichever is recent
- ROLLBACK - Undoes the changes to the database perfomed, back to the last `COMMIT` point in the session
- SAVEPOINT - Temporarily sets an optional point or marker to empower future `COMMIT or ROLLBACK` by providing one or more optional points at which may or may not undo changes.

TCL performs changes made to the database within a session.A session begins when a single user logs in and continues as the user engages in a series of transactions, until the user disconnects from the database by either logging out or breaking some connection in a certain manner.

One session, one user, one user one or many session, - vice versa not true

## `COMMIT`

Is used to save changes made within a session to any tables that have been modified by the DML statements.
Once committed **Those changes can no longer be undone using ROLLBACK**. The only way to change back is using other DML statements and commiting those changes.

A series of SQL statements are considered as a **_transaction_**, and are treated as a single unit. Until a commit is issued, there are no permanent changes to the database, and all changes made can be undone.

There are two types of commits in Oracle:-

- `EXPLICIT` Commit: Occurs when the `COMMIT` statement is issued/executed
- `IMPLICIT` Commit: Occurs automatically when certaun database events occur

### Explicit Commit

Occur whenever the `COMMIT` statement is executed, its syntax is as follows:-

```sql
    COMMIT; --OR
    COMMIT WORK; -- the work keyword is optional/ it is ANSI but optional in Oracke
```

### IMPLICIT Commit

Occures when certain events takes place on the database, these events include:-

- Immediately after an attempt to any execute DDL. Even if the DDL fails, the commit is performed before the DDL execution starts
- A normal exit from most of oracles's Utils and Tools eg SQL\* Plus or SQL Developer

### Commit and Multiple Sessions
