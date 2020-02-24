/*1.   SQL Query for Retrieving Tables
This query can be run to retrieve the list of tables present in a database where the database is “My_Schema”.
*/

SELECT * FROM My_Schema.Tables;

/*2.   Query for Selecting Columns from a Table
This is perhaps the most widely used SQL queries examples. In the example below, we are extracting 
the “Student_ID” column or attribute from the table “STUDENT”.
*/

SELECT Student_ID FROM STUDENT;

--If you want to display all the attributes from a particular table, this is the right query to use:
SELECT * FROM STUDENT;

/*3.   Query for Outputting Data Using a Constraint
--This SQL query retrieves the specified attributes from the table on the constraint Employee ID =0000*/
SELECT EMP_ID, NAME FROM EMPLOYEE_TBL WHERE EMP_ID = '0000';

/*4. Query for Outputting Sorted Data Using ‘Order By’
This query orders the results with respect to the attribute which is referenced to using “Order By” – 
so for example, if that attribute is an integer data type, then the result would either be sorted in 
ascending or descending order; likewise, if the data type is a String then the result would be ordered in alphabetical order.*/
SELECT EMP_ID, LAST_NAME FROM EMPLOYEE
WHERE CITY = 'Seattle' ORDER BY EMP_ID;

/*The ordering of the result can also be set manually, using “asc ” for ascending and “desc” for descending.*/
SELECT EMP_ID, LAST_NAME FROM EMPLOYEE_TBL
WHERE CITY = 'INDIANAPOLIS' ORDER BY EMP_ID asc;

/*5.   SQL Query for Outputting Sorted Data Using ‘Group By’
The ‘Group By’ property groups the resulting data according to the specified attribute.
The SQL query below will select Name, Age columns from Patients table, then will filter them 
by Age value to include records where Age is more than 40 and then will group records with similar Age 
value and then finally will output them sorted by Name.
*/
SELECT Name, Age FROM Patients WHERE Age > 40 
GROUP BY Name, Age ORDER BY Name;

/*Another sample of use of Group By: this expression will select records with a price lesser than 70 from Orders table, 
will group records with a similar price, will sort the output by price and will also add the column COUNT(price) that 
will display how many records with similar price where found:
*/
SELECT COUNT(price), price FROM orders 
WHERE price < 70 GROUP BY price ORDER BY price
/*Note: you should use the very same set of columns for both SELECT and GROUP BY commands, 
otherwise you will get an error. Many thanks to Sachidannad for pointing out!
*/

/*SQL Queries for Data Manipulation Using Math Functions
There are a lot of built-in math functions like COUNT and AVG which provide basic functionalities of counting 
the number of results and averaging them respectively.

6. Data Manipulation Using COUNT
This query displays the total number of customers by counting each customer ID. In addition, 
it groups the results according to the country of each customer.
*/
SELECT COUNT(CustomerID), Country FROM Customers GROUP BY Country;

/*7. Data Manipulation Using SUM
SUM calculates the total of the attribute that is given to it as an argument.
*/
SELECT SUM(Salary)FROM Employee WHERE Emp_Age < 30;

/*8. Data Manipulation Using AVG
Simple – an average of a given attribute.
*/
SELECT AVG(Price)FROM Products;

/*9.   SQL Query for Listing all Views
This SQL query lists all the views available in the schema.
*/
SELECT * FROM My_Schema.views;

/*10. Query for Creating a View
A view is a tailored table that is formed as a result of a query. It has tables and rows just like any other table. 
It’s usually a good idea to run queries in SQL as independent views because this allows them to be retrieved 
later to view the query results, rather than computing the same command every time for a particular set of results.
*/
CREATE VIEW Failing_Students AS
SELECT S_NAME, Student_ID
FROM STUDENT
WHERE GPA > 40;
/*11. Query for Retrieving a View
The standard syntax of selecting attributes from a table is applicable to views as well.
*/
SELECT * FROM Failing_Students;

