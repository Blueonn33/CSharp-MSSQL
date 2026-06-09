CREATE DATABASE LibraryDB_ExamPrep
USE LibraryDB_ExamPrep

-- 01
CREATE TABLE Genres
(
	Id INT PRIMARY KEY IDENTITY(1, 1),
	[Name] NVARCHAR(30) NOT NULL,
);

CREATE TABLE Contacts
(
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Email NVARCHAR(100),
	PhoneNumber NVARCHAR(20),
	PostAddress NVARCHAR(200),
	Website NVARCHAR(50)
);