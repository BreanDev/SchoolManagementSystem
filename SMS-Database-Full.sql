-- ============================================
-- SCHOOL MANAGEMENT SYSTEM - DATABASE SCRIPT
-- SQL Server 2019+
-- Currency: Zambian Kwacha (ZMW)
-- ============================================

USE [master]
GO

-- ============================================
-- 1. CREATE DATABASE
-- ============================================
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'SchoolManagementSystem')
BEGIN
    CREATE DATABASE SchoolManagementSystem;
END
GO

USE SchoolManagementSystem
GO

-- ============================================
-- 2. DROP EXISTING TABLES (if exists)
-- ============================================
IF OBJECT_ID('dbo.AuditLogs', 'U') IS NOT NULL DROP TABLE dbo.AuditLogs;
IF OBJECT_ID('dbo.BackupHistory', 'U') IS NOT NULL DROP TABLE dbo.BackupHistory;
IF OBJECT_ID('dbo.UserForm', 'U') IS NOT NULL DROP TABLE dbo.UserForm;
IF OBJECT_ID('dbo.SystemConfiguration', 'U') IS NOT NULL DROP TABLE dbo.SystemConfiguration;
IF OBJECT_ID('dbo.Menu', 'U') IS NOT NULL DROP TABLE dbo.Menu;
IF OBJECT_ID('dbo.UserProfile', 'U') IS NOT NULL DROP TABLE dbo.UserProfile;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;
IF OBJECT_ID('dbo.Examination', 'U') IS NOT NULL DROP TABLE dbo.Examination;
IF OBJECT_ID('dbo.ContinuousAssessment', 'U') IS NOT NULL DROP TABLE dbo.ContinuousAssessment;
IF OBJECT_ID('dbo.GradeDetails', 'U') IS NOT NULL DROP TABLE dbo.GradeDetails;
IF OBJECT_ID('dbo.StudentBalance', 'U') IS NOT NULL DROP TABLE dbo.StudentBalance;
IF OBJECT_ID('dbo.Transactions', 'U') IS NOT NULL DROP TABLE dbo.Transactions;
IF OBJECT_ID('dbo.StudentDetails', 'U') IS NOT NULL DROP TABLE dbo.StudentDetails;
IF OBJECT_ID('dbo.GradeSubjectAllocation', 'U') IS NOT NULL DROP TABLE dbo.GradeSubjectAllocation;
IF OBJECT_ID('dbo.Subject', 'U') IS NOT NULL DROP TABLE dbo.Subject;
IF OBJECT_ID('dbo.Fees', 'U') IS NOT NULL DROP TABLE dbo.Fees;
IF OBJECT_ID('dbo.Grade', 'U') IS NOT NULL DROP TABLE dbo.Grade;
IF OBJECT_ID('dbo.GradeLevel', 'U') IS NOT NULL DROP TABLE dbo.GradeLevel;
IF OBJECT_ID('dbo.Semester', 'U') IS NOT NULL DROP TABLE dbo.Semester;
IF OBJECT_ID('dbo.AcademicYear', 'U') IS NOT NULL DROP TABLE dbo.AcademicYear;
IF OBJECT_ID('dbo.TransactionType', 'U') IS NOT NULL DROP TABLE dbo.TransactionType;
IF OBJECT_ID('dbo.PaymentType', 'U') IS NOT NULL DROP TABLE dbo.PaymentType;
IF OBJECT_ID('dbo.PaymentCategory', 'U') IS NOT NULL DROP TABLE dbo.PaymentCategory;
IF OBJECT_ID('dbo.RegistrationNumber', 'U') IS NOT NULL DROP TABLE dbo.RegistrationNumber;
IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL DROP TABLE dbo.Employee;
IF OBJECT_ID('dbo.EmployeeType', 'U') IS NOT NULL DROP TABLE dbo.EmployeeType;
IF OBJECT_ID('dbo.Position', 'U') IS NOT NULL DROP TABLE dbo.Position;
IF OBJECT_ID('dbo.Qualification', 'U') IS NOT NULL DROP TABLE dbo.Qualification;
IF OBJECT_ID('dbo.Department', 'U') IS NOT NULL DROP TABLE dbo.Department;
IF OBJECT_ID('dbo.Branch', 'U') IS NOT NULL DROP TABLE dbo.Branch;
IF OBJECT_ID('dbo.Bank', 'U') IS NOT NULL DROP TABLE dbo.Bank;
IF OBJECT_ID('dbo.ErrorLogs', 'U') IS NOT NULL DROP TABLE dbo.ErrorLogs;
IF OBJECT_ID('dbo.SchoolDetails', 'U') IS NOT NULL DROP TABLE dbo.SchoolDetails;
IF OBJECT_ID('dbo.Town', 'U') IS NOT NULL DROP TABLE dbo.Town;
IF OBJECT_ID('dbo.Province', 'U') IS NOT NULL DROP TABLE dbo.Province;
IF OBJECT_ID('dbo.Nationality', 'U') IS NOT NULL DROP TABLE dbo.Nationality;
IF OBJECT_ID('dbo.StudyCategory', 'U') IS NOT NULL DROP TABLE dbo.StudyCategory;
GO

