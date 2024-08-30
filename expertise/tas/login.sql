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
				CASE WHEN PasswordHash = @PasswordHash AND IsLocked = 0 THEN 1 -- RIGHT INFORMATION AND OPEN ACCOUNT
					WHEN PasswordHash = @PasswordHash AND IsLocked = 1 THEN 2 -- RIGHT INFORMATION AND CLOSED ACCOUNT
					WHEN PasswordHash <> @PasswordHash AND IsLocked = 0 THEN 3 -- WRONG INFORMATION AND OPEN ACCOUNT
					WHEN PasswordHash <> @PasswordHash AND IsLocked = 1 THEN 4 -- WRONG INFORMATION AND CLOSED ACCOUNT
					ELSE 0 -- UNKNOWN CASE HAPPENED
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
	INSERT INTO registration.LOGINATTEMPTS(Username, Succeeded, IpAddress) 
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
	SELECT
	@ReturnValue AS STATUS,
	@MaxAttempts - @LoginAttempts as RemainingAttempts,
	CASE WHEN @ReturnValue = 2 OR @ReturnValue = 4 THEN 1
	WHEN @MaxAttempts - @LoginAttempts = 0 AND @ReturnValue =3 THEN 1
	ELSE 0 END AS AccountLocked;
	COMMIT TRANSACTION spLogin
END

-- USER UNLOCKING
CREATE OR ALTER  PROCEDURE [registration].[spUnlockUser] @User VARCHAR(50) = 'admin', @Username VARCHAR(50), @PasswordHash VARCHAR(256)
AS
BEGIN
	BEGIN TRANSACTION spUnlockUser
		UPDATE registration.[User] SET IsLocked = 0,LoginAttempts = 0
		WHERE Username = @Username
	COMMIT TRANSACTION spUnlockUser
END
GO