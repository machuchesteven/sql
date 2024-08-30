CREATE TABLE attendance.Occupant(
OccupantId INT CONSTRAINT PK_OCCUPANTS PRIMARY KEY,
Name VARCHAR(50) CONSTRAINT UN_OCCUPANT_NAME UNIQUE,
Description VARCHAR(500)
);
GO

CREATE TABLE attendance.OccupantUser(
OccupantId INT,
Username VARCHAR(50),
Assigned DateTime CONSTRAINT DF_OCCUPANT_ASSIGNED_TIME DEFAULT GETDATE(),
IsActive BIT CONSTRAINT DF_OCCUPANT_STATE DEFAULT 1,
CONSTRAINT PK_OCCUPANTUSER PRIMARY KEY ( OccupantId,Username),
CONSTRAINT FK_OCCUPANTUSER_USER FOREIGN KEY (Username) REFERENCES registration.[User] (Username) ON DELETE CASCADE,
CONSTRAINT FK_OCCUPANTUSER_OCCUPANT FOREIGN KEY (OccupantId) REFERENCES attendance.Occupant (OccupantId) ON DELETE CASCADE
);
GO

CREATE OR ALTER   PROCEDURE [attendance].[spGetOccupantUser] @Username VARCHAR(50) = NULL, 
@OccupantId int = NULL, @DeviceId INT = NULL, @IsActive BIT = 1, @User varchar(50)= 'Anonymous'
AS
BEGIN
	IF @OccupantId IS NULL AND @DeviceId IS NOT NULL
	BEGIN
	SET  @OccupantId = (SELECT TOP 1 OccupantId FROM attendance.Device WHERE DeviceId =  @DeviceId)
	END
	SELECT OccupantId, Username, IsActive FROM attendance.OccupantUser
	WHERE 
	(@Username IS NULL OR Username = @Username) AND
	(@OccupantId IS NULL OR OccupantId = @OccupantId) AND
	(IsActive = @IsActive)
END
GO



CREATE OR ALTER  PROCEDURE [attendance].[spAddUsersToOccupant] 
    @OccupantId  VARCHAR(50), 
    @usernames registration.usernamesList READONLY, 
    @IsActive BIT = 1, 
    @User VARCHAR(50) = 'Anonymous'
AS
BEGIN
    BEGIN TRANSACTION spAddUsersToOccupant;

    INSERT INTO monitoring.Logs(Username, procAccessed)
    VALUES (@User, '[attendance].[spAddUsersToOccupant]');

    IF EXISTS (SELECT 1 FROM @usernames)
    BEGIN
        MERGE INTO attendance.OccupantUser AS targetTable
		USING @usernames AS source
		ON (targetTable.OccupantId = @OccupantId AND targetTable.Username = source.Username)
		WHEN MATCHED THEN
			UPDATE SET targetTable.IsActive = @IsActive
		WHEN NOT MATCHED BY TARGET THEN
        INSERT (OccupantId, Username, IsActive)
        VALUES (@OccupantId, source.Username, @IsActive);
    END
    ELSE
    BEGIN
        MERGE INTO attendance.OccupantUser AS targetTable
		USING (SELECT Username FROM registration.[User]) AS source
		ON (targetTable.OccupantId = @OccupantId AND targetTable.Username = source.Username)
		WHEN MATCHED THEN
			UPDATE SET targetTable.IsActive = @IsActive
		WHEN NOT MATCHED BY TARGET THEN
        INSERT (OccupantId, Username, IsActive)
        VALUES (@OccupantId, source.Username, @IsActive);
    END
    COMMIT TRANSACTION spAddUsersToOccupant;
END
GO


CREATE OR ALTER     PROCEDURE [attendance].[spOccupantUserAddorRemove] @Username VARCHAR(50),
@OccupantId int, @IsActive BIT = 1, @User varchar(50)= 'Anonymous'
AS
BEGIN
BEGIN TRANSACTION spOccupantUserAddorRemove
	INSERT INTO monitoring.Logs(Username, procAccessed)
	VALUES (@User, '[attendance].[spOccupantUserAddorRemove]');
	BEGIN
        MERGE INTO attendance.OccupantUser AS targetTable
		USING (SELECT @OccupantId AS OccupantId, @Username AS Username) AS source
		ON (targetTable.OccupantId = source.OccupantId AND targetTable.Username = @Username)
		WHEN MATCHED THEN
			UPDATE SET targetTable.IsActive = @IsActive
		WHEN NOT MATCHED BY TARGET THEN
        INSERT (OccupantId, Username, IsActive)
        VALUES (source.OccupantId, @Username, @IsActive);
    END
	COMMIT TRANSACTION spOccupantUserAddorRemove
END
GO



CREATE TABLE attendance.Occupant(
OccupantId INT CONSTRAINT PK_OCCUPANTS PRIMARY KEY,
Name VARCHAR(50) CONSTRAINT UN_OCCUPANT_NAME UNIQUE,
Description VARCHAR(500)
);
GO


CREATE OR ALTER PROCEDURE attendance.spOccupantGet @OccupantId INT = NULL, @Name VARCHAR(50) = NULL, @User NVARCHAR(50)= 'Anonymous'
AS
BEGIN
	BEGIN TRANSACTION spOccupantGet
	INSERT INTO monitoring.Logs(Username, procAccessed)
	VALUES (@User, '[attendance].[spOccupantGet]');
	SELECT * FROM attendance.Occupant WHERE (@OccupantId IS NULL OR OccupantId = @OccupantId) AND (@Name IS NULL OR Name = @Name);
	COMMIT TRANSACTION spOccupantGet
END

CREATE OR ALTER PROCEDURE attendance.spOccupantInsert @OccupantId INT, @Name VARCHAR(50), @Description VARCHAR(500) = NULL, @User NVARCHAR(50)= 'Anonymous'
AS
BEGIN
	BEGIN TRANSACTION spOccupantInsert
	INSERT INTO monitoring.Logs(Username, procAccessed)
	VALUES (@User, '[attendance].[spOccupantInsert]');
	INSERT INTO attendance.Occupant(OccupantId, Name, Description) VALUES (@OccupantId,@Name, @Description);
	COMMIT TRANSACTION spOccupantInsert
END

CREATE OR ALTER PROCEDURE attendance.spOccupantUpdate @OccupantId INT, @Name VARCHAR(50), @Description VARCHAR(500) = NULL, @User NVARCHAR(50)= 'Anonymous'
AS
BEGIN
	BEGIN TRANSACTION spOccupantUpdate
	INSERT INTO monitoring.Logs(Username, procAccessed)
	VALUES (@User, '[attendance].[spOccupantUpdate]');
	UPDATE [attendance].[Occupant]
	SET
	Name = @Name,
	Description = @Description
	WHERE OccupantId = @OccupantId;
	COMMIT TRANSACTION spOccupantUpdate
END

