SELECT DepartmentID, AVG(Salary) AS AvgSalary      
FROM Employees
GROUP BY DepartmentID

SELECT DepartmentID, Salary, COUNT(*) AS Count      
FROM Employees
GROUP BY DepartmentID, Salary
ORDER BY DepartmentID, Salary DESC

SELECT 
		DepartmentID,
		COUNT(DepartmentID) AS EmployeesCount,
		MIN(Salary) AS MinSalary,
		MAX(Salary) AS MaxSalary,
		AVG(Salary) AS AverageSalary,
		SUM(Salary) AS TotalSalary,
		STRING_AGG(CONCAT_WS(' ', FirstName, LastName), ', ') 
			WITHIN GROUP (ORDER BY Salary DESC)
FROM Employees
GROUP BY DepartmentID
ORDER BY 1 -- DepartmentID

SELECT SUM(Salary)
FROM Employees

-------
SELECT 
		DepartmentID,
		SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentID
HAVING SUM(Salary) > 300000

--------
SELECT *
FROM (
	SELECT 
			DepartmentID,
			SUM(Salary) AS TotalSalary
	FROM Employees
	GROUP BY DepartmentID
) AS d
WHERE d.TotalSalary < 100000

----------
SELECT 
		DepartmentID,
		SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentID
HAVING SUM(Salary) < 100000