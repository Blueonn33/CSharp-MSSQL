SELECT DepartmentID, AVG(Salary) AS AvgSalary      
FROM Employees
GROUP BY DepartmentID