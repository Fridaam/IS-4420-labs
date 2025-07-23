-- Name: Frida Aguilar Mora
-- U-number: 01389224
-- Assignment: SQL for Buesiness Analysis
-- Date: 2025-07-22


-- 1.Analyze the growth by channel (retail versus online).   

select 
  oh.order_type as channel,
  year(oh.order_date) as year,
  quarter(oh.order_date) as quarter,
  count(distinct oh.order_id) as order_count,
  sum(ol.quantity * p.product_price) as total_revenue
from order_header oh
join order_line ol on oh.order_id = ol.order_id
join product p on ol.product_id = p.product_id
group by channel, year, quarter
order by year, quarter, channel;

-- Online sales have grown rapidly, especially from Q3 2023 onward, nearly matching or surpassing retail in both orders and revenue by 2024. 
-- The manager should prioritize online investments to capitalize on this momentum.

-- 2.Analyze customer activation trends.  

select 
  year(oh.order_date) as year,
  count(distinct oh.customer_id) as customer_count,
  round(count(*) * 1.0 / count(distinct oh.customer_id), 2) as avg_orders_per_customer,
  round(sum(ol.quantity * p.product_price) * 1.0 / count(distinct oh.customer_id), 2) as avg_revenue_per_customer
from order_header oh
join order_line ol on oh.order_id = ol.order_id
join product p on ol.product_id = p.product_id
group by year
order by year;

-- Customer activation has grown significantly, especially in 2023 and 2024, with increases in both orders and revenue per customer. 
-- Managers should focus on re-engaging the 2022 cohort and sustaining momentum with targeted retention and upselling strategies.

-- 3.Analyze day-of-week trends.  

with total_orders_cte as (
  select COUNT(*) as total_orders from order_header
),
day_stats as (
  select 
    dayname(oh.order_date) as day_of_week,
    count(*) as order_count,
    sum(ol.quantity * p.product_price) as total_revenue,
    round(sum(ol.quantity * p.product_price) / count(*), 2) as avg_order_revenue
  from order_header oh
  join order_line ol on oh.order_id = ol.order_id
  join product p on ol.product_id = p.product_id
  group by dayname(oh.order_date)
)
select  
  ds.day_of_week,
  ds.order_count,
  ds.total_revenue,
  ds.avg_order_revenue,
  round((ds.order_count * 100.0) / toc.total_orders, 2) as percent_of_orders
from day_stats ds, total_orders_cte toc
order by 
  field(ds.day_of_week, 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');
  
 -- The analysis shows that Wednesday has the highest order count and total revenue, indicating peak customer activity midweek, while average order revenue varies moderately across days. 
 -- For a manager, focusing marketing campaigns and promotions around Wednesdays could maximize sales volume, and examining ways to boost average order value on lower-performing days like Monday or Saturday may improve overall revenue.
 
-- 4.Analyze year-over-year growth. 

select 
  p.product_line,
  sum(case when year(oh.order_date) = 2022 then ol.quantity * p.product_price else 0 end) as revenue_2022,
  sum(case when year(oh.order_date) = 2023 then ol.quantity * p.product_price else 0 end) as revenue_2023,
  round(
    (sum(case when year(oh.order_date) = 2023 then ol.quantity * p.product_price else 0 end) -
     sum(case when year(oh.order_date) = 2022 then ol.quantity * p.product_price else 0 end)) * 100.0 /
    nullif(sum(case when year(oh.order_date) = 2022 then ol.quantity * p.product_price else 0 end), 0), 2
  ) as percent_change
from product p
join order_line ol on p.product_id = ol.product_id
join order_header oh on ol.order_id = oh.order_id
where year(oh.order_date) in (2022, 2023)
group by p.product_line
order by p.product_line;

-- The year-over-year revenue analysis reveals significant growth in categories like Bikes (214%), Cameras (128%), and Mobile (466%), while Laptop and Projector sales dropped completely to zero in 2023. 
-- For management, this suggests prioritizing investment and marketing in the rapidly growing product lines while investigating why Laptop and Projector revenues disappeared to address potential supply or demand issues.

-- 5.Product seasonality. 

with season_cte as (
  select 
    p.product_line,
    case 
      when month(oh.order_date) in (12, 1, 2) then 'Winter'
      when month(oh.order_date) in (3, 4, 5) then 'Spring'
      WHEN month(oh.order_date) in (6, 7, 8) then 'Summer'
      when month(oh.order_date) in (9, 10, 11) then 'Fall'
    end as season,
    ol.quantity
  from order_header oh
  join order_line ol on oh.order_id = ol.order_id
  join product p on ol.product_id = p.product_id
),
season_totals as (
  select 
    product_line,
    season,
    sum(quantity) as total_quantity
  from season_cte
  group by product_line, season
)
select 
  product_line,
  coalesce(sum(case when season = 'Winter' then total_quantity end), 0) as winter_quantity,
  coalesce(sum(case when season = 'Spring' then total_quantity end), 0) as spring_quantity,
  coalesce(sum(case when season = 'Summer' then total_quantity end), 0) as summer_quantity,
  coalesce(sum(case when season = 'Fall' then total_quantity end), 0) as fall_quantity
from season_totals
group by product_line
order by product_line;

-- This query reveals clear seasonal demand patterns across product lines, with Accessories and Electronics peaking strongly in Spring, while some products like Laptops and Projectors show steep declines in Fall.
--  For managers, this insight suggests optimizing inventory and marketing efforts seasonally—boosting stock and promotions for high-demand seasons, and scaling back or exploring alternatives for low-demand periods to improve profitability and reduce excess inventory.
