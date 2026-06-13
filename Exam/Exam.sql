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
SELECT 
		FORMAT(MatchDate, 'yyyy-MM-dd') AS MatchDate,
		HomeTeamGoals,
		AwayTeamGoals,
		(HomeTeamGoals + AwayTeamGoals) AS TotalGoals
FROM Matches
WHERE (HomeTeamGoals + AwayTeamGoals) >= 5
ORDER BY TotalGoals DESC, MatchDate ASC

-- 06
SELECT 
		p.[Name],
		t.City
FROM Players AS p
JOIN PlayersTeams AS pt ON pt.PlayerId = p.Id
JOIN Teams AS t ON pt.TeamId = t.Id
WHERE p.[Name] LIKE '%Aaron%'
ORDER BY p.[Name] ASC

-- 07
SELECT 
		p.Id,
		p.[Name],
		p.[Position]
FROM Players AS p
JOIN PlayersTeams AS pt ON pt.PlayerId = p.Id
JOIN Teams AS t ON pt.TeamId = t.Id
WHERE t.City = 'London'
ORDER BY p.[Name] ASC

-- 08
SELECT TOP 10
				h.[Name] AS HomeTeamName,
				a.[Name] AS AwayTeamName,
				l.[Name] AS LeagueName,
				FORMAT(m.MatchDate, 'yyyy-MM-dd') AS MatchDate
FROM Matches AS m
JOIN Teams AS h ON m.HomeTeamId = h.Id
JOIN Teams AS a ON m.AwayTeamId = a.Id
JOIN Leagues AS l ON m.LeagueId = l.Id
WHERE (m.MatchDate BETWEEN '2024-09-01' AND '2024-09-15') AND l.Id % 2 = 0
ORDER BY m.MatchDate ASC, h.[Name] ASC

-- 09
SELECT 
		Id,
		[Name],
		TotalAwayGoals
FROM (
		SELECT
				t.Id,
				t.[Name],
				SUM(m.AwayTeamGoals) AS TotalAwayGoals
		FROM Teams AS t
		JOIN Matches AS m ON m.AwayTeamId = t.Id
		JOIN Leagues AS l ON m.LeagueId = l.Id
		GROUP BY t.Id, t.[Name]
		HAVING SUM(m.AwayTeamGoals) >= 6
) AS TotalAwayGoals
ORDER BY TotalAwayGoals DESC, [Name] ASC

-- 10
SELECT
		l.[Name] AS LeagueName,
		SELECT AvgScoringRate
		FROM (
			IF (
				RIGHT(CAST(ROUND(AVG(CAST(m.HomeTeamGoals AS DECIMAL(3, 2)) + m.AwayTeamGoals), 2) AS NVARCHAR(3)), 1) = 0
			)
			BEGIN
				CAST(ROUND(AVG(CAST(m.HomeTeamGoals AS DECIMAL(3, 2)) + m.AwayTeamGoals), 2) AS DECIMAL (3,1))
			END
			CAST(ROUND(AVG(CAST(m.HomeTeamGoals AS DECIMAL(3, 2)) + m.AwayTeamGoals), 2) AS DECIMAL (3,2)) AS AvgScoringRate
		) AS AvgScoringRate
FROM Leagues AS l
JOIN Matches AS m ON m.LeagueId = l.Id
GROUP BY l.[Name]
ORDER BY AvgScoringRate DESC


SELECT
		l.[Name] AS LeagueName,
		CASE
			WHEN RIGHT(CAST(AVG(m.HomeTeamGoals + m.AwayTeamGoals), 2) AS VARCHAR(3)), 1) = '0'
				THEN CAST(AVG(m.HomeTeamGoals + m.AwayTeamGoals) AS DECIMAL (3,1))
			ELSE CAST(AVG(m.HomeTeamGoals + m.AwayTeamGoals) AS DECIMAL (3,2))
		END AS AvgScoringRate
FROM Leagues AS l
JOIN Matches AS m ON m.LeagueId = l.Id
GROUP BY l.[Name]
ORDER BY AvgScoringRate DESC

SELECT
    l.[Name] AS LeagueName,
    CASE 
        WHEN RIGHT(CAST(ROUND(AVG(CAST(m.HomeTeamGoals AS DECIMAL (3, 2)) + m.AwayTeamGoals), 2) AS VARCHAR(10)), 1) = '0'
            THEN CAST(ROUND(AVG(m.HomeTeamGoals + m.AwayTeamGoals), 1) AS DECIMAL(3,1))
        ELSE CAST(ROUND(AVG(m.HomeTeamGoals + m.AwayTeamGoals), 2) AS DECIMAL(3,2))
    END AS AvgScoringRate
