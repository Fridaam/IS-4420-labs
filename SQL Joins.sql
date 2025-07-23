-- Name: Frida Aguilar Mora
-- U-number: 01389224
-- Assignment: SQL Joins
-- Date: 2025-07-12

-- 1. List the ID, name, and price for all products with a greater than the average product price.

select product_id, product_name, product_price
from product
where product_price > (
    select avg(product_price)
    FROM product);

-- 2. For each product, list its name and total quantity ordered. Products should be listed in ascending order of the product name.

select p.product_name, sum(ol.quantity) as total_quantity_ordered
from product p
join order_line ol on p.product_id = ol.product_id
group by p.product_name
order by p.product_name asc;

-- 3. For each product, list its ID and total quantity ordered. Products should be listed in ascending order of total quantity ordered.

select p.product_name, sum(ol.quantity) as total_quantity_ordered
from product p
join order_line ol on p.product_id = ol.product_id
group by p.product_id
order by total_quantity_ordered asc;

-- 4. For each product, list its ID, name and total quantity ordered. Products should be listed in ascending order of the product name.

select p.product_name, sum(ol.quantity) as total_quantity_ordered
from product p
join order_line ol on p.product_id = ol.product_id
group by p.product_name, p.product_id
order by p.product_name asc;

-- 5. List the name for all customers who have placed more than 2 orders. Each customer name should appear exactly once. Customer names should be sorted in descending alphabetical order.

select c.customer_name
from customer c
join order_header oh on c.customer_id = oh.customer_id
group by c.customer_name
having count(oh.customer_id) > 2
order by c.customer_name desc;

-- 6. For each city, list the number of customers from that city, who have placed more than 2 orders. Cities are listed in descending alphabetical order.

select c.city, count(*) as customer_count
from ( 
		select oh.customer_id
        from order_header oh
        group by oh.customer_id
		having count(oh.order_id) > 2
    )
as frequent_customers
join customer c on c.customer_id = frequent_customers.customer_id
group by c.city
order by c.city desc;

-- 7. List the ID for all California customers, who have placed one or more orders on Dec 5, 2021 or after. Sort the results by the customer id in ascending order.   Make sure to look for alternate spellings for California, like "CA"

select distinct c.customer_id
from customer c
join order_header oh on c.customer_id = oh.customer_id
where (c.state_province = 'California' or c.state_province = 'CA')
	and oh.order_date >= '2021-12-05'
order by c.customer_id asc;

-- 8. List the IDs for all California customers along with all customers (regardless where they are from) who have placed one or more order(s) before Dec 8, 2022. Sort the results by the customer id in ascending order. Use union for this query.

select customer_id
from customer
where state_province = 'California' or state_province = 'CA'
union
select distinct customer_id
from order_header
where order_date < '2022-12-08'
order by customer_id asc;


-- 9. List the product ID, product name and total quantity ordered for all products with total quantity ordered of 2 or more.

select p.product_id, p.product_name, sum(ol.quantity) as total_quantity_ordered
from product p
join order_line ol on p.product_id = ol.product_id
group by p.product_id, p.product_name
having sum(ol.quantity) >=2;

-- 10. List the product ID, product name  and total quantity ordered for all products with total quantity ordered greater than 3 and were placed by Illinois customers.  Make sure to look for alternative spellings for Illinois state.

select p.product_id, p.product_name, sum(ol.quantity) as total_quantity_ordered
from product p
join order_line ol on p.product_id = ol.product_id
join order_header oh on ol.order_id = oh.order_id
join customer c on oh.customer_id = c.customer_id
where c.state_province in ('Illinois', 'IL')
group by p.product_id, p.product_name
having sum(ol.quantity) > 3;

-- 11. For each customer, list their name, number of distinct products ordered, and total quantity ordered. Display only customers who ordered more than 10 distinct products.

select c.customer_name,
	count(distinct ol.product_id) as distinct_product_ordered,
    sum(ol.quantity) as total_quantity_ordered
from customer c
join order_header oh on c.customer_id = oh.customer_id
join order_line ol on oh.order_id = ol.order_id
group by c.customer_id, c.customer_name
having count(distinct ol.product_id) > 10;

-- 12. List the customer name and total number of orders they placed where at least one product was ordered with quantity greater than 10.

select c.customer_name,
	count(distinct ol.product_id) as qualifying_orders
from customer c
join order_header oh on c.customer_id = oh.customer_id
join order_line ol on oh.order_id = ol.order_id
where ol.quantity > 10
group by c.customer_id, c.customer_name;

-- 13. For each product, list its name and the latest order date where it was purchased.

select p.product_name, max(oh.order_date) as latest_order_date
from product p
join order_line ol on p.product_id = ol.product_id
join order_header oh on ol.order_id = oh.order_id
group by p.product_id, p.product_name;

-- 14. List product names that have been ordered by more than 20 distinct customers.

select p.product_name
from product p
join order_line ol on p.product_id = ol.product_id
join order_header oh on ol.order_id = oh.order_id
join customer c on oh.customer_id = c.customer_id
group by p.product_id, p.product_name
having count(distinct c.customer_id) > 20;

-- 15. List the customers who placed orders where at least one product was ordered with quantity = 1 and at least one product was ordered with quantity >= 5 - in the same order.

select distinct c.customer_name
from customer c
join order_header oh on c.customer_id = oh.customer_id
where oh.order_id in (
    select ol1.order_id
    from order_line ol1
    join order_line ol2 on ol1.order_id = ol2.order_id
    where ol1.quantity = 1 and ol2.quantity >= 5 );
