SELECT DepartmentID, AVG(Salary) AS AvgSalary      
FROM Employees
GROUP BY DepartmentID

SELECT DepartmentID, Salary, COUNT(*) AS Count      
FROM Employees
GROUP BY DepartmentID, Salary
ORDER BY DepartmentID, Salary DESC

SELECT 
		DepartmentID,
		SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentID
ORDER BY 1 -- DepartmentID