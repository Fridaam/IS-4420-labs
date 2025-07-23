-- Name: Frida Aguilar Mora
-- Assignment: Advanced Select
-- Date: 2025-07-07

-- 1. For each product, list its name and total quantity ordered. Products should be listed in ascending order of the product name.

select p.product_name, sum(ol.quantity) as total_quantity
from product p
join order_line ol on p.product_id = ol.product_id
group by p.product_name
order by p.product_name asc;

-- 2.For each customer in Texas, list their name, city and total dollars spent.  Sort the customers from highest revenue to lowest revenue. 

select c.customer_name, c.city, SUM(ol.quantity * p.product_price) AS total_spent
from customer c
join order_header oh on c.customer_id = oh.customer_id
join order_line ol on oh.order_id = ol.order_id
join product p on ol.product_id = p.product_id
where c.state_province = 'TX'
group by c.customer_id, c.customer_name, c.city
order by  total_spent desc;

-- 3.For each product, list its ID, name and total revenue for 2023. Products should be listed in ascending order of the product name.

select p.product_id, p.product_name, sum(ol.quantity * p.product_price) as total_revenue
from product p
join order_line ol on p.product_id = ol.product_id
join order_header oh on ol.order_id = oh.order_id
where year (oh.order_date) = 2023
group by p.product_id, p.product_name
order by p.product_name asc;

-- 4.List the email and name for all customers who have placed 3 or more orders. Each customer name should appear exactly once. Customer emails should be sorted in descending alphabetical order.

select c.email, c.customer_name
from customer c
join order_header oh on c.customer_id = oh.customer_id
group by c.customer_id, c.email, c.customer_name
having count(oh.order_id) >= 3
order by  c.email desc;

-- 5.Implement the previous query using a subquery and IN adding the requirement that the customers’ orders have been placed on or after Oct 5, 2022.

select c.email, c.customer_name
from customer c
where c.customer_id in (
    select oh.customer_id
    from order_header oh
    where oh.order_date >= '2022-10-05'
    group by oh.customer_id
    having count(oh.order_id) >= 3
    )
order by  c.email desc;

-- 6.For each city in California, list the name of the city and number of customers from that city who have purchased Clothing.  Filter out any customers who have not ordered clothing.  Cities are sorted by the number of customers, descending.

select 
    city,
    count(*) as customer_count
from (
    select distinct c.customer_id, c.city
    from customer c
    join order_header oh on c.customer_id = oh.customer_id
    join order_line ol on oh.order_id = ol.order_id
    join product p on ol.product_id = p.product_id
   where 
    c.state_province = 'California' 
    and p.product_line = 'Clothing'
) as clothing_customers
group by city
order by customer_count desc;

-- 7.Implement the previous using a subquery and IN.

select 
    c.city,
    count(distinct c.customer_id) as customer_count
from customer c
where 
    c.state_province = 'California'
    and c.customer_id in (
        select oh.customer_id
        from order_header oh
        join order_line ol on oh.order_id = ol.order_id
        join product p on ol.product_id = p.product_id
        where p.product_line = 'Clothing'
    )
group by c.city
order by customer_count desc;

-- 8.List the ID for all products, which have NOT been ordered on Dec 5, 2023 or before. Sort your results by the product id in ascending order.  Use EXCEPT for this query.

select product_id
from product

except

select distinct p.product_id
from product p
join order_line ol on p.product_id = ol.product_id
join order_header oh on ol.order_id = oh.order_id
where oh.order_date <= '2023-12-05'

order by product_id asc;

-- 9.List the ID for all California customers, who have placed one or more orders in November 2023 or after. Sort the results by the customer id in ascending order.  Use Intersect for this query.  Make sure to look for alternate spellings for California, like "CA"

select customer_id
from customer
where state_province in ('CA', 'California')

intersect

select oh.customer_id
from order_header oh
where oh.order_date >= '2023-11-01'

order by customer_id asc;

-- 10.Implement the previous query using a subquery and IN.

select customer_id
from customer
where state in ('CA', 'California')
  and customer_id in (
      select customer_id
      from order_header
      where order_date >= '2023-11-01'
  )
order by customer_id asc;

-- 11.List the IDs for all California customers along with all customers (regardless where they are from) who have placed one or more order(s) before December 2022. Sort the results by the customer id in descending order.  Use union for this query.

select customer_id
from customer
where state = 'California'

union

select distinct oh.customer_id
from order_header oh
where oh.order_date < '2022-12-01'

order by customer_id desc;


-- 12.List the product ID, product name and total quantity ordered for all products with total quantity ordered of less than 50.

select 
    p.product_id,
    p.product_name,
    sum(ol.quantity) as total_quantity_ordered
from 
    product p
join order_line ol on p.product_id = ol.product_id
group by 
    p.product_id, p.product_name
having 
    sum(ol.quantity) < 50;

-- 13.List the product ID, product name  and total quantity ordered for all products with total quantity ordered greater than 3 and were placed by Illinois customers.  Make sure to look for alternative spellings for Illinois state.

select 
    p.product_id,
    p.product_name,
    sum(ol.quantity) as total_quantity_ordered
from 
    product p
join order_line ol on p.product_id = ol.product_id
join order_header oh on ol.order_id = oh.order_id
join customer c on oh.customer_id = c.customer_id
where 
    c.state_province in ('IL', 'Illinois')
group by 
    p.product_id, p.product_name
having sum(ol.quantity) > 3;

-- 14.List the customer name and city for all customers who have purchased products that are no longer active status.  

select distinct 
    c.customer_name,
    c.city
from 
    customer c
join order_header oh on c.customer_id = oh.customer_id
join order_line ol on oh.order_id = ol.order_id
join product p on ol.product_id = p.product_id
where 
    p.product_status <> 'active';

-- 15.List the ID, name, and price for all products with less than or equal to the average product price.

select 
    product_id,
    product_name,
    product_price
from 
    product
where 
    product_price <= (
        select avg(product_price) 
        from product
    );

