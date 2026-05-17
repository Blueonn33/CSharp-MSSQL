SELECT 
	CONCAT_WS(' ', FirstName, LastName) AS "Full Name",
	JobTitle AS "Job Title",
	Salary
FROM Employees

SELECT DISTINCT
	DepartmentID 
FROM Employees

-- Highest Peek

Select TOP 1 * 
FROM Peaks
ORDER BY Elevation DESC


