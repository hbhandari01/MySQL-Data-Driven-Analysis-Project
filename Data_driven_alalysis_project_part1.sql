-- 	DATA DRIVEN ANALYSIS PROJECT PART-1

-- TASK 1 (CUSTOMER DATA ANALYSIS)

-- 1) FIND THE TOP 10 CUSTOMERS BY CREDIT LIMIT
USE MODELCARSDB;

SELECT CUSTOMERNUMBER, CUSTOMERNAME, CREDITLIMIT FROM CUSTOMERS GROUP BY CUSTOMERNUMBER ORDER BY CREDITLIMIT DESC LIMIT 10;

/* Interpretations : 
SELECT CUSTOMERNUMBER, CUSTOMERNAME, CREDITLIMIT : select command specifies the columns that we want to retrieve 
FROM CUSTOMERS : indicates the table from which we are retrieving the data
GROUP BY CUSTOMERNUMBER : this clause groups the results by the customer number 
ORDER BY CREDITLIMIT DESC LIMIT 10 : this sorts the results in descending order based on the credit limit
LIMIT 10 : this gives us the output of the top 10 customers by credit limit.
*/

-- 2) FIND THE AVERAGE CREDIT LIMIT FOR CUSTOMERS IN EACH COUNTRY

SELECT CUSTOMERNAME, COUNTRY, AVG(CREDITLIMIT) AVG_CREDIT_LIMIT FROM CUSTOMERS GROUP BY CUSTOMERNAME, COUNTRY ORDER BY AVG_CREDIT_LIMIT DESC;

/* Interpretations :
SELECT CUSTOMERNAME, COUNTRY, AVG(CREDITLIMIT) AVG_CREDIT_LIMIT : select command specifies the columns that we want to retrieve and calculates the average
credit limit using the avg() function.
FROM CUSTOMERS : specifies the table to retrieve the data.
GROUP BY CUSTOMERNAME, COUNTRY : this groups the customers by their name and country
ORDER BY AVG_CREDIT_LIMIT DESC : this sorts the results in descending order of the calculated average credit limit
*/

-- 3) FIND THE NUMBER OF CUSTOMERS IN EACH COUNTRY

SELECT COUNTRY, COUNT(*) AS NUMBER_OF_CUSTOMERS FROM CUSTOMERS GROUP BY COUNTRY;

/* Interpretations :
SELECT COUNTRY, COUNT(*) AS NUMBER_OF_CUSTOMERS : select command specifies the country column and also counts the number of rows
for each country.
FROM CUSTOMERS : specifies the table
GROUP BY COUNTRY : groups the customers by country, so the count(*) function counts 
the customers within country
*/

-- 4) FIND THE CUSTOMERS WHO HAVEN'T PLACED ANY ORDERS

SELECT CUSTOMERS.CUSTOMERNUMBER, CUSTOMERS.CUSTOMERNAME FROM CUSTOMERS LEFT JOIN ORDERS ON CUSTOMERS.CUSTOMERNUMBER = ORDERS.CUSTOMERNUMBER 
WHERE ORDERNUMBER IS NULL ;

/* Interpretations:
SELECT CUSTOMERS.CUSTOMERNUMBER, CUSTOMERS.CUSTOMERNAME : select command specifies the columns name that we want to retrieve
FROM CUSTOMERS LEFT JOIN ORDERS ON CUSTOMERS.CUSTOMERNUMBER = ORDERS.CUSTOMERNUMBER : this performs a left join among the customers and orders tables,
matching customers based on the common column "customernumber". A left join ensures that all customers are included in the result, even if they haven't
placed any orders. 
*/

-- 5) CALCULATE TOTAL SALES FOR EACH CUSTOMER

SELECT CUSTOMERS.CUSTOMERNUMBER, CUSTOMERS.CUSTOMERNAME, ORDERS.ORDERNUMBER, SUM(ORDERDETAILS.QUANTITYORDERED*ORDERDETAILS.PRICEEACH) AS TOTAL_SALES FROM CUSTOMERS
LEFT JOIN ORDERS ON CUSTOMERS.CUSTOMERNUMBER = ORDERS.CUSTOMERNUMBER LEFT JOIN ORDERDETAILS ON ORDERS.ORDERNUMBER = ORDERDETAILS.ORDERNUMBER 
GROUP BY CUSTOMERS.CUSTOMERNUMBER, CUSTOMERS.CUSTOMERNAME, ORDERS.ORDERNUMBER ;

/* Interpretations: 
In this query we are joining customers, orders and orderdetails to link customers to their orders and details of each order.
It calculates the total sales for each order by multiplying quantityordered by priceeach.
It uses sum() to add up the sales for all orders for each customer
It groups the results by customer number, customer name, order number

*/

