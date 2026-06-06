CREATE FUNCTION udf_ProjectDurationInWeeks(@StartDate DATETIME, @EndDate DATETIME)
RETURNS INT
AS 
BEGIN
	DECLARE @projectDuration INT 
	IF (@EndDate IS NULL)
	BEGIN
		SET @EndDate = GETDATE()
	END
	SET @projectDuration = DATEDIFF(WEEK, @StartDate, @EndDate)
	RETURN @projectDuration
END;

SELECT 
		[Name],
		dbo.udf_ProjectDurationInWeeks(StartDate, EndDate) AS ProjectDuration
FROM Projects

-------------
-- Трябва да се сложи на отделно Query

CREATE FUNCTION udf_AverageSalary(@DepartmentName VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
		SELECT 
				d.[Name] AS DepartmentName,
				AVG(e.Salary) AS AverageSalary
		FROM Departments AS d
		JOIN Employees AS e ON d.DepartmentID = e.DepartmentID
		WHERE d.[Name] = @DepartmentName
		GROUP BY d.[Name]
)

SELECT *
FROM udf_AverageSalary('Sales')

------------
CREATE FUNCTION udf_SalaryLevel(@Salary MONEY)
RETURNS VARCHAR(10)
BEGIN
	DECLARE @level VARCHAR(10)
	IF(@Salary < 30000)
	BEGIN
		SET @level = 'Low'
	END
	ELSE IF(@Salary <= 50000)
	BEGIN
		SET @level = 'Average'
	END
	ELSE
	BEGIN
		SET @level = 'High'
	END
	RETURN @level
END;

SELECT
		FirstName,
		LastName,
		Salary,
		dbo.udf_SalaryLevel(Salary) AS SalaryLevel
FROM Employees

--------------

CREATE OR ALTER PROCEDURE usp_SelectEmployeesBySeniority
(@MinYears INT = 5)
AS 
	SELECT 
			FirstName,
			LastName,
			HireDate,
			DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsOnDuty
	FROM Employees
	WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > @MinYears
	ORDER BY HireDate

EXEC usp_SelectEmployeesBySeniority 24
-- EXEC usp_SelectEmployeesBySeniority @MinYears = 24

EXEC sp_depends usp_SelectEmployeesBySeniority

-----------------
-- sum 2 numbers - stored procedure

GO

CREATE OR ALTER PROCEDURE usp_AddNumbers
(
	@FirstNumber INT,
	@SecondNumber INT,
	@Result INT OUTPUT
)
AS 
SET @Result = @FirstNumber + @SecondNumber

GO

DECLARE @answer INT
EXEC usp_AddNumbers 5, 6, @answer OUTPUT

SELECT CONCAT_WS(' ', 'The result is', @answer) AS SumOfNumbers

------------

CREATE OR ALTER PROCEDURE usp_FailProc
AS
BEGIN TRY
	-- Generate a divide-by-zero error
	SELECT 1/0
END TRY
BEGIN CATCH
	SELECT 
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() AS ErrorState,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO