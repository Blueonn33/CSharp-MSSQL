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