/*12. Query for Updating a View
This query updates the view named ‘Product List’ – and if this view doesn’t exist, then the Product List view 
gets created as specified in this query.
*/
CREATE OR REPLACE VIEW [ Product List] AS
SELECT ProductID, ProductName, Category
FROM Products
WHERE Discontinued = No;

/*13. Query for Dropping a View
This query will drop or delete a view named ‘V1’.
*/
DROP VIEW V1;

/*14. Query to Display User Tables
A user-defined table is a representation of defined information in a table, and they can be used as arguments 
for procedures or user-defined functions. Because they’re so useful, it’s useful to keep track of them using 
the following query.
*/
SELECT * FROM Sys.objects WHERE Type='u'

/*15. Query to Display Primary Keys
A primary key uniquely identifies all values within a table. The following SQL query lists all the fields 
in a table’s primary key.
*/
SELECT * from Sys.Objects WHERE Type='PK'

/*16. Query for Displaying Unique Keys
A Unique Key allows a column to ensure that all of its values are different.
*/
SELECT * FROM Sys.Objects WHERE Type='uq'

/*17. Displaying Foreign Keys
Foreign keys link one table to another – they are attributes in one table which refer to the primary key of another table.
*/
SELECT * FROM Sys.Objects WHERE Type='f'

/*18. Displaying Triggers
A Trigger is sort of an ‘event listener’ – i.e, it’s a pre-specified set of instructions that execute when a certain event occurs. The list of defined triggers can be viewed using the following query.
*/
SELECT * FROM Sys.Objects WHERE Type='tr'

/*19. Displaying Internal Tables
Internal tables are formed as a by-product of a user-action and are usually not accessible. 
The data in internal tables cannot be manipulated; however, the metadata of the internal tables 
can be viewed using the following query.
*/
SELECT * FROM Sys.Objects WHERE Type='it'

/*20. Displaying a List of Procedures
A stored procedure is a group of SQL queries that logically form a single unit and perform a particular task. 
Thus, using the following query you can keep track of them:
*/
SELECT * FROM Sys.Objects WHERE Type='p'

/*21. Swapping the Values of Two Columns in a table
In this and subsequent examples, we will use a common company database including several tables which are easily visualized. 
Our practice DB will include a Customers table and an Order table. The Customers table will contain some obvious columns 
including ID, Name, Address, zip, and email, for example, where we assume for now that the primary key field 
for indexing is the Customer_ID field.

With this in mind, we can easily imagine an Orders table which likewise contains the indexed customer ID field, 
along with details of each order placed by the customer. This table will include the order Number, Quantity, Date, Item, 
and Price. In our first one of SQL examples, imagine a situation where the zip and phone fields were transposed 
and all the phone numbers were erroneously entered into the zip code field. We can easily fix this problem 
with the following SQL statement:
*/
UPDATE Customers SET Zip=Phone, Phone=Zip

/*22. Returning a Column of Unique Values
Now, suppose that our data entry operator added the same Customers to the Customers table more than once by mistake. As you know, proper indexing requires that the key field contain only unique values. To fix the problem, we will use SELECT DISTINCT to create an indexable list of unique customers:
*/
SELECT DISTINCT ID FROM Customers

/*23. Making a Top 25 with the SELECT TOP Clause
Next, imagine that our Customers table has grown to include thousands of records, but we just want to show a sample of 25 of these records to demonstrate the column headings and The SELECT TOP clause allows us to specify the number of records to return, like a Top-25 list. In this example we will return the top 25 from our Customers table:
*/
SELECT TOP 25 FROM Customers WHERE Customer_ID<>NULL;

/*24. Searching for SQL Tables with Wildcards
Wildcard characters or operators like “%” make it easy to find particular strings in a large table of thousands of records. 
Suppose we want to find all of our customers who have names beginning with “Herb” including Herberts, and Herbertson. 
The % wildcard symbol can be used to achieve such a result. The following SQL query will return all rows from the 
Customer table where the Customer_name field begins with “Herb”:
*/
SELECT * From Customers WHERE Name LIKE 'Herb%'

