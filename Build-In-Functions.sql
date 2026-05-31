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
	FirstName,
	LastName,
	DepartmentID,
	Salary
FROM Employees
