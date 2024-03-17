# Oracle Basics for the Exam

Types of Oracle SQL statements

1. DML - Used for manipulating and selecting data. The list below shows only those covered by the exam, Uncovered includes `CALL`, `LOCK TABLE`, `EXPLAIN PLAN`
   - SELECT - display data of a database view or table
   - INSERT - insert data into a database table, either directly or through a view
   - UPDATE - update data in a database table, either directly or through a view
   - DELETE - delete data from a database table
   - MERGE - perform a combination insert, update and delete in a single statement
2. DDL - Used for schema objects manipulation. Uncovered statements include `ANALYZE`, `AUDIT`,`ASSOCIATE STATISTICS`, `DISASSOCIATE`, `NOAUDIT`
   - **CREATE** - used to create new database objects
   - **ALTER** - change the state of the database obeject
   - **DROP** - delete a table with its data
   - **TRUNCATE** - delete all rows from the table, works like delete but with better performance
   - **RENAME**
   - **GRANT** - give user objects rights to perform several operations
   - **REVOKE** - removes rights from user objects
   - **FLASHBACK** - restores to an earlier version of the table or database
   - **COMMENT** - add comment to the datase object
   - **PURGE** - remove objects permanently from the recycle bin
3. TCL - Used for transactions control. Uncovered by the exam include the following `SET TRANSACTION`, `SET CONSTRAINT`. Also implicit commit occurs when you issue a DDL function after any DML. Even if you did not explicitly commit
   - **BEGIN**
   - **SAVEPOINT** - marks a position in a session to prepare for a future ROLLBACK to enable that ROLLBACK to restore dataat a selected point in a session other than the most recent
     commit event
   - **COMMIT** - saves a set of database modifications performed in the current session
   - **ROLLBACK** - undo a set of database modifications performed in the current session
4. Session Control Statement eg `SET ROLE`, `ALTER SESSION`,
5. System Control Statement Eg `ALTER SYSTEM`
6. Embedded SQL statements - These are ones that are created or added using the Third Generation Languages
