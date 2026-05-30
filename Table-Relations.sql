CREATE DATABASE TableRelations

-- 01
-- Relationship 1:1
-- Rule: FK columns should be UNIQUE
-- 1:1 can be viewed as subcase of 1:N, where all FK are unique
-- Rule: Order of creation/deletion of table

CREATE TABLE Passports
(
	PassportID INT PRIMARY KEY IDENTITY(101, 1),
	PassportNumber CHAR(8) UNIQUE NOT NULL 
);

CREATE TABLE Persons
(
	PersonID INT PRIMARY KEY IDENTITY(1, 1),
	FirstName VARCHAR(50) NOT NULL,
	Salary DECIMAL(8, 2) NOT NULL,
	PassportID INT UNIQUE FOREIGN KEY REFERENCES Passports(PassportID)
);

INSERT INTO Passports (PassportNumber)
	 VALUES 
			('N34FG21B'),
			('K65LO4R7'),
			('ZE657QP2')

select * from Passports
order by PassportID

INSERT INTO Persons (FirstName, Salary, PassportID)
	 VALUES
			('Roberto', 43300.00, 102),
			('Tom', 56100.00, 103),
			('Yana', 60200.00, 101)
			
-- 02
CREATE TABLE Manufacturers
(
	ManufacturerID INT PRIMARY KEY IDENTITY(1, 1),
	[Name] VARCHAR(50) NOT NULL,
	EstablishedOn DATE
);

CREATE TABLE Models
(
	ModelID INT PRIMARY KEY IDENTITY(101, 1),
	[Name] VARCHAR(70) NOT NULL,
	ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID) NOT NULL
);

INSERT INTO Manufacturers ([Name], EstablishedOn)
VALUES 
		('BMW', '1916-03-07'),
		('Tesla', '2003-01-01'),
		('Lada', '1966-05-01')

INSERT INTO Models ([Name], ManufacturerID)
VALUES	
		('X1', 1),
		('i6', 1),
		('Model S', 2),
		('Model X', 2),
		('Model 3', 2),
		('Nova', 3)

-- 03
CREATE TABLE Students
(
	StudentID INT PRIMARY KEY IDENTITY(1, 1),
	[Name] VARCHAR(50) NOT NULL,
);

CREATE TABLE Exams
(
	ExamID INT PRIMARY KEY IDENTITY(101, 1),
	[Name] VARCHAR(100) NOT NULL
);

-- Composite PK: Defines rules for NOT NULL + UNIQUE of 2 FKs
CREATE TABLE StudentsExams
(
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
	ExamID INT FOREIGN KEY REFERENCES Exams(ExamID)
	PRIMARY KEY(StudentID, ExamID)
);

INSERT INTO Students ([Name])
VALUES
		('Mila'),
		('Toni'),
		('Ron')

INSERT INTO Exams ([Name])
VALUES
		('SpringMVC'),
		('Neo4j'),
		('Oracle 11g')

INSERT INTO StudentsExams (StudentID, ExamID)
VALUES	
		(1, 101),
		(1, 102),
		(2, 101),
		(2, 102),
		(2, 103),
		(3, 103)

-- 04
CREATE TABLE Teachers
(
	TeacherID INT PRIMARY KEY IDENTITY(101, 1),
	[Name] VARCHAR(50) NOT NULL,
	ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID) NULL
);

INSERT INTO Teachers ([Name], ManagerID)
	 VALUES
			('John', NULL),
			('Maya', 106),
			('Silvia', 106),
			('Ted', 105),
			('Mark', 101),
			('Greta', 101);

-- 05
CREATE DATABASE OnlineStore
USE OnlineStore

CREATE TABLE Cities
(
	CityID INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL
);

CREATE TABLE ItemTypes
(
	ItemTypeID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
);

-- 06
CREATE DATABASE UniversityDB

CREATE TABLE Subjects
(
	SubjectID INT PRIMARY KEY IDENTITY,
	SubjectName NVARCHAR(100) NOT NULL
);

CREATE TABLE Majors
(
	MajorID INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL
);

CREATE TABLE Students
(
	StudentID INT PRIMARY KEY IDENTITY,
	StudentNumber CHAR(10) UNIQUE NOT NULL,
	StudentName NVARCHAR(80) NOT NULL,
	MajorID INT FOREIGN KEY REFERENCES Majors(MajorID) NOT NULL
);

CREATE TABLE Payments
(
	PaymentID INT PRIMARY KEY IDENTITY,
	PaymentDate DATETIME2 NOT NULL,
	PaymentAmount DECIMAL(9, 4) NOT NULL,
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID) NOT NULL
);

CREATE TABLE Agenda
(
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
	SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID),
	PRIMARY KEY(StudentID, SubjectID)
);