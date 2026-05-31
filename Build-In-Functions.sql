SELECT 'Пешо' AS [Name], UPPER('Пешо') AS NormalizedName

SELECT CONCAT(SUBSTRING('8958329213', 1, LEN('8958329213') - 4), REPLICATE('*', 4))

SELECT FORMAT(8.675, 'C2', 'bg-BG')

SELECT CHARINDEX('Uni', 'SoftUni')

------------------

SELECT 
		Id,
		CEILING(
			CAST(CEILING(CAST(Quantity AS FLOAT) / BoxCapacity) AS FLOAT) / PalletCapacity
		) AS Pallets
		FROM Products

-----------------

SELECT SIGN(6)
SELECT SIGN(-98)

SELECT ROUND(RAND() * 100, 0)

-----------------

SELECT DATEPART(WEEKDAY, '2043-09-09')

-----------------

SELECT 
		InvoiceId,
		InvoiceDate,
		Total,
		DATEPART(Q, InvoiceDate) AS Quater,
		DATEPART(M, InvoiceDate) AS [Month],
		YEAR(InvoiceDate) AS [Year],
		DAY(InvoiceDate) AS [Day]
	FROM Invoices

------------------

SELECT 
		EmployeeID,
		FirstName,
		DATEDIFF(DAY, HireDate, GETDATE()) AS YearsInService
	FROM Employees

------------------

SELECT DATENAME(WEEKDAY, '2004-10-21')

------------------

SELECT CAST('67' AS INT) + '3'
SELECT CONVERT(INT, '43') + 3

SELECT * FROM Employees
WHERE MiddleName IS NULL

SELECT ISNULL(MiddleName, 'N/A')	
FROM Employees

SELECT COALESCE('Pesho', 'N/A', 'Misho', 'Lipsva')

SELECT * FROM Employees
ORDER BY EmployeeID
	OFFSET 0 * 10 ROWS			-- retrives the first 10 IDs
	FETCH NEXT 10 ROWS ONLY

SELECT * FROM Employees
ORDER BY EmployeeID
	OFFSET 1 * 10 - 10 ROWS		-- retrives the first 10 IDs
	FETCH NEXT 10 ROWS ONLY

------------------

SELECT
	ROW_NUMBER() OVER (PARTITION BY DepartmentId ORDER BY Salary) AS RowNum,
	RANK() OVER (PARTITION BY DepartmentId ORDER BY Salary) AS [Rank],
	DENSE_RANK() OVER (PARTITION BY DepartmentId ORDER BY Salary) AS DenseRank,
	NTILE(2) OVER (PARTITION BY DepartmentId ORDER BY Salary) AS [NTile], -- devides by N groups(2)
	FirstName,
	LastName,
	DepartmentID,
	Salary
FROM Employees

------------------

SELECT * 
  FROM Employees
 WHERE 
	   FirstName LIKE 'Ro%'

-- %		any string, including zero-length
-- _		any single character
-- [...]	any character within range
-- [^..]	any character not in the range
-- ESCAPE	specify a prefix to treat special characters as normal

SELECT * FROM Projects 
WHERE [Name] LIKE '%?_vest' ESCAPE '?'

--------------------

-- 01
 SELECT 
		FirstName, LastName
   FROM Employees
  WHERE FirstName LIKE 'Sa%'

 SELECT 
		FirstName, LastName
   FROM Employees
  WHERE LEFT(FirstName, 2) = 'Sa'

 SELECT 
		FirstName, LastName
   FROM Employees
  WHERE SUBSTRING(FirstName, 1, 2) = 'Sa'

-- 02
SELECT FirstName, LastName
FROM Employees
WHERE LastName LIKE '%ei%'

-- 03
SELECT FirstName
FROM Employees
WHERE DepartmentID IN (3, 10) AND YEAR(HireDate) BETWEEN 1995 AND 2005

-- 04
-- I. Wildcard -> NOT LIKE '%engineer%'
-- II. NOT CONTAINS('engineer', JobTitle)
-- III. CHARINDEX('engineer', JobTitle) = 0

SELECT FirstName, LastName
FROM Employees
WHERE CHARINDEX('engineer', JobTitle) = 0

-- 05
SELECT [Name] 
FROM Towns
WHERE [Name] LIKE '_____' OR [Name] LIKE '______'
ORDER BY [Name]

SELECT [Name] 
FROM Towns
WHERE LEN([Name]) = 5 OR LEN([Name]) = 6
ORDER BY [Name]

SELECT [Name] 
FROM Towns
WHERE LEN([Name]) IN (5, 6)
ORDER BY [Name]

-- 06
SELECT TownID, [Name] 
FROM Towns
WHERE [Name] LIKE '[MKBE]%'
ORDER BY [Name]

SELECT TownID, [Name] 
FROM Towns
WHERE LEFT([Name], 1) IN ('M', 'K', 'B', 'E')
ORDER BY [Name]

-- 07
SELECT TownId, [Name]
FROM Towns
WHERE [Name] NOT LIKE '[RBD]%'
ORDER BY [Name]

-- 08
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName
FROM Employees
WHERE YEAR(HireDate) > 2000

-- 09
SELECT FirstName, LastName
FROM Employees
WHERE LEN(LastName) = 5

-- 10
  SELECT EmployeeID,
		 FirstName,
		 LastName,
		 Salary,
	     DENSE_RANK() OVER(PARTITION BY Salary ORDER BY EmployeeID) 
	  AS [Rank]
    FROM Employees
   WHERE Salary BETWEEN 10000 AND 50000
ORDER BY Salary DESC

-- 11
 SELECT *
   FROM (
					SELECT EmployeeID,
					 FirstName,
					 LastName,
					 Salary,
					 DENSE_RANK() OVER(PARTITION BY Salary ORDER BY EmployeeID) 
				  AS [Rank]
				FROM Employees
			   WHERE Salary BETWEEN 10000 AND 50000
		) AS EmployeesSalaryRank
   WHERE [Rank] = 2
ORDER BY Salary DESC		

-- 13
SELECT p.PeakName,
	   r.RiverName,
	   LOWER(CONCAT(p.PeakName, SUBSTRING(r.RiverName, 2, LEN(r.RiverName) - 1))) 
	AS Mix
  FROM Peaks 
    AS p, 
	   Rivers 
	AS r
 WHERE RIGHT(p.PeakName, 1) = LEFT(r.RiverName, 1)
ORDER BY Mix

-- 17
SELECT [Name],
	   CASE
			WHEN DATEPART(HOUR, [Start]) BETWEEN 0 AND 11 THEN 'Morning'
			WHEN DATEPART(HOUR, [Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
	   END
    AS [Part of the Day],
	   CASE
			WHEN Duration <= 3 THEN 'Extra Short'
			WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
			WHEN Duration > 6 THEN 'Long'
			WHEN Duration IS NULL THEN 'Extra Long'
		END
	AS  Duration
  FROM Games AS g
ORDER BY g.[Name], 
		 Duration,
		 [Part of the Day]