/*25. Between Monday and Tuesday
Today is Wednesday, and we arrive at work and discover that our new data entry clerk in training has entered all new orders incorrectly on Monday and Tuesday. We wish to teach our new trainee to find and correct all erroneous records. What’s the easiest way to get all the records from the Orders table entered on Monday and Tuesday? The Between clause makes the task a breeze:
*/
SELECT ID FROM Orders WHERE
Date BETWEEN ‘01/12/2018’ AND ‘01/13/2018’

/*26. Finding the Intersection of Two Tables
Undoubtedly the whole reason that a relational database exists in the first place is to find matching records in two tables! 
The JOIN statement accomplishes this core objective of SQL and makes the task easy. Here we are going to fetch a list of 
all records which have matches in the Customers and Orders tables:
*/
SELECT ID FROM Customers INNER
JOIN Orders ON Customers.ID = Orders.ID

/*The point of INNER JOIN, in this case, is to select records in the Customers table which have a matching customer 
ID values in the Orders table and return only those records. Of course there are many types of JOIN, such as FULL, SELF, 
and LEFT, but for now, let’s keep things interesting and move on to more diverse types of queries.
*/
/*27. Doubling the Power with UNION
We can combine the results of two SQL queries examples into one naturally with the UNION keyword. 
Suppose we want to create a new table by combining the Customer_name and phone from Customers with a list of that 
customer’s recent orders so that we can look for patterns and perhaps suggest future purchases. Here is a quick way to 
accomplish the task:*/
SELECT phone FROM Customers 
UNION SELECT item FROM Orders
/*The UNION keyword makes it possible to combine JOINS and other criteria to achieve very powerful new table generation 
potential.*/

/*28. Making Column Labels More Friendly
Aliasing column labels give us the convenience of renaming a column label to something more readable. 
There is a tradeoff when naming columns to make them succinct results in reduced readability in subsequent daily use. 
In our Orders table, the item column contains the description of purchased products. Let’s see how to alias the item column 
to temporarily rename it for greater user-friendliness:*/
SELECT Item AS item_description FROM Orders

/*29. Always and Everywhere!
Wouldn’t it be great if there were a set of conditions you could depend on every time? The SQL queries using ANY 
and ALL can make this ideal a reality! Let’s look at how the ALL keyword is used to include records only when 
a set of conditions is true for ALL records. In the following example, we will return records from the Orders table 
where the idea is to get a list of high volume orders for a given item, in this case for customers who ordered more 
than 50 of the product:*/
SELECT Item FROM Orders 
WHERE id = ALL
(SELECT ID FROM Orders
WHERE quantity > 50)

/*30. Writing Developer Friendly SQL
An often overlooked but very important element of SQL scripting is adding comments to a script of queries to explain 
what it’s doing for the benefit of future developers who may need to revise and update your queries.
The — single line and the /* .. */ multi-line delimiters empower us to add useful comments to scripts, but this is also 
used in another valuable way. Sometimes a section of code may not be in use, but we don’t want to delete it, because we 
anticipate using it again. Here we can simply add the comment delimiter to deactivate it momentarily:*/
/* This query below is commented so it won't execute*/
/*
SELECT item FROM Orders 
WHERE date ALL = (SELECT Order_ID FROM Orders
WHERE quantity > 50)
*/
 
/* the sql query below the will be executed 
ignoring the text after "--"
*/
 
SELECT item -- single comment  
FROM Orders -- another single comment
WHERE id 
ALL = (SELECT ID FROM Orders
WHERE quantity > 25)

/*31.  SQL queries for Database Management
So far we have explored SQL query commands for querying tables and combining records from multiple queries. Now it’s time 
to take a step upward and look at the database on a structural level. Let’s start with the easiest SQL statement of all 
which creates a new database. Here, we are going to create the DB as a container for our Customers and Orders tables used 
in the previous ten examples above:*/
CREATE DATABASE AllSales

