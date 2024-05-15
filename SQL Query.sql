CREATE DATABASE IF NOT EXISTS Walmartsalesdata;

CREATE TABLE IF NOT EXISTS sales(
invoice_id varchar(35) NOT NULL PRIMARY KEY,
branch varchar(10) NOT NULL,
city varchar(35) NOT NULL,
customer_type varchar(35) NOT NULL,
gender varchar(10) NOT NULL,
product_line varchar (150) NOT NULL,
unit_price decimal(11, 2) NOT NULL,
quantity int NOT NULL,
Vat float (6, 4) NOT NULL,
total decimal (15, 4) NOT NULL,
date datetime NOT NULL,
time time NOT NULL,
payment_method varchar (20) NOT NULL,
cogs decimal (12, 2) NOT NULL,
gross_margin_percentge float (12, 9),
gross_income decimal (12, 4) NOT NULL,
rating float (2, 1)	
);

-- ------------------------------------------DATA EXPLOARION PROCESS ---------------------------------------------------

SELECT time
 FROM sales;

-- ADDING THE TIME OF THE DAY
SELECT time,(
CASE
		WHEN 'time' BETWEEN "00:00:00" AND "11:59:00" THEN "Morning"
        WHEN 'time' BETWEEN "12:00:00" AND "15:59:00" THEN "Afternoon"
        ELSE "Evening"
        END
) AS time_of_the_day
 FROM sales;
 
 -- ADDING TIME_OF_THE_DAY COLUMN

ALTER TABLE sales ADD COLUMN time_of_the_day varchar(20);    

-- INSERTING DATA TO THE time_of_the_day COLUMN
UPDATE sales
SET time_of_the_day =(
CASE
WHEN 'time' BETWEEN "00:00:00" AND "11:59:00" THEN "Morning"
WHEN 'time' BETWEEN "12:00:00" AND "15:59:00" THEN "Afternoon"
ELSE "Evening"
END); 

-- ADDING THE_DAY_NAME
SELECT 
	date,
    dayname(date) AS day_name
FROM sales; 

-- ADDING THE_DAY_NAME COLUMN
ALTER TABLE sales ADD COLUMN day_name varchar(10);

-- POPULATING THE day_name COLUMN
UPDATE sales
SET day_name = dayname(date);

-- Month name
SELECT
	date,
		monthname(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name varchar (10);

UPDATE sales
SET month_name = monthname(date);

-- ----------------------------------------------------ANSWERING BUSINESS QUESTIONS ---------------------------------------------------------

-- How many unique cities does the data have?

SELECT distinct city
FROM sales; 
 
 -- How many unique branches does the data have?
SELECT distinct branch
FROM sales; 

-- Which city is each branch located? 
SELECT distinct city, branch
FROM sales; 

-- PRODUCT BASED QUESTIONS
-- How many unique product lines does the business have
SELECT count(distinct product_line)
FROM sales;

-- What is the most common payment method?
SELECT payment_method,
	   count(payment_method) AS Total_payment_method
FROM sales
GROUP BY payment_method
ORDER BY total DESC;

-- What is the most selling product line?
SELECT product_line,
	   count(product_line) AS Total_product_line
FROM sales
GROUP BY product_line
ORDER BY total DESC;

-- What is the total revenue by month?
SELECT  month_name,
	   sum(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- Which month has the highest COGS
SELECT  month_name,
	   sum(cogs) AS Cogs
FROM sales
GROUP BY month_name
ORDER BY Cogs DESC;

 -- What product line had the largest revenue
 SELECT product_line,
	    sum(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What city has the highest revenue
SELECT branch, city,
	    sum(total) AS total_revenue
FROM sales
GROUP BY city, branch
ORDER BY total_revenue DESC;

-- What product line had the largest VAT
 SELECT product_line,
	    avg(Vat) AS VAT
FROM sales
GROUP BY product_line
ORDER BY VAT DESC; 

-- Which branch sold more products than vaverage product sold?
SELECT  branch,
		sum(quantity) AS quantity
FROM sales
GROUP BY branch
HAVING sum(quantity) > (SELECT avg(quantity) FROM sales);

-- WHat is the most product line by gender?
SELECT gender,
		product_line,
        COUNT(gender) AS Total_gender
FROM sales
GROUP BY gender, product_line
ORDER BY total_gender DESC;

 -- What is the average rating of each product?
 SELECT product_line,
		round(avg(rating), 2) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg(rating);

-- ------------------------------------------------END ---------------------------------------------------------------