-- 6) LIST CUSTOMERS WITH THEIR ASSIGNED SALES REPRESENTATIVES

SELECT CUSTOMERS.CUSTOMERNAME, EMPLOYEES.FIRSTNAME, EMPLOYEES.LASTNAME FROM EMPLOYEES
LEFT JOIN CUSTOMERS ON EMPLOYEES.EMPLOYEENUMBER = CUSTOMERS.SALESREPEMPLOYEENUMBER 
WHERE CUSTOMERNAME IS NOT NULL;

/* Interpretaions:
SELECT CUSTOMERS.CUSTOMERNAME, EMPLOYEES.FIRSTNAME, EMPLOYEES.LASTNAME : select command specifies the column names that we want to retrieve.
FROM EMPLOYEES LEFT JOIN CUSTOMERS ON EMPLOYEES.EMPLOYEENUMBER = CUSTOMERS.SALESREPEMPLOYEENUMBER : a left join ensures that all the employees
are included in the output, even if they don't have any customers assigned.
*/

-- 7) RETRIEVE CUSTOMER INFORMATION WITH THEIR MOST RECENT PAYMENT DETAILS

SELECT CUSTOMERS.CUSTOMERNUMBER , CUSTOMERS.CUSTOMERNAME, PAYMENTS.AMOUNT, MAX(PAYMENTS.PAYMENTDATE) AS RECENT_PAYMENT FROM CUSTOMERS
INNER JOIN PAYMENTS ON CUSTOMERS.CUSTOMERNUMBER =  PAYMENTS.CUSTOMERNUMBER GROUP BY CUSTOMERS.CUSTOMERNUMBER, CUSTOMERS.CUSTOMERNAME, PAYMENTS.AMOUNT
ORDER BY RECENT_PAYMENT DESC;

/* Interpretations:
SELECT CUSTOMERS.CUSTOMERNUMBER , CUSTOMERS.CUSTOMERNAME, PAYMENTS.AMOUNT, MAX(PAYMENTS.PAYMENTDATE) AS RECENT_PAYMENT: select command retrieves the columns 
name required and the most recent payment as "Recent_Payment".
FROM CUSTOMERS LEFT JOIN PAYMENTS ON CUSTOMERS.CUSTOMERNUMBER =  PAYMENTS.CUSTOMERNUMBER : this performs a join between the customers and the payments
table , matching customers with their payments based on the customer number.
GROUP BY CUSTOMERS.CUSTOMERNUMBER, CUSTOMERS.CUSTOMERNAME, PAYMENTS.AMOUNT : this group the results by the following column names.
ORDER BY RECENT_PAYMENT DESC: this sorts the result by the recent_payment in descending order.
*/

-- 8) IDENTIFY THE CUSTOMERS WHO HAVE EXCEEDED THEIR CREDIT LIMIT 

SELECT CUSTOMERS.CUSTOMERNAME, CUSTOMERS.CREDITLIMIT FROM CUSTOMERS
WHERE CUSTOMERS.CREDITLIMIT < (SELECT SUM(ORDERDETAILS.QUANTITYORDERED*ORDERDETAILS.PRICEEACH) FROM ORDERS LEFT JOIN ORDERDETAILS ON
ORDERS.ORDERNUMBER = ORDERDETAILS.ORDERNUMBER WHERE ORDERS.CUSTOMERNUMBER = CUSTOMERS.CUSTOMERNUMBER
GROUP BY CUSTOMERS.CUSTOMERNUMBER);

/* Interpretations:
SELECT CUSTOMERS.CUSTOMERNAME, CUSTOMERS.CREDITLIMIT : select command secifies the column names that we want to retrieve
FROM CUSTOMERS: specifies the table
WHERE CUSTOMERS.CREDITLIMIT < : this filters the customers to include only those whose credit limit is less thatn the result of the subquery
(SELECT SUM(ORDERDETAILS.QUANTITYORDERED*ORDERDETAILS.PRICEEACH) : this subquery calculated the sum of the order amounts for each customer.
LEFT JOIN ORDERDETAILS ON ORDERS.ORDERNUMBER = ORDERDETAILS.ORDERNUMBER : joins orders and orderdetails 
GROUP BY CUSTOMERS.CUSTOMERNUMBER : groups the order details by customer number to calculate the sum for each customer
*/

-- 9) FIND THE NAMES OF ALL THE CUSTOMERS WHO HAVE PLACED AN ORDER FOR A PRODUCT FROM A SPECIFIC PRODUCT LINE

