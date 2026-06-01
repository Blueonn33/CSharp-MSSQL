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

