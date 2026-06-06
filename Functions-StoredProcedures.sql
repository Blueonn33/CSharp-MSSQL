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

EXEC usp_FailProc

DECLARE @test INT
SELECT 1/0
SET @test = @@ERROR

SELECT @test


---------------------------------

-- 01
GO

CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
(
	SELECT 
			FirstName,
			LastName
	FROM Employees
	WHERE Salary > 35000
)

GO

EXEC usp_GetEmployeesSalaryAbove35000

GO 

CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000AndDepartment
AS
BEGIN
	SELECT 
			FirstName,
			LastName
	FROM Employees
	WHERE Salary > 35000

	SELECT *
	FROM Departments
END

GO

-- 02
CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber (@minSalary DECIMAL(18,4)) 
AS
BEGIN
		IF @minSalary < 0
			THROW 50001, 'Min salary is not valid?!', 1;
		SELECT 
				FirstName,
				LastName
		FROM Employees
		WHERE Salary >= @minSalary
END

EXEC usp_GetEmployeesSalaryAboveNumber 48100

-- 03
-- 04
-- 05
-- 06
-- 07

GO

CREATE FUNCTION ufn_IsWordComprised (@setOfLetters VARCHAR(50) = '', @word VARCHAR(100) = '')
RETURNS BIT AS
		 BEGIN
				-- Define variable to store the current word index (starting from 1)
				-- String indeces in SQL start from 1
				DECLARE @wordIndex AS TINYINT = 1;
				DECLARE @currentLetter AS CHAR(1);
				DECLARE @letterIndex AS TINYINT = 0;

				-- SQL code in WHILE loop will be repeated length of word times
				WHILE @wordIndex <= LEN(@word)
				BEGIN
						-- SQL code here will be repeated until value of wordIndex is <= of the length of the word
						SET @currentLetter = LOWER(SUBSTRING(@word, @wordIndex, 1));
						SET @letterIndex = CHARINDEX(@currentLetter, @setOfLetters)

						IF @letterIndex = 0
						BEGIN
							-- Missing letter is found
							RETURN 0;
						END

						-- Guarantee that the loop will end at some point
						SET @wordIndex += 1;
				END

				-- All letters from the word were found in the set
				RETURN 1;
		   END

GO

-- User-defined functions are used in SQL queries
SELECT dbo.ufn_IsWordComprised('alim', 'Mila') -- 1
SELECT dbo.ufn_IsWordComprised('alim', 'Mila!') -- 0

