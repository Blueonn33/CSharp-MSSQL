CREATE DATABASE EuroLeagues
USE EuroLeagues

CREATE TABLE Leagues
(
	Id INT PRIMARY KEY IDENTITY (1, 1),
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Teams
(
	Id INT PRIMARY KEY IDENTITY (1, 1),
	[Name] NVARCHAR(50) UNIQUE NOT NULL,
	City NVARCHAR(50) NOT NULL,
	LeagueId INT FOREIGN KEY REFERENCES Leagues(Id) NOT NULL
)

CREATE TABLE Players
(
	Id INT PRIMARY KEY IDENTITY (1, 1),
	[Name] NVARCHAR(100) NOT NULL,
	Position NVARCHAR(20) NOT NULL
)

CREATE TABLE Matches
(
	Id INT PRIMARY KEY IDENTITY (1, 1),
	HomeTeamId INT FOREIGN KEY REFERENCES Teams(Id) NOT NULL,
	AwayTeamId INT FOREIGN KEY REFERENCES Teams(Id) NOT NULL,
	MatchDate DATETIME2 NOT NULL,
	HomeTeamGoals INT NOT NULL DEFAULT 0,
	AwayTeamGoals INT NOT NULL DEFAULT 0,
	LeagueId INT FOREIGN KEY REFERENCES Leagues(Id) NOT NULL
)

CREATE TABLE PlayersTeams
(
	PRIMARY KEY(PlayerId, TeamId),
	PlayerId INT FOREIGN KEY REFERENCES Players(Id),
	TeamId INT FOREIGN KEY REFERENCES Players(Id),
)

CREATE TABLE PlayerStats
(
	PRIMARY KEY(PlayerId),
	PlayerId INT FOREIGN KEY REFERENCES Players(Id),
	Goals INT NOT NULL DEFAULT 0,
	Assists INT NOT NULL DEFAULT 0
)

CREATE TABLE TeamStats
(
	PRIMARY KEY(TeamId),
	TeamId INT FOREIGN KEY REFERENCES Teams(Id),
	Wins INT NOT NULL DEFAULT 0,
	Draws INT NOT NULL DEFAULT 0,
	Losses INT NOT NULL DEFAULT 0,
)

----------------------------------

-- 02

INSERT INTO Leagues([Name])
VALUES ('Eredivisie')

INSERT INTO Teams([Name], City, LeagueId)
VALUES ('PSV', 'Eindhoven', 6),
	   ('Ajax', 'Amsterdam', 6)

INSERT INTO Players([Name], Position)
VALUES ('Luuk de Jong', 'Forward'),
	   ('Josip Sutalo', 'Defender')

INSERT INTO Matches(HomeTeamId, AwayTeamId, MatchDate, HomeTeamGoals, AwayTeamGoals, LeagueId)
VALUES (98, 97, '2024-11-02 20:45:00', 3, 2, 1)

INSERT INTO PlayersTeams(PlayerId, TeamId)
VALUES (2305, 97),
	   (2306, 98)

INSERT INTO PlayerStats(PlayerId, Goals, Assists)
VALUES (2305, 2, 0),
	   (2306, 2, 0)

INSERT INTO TeamStats(TeamId, Wins, Draws, Losses)
VALUES (97, 15, 1, 3),
	   (98, 14, 3, 2)

-- 03
UPDATE PlayerStats 
SET Goals += 1
WHERE PlayerId IN (
				     SELECT p.Id
					 FROM Players AS p
					 JOIN PlayersTeams AS pt ON p.Id = pt.PlayerId
					 JOIN Teams AS t ON t.Id = pt.TeamId
					 JOIN Leagues AS l ON l.Id = t.LeagueId
					 WHERE Position = 'Forward' AND l.[Name] = 'La Liga'
				  )

-- 04
DELETE 
FROM PlayerStats
WHERE PlayerId IN (
				SELECT p.Id
				FROM Players AS p
				JOIN PlayersTeams AS pt ON p.Id = pt.PlayerId
				JOIN Teams AS t ON t.Id = pt.TeamId
				JOIN Leagues AS l ON l.Id = t.LeagueId
				WHERE p.[Name] IN ('Luuk de Jong', 'Josip Sutalo') AND l.[Name] = 'Eredivisie'
			)

DELETE 
FROM PlayersTeams
WHERE PlayerId IN (
						SELECT p.Id
						FROM Players AS p
						JOIN PlayersTeams AS pt ON p.Id = pt.PlayerId
						JOIN Teams AS t ON t.Id = pt.TeamId
						JOIN Leagues AS l ON l.Id = t.LeagueId
						WHERE p.[Name] IN ('Luuk de Jong', 'Josip Sutalo') AND l.[Name] = 'Eredivisie'
				  )

DELETE
FROM Players
WHERE [Name] IN ('Luuk de Jong', 'Josip Sutalo')

-----------------------------------
-- 05
