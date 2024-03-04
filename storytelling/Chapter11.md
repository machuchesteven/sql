# Dealing with Dates and Times

```SQL
SELECT CAST(GETDATE() AS DATE)


SELECT CAST('2024-02-12' AS DATE)

SELECT CONVERT(DATE, GETDATE())


SELECT DATEPART(DAY, GETDATE())


SELECT DAY(GETDATE())

```

Query to cleansen to get the values required from the database

```sql

USE [ATTENDANCEDB]
GO
/****** Object:  StoredProcedure [reports].[spGetLast14DaysAttendances]    Script Date: 14/02/2024 19:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER procedure [reports].[spGetLastDaysAttendances] @NumDays INT = 14, @date DATE = '2024-02-14'
as
begin

-- should be selected from a settings schema
DECLARE @logicLateHour INT = 8;
DECLARE @cols AS NVARCHAR(MAX);
DECLARE @query AS NVARCHAR(MAX);

WITH FirstIn AS (
    SELECT
        Username,
        CAST(CapturedTime AS DATE) AS CaptureDate,
        CapturedTime,
        ROW_NUMBER() OVER (PARTITION BY Username, CAST(CapturedTime AS DATE) ORDER BY CapturedTime) AS RowNum
    FROM
        [ATTENDANCEDB].[attendance].[Attendance]
    WHERE
        IsAllowed = 1 AND IsEntering = 1
),
LastOut AS (
    SELECT
        Username,
        CAST(CapturedTime AS DATE) AS CaptureDate,
        CapturedTime,
        ROW_NUMBER() OVER (PARTITION BY Username, CAST(CapturedTime AS DATE) ORDER BY CapturedTime DESC) AS RowNum
    FROM
        [ATTENDANCEDB].[attendance].[Attendance]
    WHERE
        IsAllowed = 1 AND IsEntering = 0
),
Intime as (
    SELECT
        Username,
        CaptureDate,
        CapturedTime AS FirstIn
    FROM
        FirstIn
    WHERE
        RowNum = 1
),
OutTime AS (
    SELECT
        Username,
        CaptureDate,
        CapturedTime AS LastOut
    FROM
        LastOut
    WHERE
        RowNum = 1
),
Calculated as (
    SELECT
        IT.Username,
        IT.CaptureDate,
        IT.FirstIn,
        CASE
            WHEN OT.LastOut IS NULL THEN CONVERT(datetime, CONVERT(date, IT.CaptureDate)) + ' 23:59:59'
            ELSE OT.LastOut
        END AS LastOut,
        ISNULL(DATEDIFF(HOUR, IT.FirstIn, OT.LastOut), 0) AS TimeUsed,
        CASE
            WHEN OT.LastOut IS NULL THEN 'System'
            WHEN DATEDIFF(HOUR, IT.FirstIn, OT.LastOut) >= @logicLateHour THEN 'Complete'
            ELSE 'Partially'
        END AS Status
    FROM
        Intime IT
    LEFT JOIN
        OutTime OT ON OT.Username = IT.Username AND OT.CaptureDate = IT.CaptureDate
),
DateRange AS (
    SELECT CONVERT(DATE, DATEADD(DAY, -1, @date)) AS Date, 1 AS DayCount
    UNION ALL
    SELECT CONVERT(DATE, DATEADD(DAY, -1, Date)), DayCount + 1
    FROM DateRange
    WHERE DayCount < @NumDays
),
CrossJoinUserDate AS (
    SELECT
        u.[Username],
        u.[FirstName],
        u.[LastName],
        dr.[Date]
    FROM
        [ATTENDANCEDB].[registration].[User] u
    CROSS JOIN
        DateRange dr
),
TheData AS (
    SELECT
        CONCAT(cjd.FirstName,' ', cjd.LastName) AS Name,
        cjd.Date,
        ISNULL(cd.Status, 'Absent') AS Status
    FROM
        CrossJoinUserDate cjd
    LEFT JOIN
        Calculated cd ON cjd.Username = cd.Username AND cjd.Date = cd.CaptureDate
)

-- Insert data from TheData CTE into a temporary table
SELECT *
INTO #TempTheData
FROM TheData;

-- Generate a comma-separated list of dates for pivoting
SELECT @cols = COALESCE(@cols + ', ','') + QUOTENAME(CONVERT(varchar, Date, 106))
FROM (SELECT DISTINCT Date FROM #TempTheData) AS DateList
ORDER BY Date;

-- Dynamic SQL to pivot the data
SET @query =
    'SELECT Name, ' + @cols + '
    FROM (
        SELECT Name, Date, Status
        FROM #TempTheData
    ) AS SourceTable
    PIVOT (
        MAX(Status)
        FOR Date IN (' + @cols + ')
    ) AS PivotTable';

EXEC(@query);

-- Drop the temporary table
DROP TABLE #TempTheData;

end

```

the query to customize tonight

```sql

EXECUTE  [reports].[spGetLastDaysAttendances]

```