FROM Leagues AS l
JOIN Matches AS m ON m.LeagueId = l.Id
GROUP BY l.[Name]
ORDER BY AvgScoringRate DESC;

SELECT
		l.[Name] AS LeagueName,
		RIGHT(CAST(CAST(ROUND(AVG(CAST(m.HomeTeamGoals AS DECIMAL(3, 2)) + m.AwayTeamGoals), 2) AS DECIMAL (3,2)) AS VARCHAR(4)), 1) AS Test,
		CAST(ROUND(AVG(CAST(m.HomeTeamGoals AS DECIMAL(3, 2)) + m.AwayTeamGoals), 2) AS DECIMAL (2,1)) AS Test1,
		CASE
			WHEN RIGHT(CAST(CAST(ROUND(AVG(CAST(m.HomeTeamGoals AS DECIMAL(3, 2)) + m.AwayTeamGoals), 2) AS DECIMAL (3,2)) AS VARCHAR(4)), 1) = '0'
				THEN CAST(ROUND(AVG(CAST(m.HomeTeamGoals AS DECIMAL(3, 2)) + m.AwayTeamGoals), 2) AS DECIMAL (2,1))
		ELSE
			CAST(ROUND(AVG(CAST(m.HomeTeamGoals AS DECIMAL(3, 2)) + m.AwayTeamGoals), 2) AS DECIMAL (3,2))
		END AS AvgScoringRate
FROM Leagues AS l
JOIN Matches AS m ON m.LeagueId = l.Id
GROUP BY l.[Name]
ORDER BY AvgScoringRate DESC


SELECT
		l.[Name] AS LeagueName,
		CASE
			WHEN RIGHT(CAST(CAST(ROUND(AVG(CAST(m.HomeTeamGoals AS DECIMAL(3, 2)) + m.AwayTeamGoals), 2) AS DECIMAL (3,2)) AS VARCHAR(4)), 1) = '0'
				THEN SUBSTRING(CAST(CAST(ROUND(AVG(CAST(m.HomeTeamGoals AS DECIMAL(3, 2)) + m.AwayTeamGoals), 2) AS DECIMAL (3,1)) AS VARCHAR(3)), 1, 3)
		ELSE
			CAST(ROUND(AVG(CAST(m.HomeTeamGoals AS DECIMAL(3, 2)) + m.AwayTeamGoals), 2) AS DECIMAL (3,2))
		END AS AvgScoringRate
FROM Leagues AS l
JOIN Matches AS m ON m.LeagueId = l.Id
GROUP BY l.[Name]
ORDER BY AvgScoringRate DESC

SELECT
    l.[Name] AS LeagueName,
    CASE
        WHEN ROUND(AVG(m.HomeTeamGoals + m.AwayTeamGoals * 1.0), 2)
             = ROUND(AVG(m.HomeTeamGoals + m.AwayTeamGoals * 1.0), 1)
        THEN CAST(ROUND(AVG(m.HomeTeamGoals + m.AwayTeamGoals * 1.0), 1) AS VARCHAR(10))
        ELSE CAST(ROUND(AVG(m.HomeTeamGoals + m.AwayTeamGoals * 1.0), 2) AS VARCHAR(10))
    END AS AvgScoringRate
FROM Leagues AS l
JOIN Matches AS m ON m.LeagueId = l.Id
GROUP BY l.[Name]
ORDER BY ROUND(AVG(m.HomeTeamGoals + m.AwayTeamGoals * 1.0), 2) DESC;


SELECT
		l.[Name] AS LeagueName,
		CASE
			WHEN RIGHT(CAST(ROUND(AVG(CAST(m.HomeTeamGoals AS DECIMAL(3,2)) + m.AwayTeamGoals), 2) AS VARCHAR(10)), 1) = '0'
				THEN RTRIM(REPLACE(CAST(ROUND(AVG(CAST(m.HomeTeamGoals AS DECIMAL(3,2)) + m.AwayTeamGoals), 2) AS VARCHAR(10)), '0', ''))
			ELSE
				CAST(ROUND(AVG(CAST(m.HomeTeamGoals AS DECIMAL(3,2)) + m.AwayTeamGoals), 2) AS VARCHAR(10))
		END AS AvgScoringRate
FROM Leagues AS l
JOIN Matches AS m ON m.LeagueId = l.Id
GROUP BY l.[Name]
ORDER BY CAST(ROUND(AVG(CAST(m.HomeTeamGoals AS DECIMAL(3,2)) + m.AwayTeamGoals), 2) AS DECIMAL(4,2)) DESC

