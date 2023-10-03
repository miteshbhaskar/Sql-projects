drop database if exists pizza_project;
create database pizza_project;
use pizza_project;
select * from pizza_sales;

-- 1. Total Revenue: The sum of the total price of all pizza orders.
select round(sum(total_price)) as Total_Revenue from pizza_sales;

-- 2. Average Order Value: The average amount spent per order, calculated by dividing the total revenue by the total number of orders/.
select round(round(sum(total_price)) / count(*),2) as avearge_order_value from pizza_sales;

-- 3. Total Pizzas Sold: The sum of the quantities of all pizza sold.
select sum(quantity) as Total_pizza_sold from pizza_sales;

-- 4. Total Orders: The total number of orders placed. 
select count(*) as Total_order from pizza_sales;

-- 5. Average Pizza Per Order: The average number of pizzas sold per order, calculated by dividing the total number of pizzas sold by the total number of orders 
 select round(sum(quantity)/count(*),2) as Average_pizza_order from pizza_sales; 
 
 
 -- 1. Daily trend for total Orders:
 select order_date as `day`, count(order_id) as total_order from pizza_sales group by order_date order by month(order_date);
 
 -- 2. Monthly Trend for Total Orders: 
create view p_s_v as select str_to_date(order_date,'%d-%m-%Y') as date1,order_id,quantity,unit_price,total_price,pizza_size,pizza_category,pizza_name from pizza_sales;
create view p_s_v_1 as select str_to_date(order_date,'%d-%m-%Y') as order_date,order_id from pizza_sales ;
select month(order_date) month,count(order_id) as total_order from p_s_v_1 group by month(order_date);
select month(date1) as month,  count(order_id) as total_order from p_s_v group by month(date1) order by month(date1);
 
-- 3. Percentage of Sales by Pizza Category:
select pizza_category, round(sum(total_price),2) as sales, round((sum(total_price)/total_sales)*100,2) as sales_pct from pizza_sales,
(select sum(total_price) as total_sales from pizza_sales) as stat group by pizza_category; 

-- 4. Percentage of Sales by Pizza Size:
select pizza_size, round(sum(total_price),2) as sales,concat(round((sum(total_price)/total_sales)*100,2),' %') as pizza_sales_pct from 
pizza_sales, (select sum(total_price) as total_sales from pizza_sales) as stat group by pizza_size;

-- 5. Total Pizza Sold by Pizza Category:
select pizza_category, sum(quantity) as total_pizza_sold from pizza_sales group by pizza_category;

-- 6. Top 5 Best Sellers by Revenue, Total Quantity and Total Orders 
select pizza_name, round(sum(total_price),2) as total_revenue, sum(quantity) as total_quantity, count(order_id) as total_order from 
pizza_sales group by pizza_name order by total_revenue desc limit 5;

-- 7. Bottom 5 Best Sellers by Revenue, Total Quantity and Total Orders:
select pizza_name, round(sum(total_price),2) as total_revenue, sum(quantity) as total_quantity, count(order_id) as total_order from 
pizza_sales group by pizza_name order by total_revenue limit 5;
 
 

 
 select str_to_date('01,5,2023', '%d-%m-%Y') 
 
 
 