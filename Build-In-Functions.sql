SELECT 'Пешо' AS [Name], UPPER('Пешо') AS NormalizedName

SELECT CONCAT(SUBSTRING('8958329213', 1, LEN('8958329213') - 4), REPLICATE('*', 4))

SELECT FORMAT(8.675, 'C2', 'bg-BG')

SELECT CHARINDEX('Uni', 'SoftUni')

------------------

SELECT 
		Id,
		CEILING(
			CAST(CEILING(CAST(Quantity AS FLOAT) / BoxCapacity) AS FLOAT) / PalletCapacity
		)
		FROM Products