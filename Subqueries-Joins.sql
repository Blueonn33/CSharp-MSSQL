-- Subqueries
SELECT 
	MIN(dt.AvgSalary) AS MinAverageSalary
FROM
	(SELECT AVG(Salary) AS AvgSalary
		FROM Employees
		GROUP BY DepartmentID
	) AS dt

SELECT TOP 1
	AVG(Salary) AS MinAverageSalary
	FROM Employees
	GROUP BY DepartmentID
	ORDER BY MinAverageSalary

-- Common Table Expressions
WITH AvgSalaryCTE (AverageSalary)
AS 
(SELECT AVG(Salary)
	FROM Employees
	GROUP BY DepartmentID)

SELECT 
	MIN(AverageSalary) AS MinAverageSalary
FROM
	AvgSalaryCTE

-- Temporary Tables
CREATE TABLE #Employees
(
	Id INT PRIMARY KEY,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	[Address] VARCHAR(200) 
);

INSERT INTO #Employees 
SELECT 
	e.EmployeeID, 
	e.FirstName, 
	e.LastName,
	a.AddressText
FROM Employees AS e
	JOIN Addresses AS a ON e.AddressID = a.AddressID

SELECT * FROM #Employees

-- Global Temporary Table
CREATE TABLE ##Employees
(
	Id INT PRIMARY KEY,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
)

INSERT INTO ##Employees
SELECT
		EmployeeID,
		FirstName,
		LastName
FROM Employees

SELECT * FROM ##Employees

------------------

-- 01
SELECT TOP 5 
	   e.EmployeeID,
	   e.JobTitle,
	   e.AddressID,
	   a.AddressText
FROM Employees AS e
JOIN Addresses AS a ON e.AddressID = a.AddressID
ORDER BY e.AddressID

-- 02
SELECT TOP 50
	   e.FirstName,
	   e.LastName,
	   t.[Name] AS Town,
	   a.AddressText
FROM Employees AS e
JOIN Addresses AS a ON e.AddressID = a.AddressID
JOIN Towns AS t ON t.TownID = a.TownID
ORDER BY e.FirstName, e.LastName

-- 03
SELECT e.EmployeeID,
	   e.FirstName,
	   e.LastName,
	   d.[Name] AS DepartmentName
FROM Employees AS e
JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE d.[Name] = 'Sales'
ORDER BY e.EmployeeID

-- 04
SELECT TOP 5 EmployeeID, FirstName, Salary, d.[Name] AS DepartmentName
FROM Employees AS e
INNER JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 15000
ORDER BY d.DepartmentID

-- 05
SELECT TOP 3
	   e.EmployeeID,
	   e.FirstName
FROM Employees AS e
LEFT JOIN EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID
LEFT JOIN Projects AS p ON p.ProjectID = ep.ProjectID
WHERE p.[Name] IS NULL
ORDER BY e.EmployeeID

-- 06
SELECT e.FirstName,
	   e.LastName,
	   e.HireDate,
	   d.[Name]
FROM Employees AS e
JOIN Departments AS d ON d.DepartmentID = e.DepartmentID 
AND d.[Name] IN ('Sales', 'Finance')
WHERE e.HireDate > '01/01/1999'
ORDER BY e.HireDate

-- 07
SELECT TOP 5 
	   e.EmployeeID,
	   e.FirstName,
	   p.[Name] AS ProjectName
FROM EmployeesProjects AS ep
INNER JOIN Employees AS e ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects AS p ON ep.ProjectID = p.ProjectID
WHERE p.StartDate > '08/13/2002' AND p.EndDate IS NULL
ORDER BY e.EmployeeID

-- 08
SELECT 
		e.EmployeeID,
		e.FirstName,
		CASE
			WHEN YEAR(p.StartDate) >= 2005 THEN NULL
			ELSE p.[Name] 
		END AS ProjectName
FROM Employees AS e
JOIN EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID
JOIN Projects AS p ON p.ProjectID = ep.ProjectID
WHERE e.EmployeeID = 24

-- 09
SELECT e.EmployeeID,
	   e.FirstName,
	   e.ManagerID,
	   m.FirstName AS ManagerName
FROM Employees as e
JOIN Employees as m ON e.ManagerID = m.EmployeeID
WHERE m.EmployeeID IN (3, 7)
ORDER BY e.EmployeeID

-- 10
SELECT TOP 50
		e.EmployeeID,
		CONCAT_WS(' ', e.FirstName, e.LastName) AS EmployeeName,
		CONCAT_WS(' ', m.FirstName, m.LastName) AS ManagerName,
		d.[Name] AS DepartmentName