SELECT CUSTOMERS.CUSTOMERNAME, PRODUCTS.PRODUCTNAME, PRODUCTS.PRODUCTLINE, SUM(ORDERDETAILS.QUANTITYORDERED*ORDERDETAILS.PRICEEACH) AS TOTAL_SALES
FROM CUSTOMERS LEFT JOIN ORDERS ON CUSTOMERS.CUSTOMERNUMBER = ORDERS.CUSTOMERNUMBER LEFT JOIN ORDERDETAILS ON 
ORDERS.ORDERNUMBER = ORDERDETAILS.ORDERNUMBER LEFT JOIN PRODUCTS ON 
ORDERDETAILS.PRODUCTCODE = PRODUCTS.PRODUCTCODE GROUP BY CUSTOMERS.CUSTOMERNAME, PRODUCTS.PRODUCTNAME, PRODUCTS.PRODUCTLINE ORDER BY TOTAL_SALES DESC;

/* Interpretations:
FROM CUSTOMERS LEFT JOIN ORDERS ON CUSTOMERS.CUSTOMERNUMBER = ORDERS.CUSTOMERNUMBER LEFT JOIN ORDERDETAILS ON 
ORDERS.ORDERNUMBER = ORDERDETAILS.ORDERNUMBER LEFT JOIN PRODUCTS ON 
ORDERDETAILS.PRODUCTCODE = PRODUCTS.PRODUCTCODE : left join ensure that all customrs are included in the output.
GROUP BY CUSTOMERS.CUSTOMERNAME, PRODUCTS.PRODUCTNAME, PRODUCTS.PRODUCTLINE : this groups the results by the following column names.
*/

-- 10) FIND THE NAMES OF ALL THE CUSTOMERS WHO HAVE PLACED AN ORDER FOR THE MOST EXPENSIVE PRODUCT

SELECT CUSTOMERS.CUSTOMERNAME, PRODUCTS.PRODUCTNAME, PRODUCTS.PRODUCTCODE, PRODUCTS.BUYPRICE FROM CUSTOMERS INNER JOIN ORDERS 
ON CUSTOMERS.CUSTOMERNUMBER = ORDERS.CUSTOMERNUMBER
INNER JOIN ORDERDETAILS ON ORDERS.ORDERNUMBER = ORDERDETAILS.ORDERNUMBER 
INNER JOIN PRODUCTS ON ORDERDETAILS.PRODUCTCODE = PRODUCTS.PRODUCTCODE ORDER BY PRODUCTS.BUYPRICE DESC LIMIT 1;

/* Interpretations:
SELECT CUSTOMERS.CUSTOMERNAME, PRODUCTS.PRODUCTNAME, PRODUCTS.PRODUCTCODE, PRODUCTS.BUYPRICE: specifies the column names which we want to retrieve
INNER JOIN : only customers who placed an order are included due to this inner join
ORDER BY PRODUCTS.BUYPRICE DESC LIMIT 1: this limits the result to only one row, giving the single most expensive product.
*/



-- TASK 2 (OFFICE DATA ANALYSIS)

-- 1) COUNT THE NUMBER OF EMPLOYEES WORKING IN EACH OFFICE

SELECT OFFICECODE , COUNT(*) AS 'NUMBER OF EMPLOYEES'  FROM EMPLOYEES GROUP BY OFFICECODE ORDER BY 'NUMBER OF EMPLOYEES';

/* Interpretations:
SELECT OFFICECODE, COUNT(*) AS 'NUMBER OF EMPLOYEES': This selects the OFFICECODE and counts all rows (representing employees) for each group.
FROM EMPLOYEES: Specifies the EMPLOYEES table as the source of data.
GROUP BY OFFICECODE: Groups the rows based on the OFFICECODE, so the COUNT(*) function counts employees within each office.
ORDER BY 'NUMBER OF EMPLOYEES': Sorts the result in ascending order based on the calculated number of employees.
*/

-- 2) IDENTIFY THE OFFICES WITH LESS THAN A CERTAIN NUMBER OF EMPLOYEES

SELECT OFFICES.OFFICECODE, OFFICES.ADDRESSLINE1, OFFICES.ADDRESSLINE2, COUNT(EMPLOYEES.EMPLOYEENUMBER) AS 'TOTAL COUNT'
FROM EMPLOYEES LEFT JOIN OFFICES ON EMPLOYEES.OFFICECODE = OFFICES.OFFICECODE 
GROUP BY OFFICES.OFFICECODE, OFFICES.ADDRESSLINE1, OFFICES.ADDRESSLINE2
HAVING (COUNT(EMPLOYEES.EMPLOYEENUMBER) < 5) ORDER BY COUNT(EMPLOYEES.EMPLOYEENUMBER) DESC ;

