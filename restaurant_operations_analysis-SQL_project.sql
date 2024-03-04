--A Restaurant Order Analysis - A MySQL Guided Maven Project

--Analyze order data to identify the most and least popular menu items and types of cuisine.

SELECT *
FROM menu_items;

SELECT count(*)
FROM menu_items; -- 32 rows

SELECT *
FROM menu_items
Order by price desc; -- shrimp scampi is most expensive at 19.95, edamame is least expensive at 5.00

SELECT count(*)
FROM menu_items
WHERE category = "Italian"; -- there are 9 items that are Italian

SELECT *
FROM menu_items
WHERE category = "Italian"
order by price desc; -- shrimp scampi is the most expensive italian dish at 19.95, fettuccine alfredo and spaghetti are tied as the least expensive at 14.50

SELECT category, count(menu_item_id) as num_dishes
FROM menu_items
group by category; -- there are 6 american, 8 asian, 9 mexican, ane 9 italian dishes

SELECT category, avg(price) as avg_price_per_dish
FROM menu_items
group by category
order by avg(price); -- the average price per dish for american is 10.06, mexican is 11.80, asian is 13.47, italian 16.75

SELECT order_date
FROM order_details
order by order_date; -- there are 12,234 records. the date ranges from jan 1, 2023- march 31, 2023, 3 months.

SELECT *
FROM order_details;

SELECT count(distinct order_id)
FROM order_details; -- 5,370 unique items were ordered

SELECT order_id, count(item_id) as num_items
FROM order_details
group by order_id
order by num_items desc;

SELECT COUNT(*) as orders_with_more_than_12_items
FROM
	(SELECT order_id, count(item_id) as num_items
	FROM order_details
	group by order_id
	having num_items > 12) as num_orders; -- make subquary to find the count of orders that had more then 12 items
    

SELECT *
FROM order_details
left join menu_items
on menu_items.menu_item_id = order_details.item_id; -- always use the table with transactional details (foreign key(s)) first or left, then join the secondary or look up table (primary key) to the left table  

SELECT category, item_name,count(order_details_id) as num_purchases 
FROM order_details
left join menu_items
on menu_items.menu_item_id = order_details.item_id
group by category, item_name
order by num_purchases desc; -- most ordered item was an american hamburger at 622, the least oredred was mexican chicken tacos at 123 


SELECT order_id, sum(price) as total_spent 
FROM order_details
left join menu_items
on menu_items.menu_item_id = order_details.item_id
group by order_id
order by total_spent desc
limit 5; -- top 5 orders that spent the most amount

SELECT category, count(item_id) as num_items
FROM order_details
left join menu_items
on menu_items.menu_item_id = order_details.item_id
WHERE order_id = 440
group by category; -- top spender, order id 440, spent the most on italian food

SELECT order_id,category, count(item_id) as num_items
FROM order_details
left join menu_items
on menu_items.menu_item_id = order_details.item_id
WHERE order_id in (330,440,1957,2075,2675)
group by order_id,category; -- the top 5 orders that spent the most aount were on italian food, least on american food








