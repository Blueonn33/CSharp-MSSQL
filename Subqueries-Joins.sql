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