/* Interpretations:
SELECT OFFICES.OFFICECODE, OFFICES.ADDRESSLINE1, OFFICES.ADDRESSLINE2, COUNT(EMPLOYEES.EMPLOYEENUMBER) AS TOTAL_COUNT: specifies the column names which we want to retrieve
FROM EMPLOYEES LEFT JOIN OFFICES ON EMPLOYEES.OFFICECODE = OFFICES.OFFICECODE: Joins the EMPLOYEES and OFFICES tables based on the OFFICECODE. 
A LEFT JOIN ensures that all offices are included in the output, even if they have no employees.
GROUP BY OFFICES.OFFICECODE, OFFICES.ADDRESSLINE1, OFFICES.ADDRESSLINE2: Groups the results by office to count employees within each office.
HAVING COUNT(EMPLOYEES.EMPLOYEENUMBER) < 5: Filters the grouped results, keeping only offices where the count of employee numbers is less than 5.
ORDER BY COUNT(EMPLOYEES.EMPLOYEENUMBER) DESC: Sorts the results in descending order based on the employee count,
so the offices with the fewest employees (but still less than 5) appear first.
*/

-- 3) LIST OFFICES ALONG WITH THEIR ASSIGNED TERRITORIES

SELECT ADDRESSLINE1, ADDRESSLINE2, TERRITORY FROM OFFICES ;

/* Interpretation:
SELECT ADDRESSLINE1, ADDRESSLINE2, TERRITORY: Selects the columns we want to retrieve.
FROM OFFICES: Specifies the OFFICES table.
*/

-- 4) FIND THE OFFICES THAT HAVE NO EMPLOYEES ASSIGNED TO THEM

SELECT OFFICES.ADDRESSLINE1, OFFICES.OFFICECODE FROM OFFICES LEFT JOIN EMPLOYEES ON OFFICES.OFFICECODE = EMPLOYEES.OFFICECODE
WHERE EMPLOYEES.EMPLOYEENUMBER IS NULL;

/* Interpretations:
SELECT OFFICES.ADDRESSLINE1, OFFICES.OFFICECODE: Specifies the columnswe want to retrieve.
FROM OFFICES LEFT JOIN EMPLOYEES ON OFFICES.OFFICECODE = EMPLOYEES.OFFICECODE: Performs a LEFT JOIN between OFFICES and EMPLOYEES tables on the OFFICECODE. 
This ensures that all offices are included in the initial result set, even if they don't have matching employees.
WHERE EMPLOYEES.EMPLOYEENUMBER IS NULL: Filters the results to include only those offices where the EMPLOYEENUMBER is NULL. 
*/

-- 5) RETRIEVE THE MOST PROFITABLE OFFICE BASED ON TOTAL SALES

SELECT OFFICES.OFFICECODE, OFFICES.ADDRESSLINE1, OFFICES.ADDRESSLINE2, SUM(ORDERDETAILS.QUANTITYORDERED*ORDERDETAILS.PRICEEACH) AS 'TOTAL SALES'
FROM OFFICES LEFT JOIN EMPLOYEES ON OFFICES.OFFICECODE = EMPLOYEES.OFFICECODE LEFT JOIN CUSTOMERS ON EMPLOYEES.EMPLOYEENUMBER = CUSTOMERS.SALESREPEMPLOYEENUMBER
LEFT JOIN ORDERS ON CUSTOMERS.CUSTOMERNUMBER = ORDERS.CUSTOMERNUMBER LEFT JOIN ORDERDETAILS ON ORDERS.ORDERNUMBER = ORDERDETAILS.ORDERNUMBER 
GROUP BY OFFICES.OFFICECODE, OFFICES.ADDRESSLINE1, OFFICES.ADDRESSLINE2 ORDER BY 'TOTAL SALES' DESC LIMIT 1;

/* Interpretations: 
SELECT OFFICES.OFFICECODE, OFFICES.ADDRESSLINE1, OFFICES.ADDRESSLINE2, SUM(ORDERDETAILS.ORDEREDQUANTITY * ORDERDETAILS.PRICEEACH) AS 'TOTAL SALES': Specifies the columns to be retrieved.
FROM OFFICES ,LEFT JOIN : Multiple LEFT JOINs are used to connect the OFFICES table to ORDERDETAILS through the intermediate tables EMPLOYEES, CUSTOMERS, and ORDERS. This allows us to link office information to sales data.
GROUP BY OFFICES.OFFICECODE, OFFICES.ADDRESSLINE1, OFFICES.ADDRESSLINE2: Groups the results by office, so the SUM() function calculates the total sales for each office.
ORDER BY 'TOTAL SALES' DESC: Sorts the results in descending order based on the total sales, placing the most profitable office at the top.
LIMIT 1: Restricts the result to only the first row, effectively returning the office with the highest total sales.

*/

