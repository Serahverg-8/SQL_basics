-- Joins
	-- Joins play a crucial role in RDBMS - Relational Data
	-- There are 3 types of Joins
		-- Inner Join
		-- Outer Join (Left Outer Join/Left Join, Right Outer Join/Right Join, Full Outer Join/Full Join)
		-- Cross Join

-- Create a table that holds DOB for each employee
CREATE TABLE EmployeeDOB
(
	EmployeeID int
	, EmployeeDOB datetime2
)

INSERT INTO EmployeeDOB(EmployeeID, EmployeeDOB)
SELECT 1, GETDATE()-7000 UNION ALL
SELECT 2, GETDATE()-7300 UNION ALL
SELECT 5, GETDATE()-7900 UNION ALL
SELECT 6, GETDATE()-8000 UNION ALL
SELECT 7, GETDATE()-7800 UNION ALL
SELECT 8, GETDATE()-7600 UNION ALL
SELECT 9, GETDATE()-6000 UNION ALL
SELECT 10, GETDATE()-12000 

SELECT * FROM EmployeeDOB
SELECT * FROM Employee

-- Inner Join
	-- It returns the common records across both these tables
SELECT emp.EmployeeID, EmployeeFirstName, EmployeeLastName, Salary, Address, EmployeeDOB
FROM Employee AS emp
INNER JOIN EmployeeDOB AS edob ON edob.EmployeeID = emp.EmployeeID
--INNER JOIN EmployeeLeaves AS el ON el.EmployeeID = emp.EmployeeID
--INNER JOIN PrimaryKeyTest AS pkt ON pkt.Id = emp.EmployeeId

-- Left Outer Join
	-- Returns the records which are present in the left table and only matching records from
		-- the right table
SELECT *
FROM Employee AS emp 
LEFT OUTER JOIN EmployeeDOB AS edob ON edob.EmployeeID = emp.EmployeeId
WHERE edob.EmployeeDOB IS NULL -- This will help in figuring out the records present in left table but missing in right

-- Right outer Join
	-- Returns all records from the right table and the matching records from the left table
SELECT *--edob.EmployeeID
FROM Employee AS emp 
RIGHT JOIN EmployeeDOB AS edob ON edob.EmployeeID = emp.EmployeeId
WHERE emp.EmployeeID IS NULL

-- Full Outer Join
SELECT *
FROM Employee AS emp 
FULL OUTER JOIN EmployeeDOB AS edob ON edob.EmployeeID = emp.EmployeeId
WHERE emp.EmployeeId IS NULL OR edob.EmployeeID IS NULL

-- CROSS JOIN
	-- Cross join is the cartesian product of both the tables
	-- Each record from one table is joined with all the records from the other table
	-- The size of the output is equal to number of records in the first table X no of records in the
		-- second table

SELECT * FROM Employee AS emp
CROSS JOIN EmployeeDOB AS edob

1
2
3

a
b

1a
2a
3a
1b
2b
3b

CREATE TABLE Months(MonthNm varchar(10)) 

INSERT INTO Months(MonthNm)
SELECT 'Jan' UNION ALL
SELECT 'Feb' UNION ALL
SELECT 'Mar' UNION ALL
SELECT 'Apr' UNION ALL
SELECT 'May' UNION ALL
SELECT 'Jun' UNION ALL
SELECT 'Jul' UNION ALL
SELECT 'Aug' UNION ALL
SELECT 'Sep' UNION ALL
SELECT 'Oct' UNION ALL
SELECT 'Nov' UNION ALL
SELECT 'Dec' 

SELECT EmployeeFirstName, EmployeeLastName,MonthNm 
FROM Employee AS Emp
CROSS JOIN Months AS m

-- Update and DELETE
	-- Take the backup of the rows before your update or DELETE them
	-- Always start your UPDATE and DELETE query with a SELECT
	-- Never EVER EVER EVERRRRR forget your WHERE clause	

-- Take a backup of the rows before you perform any DML operation(UPDATE and DELETE)
SELECT *
INTO Employee_Backup-- Automatically create this physical table for you
FROM Employee

SELECT * FROM Employee_Backup

-- Backup only a few rows from the table
SELECT *
INTO Employee_BackupOnlyRows-- Automatically create this table for you
FROM Employee
WHERE EmployeeID IN (1,4,7)

SELECT * FROM Employee_BackupOnlyRows

-- Backup only few columns
SELECT EmployeeId, Salary
INTO Employee_BackupOnlyColumns
FROM Employee
WHERE EmployeeID IN (1,4,7)

