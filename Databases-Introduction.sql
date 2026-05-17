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
CREATE DATABASE [CarRental]

CREATE TABLE [Categories]
(
	[Id] INT PRIMARY KEY IDENTITY(1, 1),
	[CategoryName] NVARCHAR(60) NOT NULL,
	[DailyRate] DECIMAL NOT NULL,
	[WeeklyRate] DECIMAL NOT NULL,
	[MonthlyRate] DECIMAL NOT NULL,
	[WeekendRate] DECIMAL NOT NULL
);

CREATE TABLE [Cars]
(
	[Id] INT PRIMARY KEY IDENTITY(1, 1),
	[PlateNumber] NVARCHAR(20) UNIQUE NOT NULL,
	[Manufacturer] NVARCHAR(60) NOT NULL,
	[Model]	NVARCHAR(60) NOT NULL,
	[CarYear] DATE NOT NULL,
	[CategoryId] INT FOREIGN KEY REFERENCES [Categories](Id),
	[Doors] TINYINT NOT NULL,
	[Picture] VARBINARY(MAX),
	[Condition] BIT NOT NULL,
	[Available] BIT NOT NULL
);

CREATE TABLE [Employees]
(
	[Id] INT PRIMARY KEY IDENTITY(1, 1),
	[FirstName] NVARCHAR(60) NOT NULL,
	[LastName] NVARCHAR(60) NOT NULL,
	[Address] NVARCHAR(100) NOT NULL,
	[City] NVARCHAR(100) NOT NULL,
	[ZIPCode] INT NOT NULL,
	[Notes] NVARCHAR(500)
);

CREATE TABLE [Customers]
(
	[Id] INT PRIMARY KEY IDENTITY(1, 1),
	[DriverLicenseNumber] NVARCHAR(30) UNIQUE NOT NULL,
	[FullName] NVARCHAR(100) NOT NULL,
	[Address] NVARCHAR(100) NOT NULL,
	[City] NVARCHAR(100) NOT NULL,
	[ZIPCode] INT NOT NULL,
	[Notes] NVARCHAR(500)
);

CREATE TABLE [RentalOrders]
(
	[Id] INT PRIMARY KEY IDENTITY(1, 1),
	[EmployeeId] INT FOREIGN KEY REFERENCES [Employees](Id),
	[CustomerId] INT FOREIGN KEY REFERENCES [Customers](Id),
	[CarId] INT FOREIGN KEY REFERENCES [Cars](Id),
	[TankLevel] TINYINT NOT NULL,
	[KilometrageStart] DECIMAL NOT NULL,
	[KilometrageEnd] DECIMAL NOT NULL,
	[TotalKilometrage] DECIMAL NOT NULL,
	[StartDate] DATE NOT NULL,
	[EndDate] DATE NOT NULL,
	[TotalDays] DATE NOT NULL,
	[RateApplied] DECIMAL NOT NULL,
	[TaxRate] DECIMAL NOT NULL,
	[OrderStatus] BIT NOT NULL,
	[Notes] NVARCHAR(500)
);

