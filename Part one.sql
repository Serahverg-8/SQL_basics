/*
Hello 
world
*/
--This is a line that I want to comment
/*
 Three options to execute your query : 
	 Execute button at the top of the query window
	 Use F5 (fn+F5)
	 Ctrl + E
 To hide/unhide the results window/pane : Ctrl + R
 To Comment a line of code  : Ctrl+K+C
 To uncomment : Ctrl+K+U
 
 CREATE A DATABASE
	 Database is a storage unit that helps us in storing data in form of tables.
	 Database also holds certain other objects that helps us in managing and accessing data as well.
	 All these above objects are referred to as database objects and are created in the database itself
*/
--1. To create a database using Transact-SQL(TSQL)
CREATE DATABASE Intellipaat_23_Oct_2021

--2. Using the GUI(Graphical User Interface)

-- Whenever we create a database there are two files that are created : 
	-- MDF (Master Data File) - It holds data that is stored
	-- LDF (Log Data File) - It holds the log of all the changes that is performed on the database

-- Change the database connection
USE Intellipaat_23_Oct_2021

-- Remove/Delete the database -- Comments in SQL Server
DROP DATABASE Intellipaat_23_Oct_2021

-- 2 types of comments
	-- Single Line : --
	-- Multi Line  : /*.....*/

-- Tables in SQL Server
	-- Table is a container that comprises of multiple fields(columns) that helps us in storing data
	-- Alt + F1 - To view the metadata of the object
CREATE TABLE Employee
(
	EmployeeId int
	, EmployeeFirstName varchar(100)
	, EmployeeLastName varchar(100)
	, Salary int
	, Address varchar(500)-- Address is a keyword in SQL
)
GO

sp_help Employee
GO
/*
DATABASE ==> SCHEMA ==> TABLES

Schema
	-- Logical Partition of the database
	-- dbo stands for database objects
	-- dbo schema is the default schema for all the database objects
Database --> Schemas --> Tables/Objects
*/

CREATE SCHEMA Food -- Employee, Product, Sale, Profit
GO -- Batch is forced to end

CREATE SCHEMA Clothing -- Employee, Product, Sale, Profit
GO

CREATE SCHEMA Electronics-- Employee, Product, Sale, Profit
GO

-- To remove a schema
DROP SCHEMA Food
GO

CREATE TABLE Food.Employee
(
	EmployeeId int
	, EmployeeFirstName varchar(100)
	, EmployeeLastName varchar(100)
	, Salary int
	, Address varchar(100)
)

CREATE TABLE Clothing.Employee
(
	EmployeeId int
	, EmployeeFirstName varchar(100)
	, EmployeeLastName varchar(100)
	, Salary int
	, Address varchar(100)
)

CREATE TABLE Electronics.Employee
(
	EmployeeId int
	, EmployeeFirstName varchar(100)
	, EmployeeLastName varchar(100)
	, Salary int
	, [Address] varchar(100)
)

-- Insert data into a table
	-- Values
	INSERT INTO Employee
	(
		EmployeeId
		, EmployeeFirstName
		, EmployeeLastName
		, Salary
		, Address
	)
	VALUES (1,'Dinesh','Kumar', 1000, 'India')
	, (2,'John','Smith', 2000, 'US')
	, (3,'Santosh','Kumar', 3000, 'India')
	, (4,'Steve','Smith', 5000, 'Aus')
	
	-- Select
	INSERT INTO Employee
	(
		EmployeeId
		, EmployeeFirstName
		, EmployeeLastName
		, Salary
		, Address
	)
	SELECT 5,'Kumar','Sanu',2750,'India' UNION ALL
	SELECT 6,'Ravi','Kumar',4300,'India' UNION ALL
	SELECT 7,'John','Cena',2750,'US' UNION ALL
	SELECT 8,'John','Wright',2750,'US' 

-- Retrive the data from the table
SELECT * -- * represents all the columns
FROM Employee -- The name of the table

SELECT *
FROM Food.Employee
-- Select a hardcoded value
	-- UNION returns only the distinct rows whereas UNION ALL returns all the values

