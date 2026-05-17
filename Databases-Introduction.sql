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
CREATE TABLE [People]
(
		[Id] INT PRIMARY KEY IDENTITY(1, 1),
	  [Name] NVARCHAR(200) NOT NULL,
   [Picture] VARBINARY(MAX) NULL,
			 CHECK(LEN([Picture]) <= 2097152), -- Up to 2048KB
	[Height] DECIMAL(3, 2) NULL,
	[Weight] DECIMAL(5, 2) NULL,
	[Gender] CHAR(1) NOT NULL,
			 CHECK([Gender] IN ('m', 'f')),
  [Birthday] DATE NOT NULL,
 [Biography] NVARCHAR(MAX) NULL
);
INSERT INTO People ([Name], [Picture], [Height], [Weight], [Gender], [Birthday], [Biography])
VALUES
('Ivan Petrov', NULL, 1.82, 82.50, 'm', '1990-04-12', 'Ivan is a software engineer who loves hiking.'),
('Maria Georgieva', NULL, 1.67, 58.20, 'f', '1995-09-30', 'Maria is a graphic designer and photographer.'),
('Georgi Dimitrov', NULL, 1.75, 76.10, 'm', '1988-01-22', 'Georgi works as a fitness trainer.'),
('Elena Stoyanova', NULL, 1.60, 52.00, 'f', '1992-06-18', 'Elena is a teacher who enjoys reading and traveling.'),
('Petar Ivanov', NULL, 1.90, 90.30, 'm', '1985-11-05', 'Petar is a musician and plays the guitar.');

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
INSERT INTO [Users] ([Name], [Password], [ProfilePicture], [LastLoginTime], [IsDeleted]) 
VALUES
('martin', 'Pass1234!', 0xFFD8FFE0, '2026-05-16 10:15:00', 0),
('alex', 'Qwerty2026$', 0x89504E47, '2026-05-15 18:40:00', 0),
('sara', 'MySecretKey#1', 0x47494638, '2026-05-14 09:05:00', 0),
('john', 'SecurePass_99', 0x25504446, '2026-05-10 22:30:00', 1),
('emily', 'AlphaBetaGamma12', 0x424D36, '2026-05-12 14:20:00', 0);

-- 9
ALTER TABLE [Users]
DROP CONSTRAINT [PK__Users__5523B448D1C603DF]

--Composite Primary key: Unique Combination of several columns forming PK
ALTER TABLE	[Users]
ADD CONSTRAINT [PK_Users_Id_Name] PRIMARY KEY([Id], [Name])

-- 10
ALTER TABLE [Users]
ADD CONSTRAINT [CK_Password_Min_Length_5] CHECK(LEN([Password]) >= 5)

-- 11
ALTER TABLE [Users]
ADD CONSTRAINT [DF_LastLoginTime_Now] DEFAULT(GETDATE()) FOR [LastLoginTime]

-- 12
ALTER TABLE [Users]
DROP CONSTRAINT [PK_Users_Id_Name]
ALTER TABLE [Users]
ADD CONSTRAINT [PK_Users_Id] PRIMARY KEY([Id])
ALTER TABLE [Users]
ADD CONSTRAINT [UQ_Users_Name] UNIQUE([Name])

-- 13
CREATE DATABASE [Movies]

CREATE TABLE [Directors]
(
	[Id] INT PRIMARY KEY IDENTITY(1, 1),
	[DirectorName] NVARCHAR(60) NOT NULL,
	[Notes]	NVARCHAR(500),
);

CREATE TABLE [Genres]
(
	[Id] INT PRIMARY KEY IDENTITY(1, 1),
	[GenreName] NVARCHAR(50) NOT NULL,
	[Notes] NVARCHAR(500)
);

CREATE TABLE [Categories]
(
	[Id] INT PRIMARY KEY IDENTITY(1, 1),
	[CategoryName] NVARCHAR(50) NOT NULL,
	[Notes]	NVARCHAR(500)
);

