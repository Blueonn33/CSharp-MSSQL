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
	PassportID INT FOREIGN KEY REFERENCES Passports(PassportID)
);