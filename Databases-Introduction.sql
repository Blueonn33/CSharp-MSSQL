-- 1
CREATE DATABASE [Minions]

-- 2
CREATE TABLE [Minions]
(
	[Id] INT PRIMARY KEY,
	[Name] VARCHAR(50) NOT NULL,
	[Age] TINYINT 
);
CREATE TABLE [Towns]
(
	[Id] INT PRIMARY KEY,
	[Name] VARCHAR(100) NOT NULL
);

-- 3
ALTER TABLE [Minions]
ADD [TownId] INT FOREIGN KEY REFERENCES [Towns]([Id]) NOT NULL

-- 4
INSERT INTO [Towns]([Id], [Name])
VALUES (1, 'Sofia'),
	   (2, 'Plovdiv'),
	   (3, 'Varna');
INSERT INTO [Minions]([Id], [Name], [Age], [TownId])
VALUES (1, 'Kevin', 22, 1),
	   (2, 'Bob', 15, 3),
	   (3, 'Steward', NULL , 2);

-- 5
TRUNCATE TABLE [Minions]

-- 6 
DROP TABLE [Minions]
DROP TABLE [Towns]

-- 7 

-- 8
-- CHECK Constraint: User-defined rule for the value in a column/s
CREATE TABLE [Users] 
(
	[Id] BIGINT PRIMARY KEY	IDENTITY(1, 1),
	[Name] VARCHAR(30) UNIQUE NOT NULL,
	[Password] VARCHAR(26) NOT NULL,
	[ProfilePicture] VARBINARY(MAX),
	CHECK(LEN([ProfilePicture]) <= 921600), -- Up to 900KB
	[LastLoginTime] DATETIME2,
	[IsDeleted] BIT NOT NULL
);

-- 9

-- 10

-- 11

-- 12

-- 13

-- 14

-- 15

-- 16

-- 17