INSERT INTO Categories (CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
VALUES
('Economy', 25.00, 150.00, 550.00, 40.00),
('SUV', 45.00, 280.00, 1000.00, 70.00),
('Luxury', 80.00, 500.00, 1800.00, 120.00);

INSERT INTO Cars (PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Picture, Condition, Available)
VALUES
('BT1234AB', 'Toyota', 'Yaris', '2018-01-01', 1, 4, NULL, 1, 1),
('CT5678AC', 'Honda', 'CR-V', '2020-01-01', 2, 5, NULL, 1, 1),
('CA9999BB', 'BMW', '530d', '2019-01-01', 3, 4, NULL, 1, 0);

INSERT INTO Employees (FirstName, LastName, Address, City, ZIPCode, Notes)
VALUES
('Ivan', 'Petrov', 'Ul. Shipka 12', 'Sofia', 1000, 'Senior employee'),
('Maria', 'Dimitrova', 'Ul. Vitosha 45', 'Plovdiv', 4000, 'Part-time'),
('Georgi', 'Nikolov', 'Ul. Dunav 7', 'Varna', 9000, 'New hire');

INSERT INTO Customers (DriverLicenseNumber, FullName, Address, City, ZIPCode, Notes)
VALUES
('DL123456', 'Petar Ivanov', 'Ul. Slivnitsa 10', 'Sofia', 1000, 'Regular customer'),
('DL654321', 'Elena Stoyanova', 'Ul. Trakia 22', 'Burgas', 8000, 'VIP'),
('DL987654', 'Kiril Georgiev', 'Ul. Ohrid 5', 'Ruse', 7000, 'First rental');

INSERT INTO RentalOrders
(EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd, TotalKilometrage,
 StartDate, EndDate, TotalDays, RateApplied, TaxRate, OrderStatus, Notes)
VALUES
(1, 1, 1, 80, 15000, 15200, 200, '2024-01-05', '2024-01-07', '2024-01-07', 50.00, 0.20, 1, 'Weekend rental'),
(2, 2, 2, 90, 30000, 30550, 550, '2024-02-10', '2024-02-17', '2024-02-17', 280.00, 0.20, 1, 'Weekly rental'),
(3, 3, 3, 60, 50000, 50300, 300, '2024-03-01', '2024-03-05', '2024-03-05', 320.00, 0.20, 0, 'Car returned with scratches');


-- 15
CREATE DATABASE [Hotel]

CREATE TABLE [Employees]
(
	[Id] INT PRIMARY KEY IDENTITY(1, 1),
	[FirstName] NVARCHAR(60) NOT NULL,
	[LastName] NVARCHAR(60) NOT NULL,
	[Title] NVARCHAR(60) NOT NULL,
	[Notes] NVARCHAR(500)
);

CREATE TABLE [Customers]
(
	[AccountNumber] INT PRIMARY KEY,
	[FirstName] NVARCHAR(60) NOT NULL,
	[LastName] NVARCHAR(60) NOT NULL,
	[PhoneNumber] NVARCHAR(20) NOT NULL,
	[EmergencyName] NVARCHAR(60) NOT NULL,
	[EmergencyNumber] NVARCHAR(20) NOT NULL,
	[Notes] NVARCHAR(500)
);

CREATE TABLE [RoomStatus]
(
	[RoomStatus] BIT NOT NULL,
	[Notes] NVARCHAR(500)
);

CREATE TABLE [RoomTypes]
(
	[RoomType] VARCHAR(30) NOT NULL,
	[Notes] NVARCHAR(500)
);

CREATE TABLE [BedTypes]
(
	[BedType] VARCHAR(30) NOT NULL,
	[Notes] NVARCHAR(500)
);

CREATE TABLE [Rooms]
(
	[RoomNumber] INT UNIQUE NOT NULL,
	[RoomType] VARCHAR(30) NOT NULL,
	[BedType] VARCHAR(30) NOT NULL,
	[Rate] TINYINT NOT NULL,
	[RoomStatus] BIT NOT NULL,
	[Notes] NVARCHAR(500)
);

CREATE TABLE [Payments]
(
	[Id] INT PRIMARY KEY,
	[EmployeeId] INT FOREIGN KEY REFERENCES [Employees](Id),
	[PaymentDate] DATETIME2 NOT NULL,
	[AccountNumber] INT NOT NULL,
	[FirstDateOccupied] DATETIME2 NOT NULL,
	[LastDateOccupied] DATETIME2 NOT NULL,
	[TotalDays] TINYINT NOT NULL,
	[AmountCharged] DECIMAL NOT NULL,
	[TaxRate] DECIMAL NOT NULL,
	[TaxAmount] DECIMAL NOT NULL,
	[PaymentTotal] DECIMAL NOT NULL,
	[Notes] NVARCHAR(500)
);

CREATE TABLE [Occupancies]
(
	[Id] INT PRIMARY KEY NOT NULL,
	[EmployeeId] INT FOREIGN KEY REFERENCES [Employees](Id),
	[DateOccupied] DATETIME2 NOT NULL,
	[AccountNumber] INT NOT NULL,
	[RoomNumber] INT UNIQUE NOT NULL,
	[RateApplied] TINYINT NOT NULL,
	[PhoneCharge] DECIMAL NOT NULL,
	[Notes] NVARCHAR(500)
);

INSERT INTO Employees (FirstName, LastName, Title, Notes) VALUES
('Ivan', 'Petrov', 'Manager', 'Night shift supervisor'),
('Maria', 'Georgieva', 'Receptionist', 'Fluent in English and German'),
('Stoyan', 'Iliev', 'Housekeeping', 'Responsible for 3rd floor');

INSERT INTO Customers (AccountNumber, FirstName, LastName, PhoneNumber, EmergencyName, EmergencyNumber, Notes) VALUES
(1001, 'Georgi', 'Dimitrov', '0888123456', 'Petar Dimitrov', '0888999000', 'VIP client'),
(1002, 'Elena', 'Koleva', '0888456789', 'Mariya Koleva', '0888777666', 'Allergic to peanuts'),
(1003, 'Nikolay', 'Stanev', '0888987654', 'Ivan Stanev', '0888111222', NULL);

INSERT INTO RoomStatus (RoomStatus, Notes) VALUES
(1, 'Occupied'),
(0, 'Available'),
(1, 'Cleaning in progress');

INSERT INTO RoomTypes (RoomType, Notes) VALUES
('Single', 'One bed'),
('Double', 'Two beds'),
('Suite', 'Luxury suite');

INSERT INTO BedTypes (BedType, Notes) VALUES
('Single Bed', 'Standard single'),
('Double Bed', 'Standard double'),
('King Size', 'Large bed');

INSERT INTO Rooms (RoomNumber, RoomType, BedType, Rate, RoomStatus, Notes) VALUES
(101, 'Single', 'Single Bed', 50, 0, 'Quiet room'),
(202, 'Double', 'Double Bed', 80, 1, 'Sea view'),
(303, 'Suite', 'King Size', 150, 0, 'VIP suite');

INSERT INTO Payments (Id, EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, TotalDays, AmountCharged, TaxRate, TaxAmount, PaymentTotal, Notes) VALUES
(1, 1, '2024-05-01', 1001, '2024-04-25', '2024-04-28', 3, 300, 0.10, 30, 330, 'Paid in cash'),
(2, 2, '2024-05-10', 1002, '2024-05-05', '2024-05-07', 2, 160, 0.10, 16, 176, NULL),
(3, 1, '2024-05-15', 1003, '2024-05-10', '2024-05-14', 4, 600, 0.10, 60, 660, 'Late checkout included');

INSERT INTO Occupancies (Id, EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge, Notes) VALUES
(1, 2, '2024-04-25', 1001, 101, 50, 5.50, 'International call'),
(2, 1, '2024-05-05', 1002, 202, 80, 0.00, NULL),
(3, 3, '2024-05-10', 1003, 303, 150, 12.75, 'Room service calls');


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
/*
decrease tax rate by 3% to all payments. Then select only TaxRate column from the Payments table
*/

UPDATE [Payments]
	SET [TaxRate] -= ([TaxRate] * 0.03)

SELECT [TaxRate]
	FROM [Payments]

-- 24
SELECT * FROM [Occupancies]

DELETE FROM [Occupancies]