SELECT 1,'Dinesh' UNION ALL
SELECT 1,'Dinesh' UNION ALL
SELECT 2,'Dinesh' 

SELECT 1,'Dinesh' UNION 
SELECT 1,'Dinesh' UNION 
SELECT 2,'Dinesh' UNION
SELECT 2,'Dinesh'

/*
-- Constraints/Integrity Constraints
	-- These are rules that we apply on the column of a table(while creating) 
		-- to restrict the data that can be stored in the column
		NOT NULL
		UNIQUE
		PRIMARY KEY
		FOREIGN KEY
		CHECK
		DEFAULT
		IDENTITY
*/
--NOT NULL
	-- Helps us in identifying the columns that can hold NULL and that cannot
	-- By default when we create a column it is set to NULLABLE
	-- The columns which are NULLBALE are optional for insert
CREATE TABLE NotNULLTest
(
	Id int NOT NULL -- Mandatory
	, Name varchar(100) -- Optional
)

INSERT INTO NotNULLTest(ID,Name)
SELECT 1,'Dinesh'

INSERT INTO NotNULLTest(ID,Name)
SELECT NULL,'John'

INSERT INTO NotNULLTest(ID,Name)
SELECT 3,NULL

INSERT INTO NotNULLTest(ID)
SELECT 4

SELECT * FROM NotNULLTest

-- Unique
	-- This helps us in maintaining unique data in a column
	-- There is also one NULL value that is allowed per Unique column
CREATE TABLE UniqueTest
(
	Id int UNIQUE --NOT NULL
	, Name varchar(100) 
)

INSERT INTO UniqueTest(Id,name)
SELECT 1,'Dinesh'

INSERT INTO UniqueTest(Id,name)
SELECT 2,'John'

INSERT INTO UniqueTest(Id,name)
SELECT NULL,'John'

SELECT * FROM UniqueTest

-- PRIMARY KEY
	-- Uniquely identifiyng a row in a table
	-- Combination of UNIQUE and NOT NULL constraint
CREATE TABLE PrimaryKeyTest
(
	Id int PRIMARY KEY
	, Name varchar(100)
)

-- You want to create a primary key after the table is created
--ALTER TABLE PrimaryKeyTest -- Table Name
--ADD CONSTRAINT PK_PKT PRIMARY KEY (Id,Name) 

INSERT INTO PrimaryKeyTest(Id,Name)
SELECT 1,'Dinesh'

INSERT INTO PrimaryKeyTest(Id,Name)
SELECT 2,'John'

SELECT * FROM PrimaryKeyTest

-- Foreign Key
/*
Emp(Parent Table)
EmpId(PK) Name
1		  Dinesh
2		  John
3		  Smith

EmpDOB(Child Table)
EmpID(FK)  DOB
1		   28-09-1991
2		   28-07-1982
3		   28-06-1976
--4		   28-10-1987 -- Orphan Record : This will never get inserted
*/

-- Is a field that helps us in identifying a row in another(primary parent) table
CREATE TABLE ForeignKeyTest
(
	Id int FOREIGN KEY REFERENCES PrimaryKeyTest(ID)-- TableName(ColumnName)
	, DOB datetime
)

INSERT INTO ForeignKeyTest(Id,DOB)
SELECT 1,'2019-01-10'

SELECT * FROM ForeignKeyTest

INSERT INTO ForeignKeyTest(Id,DOB)
SELECT 5,'2019-01-10'

SELECT * FROM PrimaryKeyTest

SELECT * FROM ForeignKeyTest

-- Check Constraint
	-- Helps us in checking the value that is inserted against a condition
CREATE TABLE CheckTest
(
	Id int
	, Age int CHECK(Age >= 60)
)

INSERT INTO CheckTest(Id,Age)
SELECT 1,60

INSERT INTO CheckTest(Id,Age)
SELECT 2,59

SELECT * FROM CheckTest

CREATE TABLE CheckTest2
(
	Name varchar(100)
	, Flag varchar(10) CHECK(Flag IN ('Yes','No'))
)

INSERT INTO CheckTest2(Name,Flag)
SELECT 'Dinesh','No'

