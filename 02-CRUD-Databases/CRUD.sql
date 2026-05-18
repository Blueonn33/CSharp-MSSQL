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

------------------------

SELECT 
	FirstName,
	LastName,
	d.[Name] AS DepartmentName
INTO EmployeesWithDepartment
FROM Employees AS e JOIN Departments AS d ON e.DepartmentID = d.DepartmentID

---------------------------

CREATE SEQUENCE seq_NumberGenerator
	AS INT
	START WITH 1
	INCREMENT BY 1
