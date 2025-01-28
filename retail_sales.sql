-- SQL Retail Sales Analysis p1
-- create table
CREATE TABLE retail_sales(
       transactions_id INT PRIMARY KEY,
	   sale_date DATE,
	   sale_time TIME,
	   customer_id INT,
	   gender VARCHAR(15),
	   age INT,
	   category VARCHAR(15) ,
	   quantiy INT,
	   price_per_unit FLOAT,
	   cogs FLOAT,
	   total_sale FLOAT
	   );

SELECT * FROM retail_sales

select * from retail_sales limit 10;

select count(*) from retail_sales;

- -- Data Cleaning
-- to check if ther are any null values and where
select * from retail_sales
where
transactions_id ISNULL
or
sale_date isnull
or
sale_time isnull
or
gender isnull
or
category isnull
or
quantiy isnull
or
cogs isnull
or
total_sale isnull;

-- to delete the null values
 delete from retail_sales
 where
 transactions_id ISNULL
 or
 sale_date isnull
 or
 sale_time isnull
 or
 gender isnull
 or
 category isnull
 or
 quantiy isnull
 or
 cogs isnull
 or
 total_sale isnull;


--Data Exploration
--how many sales we have ?

select count(total_sale) as total_sale from retail_sales;

--how many unique customers we have ?

select count(DISTINCT customer_id) as "Number of Customers" from retail_sales;

--how many categories we have ?

select count(DISTINCT category) as "number of categories" from retail_sales;

--what are the categories we have ?

select DISTINCT category from retail_sales;

--Data Analysis & Business key Problems & Answers

--Q1. write a sql query to retrive all columns for sales made on '2022-11-05'

select * from retail_sales where sale_date = '2022-11-05'

--Q2. write a sql query to retrive all transactions where the category is 'clothing'and the quantity sold is more than 10 in the month of nov-2022
	
select * from retail_sales
where
category = 'Clothing'
AND
TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
AND
quantiy >= 4
order by sale_date

-- Q3. write a sql query to calculate the total sales (total_sales) for each category.
select category, sum(total_sale) as "net sales" , count(total_sale) as "total orders" from retail_sales group by 1

-- Q4. write a sql query to find the average age of customers who purchased items from the 'Beauty'category.
select round(avg(age),2) as avg_age from retail_sales where category = 'Beauty'

-- Q5. write a sql query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales where total_sale > 1000 order by sale_date

--Q6. write a sql query to find the total number of transactions ( transaction_id) made by each gender in each category
select gender, category, count(transactions_id) as total_transactions from retail_sales group by category , gender

--Q7. write a sql query to calculate the average sale for each month. find out best selling month in each year.
	
select year, month, avg_sale from
(
select
EXTRACT(YEAR from sale_date) as year,
EXTRACT(MONTH from sale_date) as month,
avg(total_sale) as avg_sale ,
RANK() OVER(PARTITION BY EXTRACT (YEAR from sale_date) ORDER BY AVG(total_sale) DESC) as rank
from retail_sales
group by 1,2) as t1
where rank = 1

--Q8. write a sql query to find the top 5 customers based on the highest total sales
select customer_id, sum(total_sale) as total_sale from retail_sales group by 1 order by 2 DESC LIMIT 5

--Q9. write a sql query to find the number of unique customers who purchased items from each category.
select category, count(distinct customer_id ) as unique_customers from retail_sales group by 1

--Q10. write a sql query to create each shift and number of orders (Example Morning <= 12. Afternoon between 12 & 17, Evening > 17)
	
WITH hourly_sale
AS
(
select * ,
CASE
when extract (HOUR FROM sale_time) < 12 THEN 'Morning'
when extract (HOUR FROM sale_time) BETWEEN 12 AND 17 then 'Afternoon'
else 'Evening'
end as shift
from retail_sales)
SELECT
shift,count(*) as total_orders FROM hourly_sale
group by shift

--end of project
