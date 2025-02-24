---FIRST PROJECT

CREATE TABLE retail_sales (
	transactions_id	INTEGER PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id	INTEGER,
	gender VARCHAR(15),
	age	INTEGER,
	category VARCHAR (150),
	quantiy INTEGER,
	price_per_unit FLOAT,
	cogs FLOAT,	
	total_sale FLOAT
)
---LET'S CHECK IF ALL THE DATA IS IMPORTED. ACCORDING TO EXCEL WE HAVE 2000 ENTRIES.
SELECT COUNT(*) 
FROM retail_sales
--- WITH THIS CODE WE CAN SEE WE ALSO HAVE 2000 ENTRIES HERE. ALL IS IMPORTED.

--- WE CAN CHECK IF WE HAVE ANY INFO "NOT NULL"
------------------------------- DATA CLEANING
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR 
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL
--- NOW WE DELETE THE ROWS WITH NULL
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR 
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL
	
--------------------- DATA EXPLORATION

--- HOW MANY SALES WE HAVE? 1987
SELECT COUNT(*) as total_sale FROM retail_sales

--- HOW MANY UNIQUE COSTUMERS WE HAVE? 155 (because the same costumer purcharsed multiple times)
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

--- HOW MANY UNIQUE CATEGORIES WE HAVE? 3
SELECT COUNT(DISTINCT category) FROM retail_sales

--- I DONT WANT TO COUNT THE NUMBER OF CATEGORIES, JUST SEE THE NAME.
SELECT DISTINCT category FROM retail_sales

------------------------- DATA ANALYSIS
SELECT * FROM retail_sales
---1) WRITE A SQL QUERY TO RETRIEVE ALL COLUMNS FOR SALES MADE ON 2022-11-05

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05'

---2) WRITE A SQL QUERY TO RETRIEVE ALL TRANSACTIONS WHERE CATEGORY IS CLOTHING AND QUANTITY IS MORE THAN 10 IN THE MONTH OF NOV-2022

SELECT 
	*
FROM retail_sales
WHERE category = 'Clothing'
	AND 
	TO_CHAR(sale_date, 'YYY-MM') = '2022-11'
	AND
	quantiy >= 4


---3) WRITE A SQL QUERY TO CALCULATE THE TOTAL SALES FOR EACH CATEGORY

SELECT
	category,
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

---4) WRITE A SQL QUERY TO FIND THE AVERAGE AGE OF CUSTOMERS WHO PURCHASED ITEMS FROM THE BEAUTY CATEGORY

SELECT 
	ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'


---5) WRITE A SQL QUERY TO FIND ALL TRANSACTIONS WHERE TOTAL_SALE IS GREATER THAN 1000

SELECT
transactions_id,
total_sale
FROM retail_sales
WHERE total_sale > 1000

----- SECOND OPTION

SELECT * FROM retail_sales
WHERE total_sale > 1000


---6) WRITE A SQL QUERY TO FIND THE TOTAL NUMBER OF TRANSACTIONS (TRANSACTION_ID) MADE BY GENDER IN EACH CATEGORY

SELECT
	gender,
	category,
	COUNT(*) as total_trans
FROM retail_sales
GROUP BY 
category,
gender
ORDER BY 1

---7) WRITE A SQL QUERY TO CALCUALTE THE AVERAGE SALE FOR EACH MONTH. FIND OUT BEST SELLING MONTH IN EACH YEAR

SELECT * FROM
(
	SELECT
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS RANK
	FROM retail_sales
	GROUP BY 1, 2
) as t1
WHERE rank = 1

---8) WRITE A SQL QUERY TO FIND TOP 5 CUSTOMERS BASED ON THE HIGHEST TOTAL SALES

SELECT customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

---9) WRITE A SQL QUERY TO FIND THE NUMBER OF UNIQUE CUSTOMERS WHO PURCHASED ITMES FROM EACH CATEGORY

SELECT 
	category,
	COUNT(DISTINCT customer_id)AS unique_costumers
FROM retail_sales
GROUP BY category

---10) WRITE A SQL QUERY TO CREATE EACH SHIFT AND NUMBER OF ORDERS (morning, afternoon, evening)

WITH hourly_sale
AS
( 
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift

------END OF THE PROJECT