-- 6) FIND THE OFFICE WITH THE HIGHEST NUMBER OF EMPLOYEES

SELECT OFFICES.ADDRESSLINE1, OFFICES.ADDRESSLINE2, COUNT(EMPLOYEES.EMPLOYEENUMBER) AS "TOTAL EMPLOYEES" FROM OFFICES 
LEFT JOIN EMPLOYEES ON OFFICES.OFFICECODE = EMPLOYEES.OFFICECODE GROUP BY OFFICES.ADDRESSLINE1, OFFICES.ADDRESSLINE2 ORDER BY "TOTAL EMPLOYEES" LIMIT 1;

/* Interpretations:
SELECT OFFICES.ADDRESSLINE1, OFFICES.ADDRESSLINE2, COUNT(EMPLOYEES.EMPLOYEENUMBER) AS "TOTAL EMPLOYEES": specifies the columns to be retrieved.
FROM OFFICES LEFT JOIN EMPLOYEES ON OFFICES.OFFICECODE = EMPLOYEES.OFFICECODE: Joins the OFFICES and EMPLOYEES tables to link offices to their employees.
GROUP BY OFFICES.ADDRESSLINE1, OFFICES.ADDRESSLINE2: Groups the results by office to count the number of employees in each office.
ORDER BY "TOTAL EMPLOYEES" DESC: Sorts the results in descending order based on the number of employees.
LIMIT 1: Restricts the result to the first row, which represents the office with the highest number of employees.
*/


-- 7) FIND THE AVERAGE CREDIT LIMIT FOR CUSTOMERS IN EACH OFFICE

SELECT OFFICES.ADDRESSLINE1, OFFICES.ADDRESSLINE2, AVG(CUSTOMERS.CREDITLIMIT) AS "AVG CREDIT LIMIT" FROM OFFICES
LEFT JOIN EMPLOYEES ON OFFICES.OFFICECODE = EMPLOYEES.OFFICECODE LEFT JOIN CUSTOMERS 
ON EMPLOYEES.EMPLOYEENUMBER = CUSTOMERS.SALESREPEMPLOYEENUMBER GROUP BY OFFICES.ADDRESSLINE1, OFFICES.ADDRESSLINE2 ORDER BY "AVG CREDIT LIMIT" ;

/* Interpretations: 
SELECT OFFICES.ADDRESSLINE1, OFFICES.ADDRESSLINE2, AVG CREDIT LIMIT": Specifies the columns to be retrieved and calculates the average credit limit of the customers.
FROM OFFICES LEFT JOIN EMPLOYEES ,LEFT JOIN CUSTOMERS: Joins the OFFICES, EMPLOYEES, and CUSTOMERS tables to link offices to their employees and then to the employees customers.
GROUP BY OFFICES.ADDRESSLINE1, OFFICES.ADDRESSLINE2: Groups the results by office to calculate the average credit limit for each office's customers.
ORDER BY "AVG CREDIT LIMIT": Sorts the results in ascending order based on the average credit limit.
*/


-- 8) FIND THE NUMBER OF OFFICES IN EACH COUNTRY

SELECT COUNTRY, COUNT(*) FROM OFFICES GROUP BY COUNTRY ;

/* Interpretations:
SELECT COUNTRY, COUNT(*): Specifies the column name and counts all rows (offices) for each country.
FROM OFFICES: Specifies the OFFICES table as the data source.
GROUP BY COUNTRY: Groups the rows based on the COUNTRY column, so the COUNT(*) function counts offices within each country.
*/


-- TASK 3 (PRODUCT DATA ANALYSIS)

-- 1) COUNT THE NUMBER OF PRODUCTS IN EACH COUNTRY

SELECT OFFICES.COUNTRY, COUNT(ORDERDETAILS.PRODUCTCODE) AS "NUMBER OF PRODUCTS" FROM OFFICES LEFT JOIN EMPLOYEES
ON OFFICES.OFFICECODE = EMPLOYEES.OFFICECODE LEFT JOIN CUSTOMERS 
ON EMPLOYEES.EMPLOYEENUMBER = CUSTOMERS.SALESREPEMPLOYEENUMBER LEFT JOIN ORDERS
ON CUSTOMERS.CUSTOMERNUMBER = ORDERS.CUSTOMERNUMBER LEFT JOIN ORDERDETAILS
ON ORDERS.ORDERNUMBER = ORDERDETAILS.ORDERNUMBER GROUP BY OFFICES.COUNTRY ORDER BY "NUMBER OF PRODUCTS" ;

