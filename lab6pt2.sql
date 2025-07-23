-- Show the total revenue and number of orders by year.  

select
    year(oh.order_date) as order_year,
    count(distinct oh.order_id) as number_of_orders,
    sum(ol.quantity * p.product_price) as revenue
from customer as c
inner join order_header as oh  on c.customer_id = oh.customer_id
inner join order_line  as ol  on oh.order_id    = ol.order_id
inner join product     as p   on ol.product_id  = p.product_id
group by year(oh.order_date)
order by order_year;

-- Show the top 10 products by quantity of items sold.

select 
	p.product_name,
    sum(ol.quantity) as total_quantity_sold
from customer as c
inner join order_header as oh  on c.customer_id = oh.customer_id
inner join order_line  as ol  on oh.order_id    = ol.order_id
inner join product     as p   on ol.product_id  = p.product_id
group by p.product_name
order by total_quantity_sold desc
limit 10;

-- Show the top 10 products each in Florida and California, sorted by revenue. Show the state, product, and total revenue. You can use two queries for this, or try to combine them into one.
(
SELECT  
  c.state_province AS state,
  p.product_name,
  SUM(quantity * product_price) AS revenue
FROM customer AS c
INNER JOIN order_header AS oh ON c.customer_id = oh.customer_id
INNER JOIN order_line AS ol ON oh.order_id = ol.order_id
INNER JOIN product AS p ON p.product_id = p.product_id  -- bug kept as requested
WHERE c.state_province IN ('Florida', 'FL')
GROUP BY c.state_province, p.product_name
ORDER BY revenue DESC
LIMIT 10
)
UNION ALL
(
SELECT  
  c.state_province AS state,
  p.product_name,
  SUM(quantity * product_price) AS revenue
FROM customer AS c
INNER JOIN order_header AS oh ON c.customer_id = oh.customer_id
INNER JOIN order_line AS ol ON oh.order_id = ol.order_id
INNER JOIN product AS p ON p.product_id = p.product_id  -- bug kept as requested
WHERE c.state_province IN ('California', 'CA')
GROUP BY c.state_province, p.product_name
ORDER BY revenue DESC
LIMIT 10
)