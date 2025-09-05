-- Create Table Retail_sale 
CREATE TABLE Retail_sales(
    transactions_id	INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id	INT,
	gender VARCHAR(20),
	age	INT,
	category VARCHAR(20),	
	quantiy	INT,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
	price_per_unit	FLOAT,
	cogs FLOAT,
	total_sale FLOAT
)

-- Check the data
SELECT * FROM Retail_sales
LIMIT 100;

-- Total count of data
SELECT COUNT(*) FROM Retail_sales;

-- Data Cleaning
SELECT * FROM Retail_sales
WHERE
    transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null 
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
    price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

-- Delete the null value column or data
DELETE FROM Retail_sales
WHERE
   transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null 
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
    price_per_unit is null
	or
	cogs is null
	or
	total_sale is null; 

-- Check Left data form the given dataset
SELECT COUNT(*) 
FROM retail_sales;

-- Data Exploration

-- Q. How many customer have ?
SELECT COUNT(customer_id) as Total_Customers FROM Retail_sales;

-- Q. How many unique customer have ?
SELECT COUNT(Distinct customer_id) as Total_Customers FROM Retail_sales;

--Q. How many Category?
SELECT COUNT(category) as Total_Category FROM Retail_sales;

--Q. How many unige Category?
SELECT DISTINCT category as Total_Category FROM Retail_sales;


--Data Analysis & Business Problem and Their Answers

--Q1. Write a query to retrive all columns FOR SALE ON '2022-11-05'.
SELECT * FROM Retail_sales 
WHERE sale_date = '2022-11-05';

--Q2. Write a query to retrive all columns Transaction where the category is 'clothing' and the quantity sold is more than 4 in the month odf 'Nov-2022'.
SELECT * FROM Retail_sales 
WHERE category = 'Clothing'
AND quantiy >= 4
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' ;

--Q3. Write a query to Calculate the total sales for each category.
SELECT category, COUNT(total_sale) AS Net_sale FROM Retail_sales
GROUP BY category;

--Q4. Write a query to find the avg age of customer who purchase item 'beauty' Category.
SELECT ROUND(AVG(age),2) FROM Retail_sales
WHERE category = 'Beauty';

--Q5. Write a query to find all transaction where the total_sale is greater than 1000.
SELECT * FROM Retail_sales
WHERE total_sale > 1000;

--Q6. Write a query to find the total number of transaction(transactions_id) made by each gender in each category. 
SELECT category, gender, COUNT(transactions_id) AS Total_transactions
FROM Retail_sales
GROUP BY gender, category;

--Q7. Write a query to calculate the avg sale for each months. find out best selling month of each year.

-- Sol1.
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
    
-- Sol2.
WITH MonthlySales AS (
    -- Step 1: Calculate the average sale per month
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date) 
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY year, month
)
-- Step 2: Select only the best-selling month (rank = 1)
SELECT year, month, avg_sale
FROM MonthlySales
WHERE rank = 1;


-- Q8. Write a query to find the top 5 customer based on the highest total sale.
SELECT 
     customer_id, 
	 SUM(total_sale) AS total_sale
FROM Retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;

--Q9. Write a query to find the number of unique customer who purchased item for each category.
SELECT 
     category,
	 COUNT(DISTINCT customer_id)
FROM Retail_sales
GROUP BY category;
      
--Q10. Write a query to each shift and no of orders(example Morning < 12, afternoon 12 between 17, evening >17)
WITH Hourly_orders
AS
(SELECT *,
  CASE
    WHEN EXTRACT(Hours FROM sale_time) < 12 THEN 'Morning'
    WHEN EXTRACT(Hours FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS Shift
FROM Retail_sales)

SELECT Shift, COUNT(total_sale) AS total_sale 
FROM Hourly_orders
GROUP BY Shift;



