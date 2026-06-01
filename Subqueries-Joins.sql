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

