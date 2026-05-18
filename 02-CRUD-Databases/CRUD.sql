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

SELECT NEXT VALUE FOR seq_NumberGenerator

----------------------------

DELETE FROM Towns
WHERE TownID = 33

------------------------------

UPDATE Projects
SET EndDate = GETDATE()
WHERE EndDate IS NULL

SELECT * FROM PROJECTS



-- 02

SELECT * FROM Departments

-- 03

SELECT [Name] FROM Departments

-- 04

SELECT FirstName, LastName, Salary FROM Employees

-- 05

SELECT FirstName, MiddleName, LastName FROM Employees

-- 06

SELECT FirstName + '.' + LastName + '@softuni.bg' 
	AS "Full Email Address"
	FROM Employees

-- 07

SELECT DISTINCT Salary
FROM Employees

-- 08

SELECT * FROM Employees
WHERE JobTitle = 'Sales Representative'

-- 09

SELECT FirstName, LastName, JobTitle
FROM Employees
WHERE Salary BETWEEN 20000 AND 30000

-- 10

SELECT CONCAT_WS(' ', FirstName, MiddleName, LastName) 
AS "Full Name"
FROM Employees
WHERE Salary IN (25000, 14000, 12500, 23600)

-- 11

SELECT FirstName, LastName
FROM Employees
WHERE ManagerID IS NULL