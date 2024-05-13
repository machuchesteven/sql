CREATE OR ALTER  PROCEDURE [registration].[spLogin] @Username VARCHAR(50), @PasswordHash VARCHAR(256), @IpAddress VARCHAR(20) = NULL
AS
BEGIN
	BEGIN TRANSACTION spLogin
	DECLARE @ReturnValue TINYINT;
	DECLARE @LoginAttempts TINYINT;
	DECLARE @MaxAttempts TINYINT = 3;
	IF EXISTS (SELECT * FROM [registration].[User] WHERE USERNAME = @Username)
	BEGIN
		SELECT @ReturnValue = 
				CASE WHEN PasswordHash = @PasswordHash AND IsLocked = 0 THEN 1
					WHEN PasswordHash = @PasswordHash AND IsLocked = 1 THEN 2
					WHEN PasswordHash <> @PasswordHash AND IsLocked = 0 THEN 3
					WHEN PasswordHash <> @PasswordHash AND IsLocked = 1 THEN 4
					ELSE 0
				END,
				@LoginAttempts =
				CASE 
				-- Add attempts so that it may be easy to know whether to lock the account or not
					WHEN PasswordHash <> @PasswordHash AND IsLocked = 0 THEN LoginAttempts + 1
					ELSE 0
				END
				FROM [registration].[User] WHERE Username = @Username
		END
		ELSE IF NOT EXISTS (SELECT * FROM [registration].[User] WHERE USERNAME = @Username)
		BEGIN
			SET @ReturnValue = 0
	END
	INSERT INTO LOGINATTEMPTS(Username, Succeeded, IpAddress) 
		values (
			@Username,
			CASE
				WHEN @ReturnValue = 1 THEN 1
				ELSE 0
			END,
			@IpAddress)
	IF @ReturnValue = 3
	BEGIN
		UPDATE [registration].[User] SET 
		[LoginAttempts] = [LoginAttempts] + 1,
		IsLocked = CASE WHEN @LoginAttempts >= @MaxAttempts AND IsLocked = 0 AND LOWER(Username) <> 'superadmin' THEN 1
					ELSE IsLocked
					END
		-- Here is where we lock the account too if it is not the admin account
		WHERE Username = @Username
	END
	ELSE IF @ReturnValue = 1 -- RESET THE ATTEMPTS FOR A SUCCESSFUL LOGIN
	BEGIN
	UPDATE [registration].[User] SET [LoginAttempts] = 0 WHERE Username = @Username
	END
	select @ReturnValue AS STATUS, @MaxAttempts - @LoginAttempts as RemainingAttempts;
	COMMIT TRANSACTION spLogin
END