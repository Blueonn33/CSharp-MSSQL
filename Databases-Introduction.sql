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

