CREATE OR ALTER   PROCEDURE [registration].spAddBulkRolesToUser
@roleIds registration.rolesIdList READONLY,
@Username VARCHAR(50),
@StillActive BIT = NULL,
@User NVARCHAR(50)= 'Anonymous'
AS
BEGIN
	BEGIN TRANSACTION spAddBulkRolesToUser
	INSERT INTO monitoring.Logs(Username, procAccessed)
	VALUES (@User, '[registration].[spAddBulkRolesToUser]');
    IF EXISTS (SELECT 1 FROM @roleIds)
        BEGIN
            MERGE INTO registration.[RoleUser] AS targetTable
            USING @roleIds AS source
            ON (source.RoleId = targetTable.RoleId AND @Username = targetTable.Username)
            WHEN MATCHED THEN
            UPDATE SET targetTable.StillActive = ISNULL(@StillActive, 1)
            WHEN NOT MATCHED BY TARGET THEN
            INSERT (RoleId, Username, StillActive) VALUES (source.RoleId, @Username, ISNULL(@StillActive, 1));
        END
	COMMIT TRANSACTION spAddBulkRolesToUser
END