FROM Employees AS e
JOIN Employees AS m ON e.ManagerID = m.EmployeeID
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID

-- 11
SELECT * FROM Employees
SELECT * FROM Departments

SELECT TOP 1
		AVG(e.Salary) AS MinAverageSalary
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID
ORDER BY MinAverageSalary

-- 12
SELECT 
		c.CountryCode,
		m.MountainRange,
		p.PeakName,
		p.Elevation
FROM Countries AS c
JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
JOIN Mountains AS m ON m.Id = mc.MountainId
JOIN Peaks AS p ON p.MountainId = m.Id
WHERE c.CountryCode = 'BG' AND p.Elevation > 2835
ORDER BY p.Elevation DESC

-- 13
SELECT c.CountryCode,
	   COUNT(MountainID) AS MountainRanges
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
WHERE CountryName IN ('United States', 'Russia', 'Bulgaria')
GROUP BY c.CountryCode;

-- 14
SELECT TOP 5
		c.CountryName,
		r.RiverName
FROM Countries AS c
LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r ON r.Id = cr.RiverId
WHERE ContinentCode = 'AF'
ORDER BY CountryName

-- 15
WITH CurrencyUsageResult AS 
(
    SELECT ContinentCode, 
           CurrencyCode,
           COUNT(CountryCode) AS CurrencyUsage
    FROM Countries
    GROUP BY ContinentCode, CurrencyCode         
    HAVING COUNT(CountryCode) > 1
)

SELECT ContinentCode,	
	   CurrencyCode,
	   CurrencyUsage
FROM
(
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY ContinentCode ORDER BY CurrencyUsage DESC)
		   AS CurrencyRank
	FROM CurrencyUsageResult
) AS CurrencyRankingQuery
WHERE CurrencyRank = 1
ORDER BY ContinentCode

-- 16
SELECT COUNT(*) AS Count
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc 
       ON mc.CountryCode = c.CountryCode
WHERE mc.MountainId IS NULL;

-- 17
SELECT * FROM Countries
SELECT * FROM Peaks
SELECT * FROM Rivers

WITH HighestPeaks AS (
    SELECT 
        c.CountryCode,
        MAX(p.Elevation) AS HighestPeakElevation
    FROM Countries AS c
    LEFT JOIN MountainsCountries AS mc 
           ON mc.CountryCode = c.CountryCode
    LEFT JOIN Mountains AS m 
           ON m.Id = mc.MountainId
    LEFT JOIN Peaks AS p 
           ON p.MountainId = m.Id
    GROUP BY c.CountryCode
),
LongestRivers AS (
    SELECT 
        c.CountryCode,
        MAX(r.Length) AS LongestRiverLength
    FROM Countries AS c
    LEFT JOIN CountriesRivers AS cr 
           ON cr.CountryCode = c.CountryCode
    LEFT JOIN Rivers AS r 
           ON r.Id = cr.RiverId
    GROUP BY c.CountryCode
)
SELECT TOP 5
       c.CountryName,
       hp.HighestPeakElevation,
       lr.LongestRiverLength
FROM Countries AS c
LEFT JOIN HighestPeaks AS hp 
       ON hp.CountryCode = c.CountryCode
LEFT JOIN LongestRivers AS lr 
       ON lr.CountryCode = c.CountryCode
ORDER BY 
       hp.HighestPeakElevation DESC,
       lr.LongestRiverLength DESC,
       c.CountryName ASC;


-- 18
SELECT TOP 5 CountryName,												
	   ISNULL(PeakName, '(no highest peak)') AS [Highest Peak Name],
	   ISNULL(Elevation, 0) AS [Highest Peak Elevation],
	   ISNULL(MountainRange, '(no mountain)') AS Mountain
FROM (
	SELECT c.CountryCode,
		   c.CountryName,
		   p.PeakName,
		   p.Elevation,
		   m.MountainRange,
		   DENSE_RANK() OVER(PARTITION BY c.CountryCode ORDER BY p.Elevation DESC)
		   AS PeakRank
	FROM Countries AS c
	LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
	LEFT JOIN Mountains AS m ON m.Id = mc.MountainId
	LEFT JOIN Peaks AS p ON p.MountainId = m.Id
) AS CountryPeaksRankQuery
WHERE PeakRank = 1
ORDER BY CountryName, 
		 [Highest Peak Name]