INSERT INTO CheckTest2(Name,Flag)
SELECT 'Leo','YES'

INSERT INTO CheckTest2(Name,Flag)
SELECT 'John','Y'

SELECT * FROM CheckTest2

-- DEFAULT
	-- Helps us in inserting the default value to a column when there is no value
	-- specified explicitly

SELECT * FROM NotNULLTest

CREATE TABLE DefaultTest
(
	Id int
	, Name varchar(100) DEFAULT('NoNameProvided')
)

INSERT INTO DefaultTest(Id,Name)
SELECT 1,'Dinesh'

SELECT * FROM DefaultTest

INSERT INTO DefaultTest(Id,Name)
SELECT 2,NULL

INSERT INTO DefaultTest(Id)
SELECT 3 

-- IDENTITY CONSTRAINT
	-- Helps us in generating identity values for each row of the table
	-- Normally, you cannot insert data into a Identity column manually
CREATE TABLE IdentityTest
(	
	ID int IDENTITY(1,1) -- (Seed, Increment)
	, Name varchar(100)
)

INSERT INTO IdentityTest(Name)
SELECT 'Dinesh' UNION
SELECT 'John'

--sp_help IdentityTest

SELECT * FROM IdentityTest

SET IDENTITY_INSERT IdentityTest ON
GO

INSERT INTO IdentityTest(Id,name)
SELECT 17,'Leo'

SET IDENTITY_INSERT IdentityTest OFF
GO

CREATE TABLE IdentityTest3
(	
	ID int IDENTITY(5,5) -- (Seed, Increment)
	, Name varchar(100)
)

INSERT INTO IdentityTest3(Name)
SELECT 'Dinesh'
INSERT INTO IdentityTest3(Name)
SELECT 'John'

SELECT * FROM IdentityTest3

SELECT * FROM Employee

-- Data Retrieval Part
	-- SELECT statement helps us in filtering the columns
	-- We use the WHERE clause to restrict/filter the rows that are displayed
SELECT * --* Represents all columns in the table
	--emp.EmployeeFirstName
	--,emp.EmployeeLastName
	--,emp.Address AS AddressOfEmployee -- Column Alias
FROM Employee AS emp -- Table Alias name for a table is the short name for the table for this particular query
--WHERE EmployeeID = 5 -- Filter on one single integer value
--WHERE EmployeeFirstName = 'John' -- Filter on one single text value
--WHERE EmployeeID IN (1,2,5) -- Filter multiple values
--WHERE EmployeeFirstName IN ('John','Dinesh')
--WHERE EmployeeID >= 3
--WHERE EmployeeID <= 3
--WHERE EmployeeID != 3 -- != and <> are not equal to operators
--WHERE EmployeeID <> 3
--WHERE EmployeeID > 3 AND Address = 'India' -- BOTH conditions should be TRUE
--WHERE EmployeeID > 5 OR Address = 'India' -- Returns the record if atleast one condition is TRUE
--WHERE NOT EmployeeID IN (1,5,7)
WHERE EmployeeID BETWEEN 3 AND 6 -- Returns all the records 3 and 6 and everything between

-- DISTINCT
	-- Helps us in retrieving only the distinct values from a table
SELECT DISTINCT Address, EmployeeFirstName, EmployeeLastName
FROM Employee

-- TOP Clause
	-- Top helps us in displaying n number of records as per request
SELECT TOP 2 *
FROM Employee AS emp
WHERE Address = 'India'

-- LIKE operator
	-- Helps us in identifying patterns in the text values
	-- % refers to 0 to n number of alpha numeric characters
	-- _ refers to only one alpha numeric character
SELECT *
FROM Employee
--WHERE EmployeeFirstName LIKE '%oh%' -- Filter out all records which contains o in it
--WHERE EmployeeFirstName LIKE '%h' -- Filters out all the records which ends with h
--WHERE EmployeeFirstName LIKE 'd%' -- Filters out all the records which begins with d
--WHERE EmployeeFirstName LIKE '%s_'
WHERE EmployeeFirstName LIKE '_o%'





	