CREATE DATABASE IF NOT EXISTS SalesWalmart;

USE SalesWalmart;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id varchar (30) not null primary key,
	branch varchar(50) not null,
    city varchar (50) not null,
    customer_type varchar (30) not null,
    gender varchar (10) not null,
    product_line varchar (100) not null,
    unit_price decimal(10,2) not null,
    quantity int  not null,
    VAT float(6,4) not null,
    total decimal (12,4) not null,
    date datetime not null,
    time time not null,
    payment_method varchar(15) not null,
    cogs decimal (10,2) not null,
    gross_margin_percentage float (11,9),
    gross_income decimal (12,4) not null,
    rating float (2,1)
);


-- Feature Engineering
-- adding time_of_day column
SELECT 
    time,
    CASE 
        WHEN TIME(time) BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN TIME(time) BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS Time_of_date
FROM sales;

alter table sales add column time_of_date varchar (20);  

update sales set time_of_date = (
CASE 
        WHEN TIME(time) BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN TIME(time) BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
);

-- adding day name column
select date, dayname(date)from sales;

alter table sales add column day_name varchar (20);

update sales set day_name = dayname(date);

-- Month Name
select date, monthname(date) from sales;

alter table sales add column month_name varchar(20);

update sales set month_name = monthname(date);

-- ---------------------------------------------------------------

-- How many unique cities does the data have?
select distinct(city) from sales;

select distinct(branch) from sales;

-- in which city is each branch?
select distinct city, branch from sales;

-- How many unique product lines does the data have?

select count(distinct(product_line)) from sales;

-- What is the most common payment method?

select payment_method,count(payment_method) from sales
group by payment_method
order by count(payment_method) desc;

-- What is the most selling product line?
 
select product_line,count(product_line) from sales
group by product_line
order by count(product_line) desc;

-- What is the total revenue by month?

select month_name, sum(total) as total_revenue from sales
group by month_name
order by total_revenue desc;

-- What month had the largest COGS?

select month_name, sum(cogs)from sales
group by month_name
order by cogs desc;

-- What product line had the largest revenue?

select product_line, sum(total)as total_revenue from sales
group by product_line
order by total_revenue desc;

-- What is the city with the largest revenue?

select city, sum(total)as total_revenue from sales
group by city
order by total_revenue desc;

-- What product line had the largest VAT?

select product_line, max(VAT) as max_vat from sales
group by product_line
order by max_vat;

update sales set city = "Mumbai" where city= "Yongaon";

UPDATE sales
SET city = 'Mumbai'
WHERE city = 'Yangon';

UPDATE sales
SET city = 'Pune'
WHERE city = 'Naypyitaw';

UPDATE sales
SET city = 'Nagpur'
WHERE city = 'Naypyitaw';

-- Which branch sold more products than average product sold?

select branch,
	sum(quantity) as qty
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);


-- What is the most common product line by gender?

select gender, product_line, count(gender) as total_count
from sales 
group by gender, product_line
order by total_count;

-- What is the average rating of each product line?

select product_line, round(avg(rating),2) as avg_rating from sales
group by product_line
order by avg_rating desc;


-- Number of sales made in each time of the day per weekday

 select time_of_date, count(*) as total_Sales from sales
 group by time_of_date;

-- Which of the customer types brings the most revenue?

select customer_type, sum(total) as total_revenue from sales
group by customer_type
order by total_revenue;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?

select city, avg(VAT) as max_vat from sales
group by city
order by max_vat desc;

-- Which customer type pays the most in VAT?

select customer_type, avg(VAT) as max_vat from sales
group by customer_type
order by max_vat;

-- How many unique customer types does the data have?

select distinct(customer_type) from sales;

-- How many unique payment methods does the data have?

select distinct(payment_method) from sales;

-- Which customer type buys the most?

select customer_type, count(quantity) most from sales
group by customer_type
order by most desc;

-- What is the gender of most of the customers?

select gender, count(customer_type) as customers from sales
group by gender
order by customers desc;

-- What is the gender distribution per branch?

select branch, count(gender) as distribution from sales
group by branch
order by distribution;

-- Which time of the day do customers give most ratings?

select time_of_date, avg(rating)as r from sales
group by time_of_date
order by r desc;

-- Which time of the day do customers give most ratings per branch?

select time_of_date, branch, avg(Rating) as r from sales
group by time_of_date, branch
order by r;

-- Which day fo the week has the best avg ratings?

select day_name, avg(rating) as r from sales
group by day_name
order by r;

-- Which day of the week has the best average ratings per branch?

select day_name, avg(rating) as r from sales
where branch ='c'
group by day_name
order by r;