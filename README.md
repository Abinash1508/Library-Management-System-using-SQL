# Library-Management-System-using-SQL
## Project Title: Library Management System
Level: Intermediate
Database: library_db

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

Library_project

## Objectives
Set up the Library Management System Database: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
CRUD Operations: Perform Create, Read, Update, and Delete operations on the data.
CTAS (Create Table As Select): Utilize CTAS to create new tables based on query results.
Advanced SQL Queries: Develop complex queries to analyze and retrieve specific data.
Project Structure
1. Database Setup
ERD

## Database Creation: Created a database named library_db.

Library Managment System Project 2
```sql
-- create database library_project2;

-- creating branch table
drop table if exists branch
create table branch
	(
		branch_id varchar(25) primary key,
		manager_id varchar(18),
		branch_address varchar(55),
		contact_no varchar(18)
	);
drop table if exists employees
create table employees
	(
		emp_id varchar(25) primary key,
		emp_name varchar(25),
		position varchar(15),
		salary int,
		branch_id varchar(25)-- FK
	);
drop table if exists books
CREATE TABLE books (
    isbn VARCHAR(25) PRIMARY KEY,
    book_title VARCHAR(100),
    category VARCHAR(30),
    rental_price FLOAT,
    status VARCHAR(10),
    author VARCHAR(50),
    publisher VARCHAR(100)
);

drop table if exists members;
create table members
	(
		member_id varchar(10) primary key,
		member_name varchar(25),
		member_address varchar(75),
		reg_date date
	);
 drop table if exists issued_status;
 create table issued_status
	 (
		 issued_id varchar(10) primary key,
		 issued_member_id varchar (10),-- FK
		 issued_book_name varchar(75),
		 issued_date date,
		 issued_book_isbn varchar(25),--FK
		 issued_emp_id varchar(10)--FK
	 );
 drop table if exists return_status;
  create table return_status
	 (
		 return_id varchar(10) primary key,
		 issued_id varchar (10),
		 return_book_name varchar(75),
		 return_date date,
		 return_book_isbn varchar(25),
	);


 -- Foreign Key
 Alter table issued_status
 add constraint fk_members
 foreign key (issued_member_id)
 references members(member_id);

 Alter table issued_status
 add constraint fk_books
 foreign key (issued_book_isbn)
 references books(isbn);

 /*
 Alter table issued_status
 add constraint fk_employees
 foreign key (issued_book_isbn)
 references employees(emp_id);
 */

 ALTER TABLE issued_status
DROP CONSTRAINT fk_employees;

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE issued_status
ALTER COLUMN issued_emp_id VARCHAR(25);




 Alter table employees
 add constraint fk_branch
 foreign key (branch_id)
 references branch(branch_id);

 Alter table return_status
 add constraint fk_issued_status
 foreign key (issued_id)
 references issued_status(issued_id);



SELECT v.issued_id
FROM (VALUES
('IS101'),
('IS105'),
('IS103'),
('IS106'),
('IS107'),
('IS108'),
('IS109'),
('IS110'),
('IS111'),
('IS112'),
('IS113'),
('IS114'),
('IS115'),
('IS116'),
('IS117'),
('IS118'),
('IS119'),
('IS120')
) AS v(issued_id)
WHERE NOT EXISTS (
    SELECT 1
    FROM issued_status i
    WHERE i.issued_id = v.issued_id
);

INSERT INTO issued_status (...)
VALUES (...);   -- insert ALL missing issued_id values


INSERT INTO issued_status (issued_id)
VALUES 
('IS101'),
('IS105'),
('IS103');   -- insert ALL missing issued_id values





 Select * from branch;
 Select * from employees;
 Select * from books;
 Select * from members;
 Select * from issued_status;
 Select * from return_status;

```


 ## Project task

### Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
```sql
insert into books(isbn, book_title,category,rental_price,status,author,publisher)
values
( '978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

select * from books
```
### Task 2: Update an Existing Member's Address
```sql
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';
```

### Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
```sql
DELETE FROM issued_status
WHERE   issued_id =   'IS121';
```

### Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'
```
### Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
```sql
Select
	issued_emp_id,
	count(issued_id) as total_book_issued
	from issued_status
	group by issued_emp_id
	having count(issued_id) >1
```
## CTAS
### Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
```sql
Select b.isbn, b.book_title, count(ist.issued_id) as issue_count 
from books as b
join issued_status as ist
ON b.isbn=ist.issued_book_isbn
group by b.isbn, b.book_title

CREATE TABLE book_issued_cnt (
    isbn VARCHAR(20),
    book_title VARCHAR(255),
    issue_count INT
);
INSERT INTO book_issued_cnt (isbn, book_title, issue_count)
SELECT 
    b.isbn,
    b.book_title,
    COUNT(ist.issued_id)
FROM issued_status AS ist
JOIN books AS b
    ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;

Select * from book_issued_cnt
```
### Task 7. Retrieve All Books in a Specific Category
```sql
Select * from books
where category='Classic';
```
### Task 8: Find Total Rental Income by Category
```sql
Select
	b.category,
	sum(b.rental_price) as total_rental_income,
	count(*) as total_book_issued
from books as b
join issued_status as ist
on b.isbn=ist.issued_book_isbn
group by b.category
```
### Task 9:List Members Who Registered in the Last 180 Days
```sql
SELECT *
FROM members
WHERE reg_date >= DATEADD(DAY, -180, CAST(GETDATE() AS DATE));

 SELECT GETDATE();
 SELECT CAST(GETDATE() AS DATE);



 insert into members(member_id,member_name,member_address,reg_date)
 values
	('C120','Abinash','846 Elm Avenue','2025-11-11'),
	('C121','Swapnil','848 Richard Avenue','2025-11-15');
```
### Task 10:List Employees with Their Branch Manager's Name and their branch details:
 ```sql
 Select * from branch;
 Select * from employees;

 Select
	e1.emp_id,
	e1.emp_name,
	e1.position,
	e1.salary,
	b.*,
	e2.emp_name as manager
from branch as b
join
employees as e1
on b.branch_id=e1.branch_id
join 
employees as e2
on b.manager_id=e2.emp_id
```
### Task 11. Create a Table of Books with Rental Price Above a Certain Threshold
```sql
Select * from books;
Select max(rental_price)
from books

Select * from books
where rental_price> 7.00;
```
### Task 12: Retrieve the List of Books Not Yet Returned
```sql
Select * from issued_status
Select * from return_status

Select 
	distinct ist.issued_book_name
	from issued_status as ist
left join
return_status as rs
on rs.issued_id=ist.issued_id
where rs.return_id is null;
```
### Task 13:
#### Identify Members with Overdue Books. Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
Select CAST(getdate() as date);
Select
	ist.issued_member_id,
	m.member_name,
	bk.book_title,
	ist.issued_date,
	rs.return_date,
	datediff(day,ist.issued_date,cast(getdate() as date)) as over_dues_date
from issued_status as ist
join
members as m
	on m.member_id= ist.issued_member_id
join
books as bk
on bk.isbn=ist.issued_book_isbn
left join 
return_status as rs
on rs.issued_id=ist.issued_id
where 
	rs.return_date is null
	and
	datediff(day,ist.issued_date,cast(getdate() as date))>30
```
## Reports
Database Schema: Detailed table structures and relationships.
Data Analysis: Insights into book categories, employee salaries, member registration trends, and issued books.
## Summary Reports: 
Aggregated data on high-demand books and employee performance.
## Conclusion
This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.
