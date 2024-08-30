ALTER TABLE Settings ADD UsersPerPage INT;


UPDATE Settings SET UsersPerPage = 10;


ALTER TABLE registration.[User] ADD Image NVARCHAR(MAX);

CREATE TABLE registration.Permission 
(PermissionId INT CONSTRAINT PK_PERMISSION PRIMARY KEY,
Name VARCHAR(50) CONSTRAINT UQ_PERMISSION_NAME UNIQUE
);
GO

CREATE TABLE registration.UserPermission(
PermissionId INT,
Username VARCHAR(50),
Assigned DateTime CONSTRAINT DF_Permission_ASSIGNED_TIME DEFAULT GETDATE(),
IsActive BIT CONSTRAINT DF_Permission_STATE DEFAULT 1,
CONSTRAINT FK_PERMISSIONUSER_USER FOREIGN KEY (Username) REFERENCES registration.[User] (Username) ON DELETE CASCADE,
CONSTRAINT FK_PERMISSIONUSER_PERMISSION FOREIGN KEY (PermissionId) REFERENCES registration.Permission (PermissionId) ON DELETE CASCADE
);
GO

CREATE OR ALTER   PROCEDURE [registration].[spPermissionSelect] @PermissionId INT = NULL, @Name VARCHAR(50) = NULL,
@User NVARCHAR(50)= 'Anonymous'
AS
BEGIN
	BEGIN TRANSACTION spPermissionSelect
	INSERT INTO monitoring.Logs(Username, procAccessed)
	VALUES (@User, '[registration].[spPermissionSelect]');
	SELECT * FROM registration.Permission WHERE (@PermissionId IS NULL OR PermissionId = @PermissionId) AND (@Name IS NULL OR Name = @Name);
	COMMIT TRANSACTION spPermissionSelect
END
GO

CREATE OR ALTER  PROCEDURE [registration].[spPermissionInsert] @PermissionId INT, @Name VARCHAR(50),
@User NVARCHAR(50)= 'Anonymous'
AS
BEGIN
	BEGIN TRANSACTION spPermissionInsert
	INSERT INTO monitoring.Logs(Username, procAccessed)
	VALUES (@User, '[registration].[spPermissionInsert]');
	INSERT INTO registration.Permission(PermissionId, Name) VALUES (@PermissionId,@Name);
	COMMIT TRANSACTION spPermissionInsert
END
GO

CREATE OR ALTER   PROCEDURE [registration].[spPermissionUpdate] @PermissionId INT, @Name VARCHAR(50),
@User NVARCHAR(50)= 'Anonymous'
AS
BEGIN
	BEGIN TRANSACTION spPermissionUpdate
	INSERT INTO monitoring.Logs(Username, procAccessed)
	VALUES (@User, '[registration].[spPermissionUpdate]');
	UPDATE [registration].[Permission]
	SET
	Name = @Name
	WHERE PermissionId = @PermissionId;
	COMMIT TRANSACTION spPermissionUpdate
END
GO


CREATE OR ALTER   PROCEDURE [registration].[spUserPermissionSelect] @PermissionId INT = NULL , @Username VARCHAR(50) = NULL,
@User NVARCHAR(50)= 'Anonymous'
AS
BEGIN
	BEGIN TRANSACTION spUserPermissionSelect
	INSERT INTO monitoring.Logs(Username, procAccessed)
	VALUES (@User, '[registration].[spUserPermissionSelect]');
	SELECT a.PermissionId as PermissionId, Username, IsActive, Name FROM registration.[UserPermission] a INNER JOIN registration.[Permission] b
	ON a.PermissionId = b.PermissionId
	WHERE (@PermissionId IS NULL OR a.PermissionId = @PermissionId) AND (@Username IS NULL OR Username = @Username) AND IsActive =1 ;
	COMMIT TRANSACTION spUserPermissionSelect
END