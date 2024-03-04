# SQL triggers and how to use them

This guide explains the basics of sql triggers and how to use them.
It is meant to cover different databases and implementaions of sql triggers.

## Triggers in SQL servers

in sql server triggers are used and implement from 4 types of triggers.

1. **DML Triggers** This are meant to be used on the database with the INSERT, UPDATE and DELETE events on a particular table.
2. **DDL Triggers** These are meant to be used on the database with actions based on data schema updates and change functions like CREATE, ALTER, DROP for database objects
3. **LOGON Triggers** These are meant to be used on the database for logging events like user logins and more
4. **CLR Triggers** These are meant to be used by functions from assembly registered with SQL Server

In SQL server overall triggers are used for tasks automation, business rules integrity and more

Examples of DML Triggers are as follows:-

```sql
--- Triggers on Insert
CREATE TRIGGER trg_AfterInsert_Device
ON attendance.Device
AFTER INSERT
AS
BEGIN
    INSERT INTO attendance.DeviceLog(DeviceId, SerialNo, Event)
    SELECT DeviceId, SerialNo, 'Created' FROM inserted
END
GO

-- Triggers On Update --
CREATE TRIGGER trg_AfterUpdate_Device
ON attendance.Device
AFTER UPDATE
AS
BEGIN
    INSERT INTO attendance.DeviceLog(DeviceId, SerialNo, Event)
    SELECT i.DeviceId, i.SerialNo, 'Activated'
    FROM inserted i
    INNER JOIN deleted d ON i.DeviceId = d.DeviceId
    WHERE i.IsActive = 1 AND d.IsActive = 0

    INSERT INTO attendance.DeviceLog(DeviceId, SerialNo, Event)
    SELECT i.DeviceId, i.SerialNo, 'Deactivated'
    FROM inserted i
    INNER JOIN deleted d ON i.DeviceId = d.DeviceId
    WHERE i.IsActive = 0 AND d.IsActive = 1
END
GO

-- Triggers on Delete --
CREATE TRIGGER trg_AfterDelete_Device
ON attendance.Device
AFTER DELETE
AS
BEGIN
    INSERT INTO attendance.DeviceLog(DeviceId, SerialNo, Event)
    SELECT DeviceId, SerialNo, 'Deleted'
    FROM deleted
END
GO
delete from attendance.DeviceLog

```

## DDL Triggers

These are dealing with the schema as we said before