-- ============================================
-- 3. CREATE LOOKUP TABLES
-- ============================================

-- Nationality
CREATE TABLE Nationality (
    ID INT PRIMARY KEY IDENTITY(1,1),
    NationalityName NVARCHAR(200) NOT NULL,
    NationalityCode NVARCHAR(20) NOT NULL UNIQUE,
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);

-- Province
CREATE TABLE Province (
    ID INT PRIMARY KEY IDENTITY(1,1),
    ProvinceName NVARCHAR(100) NOT NULL,
    NationalityID INT NOT NULL,
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (NationalityID) REFERENCES Nationality(ID)
);

-- Town
CREATE TABLE Town (
    ID INT PRIMARY KEY IDENTITY(1,1),
    TownName NVARCHAR(100) NOT NULL,
    ProvinceID INT NOT NULL,
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ProvinceID) REFERENCES Province(ID)
);

-- School Details
CREATE TABLE SchoolDetails (
    ID INT PRIMARY KEY IDENTITY(1,1),
    SchoolName NVARCHAR(200) NOT NULL,
    Location NVARCHAR(200) NOT NULL,
    BoxNumber NVARCHAR(100),
    Email NVARCHAR(200),
    Mobile NVARCHAR(20),
    Telephone NVARCHAR(20),
    ProvinceID INT NOT NULL,
    TownID INT NOT NULL,
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ProvinceID) REFERENCES Province(ID),
    FOREIGN KEY (TownID) REFERENCES Town(ID)
);

-- Bank
CREATE TABLE Bank (
    ID INT PRIMARY KEY IDENTITY(1,1),
    AccountDetail NVARCHAR(100) NOT NULL,
    AccountNo NVARCHAR(100) NOT NULL,
    BankName NVARCHAR(100) NOT NULL,
    Branch NVARCHAR(100) NOT NULL,
    Location NVARCHAR(200) NOT NULL,
    BranchCode NVARCHAR(100),
    SortCode NVARCHAR(100),
    SwiftCode NVARCHAR(100),
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1
);

-- Branch
CREATE TABLE Branch (
    ID INT PRIMARY KEY IDENTITY(1,1),
    BranchName NVARCHAR(100) NOT NULL,
    SchoolID INT NOT NULL,
    ProvinceID INT NOT NULL,
    TownID INT NOT NULL,
    Location NVARCHAR(200) NOT NULL,
    ManagerID INT,
    PhoneNumber NVARCHAR(20),
    Email NVARCHAR(100),
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (SchoolID) REFERENCES SchoolDetails(ID),
    FOREIGN KEY (ProvinceID) REFERENCES Province(ID),
    FOREIGN KEY (TownID) REFERENCES Town(ID)
);

-- Department
CREATE TABLE Department (
    ID INT PRIMARY KEY IDENTITY(1,1),
    DeptName NVARCHAR(200) NOT NULL,
    BranchID INT,
    Email NVARCHAR(200),
    Mobile NVARCHAR(20),
    Telephone NVARCHAR(20),
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (BranchID) REFERENCES Branch(ID)
);

-- Study Category
CREATE TABLE StudyCategory (
    ID INT PRIMARY KEY IDENTITY(1,1),
    StudyCategory NVARCHAR(200) NOT NULL,
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);

-- Academic Year
CREATE TABLE AcademicYear (
    ID INT PRIMARY KEY IDENTITY(1,1),
    AcademicDescription NVARCHAR(20) NOT NULL,
    StartDate DATETIME,
    EndDate DATETIME,
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);

-- Grade Level
CREATE TABLE GradeLevel (
    ID INT PRIMARY KEY IDENTITY(1,1),
    GradeLevelDescription NVARCHAR(200),
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);

-- Semester
CREATE TABLE Semester (
    ID INT PRIMARY KEY IDENTITY(1,1),
    SemesterDescription NVARCHAR(50),
    StartDate DATETIME,
    EndDate DATETIME,
    BranchID INT NOT NULL,
    AcademicYearID INT NOT NULL,
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (BranchID) REFERENCES Branch(ID),
    FOREIGN KEY (AcademicYearID) REFERENCES AcademicYear(ID)
);

-- Grade
CREATE TABLE Grade (
    ID INT PRIMARY KEY IDENTITY(1,1),
    GradeName NVARCHAR(100) NOT NULL,
    BranchID INT NOT NULL,
    GradeLevelID INT NOT NULL,
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (BranchID) REFERENCES Branch(ID),
    FOREIGN KEY (GradeLevelID) REFERENCES GradeLevel(ID)
);

-- Subject
CREATE TABLE Subject (
    ID INT PRIMARY KEY IDENTITY(1,1),
    SubjectCode NVARCHAR(10) NOT NULL,
    SubjectName NVARCHAR(100) NOT NULL,
    BranchID INT NOT NULL,
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (BranchID) REFERENCES Branch(ID)
);

-- Fees
CREATE TABLE Fees (
    ID INT PRIMARY KEY IDENTITY(1,1),
    BranchID INT NOT NULL,
    GradeLevelID INT NOT NULL,
    Amount DECIMAL(18, 2) NOT NULL,
    FeeDescription NVARCHAR(200) NOT NULL,
    Currency NVARCHAR(3) DEFAULT 'ZMW',
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (BranchID) REFERENCES Branch(ID),
    FOREIGN KEY (GradeLevelID) REFERENCES GradeLevel(ID)
);

