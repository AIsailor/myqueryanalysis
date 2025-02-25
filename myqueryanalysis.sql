 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantiy >= 4


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000

--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select 
category,
gender,
count(*) as total_trans
from retail_sales
group by category,gender


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select 
year,month,average_sales
from(
select 
extract(year from sale_date)as year,
extract(month from sale_date)as month,
avg(total_sale) as average_sales,
rank() over(partition by extract(year from sale_date) order by avg(total_sale) DESC) as rank
from retail_sales
group by 1,2

)
as t1
where rank =1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select 
distinct(customer_id),
sum(total_sale) as total_sales from retail_sales
group by distinct(customer_id)
order by 2 desc
limit 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select 
category,
count(distinct customer_id)
from retail_sales
group by category


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
with hourly_Sales as (
select *,
case
	when extract(hour from sale_time)<12 then 'morning'
	when extract(hour from sale_time) between 12 and 17 then 'afternoon'
	else 'evening'
end as shift
from retail_sales)
select shift ,
count(*) as total_orders from hourly_Sales
group by shift