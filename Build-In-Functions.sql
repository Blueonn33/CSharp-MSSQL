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
		DAY(InvoiceDate) AS Day
		FROM Invoices