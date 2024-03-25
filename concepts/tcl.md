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

Considering multiple simultaneous sessions, accessing the same objects, eg tables.

Sessional changes are only visible to the current session only, until a COMMIT is issued, either explicitly or implicitly.

No matter how many users are in session, no uncommitted changes will be global, until a COMMIT is issued

In the case of conflicting sessions, where two data are updated in two different sessions, and these data are in two staging environments, `draft mode` before ca COMMIT,

#### Handling Conflicting Commits in Database

## `ROLLBACK`

This is comparable to the `UNDO` function in other software products. It does not remove any data that have already been committed.
Only changes that are rolled back are the ones within the rolling back session. Consider an example:-

```sql
insert into cruises(cruise_id, captain_id)
values ('1', '102');

ROLLBACK;
```

The rollback will make it like the Cruise with id 1 and captain 102 have never been added to the database

Changes performed within a session are visible to the session until those changes are rolled back

`NOTE: if the program abnormaly exits, the system will issue an implicit ROLLBACK, uncommitted changes at the time of an abnormal termination of, eg SQL\* Plus or SQL Developer, will be rolled back

## `SAVEPOINT`

This create a checkpoint in the session to empower any COMMIT or ROLLBACK statements to subdivide the points at which data may later be undone or saved.

Without SAVEPOINT, COMMIT or ROLLBACK statements can only exists in a sort of all or nothing basis. But if periodic savepoints are enabled, a subsequent COMMIT or ROLLBACK can be used to save or restore data to those saved points in time, marked by one or more savepoints, providing a finer level of details at which the transaction can be controlled.

Consider the example below:-

```SQL
COMMIT WORK;

insert into cruises(cruise_id, captain_id)
values (5, '103');

SAVEPOINT CR_5;

UPDATE CRUISES SET CRUISE_TYPE_ID = 3;

ROLLBACK WORK TO CR_5; -- this will restore the changes in  CRUISE_TYPE_ID

SELECT * FROM CRUISES;

COMMIT;

ROLLBACK WORK TO CR_5; -- A commit clears all savepoints
```

The rules of using Savepoints include the following:-

- ALL SAVEPOINT statements must include a name for the savepoint. The savepoint name is associated with the System Change Number `(SCN)`, this is what the savepoint is Marking.
- You should not duplicate savepoint names within a session, doing so, will make the recent override the previous savepoint. No error will occur.
- Once a commit event occur (either implicitly or explicitly), all savepoints are erased from memory, any references to them will raise an error.

Without a named savepoint, the rollback will execute just fine, and whether rollback the changes, or do nothing.

`SAVEPOINT` is particularly useful when managing a large series of transactions where incremental validation must be required, in which in every transaction a series of DML statements that might fail but can be programmatically corrected and validated before moving on to the next increment. Forexample in the financial world, once every requirement is reached, a single commit can perform a permanent save to the database then.

### `ROLLBACK` Revisited

If we perform a rollback without a savepoint name, it will ignore any particular savepoint, and undo any changes made since the latest commit was issued.

Once a rollback fails, nothing will change in the state of the database,
Uncommitted changes will still be uncommitted, or rolled back.
