-- Seasonality - Show the revenue by month, sorted in chronological order. (Note that we don't want the year, just the month.)

SELECT 
  order_date,
  CASE 
    WHEN MONTH(order_date) IN (3, 4, 5) THEN '1-Spring'
    WHEN MONTH(order_date) IN (6, 7, 8) THEN '2-Summer'
    WHEN MONTH(order_date) IN (9, 10, 11) THEN '3-Fall'
    WHEN MONTH(order_date) IN (12, 1, 2) THEN '4-Winter'
    ELSE 'Unknown'
  END AS season
FROM order_header;

-- Product Portfolio - What are the best and worst performing product lines? 

with revenue_by_line as (
  select  
    p.product_line,
    sum(ol.quantity * p.product_price) as total_revenue
  from product p
  join order_line ol on p.product_id = ol.product_id
  group by p.product_line
)

select * from (
  select 
    'Best Performing' as category,
    product_line,
    total_revenue
  from revenue_by_line
  order by total_revenue desc
  limit 1
) as best

union all 

select * from (
  select 
    'Worst Performing' as category,
    product_line,
    total_revenue
  from revenue_by_line
  order by total_revenue asc
  limit 1
) as worst;

-- Geography - Which states have had the most growth from the first year to the last year?  

select year(order_date), count(*)
from order_header
group by year(order_date)
order by 1;

with base_query as (
    select
        c.state_province,
        SUM(CASE 
            WHEN YEAR(oh.order_date) = 2022 
            THEN p.product_price * ol.quantity 
            ELSE 0 
        END) AS revenue_2022,
        SUM(CASE 
            WHEN YEAR(oh.order_date) = 2024 
            THEN p.product_price * ol.quantity 
            ELSE 0 
        END) AS revenue_2024
    FROM customer AS c
    INNER JOIN order_header AS oh ON oh.customer_id = c.customer_id
    INNER JOIN order_line AS ol ON oh.order_id = ol.order_id
    INNER JOIN product AS p ON p.product_id = ol.product_id
    GROUP BY c.state_province
)
SELECT 
    state_province, 
    revenue_2022, 
    revenue_2024,
    ROUND((revenue_2024 - revenue_2022) / NULLIF(revenue_2022, 0), 1) AS growth
FROM base_query
ORDER BY growth DESC;


-- State Comparison - Show the top 10 products, and add columns for "florida sales" and "california sales". Show the side-by-side comparison of sales in those states. 

select year(order_date), count(*)
from order_header
group by year(order_date)
order by 1;

SELECT 
  p.product_name,
  ROUND(SUM(CASE WHEN LOWER(TRIM(c.state_province)) = 'florida' THEN ol.quantity * p.product_price ELSE 0 END), 2) AS florida_sales,
  ROUND(SUM(CASE WHEN LOWER(TRIM(c.state_province)) = 'california' THEN ol.quantity * p.product_price ELSE 0 END), 2) AS california_sales,
  ROUND(SUM(ol.quantity * p.product_price), 2) AS total_sales
FROM product p
JOIN order_line ol ON p.product_id = ol.product_id
JOIN order_header oh ON ol.order_id = oh.order_id
JOIN customer c ON oh.customer_id = c.customer_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sales DESC
LIMIT 10;

 