-- Show the total revenue for customers from Florida.

select sum(quantity * product_price) as revenue
from customer as c
inner join order_header as oh
	on c.customer_id = oh.customer_id
inner join order_line as ol
	on  oh.order_id = ol.order_id
inner join product as p
	on p.product_id = p.product_id
where state_province in ('Florida', 'FL');



-- Show the top 10 customers by revenue.  

select c.customer_id, 
	customer_name, 
    sum(quantity * product_price) as revenue
from customer as c
inner join order_header as oh
	on c.customer_id = oh.customer_id
inner join order_line as ol
	on  oh.order_id = ol.order_id
inner join product as p
	on p.product_id = p.product_id
group by c.customer_id,
	customer_name
    
