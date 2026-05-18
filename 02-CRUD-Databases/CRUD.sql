SELECT 
	CONCAT_WS(' ', FirstName, LastName) AS "Full Name",
	JobTitle AS "Job Title",
	Salary
FROM Employees

SELECT DISTINCT
	DepartmentID 
FROM Employees

-- Highest Peak - 1
SELECT * FROM v_HighestPeak


INSERT INTO Towns ([Name])
VALUES ('Paris')

SELECT * FROM Towns


---------------------

INSERT INTO Projects ([Name], StartDate)
SELECT [Name] + ' Restructuring', GETDATE() FROM Departments

SELECT * FROM Projects