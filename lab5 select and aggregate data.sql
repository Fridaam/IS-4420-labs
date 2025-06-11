-- 1.Show the number of customers in each state

select state_province, 
count(customer_id) as customer_count
from customer
group by state_province
order by customer_count desc;

-- 2.Show the number of orders by year and month

select 
    year(order_date) as order_year,
    month(order_date) as order_month,
    count(*) as total_orders
from order_header
group by year(order_date), month(order_date)
order by order_year, order_month;

-- 3.Show the average product price by product line

select 
	product_line,
	round(avg(product_price)) as avg_price
from product
group by product_line
order by product_line desc;

-- 4.Show the number of customers who have invalid addresses (no street address, city, or state) 

select count(*)
from customer
where city is null
or state_province is null
or address_line_1 is null;