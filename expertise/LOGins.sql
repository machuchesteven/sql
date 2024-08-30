-- CREATE TABLE USERS(
-- 	Username VARCHAR(20) CONSTRAINT PK_USERNAME PRIMARY KEY,
-- 	Password VARCHAR(128) NOT NULL,
-- 	Email VARCHAR(50) CONSTRAINT CK_FOR_EMAIL CHECK (Email LIKE '%@%') CONSTRAINT UN_EMAIL UNIQUE,
-- 	IsLocked BIT DEFAULT 0,
-- 	Created DATETIME DEFAULT GETDATE(),
-- 	Attempts SMALLINT DEFAULT 0
-- 	);
-- GO

-- INSERT INTO USERS (username, Password, Email) VALUES ('og', '12345678', 'og@ogigo');
-- CREATE TABLE LOGINATTEMPTS(
-- 	Username VARCHAR(20),
-- 	AttemptedAt DATETIME DEFAULT GETDATE(),
-- 	Successful BIT,
-- 	IpAddress VARCHAR(10)
-- );

-- GO

-- CREATE OR ALTER PROCEDURE spLogin @Username VARCHAR(20), @Password VARCHAR(128), @IpAddress VARCHAR(10) = NULL
-- AS
-- BEGIN
-- 	DECLARE @ReturnValue TINYINT;
-- 	IF EXISTS (SELECT * FROM USERS WHERE USERNAME = @Username)
-- 	BEGIN
-- 		SELECT @ReturnValue = 
-- 				CASE WHEN Password = @Password AND IsLocked = 0 THEN 1
-- 					WHEN Password = @Password AND IsLocked = 1 THEN 2
-- 					WHEN Password <> @Password AND IsLocked = 0 THEN 3
-- 					WHEN Password <> @Password AND IsLocked = 1 THEN 4
-- 					ELSE 0
-- 				END 
-- 				FROM USERS WHERE Username = @Username
-- 		END
-- 		ELSE IF NOT EXISTS (SELECT * FROM USERS WHERE USERNAME = @Username)
-- 		BEGIN
-- 			SET @ReturnValue = 0
-- 	END
-- 	INSERT INTO LOGINATTEMPTS(Username, Successful, IpAddress) 
-- 		values (
-- 			@Username,
-- 			CASE
-- 				WHEN @ReturnValue = 1 THEN 1
-- 				ELSE 0
-- 			END,
-- 			@IpAddress)
-- 	IF @ReturnValue = 3
-- 	BEGIN
-- 		UPDATE USERS SET Attempts = Attempts + 1 
-- 		WHERE Username = @Username
-- 	END
-- 	select @ReturnValue AS STATUS;
-- END
-- GO


-- exec spLogin @Username = 'machu', @Password = 'demo';
-- exec spLogin @Username ='og', @Password = '12345678';

-- exec spLogin @Username ='og', @Password = '12322245678';

-- GO

-- SELECT * FROM LOGINATTEMPTS;
-- GO

-- SELECT * FROM USERS;
-- GO

-- DELETE LOGINATTEMPTS;
-- GO

-- Revised
CREATE TABLE USERS(
	Username VARCHAR(20) CONSTRAINT PK_USERNAME PRIMARY KEY,
	Password VARCHAR(128) NOT NULL,
	Email VARCHAR(50) CONSTRAINT CK_FOR_EMAIL CHECK (Email LIKE '%@%') CONSTRAINT UN_EMAIL UNIQUE,
	IsLocked BIT DEFAULT 0,
	Created DATETIME DEFAULT GETDATE(),
	Attempts SMALLINT DEFAULT 0
	);
GO

INSERT INTO USERS (username, Password, Email) VALUES ('og', '12345678', 'og@ogigo');
CREATE TABLE LOGINATTEMPTS(
	Username VARCHAR(20),
	AttemptedAt DATETIME DEFAULT GETDATE(),
	Successful BIT,
	IpAddress VARCHAR(10)
);

GO

CREATE OR ALTER PROCEDURE spLogin @Username VARCHAR(20), @Password VARCHAR(128), @IpAddress VARCHAR(10) = NULL
AS
BEGIN
	DECLARE @ReturnValue TINYINT;
	DECLARE @LoginAttempts TINYINT;
	IF EXISTS (SELECT * FROM USERS WHERE USERNAME = @Username)
	BEGIN
		SELECT @ReturnValue = 
				CASE WHEN Password = @Password AND IsLocked = 0 THEN 1
					WHEN Password = @Password AND IsLocked = 1 THEN 2
					WHEN Password <> @Password AND IsLocked = 0 THEN 3
					WHEN Password <> @Password AND IsLocked = 1 THEN 4
					ELSE 0
				END,
				@LoginAttempts =
				CASE 
				-- Add attempts so that it may be easy to know whether to lock the account or not
					WHEN Password <> @Password AND IsLocked = 0 THEN Attempts + 1
					ELSE 0
				END
				FROM USERS WHERE Username = @Username
		END
		ELSE IF NOT EXISTS (SELECT * FROM USERS WHERE USERNAME = @Username)
		BEGIN
			SET @ReturnValue = 0
	END
	INSERT INTO LOGINATTEMPTS(Username, Successful, IpAddress) 
		values (
			@Username,
			CASE
				WHEN @ReturnValue = 1 THEN 1
				ELSE 0
			END,
			@IpAddress)
	IF @ReturnValue = 3
	BEGIN
		UPDATE USERS SET Attempts = Attempts + 1 
		WHERE Username = @Username
	END
	select @ReturnValue AS STATUS, 3 - @LoginAttempts as RemainingAttempts;
END
GO


exec spLogin @Username = 'machu', @Password = 'demo';
exec spLogin @Username ='og', @Password = '12345678';

exec spLogin @Username ='og', @Password = '12322245678';

GO

SELECT * FROM LOGINATTEMPTS;
GO

SELECT * FROM USERS;
GO

DELETE LOGINATTEMPTS;
GO

UPDATE USERS SET ATTEMPTS = 0;

[registration].[spUnlockUser]



CREATE TABLE registration.[LoginMessage](
Id tinyint primary key,
Message varchar(256) not null
);

TRUNCATE TABLE registration.[LoginMessage] ;

insert into registration.[LoginMessage] values 
(1, 'Login Succesful'),
(2, 'The user account is locked, please contact the administrator for support'),
(3, 'Wrong Username or Password'),
(4, 'The user account is locked, please contact the administrator for support'),
(0, 'Wrong Username or Password');