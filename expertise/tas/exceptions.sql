CREATED BY   : Shitindi Ndinao
CREATE DATE  : January 06, 2023
MODIFIED BY  :
MODIFIED DATE:
DESCRIPTION  : Stored procedure for updating that client notified for Ids collection
*/
ALTER PROC  [management].[uspPersoInsertApplicantBiometric]
@ApplicationID int,
@ApplicantList type_zanid_data  readonly
AS
DECLARE @StatusCode int=0, @AffectedRows int=0;
BEGIN TRY
	
END TRY
BEGIN CATCH
IF @@TRANCOUNT > 0
	ROLLBACK TRANSACTION

SET @AffectedRows = 0;
SET @StatusCode = ERROR_NUMBER() 
DECLARE @Msg VARCHAR(MAX) = ERROR_MESSAGE();
EXEC [authorization] . uspLoggingLogSQLError NULL, @StatusCode,@Msg , 'management.uspPersoInsertApplicantBiometric' 
--ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
SELECT @AffectedRows;

RETURN @StatusCode;




USE [crvs_db]
GO

/****** Object:  Table [authorization].[tbl_error_logs]    Script Date: 5/13/2024 3:21:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [authorization].[tbl_error_logs](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NULL,
	[sql_principal] [varchar](100) NULL,
	[object_name] [varchar](100) NOT NULL,
	[error_id] [int] NOT NULL,
	[error_message] [nvarchar](max) NULL,
	[created_date] [datetime] NULL,
	[portal_type] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [authorization].[tbl_error_logs] ADD  CONSTRAINT [DF_tbl_error_logs_application]  DEFAULT ((1)) FOR [portal_type]
GO

ALTER TABLE [authorization].[tbl_error_logs]  WITH CHECK ADD  CONSTRAINT [FK_tbl_error_logs_tbl_portal_type] FOREIGN KEY([portal_type])
REFERENCES [lookup].[tbl_portal_type] ([type_id])
GO

ALTER TABLE [authorization].[tbl_error_logs] CHECK CONSTRAINT [FK_tbl_error_logs_tbl_portal_type]
GO



-- FORMAT FOR SPS
USE [crvs_db]
GO
/****** Object:  StoredProcedure [dbo].[uspLoggingLogSQLError]    Script Date: 5/13/2024 3:22:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
CREATED BY   : Shitindi Ndinao
CREATE DATE  : July 11, 2022
MODIFIED BY  :
MODIFIED DATE:
DESCRIPTION  : Stored procedure for Logging SQL errors
*/

ALTER PROCEDURE [dbo].[uspLoggingLogSQLError]
@UserId int,					--User excecuting the object
@ErrorId int,					--SQL Server error ID
@ErrorMessage varchar(max),		--SQL Server error message
@ObjectName   varchar(100)		--Ojbect reaised the error.
AS
DECLARE @Principal AS VARCHAR(100) = ORIGINAL_LOGIN();   -- Get original user executing the object

BEGIN TRY
INSERT INTO [authorization] .tbl_error_logS([user_id] , sql_principal ,[object_name], error_id , [error_message] , created_date )
VALUES(@UserId , @Principal , @ObjectName , @ErrorId , @ErrorMessage , GETDATE ())
END TRY
BEGIN CATCH

END CATCH


--- SELF IMPLEMENTED EXCEPTIONS LEARNING
CREATE TABLE ErrorLogs(
Id BIGINT IDENTITY(1,1),
ErrorLine SMALLINT,
ErrMessage VARCHAR(400),
Severity INT,
ErState INT,
ErrDate DATETIME,
ErrNumber INT,
Username VARCHAR(50)
);
GO

CREATE PROC spLogError @User VARCHAR(50)
AS
BEGIN
INSERT INTO ErrorLogs(
ErrorLine, ErrMessage, Severity, ErState, ErrDate, ErrNumber, Username)
SELECT 
ERROR_LINE() AS ErrorLine,
ERROR_MESSAGE() AS ErrMessage,
ERROR_SEVERITY() AS Severity,
ERROR_STATE() AS ErState,
GETDATE() AS ErrDate,
ERROR_NUMBER() AS ErrNumber,
@User AS ErrUser
END
GO

BEGIN TRY
DECLARE @StatusCode int;
DECLARE @USER VARCHAR(50) = 'JSTEVEN';
SELECT 1/0 AS errod_value;
set @StatusCode = 200;
-- SELECT @StatusCode,'SUCCESS' AS MESSAGE;
END TRY
BEGIN CATCH
EXEC spLogError @USER
set @StatusCode = 500;
SELECT @StatusCode AS STATUS, ERROR_MESSAGE() AS MESSAGE;
END CATCH
RETURN -- @StatusCode
GO

SELECT * FROM ErrorLogs;
GO


---- the rest
CREATE TABLE ErrorLogs(
Id BIGINT IDENTITY(1,1),
ErrorLine SMALLINT,
ErrMessage VARCHAR(400),
Severity INT,
ErState INT,
ErrDate DATETIME,
ErrNumber INT,
Username VARCHAR(50)
);
GO

CREATE OR ALTER PROC spLogError @User VARCHAR(50)
AS
BEGIN
INSERT INTO ErrorLogs(
ErrorLine, ErrMessage, Severity, ErState, ErrDate, ErrNumber, Username)
SELECT 
ERROR_LINE() AS ErrorLine,
ERROR_MESSAGE() AS ErrMessage,
ERROR_SEVERITY() AS Severity,
ERROR_STATE() AS ErState,
GETDATE() AS ErrDate,
ERROR_NUMBER() AS ErrNumber,
@User AS ErrUser;
RETURN 500;
END
GO

BEGIN TRY
DECLARE @StatusCode int;
DECLARE @Msg VARCHAR(400);
DECLARE @USER VARCHAR(50) = 'JSTEVEN';
exeC spUnknown;
END TRY
BEGIN CATCH
EXEC spLogError @USER;
SET @Msg = ERROR_MESSAGE();
RAISERROR (@Msg, 16,1, 200);
END CATCH
GO
SELECT * FROM ErrorLogs;
GO


