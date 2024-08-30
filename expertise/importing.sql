-- handling imported data we just perform the functions as follows

-- 1. Create a type of the OBJECT
-- 2. Add it as a dependency in the DATABASE
-- 3. Send the list into the database using the insert value from a selected LIST
-- 4. Update and collect values and failures in the DATABASE
-- 5. ROLLBACK if there happened an EXCEPTION
-- 6. COMMIT if the process is successful

create table devices (
id int primary key,
serial varchar(30) unique,
name varchar(30));

CREATE TYPE devicesList AS TABLE(ID INT, SERIAL VARCHAR(30), NAME VARCHAR(30));
GO

CREATE OR ALTER PROCEDURE importDevices
@devices devicesList READONLY
AS
BEGIN
INSERT INTO devices (id, serial, name)
SELECT ID, SERIAL, NAME FROM @devices;
END
GO


USE [ATTENDANCEDB]
GO
/****** Object:  StoredProcedure [attendance].[spImportDevices]    Script Date: 13/05/2024 20:48:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER   PROCEDURE [attendance].[spImportDevices]
@devices attendance.devicesList READONLY
AS
BEGIN
BEGIN TRANSACTION ImportDevices
INSERT INTO [attendance].[Device] (DeviceId, SerialNo, DeviceNameCode)
SELECT ID, SERIAL, NAME FROM @devices;
COMMIT TRANSACTION ImportDevices
END


---- HERE IS A PROCEDURE ON HOW TO HANDLE ALMOST EVERY CASE
SELECT * FROM registration.[User]
GO

CREATE TYPE registration.usersList AS TABLE(
Username varchar(50),
FirstName varchar(30),
LastName varchar(30),
Email varchar(50),
DOB Date,
PasswordHash varchar(256),
GenderId INT,
DesignationId INT,
Registerd DATETIME,
CardId varchar(20)
);


CREATE TABLE attendance.DeviceUser(
DeviceId INT,
Username varchar(50),
IsActive bit default 1,
CONSTRAINT PK_DEVICE_USER PRIMARY KEY (DeviceId, Username),
CONSTRAINT FK_USER_DEVICEUSER FOREIGN KEY (Username) REFERENCES registration.[User] (Username) ON DELETE CASCADE,
CONSTRAINT FK_DEVICE_DEVICEUSER FOREIGN KEY (DeviceId) REFERENCES attendance.Device (DeviceId) ON DELETE CASCADE
);
GO

drop table DeviceUser;
GO

DROP TABLE attendance.DeviceUser;
GO


CREATE OR ALTER PROCEDURE attendance.spAddUserToDevice @Username VARCHAR(50), 
@DeviceId int, @IsActive BIT = 1, @User varchar(50)= 'Anonymous'
AS
BEGIN
BEGIN TRANSACTION spAddUserToDevice
	INSERT INTO monitoring.Logs(Username, procAccessed)
	VALUES (@User, '[attendance].[spAddUserToDevice]');
	INSERT INTO attendance.DeviceUser (DeviceId, Username, IsActive) VALUES (@Username, @DeviceId, @IsActive);
	COMMIT TRANSACTION spAddUserToDevice
END
GO

CREATE OR ALTER PROCEDURE attendance.spGetDeviceUser @Username VARCHAR(50), 
@DeviceId int, @IsActive BIT = 1, @User varchar(50)= 'Anonymous'
AS
BEGIN
	SELECT DeviceId, Username, IsActive FROM attendance.DeviceUser 
	WHERE 
	(@Username IS NULL OR Username = @Username) AND
	(@DeviceId IS NULL OR DeviceId = @DeviceId) AND
	(IsActive = @IsActive)
END
GO

CREATE OR ALTER PROCEDURE attendance.spToggleDeviceUser @Username VARCHAR(50), 
@DeviceId int, @IsActive BIT, @User varchar(50)= 'Anonymous'
AS
BEGIN
	BEGIN TRANSACTION spToggleDeviceUser
	INSERT INTO monitoring.Logs(Username, procAccessed)
	VALUES (@User, '[attendance].[spToggleDeviceUser]');
	
	update attendance.DeviceUser 
	SET
	IsActive = @IsActive
	WHERE 
	Username = @Username AND DeviceId = @DeviceId;
	COMMIT TRANSACTION spToggleDeviceUser
END
GO


CREATE TYPE attendance.devicesIdList AS TABLE (DeviceId INT);
GO


CREATE OR ALTER PROCEDURE attendance.spAddUserToAllDevices 
    @Username VARCHAR(50), 
    @deviceIdsList attendance.devicesIdList READONLY, 
    @IsActive BIT = 1, 
    @User VARCHAR(50) = 'Anonymous'
AS
BEGIN
    BEGIN TRANSACTION spAddUserToAllDevices;

    INSERT INTO monitoring.Logs(Username, procAccessed)
    VALUES (@User, '[attendance].[spAddUserToAllDevices]');

    IF EXISTS (SELECT 1 FROM @deviceIdsList)
    BEGIN
        INSERT INTO attendance.DeviceUser (DeviceId, Username, IsActive) 
        SELECT DeviceId, @Username AS Username, @IsActive AS IsActive  
        FROM @deviceIdsList;
    END
    ELSE
    BEGIN
        INSERT INTO attendance.DeviceUser (DeviceId, Username, IsActive) 
        SELECT DeviceId, @Username AS Username, @IsActive AS IsActive 
        FROM attendance.Device;
    END

    COMMIT TRANSACTION spAddUserToAllDevices;
END
go



CREATE OR ALTER PROCEDURE attendance.spAddUserToAllDevices 
    @Username VARCHAR(50), 
    @deviceIdsList attendance.devicesIdList READONLY, 
    @IsActive BIT = 1, 
    @User VARCHAR(50) = 'Anonymous'
AS
BEGIN
    BEGIN TRANSACTION spAddUserToAllDevices;

    INSERT INTO monitoring.Logs(Username, procAccessed)
    VALUES (@User, '[attendance].[spAddUserToAllDevices]');

    IF EXISTS (SELECT 1 FROM @deviceIdsList)
    BEGIN
        MERGE INTO attendance.DeviceUser AS targetTable
		USING @deviceIdsList AS source
		ON (targetTable.DeviceId = source.DeviceId AND targetTable.Username = @Username)
		WHEN MATCHED THEN
			UPDATE SET targetTable.IsActive = @IsActive
		WHEN NOT MATCHED BY TARGET THEN
        INSERT (DeviceId, Username, IsActive)
        VALUES (source.DeviceId, @Username, @IsActive);
    END
    ELSE
    BEGIN
        MERGE INTO attendance.DeviceUser AS targetTable
		USING (SELECT DeviceId FROM attendance.Device) AS source
		ON (targetTable.DeviceId = source.DeviceId AND targetTable.Username = @Username)
		WHEN MATCHED THEN
			UPDATE SET targetTable.IsActive = @IsActive
		WHEN NOT MATCHED BY TARGET THEN
        INSERT (DeviceId, Username, IsActive)
        VALUES (source.DeviceId, @Username, @IsActive);
    END

    COMMIT TRANSACTION spAddUserToAllDevices;
END
