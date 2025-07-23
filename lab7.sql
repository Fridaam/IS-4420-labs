-- Create a query that give the names and full address of all of these groups of people, combined into one list:

-- Customers who haven't made a purchase during the last 12 months available
-- Customers who have spent more then $1,000
-- Customers who have made more than 3 orders

-- Your output should have these columns:

-- name
-- street address
-- city
-- state
-- zip
-- group (name of the group)


select customer_name as name,
	address_line_1 as street_address,
    city,
    state_province as state,
    postal_code as zip,
    'No purchases in 12 months' as group_name
    from customer
    where customer_id not in  (
		select distinct customer_id
        from order_header
        where order_date < current_date
        and order_date between '2023-07-01' and '2024-06-30'
        )

    union
    
    select customer_name as name,
	address_line_1 as street_address,
    city,
    state_province as state,
    postal_code as zip,
    'Over $1,000 spent' as group_name
    from customer as c
inner join order_header as oh
	on c.customer_id = oh.customer_id
inner join order_line as ol
	on  oh.order_id = ol.order_id
inner join product as p
	on p.product_id = ol.product_id 
group by name, street_address, city, state, zip
having sum(product_price*quantity) > 1000 

union

  select customer_name as name,
	address_line_1 as street_address,
    city,
    state_province as state,
    postal_code as zip,
    'More than 3' as group_name
    from customer as c
inner join order_header as oh
	on c.customer_id = oh.customer_id
inner join order_line as ol
	on  oh.order_id = ol.order_id
inner join product as p
	on p.product_id = ol.product_id 
group by name, street_address, city, state, zip
having count(distinct oh.order_id) > 3 ;

    