CREATE TABLE [Movies]
(
	[Id] INT PRIMARY KEY IDENTITY(1, 1),
	[Title] NVARCHAR(100) NOT NULL,
	[DirectorId] INT FOREIGN KEY REFERENCES [Directors](Id),
	[CopyrightYear] DATE NOT NULL,
	[Length] TINYINT NOT NULL,
	[GenreId] INT FOREIGN KEY REFERENCES [Genres](Id),
	[CategoryId] INT FOREIGN KEY REFERENCES [Categories](Id),
	[Rating] TINYINT,
	[Notes] NVARCHAR(500)
);

INSERT INTO Directors (DirectorName, Notes)
VALUES
('Steven Spielberg', 'Famous for adventure and sci-fi films.'),
('Christopher Nolan', 'Known for complex narratives.'),
('Quentin Tarantino', 'Stylized violence and nonlinear storytelling.'),
('James Cameron', 'Blockbuster director and innovator.'),
('Peter Jackson', 'Director of The Lord of the Rings trilogy.');

INSERT INTO Genres (GenreName, Notes)
VALUES
('Action', 'High intensity and dynamic scenes.'),
('Drama', 'Character-driven emotional stories.'),
('Comedy', 'Light-hearted and humorous.'),
('Sci-Fi', 'Speculative futuristic concepts.'),
('Fantasy', 'Magical worlds and mythical elements.');

INSERT INTO Categories (CategoryName, Notes)
VALUES
('Blockbuster', 'High-budget mainstream films.'),
('Indie', 'Independent low-budget productions.'),
('Classic', 'Older influential films.'),
('Family', 'Suitable for all ages.'),
('Award-Winning', 'Recognized by major film awards.');

INSERT INTO Movies (Title, DirectorId, CopyrightYear, Length, GenreId, CategoryId, Rating, Notes)
VALUES
('Jurassic Park', 1, '1993-01-01', 127, 1, 1, 9, 'Classic Spielberg adventure.'),
('Inception', 2, '2010-01-01', 148, 4, 1, 10, 'Mind-bending sci-fi thriller.'),
('Pulp Fiction', 3, '1994-01-01', 154, 2, 3, 9, 'Cult classic with nonlinear plot.'),
('Avatar', 4, '2009-01-01', 162, 4, 1, 8, 'Revolutionary visual effects.'),
('The Lord of the Rings: The Fellowship of the Ring', 5, '2001-01-01', 178, 5, 5, 10, 'Epic fantasy adventure.');

-- 14

-- 15

-- 16

-- 17

-- 18

-- 19
SELECT * 
  FROM [Towns]
SELECT * 
  FROM [Departments]
SELECT * 
  FROM [Employees]

-- 20
  SELECT * 
    FROM [Towns]
ORDER BY [Name]
  SELECT * 
    FROM [Departments]
ORDER BY [Name]
  SELECT * 
    FROM [Employees]
ORDER BY [Salary]
	DESC

-- 21
  SELECT [Name] 
    FROM [Towns]
ORDER BY [Name]
  SELECT [Name] 
    FROM [Departments]
ORDER BY [Name]
  SELECT [FirstName],
		 [LastName],
		 [JobTitle],
		 [Salary]
    FROM [Employees]
ORDER BY [Salary]
	DESC

-- 22
/* ALTER VS UPDATE
	1. ALTER - Used for changing the structure of the tables
	and other DB objects (TABLE, COLUMN, DataType, CONSTRAINT)

	2. UPDATE - Used for updating the value for defined column
	for defined (ALL) rows. (Row, Entities in TABLE)
	Note: UPDATE changes the data inside the table, while
	ALTER changes the rules for the data in the database
*/

-- Salary + 10% <=> Salary + (Salary * 10/100)
-- <=> Salary += Salary * 0.1

UPDATE [Employees]
   SET [Salary] += ([Salary] * 0.1)

SELECT [Salary]
  FROM [Employees]

-- 23

-- 24