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