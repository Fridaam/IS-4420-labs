-- Standardize the customer address, city and state fields to use all uppercase.

select address_line_1, city, state_province, 
	upper(address_line_1), upper(city), upper(state_province)
from customer;

update customer
set address_line_1 =  upper(address_line_1), 
	city = upper(city), 
    state_province = upper(state_province);

-- Update any order_date values in the order_header table that are mistakes with your best estimate of the correct value.

select order_date
from  order_header
order by order_date desc;

UPDATE order_header
SET order_date = DATE_FORMAT(order_date, '2024-%m-%d')
WHERE order_date BETWEEN '2029-06-30' AND '2029-08-01';



-- Add a column named "order_year" to order_header table. Add the year of each order to that column.

select *
from order_header;

alter table order_header add column order_year varchar(4);

update order_header
set order_year = extract(year from order_date);

-- Update the states that are not formatted correctly with the standard state code or name.

select state_province
from  customer
order by state_province desc;

UPDATE customer 
SET state_province = 'AL' 
WHERE state_province = 'ALABAMA';

UPDATE customer
 SET state_province = 'AK' 
 WHERE state_province = 'ALASKA';
 
UPDATE customer 
SET state_province = 'AZ' 
WHERE state_province = 'ARIZONA';

UPDATE customer 
SET state_province = 'AR' 
WHERE state_province = 'ARKANSAS';

UPDATE customer 
SET state_province = 'CA' 
WHERE state_province = 'CALIFORNIA';

UPDATE customer 
SET state_province = 'CO' 
WHERE state_province = 'COLORADO';

UPDATE customer 
SET state_province = 'CT' 
WHERE state_province = 'CONNECTICUT';

UPDATE customer 
SET state_province = 'DE' 
WHERE state_province = 'DELAWARE';

UPDATE customer 
SET state_province = 'FL' 
WHERE state_province = 'FLORIDA';

UPDATE customer 
SET state_province = 'GA' 
WHERE state_province = 'GEORGIA';

UPDATE customer 
SET state_province = 'HI' 
WHERE state_province = 'HAWAII';

UPDATE customer 
SET state_province = 'ID' 
WHERE state_province = 'IDAHO';

UPDATE customer 
SET state_province = 'IL' 
WHERE state_province = 'ILLINOIS';

UPDATE customer 
SET state_province = 'IN' 
WHERE state_province = 'INDIANA';

UPDATE customer 
SET state_province = 'IA' 
WHERE state_province = 'IOWA';

UPDATE customer 
SET state_province = 'KS' 
WHERE state_province = 'KANSAS';

UPDATE customer 
SET state_province = 'KY' 
WHERE state_province = 'KENTUCKY';

UPDATE customer 
SET state_province = 'LA' 
WHERE state_province = 'LOUISIANA';

UPDATE customer 
SET state_province = 'ME' 
WHERE state_province = 'MAINE';

UPDATE customer 
SET state_province = 'MD' 
WHERE state_province = 'MARYLAND';

UPDATE customer 
SET state_province = 'MA' 
WHERE state_province = 'MASSACHUSETTS';

UPDATE customer 
SET state_province = 'MI' 
WHERE state_province = 'MICHIGAN';

UPDATE customer 
SET state_province = 'MN' 
WHERE state_province = 'MINNESOTA';

UPDATE customer 
SET state_province = 'MS' 
WHERE state_province = 'MISSISSIPPI';

UPDATE customer 
SET state_province = 'MO' 
WHERE state_province = 'MISSOURI';

UPDATE customer 
SET state_province = 'MT' 
WHERE state_province = 'MONTANA';

UPDATE customer 
SET state_province = 'NE' 
WHERE state_province = 'NEBRASKA';

UPDATE customer 
SET state_province = 'NV' 
WHERE state_province = 'NEVADA';

UPDATE customer 
SET state_province = 'NH' 
WHERE state_province = 'NEW HAMPSHIRE';

UPDATE customer 
SET state_province = 'NJ' 
WHERE state_province = 'NEW JERSEY';

UPDATE customer 
SET state_province = 'NM' 
WHERE state_province = 'NEW MEXICO';

UPDATE customer 
SET state_province = 'NY' 
WHERE state_province = 'NEW YORK';

UPDATE customer 
SET state_province = 'NC' 
WHERE state_province = 'NORTH CAROLINA';

UPDATE customer 
SET state_province = 'ND' 
WHERE state_province = 'NORTH DAKOTA';

UPDATE customer 
SET state_province = 'OH' 
WHERE state_province = 'OHIO';

UPDATE customer 
SET state_province = 'OK' 
WHERE state_province = 'OKLAHOMA';

UPDATE customer 
SET state_province = 'OR' 
WHERE state_province = 'OREGON';

UPDATE customer 
SET state_province = 'PA' 
WHERE state_province = 'PENNSYLVANIA';

UPDATE customer 
SET state_province = 'RI' 
WHERE state_province = 'RHODE ISLAND';

UPDATE customer 
SET state_province = 'SC' 
WHERE state_province = 'SOUTH CAROLINA';

UPDATE customer 
SET state_province = 'SD' 
WHERE state_province = 'SOUTH DAKOTA';

UPDATE customer 
SET state_province = 'TN' 
WHERE state_province = 'TENNESSEE';

UPDATE customer 
SET state_province = 'TX' 
WHERE state_province = 'TEXAS';

UPDATE customer 
SET state_province = 'UT' 
WHERE state_province = 'UTAH';

UPDATE customer 
SET state_province = 'VT' 
WHERE state_province = 'VERMONT';

UPDATE customer 
SET state_province = 'VA' 
WHERE state_province = 'VIRGINIA';

UPDATE customer 
SET state_province = 'WA' 
WHERE state_province = 'WASHINGTON';

UPDATE customer 
SET state_province = 'WV' 
WHERE state_province = 'WEST VIRGINIA';

UPDATE customer 
SET state_province = 'WI' 
WHERE state_province = 'WISCONSIN';

UPDATE customer 
SET state_province = 'WY' 
WHERE state_province = 'WYOMING';

SELECT DISTINCT state_province
FROM customer
ORDER BY state_province;

-- Challenge: Add a column named "initials" to the customer table. Take the first letter from each name and put them in uppercase.

select *
from customer;

ALTER TABLE customer
ADD COLUMN initials VARCHAR(2);

UPDATE customer
SET initials = CONCAT(
    UPPER(LEFT(SUBSTRING_INDEX(customer_name, ' ', 1), 1)),
    UPPER(LEFT(SUBSTRING_INDEX(customer_name, ' ', -1), 1))
);

