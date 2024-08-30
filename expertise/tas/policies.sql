Create Table attendance.AttendancePolicy(
PolicyId INT CONSTRAINT PK_AttendancePolicy PRIMARY KEY,
Name VARCHAR(100),
IsShift BIT,
IsApplyToAll BIT,
IsActive BIT,
MaxOvertime INT,
OvertimeByHour INT,
IsUseOvertimeCalculation BIT
);
GO

CREATE Table attendance.AttendanceShift(
ShiftId INT CONSTRAINT PK_AttendanceShift PRIMARY KEY,
Name VARCHAR(100),
PolicyId INT,
ShiftStart TIME,
ShiftEnd TIME,
IsActive BIT,
CONSTRAINT FK_AttendanceShift_AttendancePolicy FOREIGN KEY (PolicyId) REFERENCES attendance.AttendancePolicy (PolicyId) ON DELETE CASCADE,
CONSTRAINT CQ_ShiftStart_Before_ShiftEnd CHECK (ShiftEnd > ShiftStart)
);
GO

CREATE Table attendance.ShiftBreak(
ShiftId INT,
BreakName VARCHAR(100),
BreakStart TIME,
BreakeEnd TIME,
MaxBreakTime INT,
CONSTRAINT FK_ShiftBreak_AttendanceShift FOREIGN KEY (ShiftId) REFERENCES attendance.AttendanceShift (ShiftId) ON DELETE CASCADE,
CONSTRAINT PK_ShiftBreak PRIMARY KEY (ShiftId, BreakName),
CONSTRAINT CQ_BreakeEnd_Before_BreakStart CHECK (BreakeEnd > BreakStart)
);
GO

CREATE Table attendance.UserShift(
ShiftId INT CONSTRAINT NN_ShiftId_UserShift NOT NULL,
Username VARCHAR(50) CONSTRAINT NN_Username_UserShift NOT NULL,
ShiftDate DATE,
CONSTRAINT FK_UserShift_AttendanceShift FOREIGN KEY (ShiftId) REFERENCES attendance.AttendanceShift (ShiftId) ON DELETE CASCADE,
CONSTRAINT FK_User_AttendanceShift FOREIGN KEY (Username) REFERENCES registration.[User] (Username)
);
GO