/* Interpretations:
This corrected query counts the number of products ordered (as reflected in the ORDERDETAILS table) for each country. 
It joins the necessary tables to link orders to customers, employees, offices, and finally, the country.
*/


-- 2) FIND THE PRODUCTS LINE WITH THE HIGHEST AVERAGE PRODUCT PRICE

SELECT PRODUCTLINES.PRODUCTLINE, AVG(PRODUCTS.BUYPRICE) AS "AVG PRODUCT PRICE" FROM PRODUCTLINES 
LEFT JOIN PRODUCTS ON PRODUCTLINES.PRODUCTLINE = PRODUCTS.PRODUCTLINE
GROUP BY PRODUCTLINES.PRODUCTLINE ORDER BY "AVG PRODUCT PRICE" DESC ;

/* Interpretations:
SELECT PRODUCTLINES.PRODUCTLINE, AVG(PRODUCTS.BUYPRICE) AS "AVG PRODUCT PRICE": Selects the product line name and calculates the average buy price of products within that line.
FROM PRODUCTLINES LEFT JOIN PRODUCTS ON PRODUCTLINES.PRODUCTLINE = PRODUCTS.PRODUCTLINE: Joins the PRODUCTLINES and PRODUCTS tables to link product lines to their products.
GROUP BY PRODUCTLINES.PRODUCTLINE: Groups the results by product line to calculate the average price for each line.
ORDER BY: Sorts the results in descending order of average price, so the product line with the highest average price appears first.
*/

-- 3) FIND ALL PRODUCTS WITH A PRICE ABOVE OR BELOW A CERTAIN AMOUNT (MSRP SHOULD BE BETWEEN 50 AND 100)

SELECT PRODUCTNAME, MSRP FROM PRODUCTS WHERE MSRP BETWEEN 50 AND 100 ;

/* Interpretations:
SELECT PRODUCTNAME, MSRP: Selects the product name and MSRP.
FROM PRODUCTS: Specifies the PRODUCTS table as the data source.
WHERE MSRP BETWEEN 50 AND 100: Filters the results to include only products where the MSRP is within the specified range.
*/


-- 4) FIND THE TOTAL SALES AMOUNT FOR EACH PRODUCT LINE

SELECT PRODUCTS.PRODUCTLINE, SUM(ORDERDETAILS.QUANTITYORDERED * ORDERDETAILS.PRICEEACH) AS "TOTAL SALES"
FROM PRODUCTS LEFT JOIN ORDERDETAILS ON PRODUCTS.PRODUCTCODE = ORDERDETAILS.PRODUCTCODE 
GROUP BY PRODUCTS.PRODUCTLINE ORDER BY "TOTAL SALES" ;

/* Interpretations:
SELECT PRODUCTS.PRODUCTLINE, SUM(ORDERDETAILS.QUANTITYORDERED * ORDERDETAILS.PRICEEACH) AS "TOTAL SALES": Specifies the column names and calculates the sum of the product of QUANTITYORDERED and PRICEEACH for each product in that line. 
This product represents the revenue from each order detail, and summing it gives the total sales for the product line.
FROM PRODUCTS LEFT JOIN ORDERDETAILS ON PRODUCTS.PRODUCTCODE = ORDERDETAILS.PRODUCTCODE: Joins the PRODUCTS and ORDERDETAILS tables, linking products to their order details.
GROUP BY PRODUCTS.PRODUCTLINE: Groups the results by product line, so the SUM() function calculates the total sales for each distinct product line.
ORDER BY "TOTAL SALES": Sorts the results in ascending order of total sales.
*/


-- 5) IDENTIFY PRODUCTS WITH LOW INVENTORY LEVELS (LESS THAN A SPECIFIC THRESHOLD VALUE OF LESS THAN 10 FOR QUANTITY IN STOCK)

SELECT PRODUCTNAME , QUANTITYINSTOCK FROM PRODUCTS WHERE QUANTITYINSTOCK < 10;

/* Interpretations:
SELECT PRODUCTNAME, QUANTITYINSTOCK: Selects the product name and quantity in stock.
FROM PRODUCTS: Specifies the PRODUCTS table as the data source.
WHERE QUANTITYINSTOCK < 10: Filters the results to include only products where the QUANTITYINSTOCK is less than 10.
*/


-- 6) RETRIEVE THE MOST EXPENSIVE PRODUCT BASED ON MSRP

SELECT PRODUCTNAME, MSRP FROM PRODUCTS ORDER BY MSRP DESC LIMIT 1;

