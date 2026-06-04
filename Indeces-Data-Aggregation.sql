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

---------------------------------------------------------------------------

-- 03
-- GROUP BY is used for data aggregation
-- Data aggregation is the process of summarizing of the data based on unique
-- group values
-- In SELECT clause, we can use ONLY columns from GROUP BY (Group Names) + Aggregating Functions
-- GROUP BY -> Find distinct values for a column(s) and sort all data records
-- from table in each group
-- Aggregating functions iterate over all data records in a Group and returns statistics

SELECT 
		DepositGroup,
		MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits
GROUP BY DepositGroup

-- 09
SELECT *
FROM WizzardDeposits

SELECT 
		SUM(CASE WHEN Age BETWEEN 0 AND 10 THEN 1 ELSE 0 END) AS "[0-10]",
		SUM(CASE WHEN Age BETWEEN 11 AND 20 THEN 1 ELSE 0 END) AS "[11-20]",
		SUM(CASE WHEN Age BETWEEN 21 AND 30 THEN 1 ELSE 0 END) AS "[21-30]"
FROM WizzardDeposits