-- SQL Project-Library Managment System part2

Select * from books;
Select * from branch;
Select * from employees;
Select * from issued_status;
Select * from members;
Select * from return_status;

/*Task 13:
Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.
*/

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