/*32. Adding Tables to Our New DB
Next, we will actually add the Customers table which we’ve been using in previous examples, and then add some of the 
column labels which we are already familiar with:*/
CREATE TABLE Customers (
ID varchar(80),
Name varchar(80),
Phone varchar(20),
....
);
/*Although most databases are created using a UI such as Access or OpenOffice, it is important to know how to create 
and delete databases and tables programmatically via code with SQL statements. This is especially so when installing 
a new web app and the UI asks new users to enter names for DBs to be added during installation.*/

/*33. Modifying and Deleting Tables with SQL
Imagine that you decide to send a birthday card to your customers to show your appreciation for their business, 
and so you want to add a birthday field to the Customers table. In these SQL examples, you see how easy it is to modify 
existing tables with the ALTER statement:*/
ALTER TABLE Customers ADD Birthday varchar(80)

/*If a table becomes corrupted with bad data you can quickly delete it like this:*/
DROP TABLE table_name

/*34. The Key to Successful Indexing
Accurate indexing requires that the Primary Key column contain only unique values for this purpose. This guarantees 
that JOIN statements will maintain integrity and produce valid matches. Let’s create our Customers table again and establish 
the ID column as the Primary Key:*/
CREATE TABLE Customers (
ID int NOT NULL,
Name varchar(80) NOT NULL,
PRIMARY KEY (ID)
);

/*We can extend the functionality of the Primary Key so that it automatically increments from a base. Change the ID entry 
above to add the AUTO_INCREMENT keyword as in the following statement:*/
ID int NOT NULL AUTO_INCREMENT

/*35. Advanced Concepts For Improving Performance
Whenever practical, is always better to write the column name list into a SELECT statement rather than using the * delimiter 
as a wildcard to select all columns. SQL Server has to do a search and replace operation to find all the columns in your table 
and write them into the statement for you (every time the SELECT is executed). For example:*/
SELECT * FROM Customers

/*Would actually execute much faster on our database as:*/

SELECT Name, Birthday, Phone, 
Address, Zip FROM Customers
Performance pitfalls can be avoided in many ways. For example, avoid the time sinkhole of forcing SQL Server to check the system/master database every time by using only a stored procedure name, and never prefix it with SP_. Also setting NOCOUNT ON reduces the time required for SQL Server to count rows affected by INSERT, DELETE, and other commands. Using INNER JOIN with a condition is much faster than using WHERE clauses with conditions. We advise developers to learn SQL server queries to an advanced level for this purpose. For production purposes, these tips may be crucial to adequate performance. Notice that our tutorial examples tend to favor the INNER JOIN.

36. Conditional Subquery Results
The SQL operator EXISTS tests for the existence of records in a subquery and returns a value TRUE if a subquery returns one or more records. Have a look at this query with a subquery condition:

1
2
3
SELECT Name FROM Customers WHERE EXISTS 
(SELECT Item FROM Orders 
WHERE Customers.ID = Orders.ID AND Price < 50)
In this example above, the SELECT returns a value of TRUE when a customer has orders valued at less than $50.

37. Copying Selections from Table to Table
There are a hundred and one uses for this SQL tool. Suppose you want to archive your yearly Orders table into a larger archive table. This next example shows how to do it.

1
2
3
INSERT INTO Yearly_Orders 
SELECT * FROM Orders 
WHERE Date<=1/1/2018
This example will add any records from the year 2018 to the archive.

38. Catching NULL Results
In cases where NULL values are allowed in a field, calculations on those values will produce NULL results as well. This can be avoided by use of the IFNULL operator. In this next example, a value of zero is returned rather than a value of NULL when the calculation encounters a field with NULL value:

1
2
3
SELECT Item, Price * 
(QtyInStock + IFNULL(QtyOnOrder, 0)) 
FROM Orders
39. HAVING can be Relieving!
The problem was that the SQL WHERE clause could not operate on aggregate functions. The problem was solved by using the HAVING clause. As an example, this next query fetches a list of customers by the region where there is at least one customer per region:

1
2
3
4
SELECT COUNT(ID), Region
FROM Customers
GROUP BY Region
HAVING COUNT(ID) > 0;
40. Tie things up with Strings!
Let’s have a look at processing the contents of field data using functions. Substring is probably the most valuable of all built-in functions. It gives you some of the power of Regex, but it’s not so complicated as Regex. Suppose you want to find the substring left of the dots in a web address. Here’s how to do it with an SQL Select query:

1
SELECT SUBSTRING_INDEX("www.bytescout.com", ".", 2);
This line will return everything to the left of the second occurrence of “. ” and so, in this case, it will return

1
<a href="https://bytescout.com">www.bytescout.com</a>
41. Use COALESCE to return the first non-null expression
The SQL Coalesce is used to manage the NULL values of the database. In this method, the NULL values are substituted with the user-defined value. The SQL Coalesce function assesses the parameters in series and always delivers first non-null value from the specified argument record.

For example,

Syntax:

1
SELECT COALESCE(NULL,NULL,'ByteScout',NULL,'Byte')
Output

ByteScout

42. Use Convert to transform any value into a particular datatype
This is used to convert a value into a defined datatype. For example, if you want to convert a particular value into int datatype then convert function can be used to achieve this. For example,

1
SELECT CONVERT(int, 27.64)
Output
27

43. DENSE_RANK()Analytical query
It is an analytic query that computes the rank of a row in an arranged collection of rows. An output rank is a number starting from 1. DENSE_RANK is one of the most important analytic queries. It returns rank preferences as sequential numbers. It does not jump rank in event of relations. For example, the following query will give the sequential ranks to the employee.

SELECT eno,
dno,
salary,
DENSE_RANK() OVER (PARTITION BY dno ORDER BY salary) AS ranking
FROM   employee;
 
ENO         DNO SALARY     RANKING
---------- ---------- ---------- ----------
7933         10 1500          1
7788         10 2650          2
7831         10 6000          3
7362         20 900          1
7870         20 1200          2
7564         20 2575          3
7784         20 4000          4
7903         20 4000          4
7901         30 550          1
7655         30 1450          2
7522         30 1450          2
7844         30 1700          3
7493         30 1500          4
7698         30 2850          5
/*44. Query_partition_clause
The query_partition_clause breaks the output set into distributions, or collections, of data. The development of the analytic query is limited to the confines forced by these partitions, related to the process a GROUP BY clause modifies the performance of an aggregate function. If the query_partition_clause is eliminated, the entire output collection is interpreted as a separate partition.

The following query applies an OVER clause, so the average displayed is based on all the records of the output set.
*/
SELECT eno, dno, salary,
AVG(salary) OVER () AS avg_sal
FROM   employee;
 
/*EO         DNO SALARY      AVG_SAL
---------- ---------- ---------- ----------
7364         20 900 2173.21428
7494         30 1700 2173.21428
7522         30 1350 2173.21428
7567         20 3075 2173.21428
7652         30 1350 2173.21428
7699         30 2950 2173.21428
7783         10 2550 2173.21428
7789         20 3100 2173.21428
7838         10 5100 2173.21428
7845         30 1600 2173.21428
7877         20 1200 2173.21428
7901         30 1050 2173.21428
7903         20 3100 2173.21428
7935         10 1400 2173.21428
45. Finding the last five records from the table
Now, if you want to fetch the last eight records from the table then it is always difficult to get such data if your table contains huge information. For example, you want to get the last 8 records from the employee table then you can use rownum and a union clause. 

For example,*/

Select * from Employee A where rownum <=8
union
select * from (Select * from Employee A order by rowid desc) where rownum <=8;

--Source: https://bytescout.com/blog/20-important-sql-queries.html