/* Interpretations:
SELECT PRODUCTNAME, MSRP: Selects the product name and MSRP.
FROM PRODUCTS: Specifies the PRODUCTS table.
ORDER BY MSRP DESC: Sorts the products in descending order of MSRP, placing the most expensive product at the top.
LIMIT 1: Restricts the result set to only the first row, which corresponds to the product with the highest MSRP.
*/


-- 7) CALCULATE TOTAL SALES FOR EACH PRODUCT

SELECT PRODUCTS.PRODUCTNAME, SUM(ORDERDETAILS.QUANTITYORDERED * ORDERDETAILS.PRICEEACH) AS "TOTAL SALES"
FROM PRODUCTS LEFT JOIN ORDERDETAILS ON PRODUCTS.PRODUCTCODE = ORDERDETAILS.PRODUCTCODE 
GROUP BY  PRODUCTS.PRODUCTNAME
ORDER BY "TOTAL SALES" DESC;

/* Interpretations:
SELECT PRODUCTS.PRODUCTNAME, SUM(ORDERDETAILS.QUANTITYORDERED * ORDERDETAILS.PRICEEACH) AS "TOTAL SALES": Selects the product name and calculates the total sales by summing the revenue from each order detail associated with that product.
FROM PRODUCTS LEFT JOIN ORDERDETAILS ON PRODUCTS.PRODUCTCODE = ORDERDETAILS.PRODUCTCODE: Joins the PRODUCTS and ORDERDETAILS tables to link products to their sales data.
GROUP BY PRODUCTS.PRODUCTNAME: Groups the results by product name, so the SUM() function calculates the total sales for each product.
ORDER BY "TOTAL SALES" DESC: Sorts the results in descending order of total sales, showing the best-selling products first.
*/


-- 8) IDENTIFY THE TOP SELLING PRODUCTS BASED ON TOTAL QUANTITY ORDERED USING A STORED 

DELIMITER //
CREATE PROCEDURE TOPSELLINGPRODUCTBASEDONTOTALQUANTITYORDERED (IN NUMBER_OF_PRODUCTS INT)
BEGIN 
     SELECT PRODUCTS.PRODUCTCODE, PRODUCTS.PRODUCTNAME, ORDERDETAILS.QUANTITYORDERED, 
	 SUM(ORDERDETAILS.QUANTITYORDERED * ORDERDETAILS.PRICEEACH) AS "TOTAL SALES"
     FROM PRODUCTS LEFT JOIN ORDERDETAILS ON PRODUCTS.PRODUCTCODE = ORDERDETAILS.PRODUCTCODE
     GROUP BY PRODUCTS.PRODUCTCODE, PRODUCTS.PRODUCTNAME, ORDERDETAILS.QUANTITYORDERED ORDER BY ORDERDETAILS.QUANTITYORDERED DESC 
     LIMIT NUMBER_OF_PRODUCTS;
     
	END //
    DELIMITER ;
    
CALL TOPSELLINGPRODUCTBASEDONTOTALQUANTITYORDERED(15) ;

/* Interpretations:
CREATE PROCEDURE TOPSELLINGPRODUCTBASEDONTOTALQUANTITYORDERED (IN NUMBER_OF_PRODUCTS INT): This line defines the stored procedure named TOPSELLINGPRODUCTBASEDONTOTALQUANTITYORDERED. It takes one input parameter:

NUMBER_OF_PRODUCTS: An integer specifying the number of top-selling products to retrieve.
BEGIN ... END //: This block contains the SQL code that the stored procedure will execute.

SELECT PRODUCTS.PRODUCTCODE, PRODUCTS.PRODUCTNAME, ORDERDETAILS.QUANTITYORDERED, SUM(ORDERDETAILS.QUANTITYORDERED * ORDERDETAILS.PRICEEACH) AS "TOTAL SALES": This selects the product code, product name, quantity ordered, and calculates the total sales for each product. The total sales are calculated by multiplying the quantity ordered by the price for each order detail and then summing these amounts for each product.

FROM PRODUCTS LEFT JOIN ORDERDETAILS ON PRODUCTS.PRODUCTCODE = ORDERDETAILS.PRODUCTCODE: This joins the PRODUCTS and ORDERDETAILS tables based on the common PRODUCTCODE column. The LEFT JOIN ensures that all products are included in the result, even if they haven't been ordered (though their sales would be 0).

GROUP BY PRODUCTS.PRODUCTCODE, PRODUCTS.PRODUCTNAME, ORDERDETAILS.QUANTITYORDERED: This groups the results by product code, product name, and quantity ordered.  This is important for the SUM() function to aggregate sales correctly for each product.  However, including ORDERDETAILS.QUANTITYORDERED in the GROUP BY clause is likely a mistake. It prevents proper aggregation of sales across different orders for the same product.

ORDER BY ORDERDETAILS.QUANTITYORDERED DESC: This sorts the results in descending order based on the quantity ordered. So, the products with the highest quantities ordered appear first.

LIMIT NUMBER_OF_PRODUCTS: This limits the number of rows returned to the value specified by the input parameter NUMBER_OF_PRODUCTS.
*/