-- Grade Subject Allocation
CREATE TABLE GradeSubjectAllocation (
    ID INT PRIMARY KEY IDENTITY(1,1),
    GradeID INT NOT NULL,
    BranchID INT NOT NULL,
    SubjectID INT NOT NULL,
    SemesterID INT NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (GradeID) REFERENCES Grade(ID),
    FOREIGN KEY (BranchID) REFERENCES Branch(ID),
    FOREIGN KEY (SubjectID) REFERENCES Subject(ID),
    FOREIGN KEY (SemesterID) REFERENCES Semester(ID)
);

-- Registration Number Counter
CREATE TABLE RegistrationNumber (
    Year INT PRIMARY KEY,
    Number INT NOT NULL DEFAULT 0,
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);

-- Employee Type
CREATE TABLE EmployeeType (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Description NVARCHAR(150) NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Position
CREATE TABLE Position (
    ID INT PRIMARY KEY IDENTITY(1,1),
    PositionName NVARCHAR(150) NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Qualification
CREATE TABLE Qualification (
    ID INT PRIMARY KEY IDENTITY(1,1),
    QualificationName NVARCHAR(200) NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Employee
CREATE TABLE Employee (
    ID INT PRIMARY KEY IDENTITY(1,1),
    FamilyName NVARCHAR(60) NOT NULL,
    FirstName NVARCHAR(60) NOT NULL,
    OtherName NVARCHAR(60),
    Gender NVARCHAR(50),
    NRCNo NVARCHAR(50) NOT NULL UNIQUE,
    PhoneNumber NVARCHAR(20),
    PositionID INT NOT NULL,
    QualificationID INT NOT NULL,
    DeptID INT NOT NULL,
    EmploymentTypeID INT NOT NULL,
    BranchID INT NOT NULL,
    DateEngaged DATETIME NOT NULL,
    DateExpired DATETIME,
    Email NVARCHAR(100),
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (PositionID) REFERENCES Position(ID),
    FOREIGN KEY (QualificationID) REFERENCES Qualification(ID),
    FOREIGN KEY (DeptID) REFERENCES Department(ID),
    FOREIGN KEY (EmploymentTypeID) REFERENCES EmployeeType(ID),
    FOREIGN KEY (BranchID) REFERENCES Branch(ID)
);

-- Update Branch Manager FK
ALTER TABLE Branch
ADD CONSTRAINT FK_Branch_Manager FOREIGN KEY (ManagerID) REFERENCES Employee(ID);

-- Student Details
CREATE TABLE StudentDetails (
    ID INT PRIMARY KEY IDENTITY(1,1),
    StudentID NVARCHAR(20) NOT NULL UNIQUE,
    BranchID INT NOT NULL,
    FamilyName NVARCHAR(100) NOT NULL,
    FirstName NVARCHAR(100) NOT NULL,
    OtherNames NVARCHAR(200),
    Gender NVARCHAR(50) NOT NULL,
    DOB DATETIME NOT NULL,
    NRCNo NVARCHAR(100),
    Guardian NVARCHAR(100),
    GuardianContact NVARCHAR(200),
    Sponsor NVARCHAR(100),
    SponsorContact NVARCHAR(20),
    MaritalStatus NVARCHAR(10),
    Email NVARCHAR(200),
    Mobile NVARCHAR(100),
    Telephone NVARCHAR(100),
    BoxNo NVARCHAR(100),
    PlotNo NVARCHAR(100),
    Street NVARCHAR(200),
    Area NVARCHAR(50),
    ProvinceID INT NOT NULL,
    TownID INT NOT NULL,
    NationalityID INT NOT NULL,
    GradeID INT NOT NULL,
    GradeLevelID INT NOT NULL,
    StudyCategoryID INT NOT NULL,
    AcademicYearID INT NOT NULL,
    Comment NVARCHAR(500),
    Photo VARBINARY(MAX),
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (BranchID) REFERENCES Branch(ID),
    FOREIGN KEY (ProvinceID) REFERENCES Province(ID),
    FOREIGN KEY (TownID) REFERENCES Town(ID),
    FOREIGN KEY (NationalityID) REFERENCES Nationality(ID),
    FOREIGN KEY (GradeID) REFERENCES Grade(ID),
    FOREIGN KEY (GradeLevelID) REFERENCES GradeLevel(ID),
    FOREIGN KEY (StudyCategoryID) REFERENCES StudyCategory(ID),
    FOREIGN KEY (AcademicYearID) REFERENCES AcademicYear(ID)
);

-- Student Balance
CREATE TABLE StudentBalance (
    ID INT PRIMARY KEY IDENTITY(1,1),
    StudentID NVARCHAR(20) NOT NULL,
    Balance DECIMAL(18, 2) NOT NULL DEFAULT 0,
    Currency NVARCHAR(3) DEFAULT 'ZMW',
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE(),
    UNIQUE(StudentID)
);

-- Grade Details (Registration)
CREATE TABLE GradeDetails (
    ID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT NOT NULL,
    AcademicYearID INT NOT NULL,
    SemesterID INT NOT NULL,
    GradeID INT NOT NULL,
    BranchID INT NOT NULL,
    GradeLevelID INT NOT NULL,
    SubjectID INT NOT NULL,
    ExamMark INT,
    CAMark INT,
    FinalMark INT,
    FinalGrade NVARCHAR(10),
    Comment NVARCHAR(MAX),
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (BranchID) REFERENCES Branch(ID),
    FOREIGN KEY (GradeLevelID) REFERENCES GradeLevel(ID),
    FOREIGN KEY (GradeID) REFERENCES Grade(ID),
    FOREIGN KEY (SubjectID) REFERENCES Subject(ID),
    FOREIGN KEY (StudentID) REFERENCES StudentDetails(ID),
    FOREIGN KEY (AcademicYearID) REFERENCES AcademicYear(ID),
    FOREIGN KEY (SemesterID) REFERENCES Semester(ID)
);

-- Continuous Assessment
CREATE TABLE ContinuousAssessment (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Year NVARCHAR(10),
    StudentID NVARCHAR(20),
    SubjectID INT,
    GradeLevelID INT,
    Mark DECIMAL(18, 2),
    EnterDate DATETIME DEFAULT GETDATE(),
    EnteredBy NVARCHAR(50),
    Comment NVARCHAR(MAX),
    FOREIGN KEY (SubjectID) REFERENCES Subject(ID),
    FOREIGN KEY (GradeLevelID) REFERENCES GradeLevel(ID)
);

-- Examination (Results)
CREATE TABLE Examination (
    ID INT PRIMARY KEY IDENTITY(1,1),
    StudentID NVARCHAR(20) NOT NULL,
    Year NVARCHAR(10) NOT NULL,
    CAMark NVARCHAR(10),
    CloseDate DATETIME DEFAULT GETDATE(),
    Comment NVARCHAR(500),
    EnterDate DATETIME DEFAULT GETDATE(),
    EnteredBy NVARCHAR(100),
    ExamGrade NVARCHAR(10),
    FinalCA NVARCHAR(10),
    FinalGrade NVARCHAR(10),
    ModeratedBy NVARCHAR(100),
    ModeratedDate DATETIME,
    ModeratedGrade NVARCHAR(10),
    Status NVARCHAR(50),
    SubjectID INT NOT NULL,
    FOREIGN KEY (SubjectID) REFERENCES Subject(ID)
);

-- Transaction Type
CREATE TABLE TransactionType (
    ID INT PRIMARY KEY IDENTITY(1,1),
    TransactionName NVARCHAR(100) NOT NULL,
    TransactionCode NVARCHAR(3) NOT NULL UNIQUE,
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);

-- Payment Category
CREATE TABLE PaymentCategory (
    ID INT PRIMARY KEY IDENTITY(1,1),
    PaymentDescription NVARCHAR(150) NOT NULL,
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);

-- Payment Type
CREATE TABLE PaymentType (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Description NVARCHAR(100) NOT NULL,
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);

-- Transactions
CREATE TABLE Transactions (
    ID INT PRIMARY KEY IDENTITY(1,1),
    AccountCode NVARCHAR(100) NOT NULL,
    PaymentCategoryID INT NOT NULL,
    FeeID INT NOT NULL,
    StudentID NVARCHAR(20),
    TranDate DATETIME,
    TranDescription NVARCHAR(100),
    TranReference NVARCHAR(100),
    BatchRef NVARCHAR(10),
    TransactionTypeCode NVARCHAR(3) NOT NULL,
    Amount DECIMAL(18, 2),
    Currency NVARCHAR(3) DEFAULT 'ZMW',
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (FeeID) REFERENCES Fees(ID),
    FOREIGN KEY (TransactionTypeCode) REFERENCES TransactionType(TransactionCode),
    FOREIGN KEY (PaymentCategoryID) REFERENCES PaymentCategory(ID)
);

-- ============================================
-- 4. CREATE SECURITY TABLES
-- ============================================

-- User Profile (Roles)
CREATE TABLE UserProfile (
    ID INT PRIMARY KEY IDENTITY(1,1),
    ProfileName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);

-- Menu Table
CREATE TABLE Menu (
    ID INT PRIMARY KEY IDENTITY(1,1),
    MenuName NVARCHAR(100) NOT NULL,
    MenuUrl NVARCHAR(200),
    MenuIcon NVARCHAR(50),
    ParentMenuID INT,
    Sequence INT DEFAULT 0,
    IsVisible BIT DEFAULT 1,
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ParentMenuID) REFERENCES Menu(ID)
);

-- User Form Permissions
CREATE TABLE UserForm (
    ID INT PRIMARY KEY IDENTITY(1,1),
    MenuID INT NOT NULL,
    ProfileID INT NOT NULL,
    CanAdd BIT DEFAULT 0,
    CanEdit BIT DEFAULT 0,
    CanDelete BIT DEFAULT 0,
    CanView BIT DEFAULT 0,
    CreatedBy NVARCHAR(60),
    ModifiedBy NVARCHAR(60),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (MenuID) REFERENCES Menu(ID),
    FOREIGN KEY (ProfileID) REFERENCES UserProfile(ID)
);

-- Users
CREATE TABLE Users (
    ID INT PRIMARY KEY IDENTITY(1,1),
    ProfileID INT NOT NULL,
    UserName NVARCHAR(100) NOT NULL UNIQUE,
    EmployeeID INT,
    Email NVARCHAR(150) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(MAX) NOT NULL,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    BranchID INT,
    IsActive BIT DEFAULT 1,
    IsLocked BIT DEFAULT 0,
    LastLogin DATETIME,
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME,
    FOREIGN KEY (ProfileID) REFERENCES UserProfile(ID),
    FOREIGN KEY (BranchID) REFERENCES Branch(ID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(ID)
);

-- ============================================
-- 5. CREATE AUDIT & LOGGING TABLES
-- ============================================

-- Audit Logs
CREATE TABLE AuditLogs (
    AuditID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    Action NVARCHAR(100),
    Entity NVARCHAR(100),
    EntityID INT,
    OldValue NVARCHAR(MAX),
    NewValue NVARCHAR(MAX),
    IPAddress NVARCHAR(50),
    Timestamp DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(ID)
);

-- Error Logs
CREATE TABLE ErrorLogs (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Error_Code NVARCHAR(MAX),
    Error_Message NVARCHAR(MAX),
    Error_Source NVARCHAR(MAX),
    ErrorDate NVARCHAR(MAX),
    User_Name NVARCHAR(MAX),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);

-- Backup History
CREATE TABLE BackupHistory (
    BackupID INT PRIMARY KEY IDENTITY(1,1),
    BackupNumber NVARCHAR(50) NOT NULL UNIQUE,
    BackupDate DATETIME DEFAULT GETDATE(),
    BackupType NVARCHAR(20),
    FilePath NVARCHAR(500),
    FileSize BIGINT,
    Status NVARCHAR(20),
    CreatedBy INT,
    Notes NVARCHAR(500),
    FOREIGN KEY (CreatedBy) REFERENCES Users(ID)
);

-- System Configuration
CREATE TABLE SystemConfiguration (
    ConfigID INT PRIMARY KEY IDENTITY(1,1),
    ConfigKey NVARCHAR(100) NOT NULL UNIQUE,
    ConfigValue NVARCHAR(MAX),
    DataType NVARCHAR(50),
    Description NVARCHAR(500),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME
);

-- ============================================
-- 6. CREATE INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX IDX_StudentDetails_StudentID ON StudentDetails(StudentID);
CREATE INDEX IDX_StudentDetails_BranchID ON StudentDetails(BranchID);
CREATE INDEX IDX_StudentDetails_GradeLevelID ON StudentDetails(GradeLevelID);

CREATE INDEX IDX_GradeDetails_StudentID ON GradeDetails(StudentID);
CREATE INDEX IDX_GradeDetails_AcademicYearID ON GradeDetails(AcademicYearID);
CREATE INDEX IDX_GradeDetails_SemesterID ON GradeDetails(SemesterID);

CREATE INDEX IDX_Transactions_StudentID ON Transactions(StudentID);
CREATE INDEX IDX_Transactions_TranDate ON Transactions(TranDate);
CREATE INDEX IDX_Transactions_TransactionTypeCode ON Transactions(TransactionTypeCode);

CREATE INDEX IDX_StudentBalance_StudentID ON StudentBalance(StudentID);

CREATE INDEX IDX_ContinuousAssessment_StudentID ON ContinuousAssessment(StudentID);
CREATE INDEX IDX_ContinuousAssessment_SubjectID ON ContinuousAssessment(SubjectID);

CREATE INDEX IDX_Examination_StudentID ON Examination(StudentID);
CREATE INDEX IDX_Examination_SubjectID ON Examination(SubjectID);

CREATE INDEX IDX_Users_UserName ON Users(UserName);
CREATE INDEX IDX_Users_Email ON Users(Email);
CREATE INDEX IDX_Users_BranchID ON Users(BranchID);

CREATE INDEX IDX_AuditLogs_UserID ON AuditLogs(UserID);
CREATE INDEX IDX_AuditLogs_Timestamp ON AuditLogs(Timestamp);

-- ============================================
-- 7. SEED DATA
-- ============================================

-- Insert Nationality
INSERT INTO Nationality (NationalityName, NationalityCode) VALUES 
('Zambian', 'ZM'),
('British', 'GB'),
('South African', 'ZA');

-- Insert Provinces
INSERT INTO Province (ProvinceName, NationalityID) VALUES 
('Lusaka', 1),
('Copperbelt', 1),
('Northern', 1),
('Eastern', 1);

-- Insert Towns
INSERT INTO Town (TownName, ProvinceID) VALUES 
('Lusaka City', 1),
('Kitwe', 2),
('Ndola', 2),
('Kasama', 3);

-- Insert School Details
INSERT INTO SchoolDetails (SchoolName, Location, BoxNumber, Email, Mobile, Telephone, ProvinceID, TownID) VALUES 
('Brean School', 'Lusaka', 'PO Box 1234', 'info@breanschool.zm', '097123456', '021 123456', 1, 1);

-- Insert Branch
INSERT INTO Branch (BranchName, SchoolID, ProvinceID, TownID, Location, PhoneNumber, Email, IsActive) VALUES 
('Main Branch', 1, 1, 1, 'Lusaka City Centre', '021 123456', 'lusaka@breanschool.zm', 1),
('Copperbelt Branch', 1, 2, 2, 'Ndola', '021 234567', 'ndola@breanschool.zm', 1);

-- Insert Department
INSERT INTO Department (DeptName, BranchID, Email, Mobile, Telephone) VALUES 
('Administration', 1, 'admin@breanschool.zm', '097123456', '021 123456'),
('Sales', 1, 'sales@breanschool.zm', '097234567', '021 234567'),
('Stores', 1, 'stores@breanschool.zm', '097345678', '021 345678'),
('Purchasing', 1, 'purchasing@breanschool.zm', '097456789', '021 456789'),
('ICT', 1, 'ict@breanschool.zm', '097567890', '021 567890');

-- Insert Study Categories
INSERT INTO StudyCategory (StudyCategory) VALUES 
('Full Time'),
('Part Time'),
('Distance Learning');

-- Insert Academic Years
INSERT INTO AcademicYear (AcademicDescription, StartDate, EndDate) VALUES 
('2024', '2024-01-15', '2024-11-30'),
('2025', '2025-01-15', '2025-11-30');

-- Insert Grade Levels
INSERT INTO GradeLevel (GradeLevelDescription) VALUES 
('Primary 1'),
('Primary 2'),
('Primary 3'),
('Primary 4'),
('Primary 5'),
('Primary 6'),
('Grade 7'),
('Grade 8'),
('Grade 9'),
('Grade 10'),
('Grade 11'),
('Grade 12');

-- Insert Grades
INSERT INTO Grade (GradeName, BranchID, GradeLevelID) VALUES 
('Primary 1A', 1, 1),
('Primary 1B', 1, 1),
('Primary 2A', 1, 2),
('Primary 2B', 1, 2),
('Grade 7A', 1, 7),
('Grade 7B', 1, 7),
('Grade 10A', 1, 10),
('Grade 12A', 1, 12);

-- Insert Subjects
INSERT INTO Subject (SubjectCode, SubjectName, BranchID) VALUES 
('MAT', 'Mathematics', 1),
('ENG', 'English', 1),
('SCI', 'Science', 1),
('SST', 'Social Studies', 1),
('ART', 'Art & Design', 1),
('PHE', 'Physical Education', 1),
('BIO', 'Biology', 1),
('CHM', 'Chemistry', 1),
('PHY', 'Physics', 1);

-- Insert Fees
INSERT INTO Fees (BranchID, GradeLevelID, Amount, FeeDescription, Currency) VALUES 
(1, 1, 850000.00, 'Primary 1 Term Fee', 'ZMW'),
(1, 2, 900000.00, 'Primary 2 Term Fee', 'ZMW'),
(1, 7, 1500000.00, 'Grade 7 Term Fee', 'ZMW'),
(1, 10, 2000000.00, 'Grade 10 Term Fee', 'ZMW'),
(1, 12, 2500000.00, 'Grade 12 Term Fee', 'ZMW');

-- Insert Semesters
INSERT INTO Semester (SemesterDescription, StartDate, EndDate, BranchID, AcademicYearID) VALUES 
('Semester 1', '2024-01-15', '2024-04-30', 1, 1),
('Semester 2', '2024-05-01', '2024-08-30', 1, 1),
('Semester 3', '2024-09-01', '2024-11-30', 1, 1),
('Semester 1', '2025-01-15', '2025-04-30', 1, 2),
('Semester 2', '2025-05-01', '2025-08-30', 1, 2),
('Semester 3', '2025-09-01', '2025-11-30', 1, 2);

-- Insert Transaction Types
INSERT INTO TransactionType (TransactionName, TransactionCode) VALUES 
('Payment', 'PAY'),
('Invoice', 'INV'),
('Credit Note', 'CRN');

-- Insert Payment Categories
INSERT INTO PaymentCategory (PaymentDescription) VALUES 
('Tuition Fee'),
('Activity Fee'),
('Transport Fee'),
('Uniform Fee'),
('Other');

-- Insert Employee Types
INSERT INTO EmployeeType (Description) VALUES 
('Full Time'),
('Part Time'),
('Contract'),
('Casual');

-- Insert Positions
INSERT INTO Position (PositionName) VALUES 
('Principal'),
('Deputy Principal'),
('Head of Department'),
('Teacher'),
('Administrator'),
('Finance Officer'),
('Accountant'),
('IT Support');

-- Insert Qualifications
INSERT INTO Qualification (QualificationName) VALUES 
('Bachelor of Science'),
('Bachelor of Arts'),
('Master of Education'),
('Diploma in Education'),
('Advanced Diploma'),
('Certificate');

-- Insert User Profiles (Roles)
INSERT INTO UserProfile (ProfileName, Description) VALUES 
('System Administrator', 'Full system access'),
('Branch Manager', 'Manage branch operations'),
('Finance Officer', 'Manage finances and payments'),
('Teacher', 'Can view and manage student records'),
('Registrar', 'Can manage registrations and results'),
('Administrator', 'General admin staff'),
('Student', 'View own records'),
('Parent', 'View child records');

-- Insert Menus
INSERT INTO Menu (MenuName, MenuUrl, MenuIcon, ParentMenuID, Sequence, IsVisible) VALUES 
('Dashboard', '/dashboard', 'fas fa-home', NULL, 1, 1),
('Students', '/students', 'fas fa-users', NULL, 2, 1),
('Overview', '/students/overview', 'fas fa-eye', 2, 1, 1),
('Add Student', '/students/add', 'fas fa-plus', 2, 2, 1),
('Student Balances', '/students/balances', 'fas fa-balance-scale', 2, 3, 1),
('Exemptions', '/students/exemptions', 'fas fa-check', 2, 4, 1),
('Finances', '/finances', 'fas fa-money-bill', NULL, 3, 1),
('Invoices', '/finances/invoices', 'fas fa-file-invoice', 7, 1, 1),
('Statement', '/finances/statement', 'fas fa-chart-line', 7, 2, 1),
('Registration', '/registration', 'fas fa-book', NULL, 4, 1),
('Add/Remove Subjects', '/registration/subjects', 'fas fa-bookmark', 10, 1, 1),
('Register Student', '/registration/register', 'fas fa-pen', 10, 2, 1),
('Results', '/results', 'fas fa-star', NULL, 5, 1),
('Continuous Assessment', '/results/ca', 'fas fa-list-check', 13, 1, 1),
('Final Results', '/results/final', 'fas fa-file-check', 13, 2, 1),
('Payments', '/payments', 'fas fa-credit-card', NULL, 6, 1),
('Record Payment', '/payments/record', 'fas fa-plus-circle', 16, 1, 1),
('Payment History', '/payments/history', 'fas fa-history', 16, 2, 1),
('Curriculum', '/curriculum', 'fas fa-book-open', NULL, 7, 1),
('Staff Members', '/staff', 'fas fa-briefcase', NULL, 8, 1),
('Add Staff', '/staff/add', 'fas fa-user-plus', 20, 1, 1),
('Staff List', '/staff/list', 'fas fa-list', 20, 2, 1),
('Reports', '/reports', 'fas fa-file-pdf', NULL, 9, 1),
('Payment Reports', '/reports/payments', 'fas fa-file-csv', 23, 1, 1),
('Results Slip', '/reports/results-slip', 'fas fa-file-pdf', 23, 2, 1),
('Transcript', '/reports/transcript', 'fas fa-graduation-cap', 23, 3, 1),
('Student Balances Report', '/reports/balances', 'fas fa-chart-bar', 23, 4, 1),
('Student List', '/reports/student-list', 'fas fa-list-alt', 23, 5, 1),
('Fees List', '/reports/fees', 'fas fa-th-list', 23, 6, 1),
('Administration', '/admin', 'fas fa-cogs', NULL, 10, 1),
('Grades', '/admin/grades', 'fas fa-layer-group', 30, 1, 1),
('Subjects', '/admin/subjects', 'fas fa-book', 30, 2, 1),
('Fees Management', '/admin/fees', 'fas fa-coins', 30, 3, 1),
('Academic Years', '/admin/academic-years', 'fas fa-calendar', 30, 4, 1),
('Semesters', '/admin/semesters', 'fas fa-calendar-alt', 30, 5, 1),
('Users', '/admin/users', 'fas fa-user-cog', 30, 6, 1),
('Roles', '/admin/roles', 'fas fa-shield-alt', 30, 7, 1),
('Departments', '/admin/departments', 'fas fa-sitemap', 30, 8, 1),
('Branches', '/admin/branches', 'fas fa-building', 30, 9, 1),
('Menu Management', '/admin/menus', 'fas fa-bars', 30, 10, 1);

-- Insert User Form Permissions for System Admin (View All)
INSERT INTO UserForm (MenuID, ProfileID, CanAdd, CanEdit, CanDelete, CanView)
SELECT m.ID, 1, 1, 1, 1, 1 FROM Menu m;

-- Insert Sample Employee
INSERT INTO Employee (FamilyName, FirstName, OtherName, Gender, NRCNo, PhoneNumber, 
                      PositionID, QualificationID, DeptID, EmploymentTypeID, BranchID, 
                      DateEngaged, Email)
VALUES ('Chimpumimbe', 'Daniel', 'K', 'Male', '456789/10/1', '097123456', 
        1, 1, 1, 1, 1, GETDATE(), 'daniel@breanschool.zm');

-- Insert System Admin User
INSERT INTO Users (ProfileID, UserName, Email, PasswordHash, FirstName, LastName, BranchID, IsActive)
VALUES (1, 'sysadmin', 'admin@breanschool.zm', 
        '$2a$11$WQvTbP7H3kHSqKV7dKM7wOp0t7jdkxk9j5n0k5j6k7j8k9j0k1j2k3', 
        'System', 'Administrator', 1, 1);

-- ============================================
-- 8. CREATE STORED PROCEDURES
-- ============================================

-- Generate Student ID
CREATE PROCEDURE sp_GenerateStudentID
    @AcademicYear INT,
    @StudentID NVARCHAR(20) OUTPUT
AS
BEGIN
    DECLARE @LastNumber INT;
    DECLARE @YearSuffix NVARCHAR(2);
    
    SET @YearSuffix = RIGHT(CAST(@AcademicYear AS NVARCHAR(4)), 2);
    
    BEGIN TRANSACTION;
    
    IF NOT EXISTS (SELECT 1 FROM RegistrationNumber WHERE Year = @AcademicYear)
    BEGIN
        INSERT INTO RegistrationNumber (Year, Number) VALUES (@AcademicYear, 1);
        SET @LastNumber = 1;
    END
    ELSE
    BEGIN
        UPDATE RegistrationNumber 
        SET Number = Number + 1 
        WHERE Year = @AcademicYear;
        
        SELECT @LastNumber = Number FROM RegistrationNumber WHERE Year = @AcademicYear;
    END
    
    SET @StudentID = @YearSuffix + FORMAT(@LastNumber, '00');
    
    COMMIT TRANSACTION;
END
GO

-- Calculate Student Balance
CREATE PROCEDURE sp_CalculateStudentBalance
    @StudentID NVARCHAR(20)
AS
BEGIN
    DECLARE @TotalInvoice DECIMAL(18,2) = 0;
    DECLARE @TotalPayment DECIMAL(18,2) = 0;
    DECLARE @TotalCredit DECIMAL(18,2) = 0;
    DECLARE @Balance DECIMAL(18,2);
    
    SELECT @TotalInvoice = ISNULL(SUM(Amount), 0) 
    FROM Transactions 
    WHERE StudentID = @StudentID AND TransactionTypeCode = 'INV';
    
    SELECT @TotalPayment = ISNULL(SUM(Amount), 0) 
    FROM Transactions 
    WHERE StudentID = @StudentID AND TransactionTypeCode = 'PAY';
    
    SELECT @TotalCredit = ISNULL(SUM(Amount), 0) 
    FROM Transactions 
    WHERE StudentID = @StudentID AND TransactionTypeCode = 'CRN';
    
    SET @Balance = @TotalInvoice - (@TotalPayment + @TotalCredit);
    
    IF NOT EXISTS (SELECT 1 FROM StudentBalance WHERE StudentID = @StudentID)
    BEGIN
        INSERT INTO StudentBalance (StudentID, Balance) VALUES (@StudentID, @Balance);
    END
    ELSE
    BEGIN
        UPDATE StudentBalance SET Balance = @Balance WHERE StudentID = @StudentID;
    END
END
GO

-- Get Payment Statement
CREATE PROCEDURE sp_GetPaymentStatement
    @StudentID NVARCHAR(20)
AS
BEGIN
    SELECT 
        TranDate [Date],
        TranReference [Transaction Reference],
        BatchRef [Batch Reference],
        CASE 
            WHEN TransactionTypeCode = 'PAY' THEN 'Payment'
            WHEN TransactionTypeCode = 'INV' THEN 'Invoice'
            WHEN TransactionTypeCode = 'CRN' THEN 'Credit Note'
        END [Transaction Type],
        TranDescription [Details],
        Amount
    FROM Transactions
    WHERE StudentID = @StudentID
    ORDER BY TranDate DESC;
    
    -- Calculate balance
    EXEC sp_CalculateStudentBalance @StudentID;
    
    SELECT Balance FROM StudentBalance WHERE StudentID = @StudentID;
END
GO

-- Daily Payment Report
CREATE PROCEDURE sp_DailyPaymentReport
    @TransactionDate DATETIME
AS
BEGIN
    SELECT 
        TranDate [Date],
        StudentID,
        TranDescription,
        Amount,
        Currency
    FROM Transactions
    WHERE TransactionTypeCode = 'PAY' 
    AND CAST(TranDate AS DATE) = CAST(@TransactionDate AS DATE)
    ORDER BY TranDate DESC;
    
    SELECT SUM(Amount) [Total Daily Payments] 
    FROM Transactions
    WHERE TransactionTypeCode = 'PAY' 
    AND CAST(TranDate AS DATE) = CAST(@TransactionDate AS DATE);
END
GO

-- Student Balance by Grade
CREATE PROCEDURE sp_StudentBalanceByGrade
    @GradeLevelID INT,
    @AcademicYearID INT
AS
BEGIN
    SELECT 
        sd.StudentID,
        sd.FamilyName + ' ' + sd.FirstName [Student Name],
        gl.GradeLevelDescription [Grade Level],
        sb.Balance,
        sb.Currency
    FROM StudentDetails sd
    INNER JOIN GradeLevel gl ON sd.GradeLevelID = gl.ID
    LEFT JOIN StudentBalance sb ON sd.StudentID = sb.StudentID
    WHERE sd.GradeLevelID = @GradeLevelID 
    AND sd.AcademicYearID = @AcademicYearID
    ORDER BY sd.FamilyName;
END
GO

-- ============================================
-- 9. COMMIT CHANGES
-- ============================================

PRINT 'Database setup completed successfully!'
PRINT 'Tables created with indexes'
PRINT 'Seed data inserted'
PRINT 'Stored procedures created'
GO
