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

-- 04
SELECT TOP 5 EmployeeID, FirstName, Salary, d.[Name] AS DepartmentName
FROM Employees AS e
INNER JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 15000
ORDER BY d.DepartmentID

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