-- 9) RETRIEVE PRODUCTS WITH LOW INVENTORY LEVELS (LESS THAN A THRESHOLD VALUE OF 10 FOR QUANTITY IN STOCK) WITH PRODUCT LINES (CLASSIC CARS, MOTORCYCLES)

SELECT PRODUCTS.PRODUCTNAME, PRODUCTLINE FROM PRODUCTS WHERE QUANTITYINSTOCK < 10;

/* Interpretations:
SELECT PRODUCTS.PRODUCTNAME, PRODUCTLINE: Selects the product name and the product line.
FROM PRODUCTS: Specifies the PRODUCTS table as the data source.
WHERE QUANTITYINSTOCK < 10: Filters the results to include only products where the QUANTITYINSTOCK is less than 10.
*/

-- 10) FIND THE NAMES OF ALL THE PRODUCTS THAT HAVE BEEN ORDERED BY MORE THAN 10 CUSTOMERS

SELECT PRODUCTS.PRODUCTNAME, COUNT(CUSTOMERS.CUSTOMERNUMBER) AS "NUMBER OF CUSTOMERS" FROM PRODUCTS LEFT JOIN 
ORDERDETAILS ON PRODUCTS.PRODUCTCODE = ORDERDETAILS.PRODUCTCODE
LEFT JOIN ORDERS ON ORDERS.ORDERNUMBER = ORDERDETAILS.ORDERNUMBER LEFT JOIN CUSTOMERS
ON ORDERS.CUSTOMERNUMBER = CUSTOMERS.CUSTOMERNUMBER GROUP BY PRODUCTS.PRODUCTNAME 
HAVING COUNT(CUSTOMERS.CUSTOMERNUMBER) > 10 ;

/* Interpretations:
SELECT PRODUCTS.PRODUCTNAME, COUNT(CUSTOMERS.CUSTOMERNUMBER) AS "NUMBER OF CUSTOMERS": Selects the product name and counts the number of customers who ordered the product.
FROM PRODUCTS ... LEFT JOIN ...: Joins the PRODUCTS, ORDERDETAILS, ORDERS, and CUSTOMERS tables to link products to their customers through orders.
GROUP BY PRODUCTS.PRODUCTNAME: Groups the results by product name to count the number of customers for each product.
HAVING COUNT(CUSTOMERS.CUSTOMERNUMBER) > 10: Filters the grouped results to include only products where the customer count is greater than 10.
*/

-- 11) FIND THE NAMES OF ALL THE PRODUCTS THAN HAVE BEEN ORDERED MORE THAN THE AVERAGE NUMBER OF ORDERS FOR THEIR PRODUCT LINE

SELECT PR.PRODUCTNAME, ORDERS_MORE_THAN_AVG
FROM PRODUCTS PR JOIN (SELECT PR.PRODUCTLINE, COUNT(ORDERNUMBER) AS ORDERS_MORE_THAN_AVG FROM PRODUCTS PR 
JOIN ORDERDETAILS OD ON PR.PRODUCTCODE = OD.PRODUCTCODE GROUP BY PR.PRODUCTLINE 
HAVING COUNT(ORDERNUMBER) > (SELECT AVG(ORDERS_PLACED) AS avg_order FROM 
(SELECT PRODUCTLINE , COUNT(ORDERNUMBER) AS ORDERS_PLACED FROM PRODUCTS PR 
JOIN ORDERDETAILS OD ON PR.PRODUCTCODE = OD.PRODUCTCODE GROUP BY PRODUCTLINE) AS AVGORDERMORE)) AS M;


/* Interpretations:
SELECT pr.productname, ORDERS_More_Than_AVG FROM products pr: Retrieves the product names from the products table.
Also fetches ORDERS_More_Than_AVG, which represents the number of times a product has been ordered (calculated in the subquery).
First subquery: This subquery calculates the total number of orders for each productline.
It joins the products table with orderdetails using productcode.
Groups the results by productline, meaning it counts the number of orders per product line.
Second Subquery (to calculate the average number of orders per product line): The inner subquery calculates the total orders per product line.
The outer subquery computes the average number of orders across all product lines using AVG(orders_placed).
*/


