------------------------------------------
-- 11
GO
CREATE OR ALTER FUNCTION udf_LeagueTopScorer (@league NVARCHAR(50)) 
RETURNS TABLE
AS
RETURN
    SELECT 
			PlayerName,
			TotalGoals
	FROM (
			SELECT
					p.[Name] AS PlayerName,
					SUM(ps.Goals) AS TotalGoals, 
					DENSE_RANK() OVER (ORDER BY SUM(ps.Goals) DESC) AS [Rank]
			FROM
				Players AS p
				JOIN PlayerStats AS ps ON ps.PlayerId = p.Id
				JOIN PlayersTeams AS pt ON pt.PlayerId = p.Id
				JOIN Teams AS t ON pt.TeamId = t.Id
				JOIN Leagues AS l ON l.Id = t.LeagueId
			WHERE l.[Name] = @league
			GROUP BY p.[Name]
	) AS Ranking
	WHERE Ranking.[Rank] = 1

SELECT *
FROM dbo.udf_LeagueTopScorer('Premier League');

SELECT 
		PlayerName,
		TotalGoals
FROM (
		SELECT
				p.[Name] AS PlayerName,
				SUM(ps.Goals) AS TotalGoals, 
				DENSE_RANK() OVER (ORDER BY SUM(ps.Goals) DESC) AS [Rank]
		FROM
			Players AS p
			JOIN PlayerStats AS ps ON ps.PlayerId = p.Id
			JOIN PlayersTeams AS pt ON pt.PlayerId = p.Id
			JOIN Teams AS t ON pt.TeamId = t.Id
			JOIN Leagues AS l ON l.Id = t.LeagueId
		GROUP BY p.[Name], l.[Name]
		HAVING l.[Name] = 'Premier League'
) AS Ranking
WHERE Ranking.[Rank] = 1
ORDER BY TotalGoals DESC, PlayerName DESC

UPDATE PlayerStats
SET Goals = 18
WHERE PlayerId = (SELECT p.Id FROM Players p WHERE p.Name = 'Erling Haaland');

UPDATE PlayerStats
SET Goals = 18
WHERE PlayerId = (SELECT p.Id FROM Players p WHERE p.Name = 'Alexander Isak');

-- 12
CREATE OR ALTER PROCEDURE usp_UpdatePlayerStats(@PlayerId INT, @GoalsDelta INT = 0, @AssistsDelta INT = 0)
AS
BEGIN
		IF NOT EXISTS(
			SELECT TOP 1 PlayerId
			FROM PlayerStats
			WHERE @PlayerId IS NULL
		)
		BEGIN
			INSERT INTO PlayerStats (PlayerId, Goals, Assists)
			VALUES (@PlayerId, @GoalsDelta, @AssistsDelta)
		END
		UPDATE PlayerStats
		SET Goals = 
					CASE
						WHEN Goals IS NOT NULL THEN Goals + @GoalsDelta
						ELSE Goals + 0
					END,
			Assists = 
					CASE
						WHEN Assists IS NOT NULL THEN Assists + @AssistsDelta
						ELSE Assists + 0
					END
END

EXEC usp_UpdatePlayerStats 51, 2;

SELECT 
		p.Id,
		p.[Name],
		ps.Goals,
		ps.Assists
FROM Players AS p
JOIN PlayerStats AS ps ON ps.PlayerId = p.Id
WHERE p.Id = 51

SELECT 16 + NULL

SELECT *
FROM PlayerStats
WHERE PlayerId = 2443



CREATE OR ALTER PROCEDURE usp_UpdatePlayerStats(@playerId INT, @goalsDelta INT = NULL, @assistsDelta INT = NULL)
AS
BEGIN
    IF NOT EXISTS (
        SELECT PlayerId 
		FROM PlayerStats 
		WHERE PlayerId = @playerId
    )
    BEGIN
        INSERT INTO PlayerStats (PlayerId, Goals, Assists)
        VALUES (@playerId, COALESCE(@goalsDelta, 0), COALESCE(@assistsDelta, 0))
		RETURN
    END
    UPDATE PlayerStats
    SET 
        Goals = Goals + COALESCE(@goalsDelta, 0),
        Assists = Assists + COALESCE(@assistsDelta, 0)
    WHERE PlayerId = @playerId
END

EXEC usp_UpdatePlayerStats 7, 1, 2;

SELECT p.Id, p.Name, ps.Goals, ps.Assists
FROM dbo.Players p
JOIN dbo.PlayerStats ps ON ps.PlayerId = p.Id
WHERE p.Id = 7;