SELECT * FROM Employee_BackupOnlyColumns

--== Update
UPDATE emp
SET EmployeeFirstName = 'DineshNew'
--SELECT *
FROM Employee AS emp
WHERE EmployeeId = 1

-- Revert Back your change using the backup table
UPDATE emp
SET EmployeeFirstName = bak.EmployeeFirstName
--SELECT emp.EmployeeID, emp.EmployeeFirstName AS NewName, bak.EmployeeFirstName AS Original
FROM Employee AS emp
INNER JOIN Employee_Backup AS bak ON bak.EmployeeID = emp.EmployeeID

-- DELETE
DELETE emp
--SELECT *
FROM Employee AS emp
WHERE EmployeeID = 8

-- Revert Back your change using the backup table
INSERT INTO Employee
(
	EmployeeId
	, EmployeeFirstName
	, EmployeeLastName
	, Salary
	, Address
)
SELECT EmployeeID
	, EmployeeFirstName
	, EmployeeLastName
	, Salary
	, Address
FROM Employee_Backup
--WHERE EmployeeID = 8

-- Merge Join(Merge Statement)
/*
Employee - HR - Live table
Salary : The Salary database also needs a copy of the employee data to be 
		refreshed twice a month
		
There can be 3 scenarios : 
1. UPDATE : When the EmployeeID is matching across the source and target but the value 
	in other columns does not match
2. INSERT : When the EmployeeID is present in the source and missing in target
3. DELETE : When the EmployeeId is missing in the source but present in target

Employee-HR(Source)
ID	Name	
1	Mahesh	-- Updated	
3	Smith
4	Leo		-- Inserted

Employee-Payroll(Target)
ID	Name
1	Mahesh
3	Smith
4	Leo

1- When the ID matches but the Name changes - There is an update in the source 
	- We do an UPDATE on the target
2- When the ID is not found in the Source 
	- There is a DELETE from the source - We do a DELETE on the target
3- When the ID is not found in the target 
	- There is an INSERT in the source - We do an INSERT on the TARGET

-- Merge Join was introduced in SQL Server 2008 to perform UPDATE, INSERT 
	and DELETE all at the same time.
-- The merge command uses a source table to read the data and replicates the 
	changes to the target.
-- Based on the matching records in Source, we can set the operation to 
		either Insert, Update or Delete from the target table
		
When doing a MERGE, we do not write to the SOURCE table
We always do the INSERT, UPDATE or DELETE during the MERGE only on the TARGET table
*/

SELECT * FROM Employee -- Source

CREATE TABLE SalaryEmployeeCollection -- Target
(
	EmployeeId int
	, EmployeeFirstName varchar(50)
	, EmployeeLastName varchar(50)
	, Salary int
	, EmployeeAddress varchar(50)
)

SELECT * FROM Employee
SELECT * FROM SalaryEmployeeCollection

UPDATE emp
SET EmployeeFirstName = 'Peter'
, EmployeeLastName = 'Fernandes'
--DELETE emp	
--SELECT *
FROM Employee AS emp
WHERE EmployeeID = 8

--== Merge Statement
MERGE SalaryEmployeeCollection AS TARGET -- Target Table
USING Employee AS Source -- Source Table
ON (TARGET.EmployeeID = Source.EmployeeID)
--1. UPDATE : When the EmployeeID is matching across the source and target, but one of the other columns has a different value
WHEN MATCHED AND (TARGET.EmployeeFirstName <> Source.EmployeeFirstName
		OR TARGET.EmployeeLastName <> Source.EmployeeLastName
		OR TARGET.Salary <> Source.Salary
		OR TARGET.EmployeeAddress <> Source.Address)
THEN UPDATE
	SET TARGET.EmployeeFirstName = Source.EmployeeFirstName
		, TARGET.EmployeeLastName = Source.EmployeeLastName
		, TARGET.Salary = Source.Salary
		, TARGET.EmployeeAddress = Source.Address		
--== 2. INSERT : When the EmployeeID is present in the source and missing in target
WHEN NOT MATCHED BY TARGET
THEN INSERT(EmployeeID, EmployeeFirstName, EmployeeLastName, Salary, EmployeeAddress)
VALUES (Source.EmployeeID, Source.EmployeeFirstName, Source.EmployeeLastName, Source.Salary, Source.Address)
--==3. DELETE : When the EmployeeId is missing in the source but present in target
WHEN NOT MATCHED BY SOURCE
THEN DELETE;


