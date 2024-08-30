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

DROP TYPE registration.usersList;
GO

CREATE TYPE registration.usersList AS TABLE(
Username varchar(50),
FirstName varchar(30),
LastName varchar(30),
Email varchar(50),
DOB Date,
Phone VARCHAR(20),
PasswordHash varchar(256),
GenderId INT,
DesignationId INT,
Registered DATETIME,
CardId varchar(20)
);
go


CREATE OR ALTER PROCEDURE registration.spImportUsers
    @users registration.usersList READONLY, 
    @IsActive BIT = 1, 
    @User VARCHAR(50) = 'Anonymous'
AS
BEGIN
    BEGIN TRANSACTION spImportUsers;
    INSERT INTO monitoring.Logs(Username, procAccessed)
    VALUES (@User, '[registration].[spImportUsers]');
    BEGIN
        MERGE INTO registration.[User] AS targetTable
		USING @users AS source
		ON (targetTable.Username = source.Username AND targetTable.FirstName = source.FirstName AND targetTable.LastName = source.LastName)
		WHEN MATCHED THEN
			UPDATE SET 
			targetTable.Email = source.Email, targetTable.PasswordHash = source.PasswordHash,  
			targetTable.CardId= source.CardId, targetTable.DOB=source.DOB, 
			targetTable.Phone = source.Phone,
			targetTable.GenderId =source.GenderId, targetTable.Registered = COALESCE(source.Registered, GETDATE()),
			targetTable.DesignationId = source.DesignationId
		WHEN NOT MATCHED BY TARGET THEN
        INSERT (
		Username, FirstName, LastName, 
		Email, PasswordHash, CardId, Phone,
		DOB, GenderId, DesignationId, Registered)
        VALUES (source.Username, source.FirstName, source.LastName, source.Email, source.PasswordHash, source.CardId,source.Phone, source.DOB, source.GenderId,source.DesignationId , COALESCE(source.Registered, GETDATE()));
    END
    COMMIT TRANSACTION spImportUsers;
END

