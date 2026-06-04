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

-- 01
SELECT COUNT(*) AS [Count]
FROM WizzardDeposits

-- 02
SELECT MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits

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

-- 04
SELECT TOP 2
		DepositGroup
FROM (
		SELECT  
				DepositGroup,
				AVG(MagicWandSize) AS MinWandSize
		FROM WizzardDeposits
		GROUP BY DepositGroup
) AS DepositGroup
ORDER BY MinWandSize ASC

-- 05
SELECT * FROM WizzardDeposits

SELECT 
		DepositGroup,
		SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
GROUP BY DepositGroup

-- 06
SELECT 
		DepositGroup,
		SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
HAVING MagicWandCreator = 'Ollivander family'

-- 07
SELECT 
		DepositGroup,
		SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
HAVING MagicWandCreator = 'Ollivander family' 
	AND SUM(DepositAmount) < 150000
ORDER BY TotalSum DESC

-- 08
SELECT
		DepositGroup,
		MagicWandCreator,
		MIN(DepositCharge) AS MinDepositCharge
FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup

-- 09
SELECT *
FROM WizzardDeposits

SELECT 
		SUM(CASE WHEN Age BETWEEN 0 AND 10 THEN 1 ELSE 0 END) AS "[0-10]",
		SUM(CASE WHEN Age BETWEEN 11 AND 20 THEN 1 ELSE 0 END) AS "[11-20]",
		SUM(CASE WHEN Age BETWEEN 21 AND 30 THEN 1 ELSE 0 END) AS "[21-30]"
FROM WizzardDeposits

SELECT 
		AgeGroup,
	    COUNT(Id) AS WizardCount
FROM (
		SELECT *,
				CASE 
					WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
					WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
					WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
					WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
					WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
					WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
					WHEN Age >= 61 THEN '[61+]'
				END
			 AS AgeGroup
		FROM WizzardDeposits
) AS AgeGroupingQuery
GROUP BY AgeGroup

-- 10

-- 12
-- I - Subquery
SELECT SUM([Difference]) AS SumDifference
FROM (
		SELECT
				h.FirstName AS [Host Wizard],
				h.DepositAmount AS [Host Wizard Deposit],
				g.FirstName AS [Guest Wizard],
				g.DepositAmount AS [Guest Wizard Deposit],
				h.DepositAmount - g.DepositAmount AS [Difference]
		FROM WizzardDeposits AS h
		JOIN WizzardDeposits AS g ON h.Id + 1 = g.Id
) AS DifferenceQuery

-- II - No subquery
SELECT SUM(h.DepositAmount - g.DepositAmount) AS SumDifference
		FROM WizzardDeposits AS h
		JOIN WizzardDeposits AS g ON h.Id + 1 = g.Id

-- III - Window function
SELECT SUM([Host Wizard Deposit] - [Guest Wizard Deposit]) AS SumDifference
FROM (
		SELECT 
				FirstName AS [Host Wizard],
				DepositAmount AS [Host Wizard Deposit],
				LEAD(FirstName) OVER (ORDER BY Id) AS [Guest Wizard],
				LEAD(DepositAmount) OVER(ORDER BY Id) AS [Guest Wizard Deposit],
				(DepositAmount - LEAD(DepositAmount) OVER(ORDER BY Id)) AS [Difference]
		FROM WizzardDeposits
) AS HostGuestWizzardDiffQuery

-- 15
-- SELECT [Columns] INTO -> Syntax for insert of returned data set into new table
-- #TableName -> Defines temp table in tempdb only for the current connection
-- DELETE FROM / UPDATE -> DO NOT forget the WHERE clause

SELECT *
INTO #EmployeesHighSalaryTempTable
FROM Employees
WHERE Salary > 30000

DELETE
FROM #EmployeesHighSalaryTempTable
WHERE ManagerID = 42

UPDATE #EmployeesHighSalaryTempTable
SET Salary += 5000
WHERE DepartmentID = 1

SELECT 
		DepartmentID,
		AVG(Salary) AS AverageSalary
FROM #EmployeesHighSalaryTempTable
GROUP BY DepartmentID

-- 16
-- I. Sort all Employees in Groups (Aggregation) based on Department in which
-- they work

SELECT 
		DepartmentID,
		MAX(Salary) AS MaxSalary
FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

-- 18
-- Nth Highest/Lowest value -> Window functions (Ranking) instead of 
-- Grouping (Aggregation)

SELECT *
FROM Employees
ORDER BY DepartmentID

SELECT DISTINCT 
				DepartmentID,
				Salary AS ThirdHighestSalary
FROM (
		SELECT  DepartmentID,
				Salary,
				DENSE_RANK() OVER(PARTITION BY DepartmentID ORDER BY Salary DESC)
				AS SalaryRank
		FROM Employees
) AS SalaryRankQuery
WHERE SalaryRank = 3