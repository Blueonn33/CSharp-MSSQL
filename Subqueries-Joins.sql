SELECT 
	MIN(dt.AvgSalary)
FROM
	(SELECT AVG(Salary) AS AvgSalary
		FROM Employees
		GROUP BY DepartmentID
	) AS dt
