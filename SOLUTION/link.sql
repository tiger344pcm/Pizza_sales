--      MYSQL__PROJECT,,,

--           Basics :-
-- Retrive the total number of orders placed
SELECT 
    SUM(quantity)
FROM
    order_details; 

-- Calculate the total revenue generated from pizza sales.
SELECT 
    SUM(price * quantity) AS total_revenue
FROM
    pizzas p
        JOIN
    order_details od ON od.pizza_id = p.pizza_id;

-- identify the highest-priced pizza.
SELECT 
    pizza_id, MAX(price) AS Premium
FROM
    pizzas
GROUP BY pizza_id
ORDER BY MAX(price) DESC
LIMIT 1;


-- Identify the most common pizza size ordered
SELECT 
    size, COUNT(quantity) AS favorable_size
FROM
    pizzas p
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY size
ORDER BY COUNT(quantity) DESC
LIMIT 1;


SELECT 
    name, SUM(quantity) AS most_time
FROM
    pizza_types pt
        JOIN
    pizzas p ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY name
ORDER BY SUM(quantity) DESC
LIMIT 5;


--      INTERMEDIATE.....
-- Join the necessary tables to find total quantity of each pizza category ordered
SELECT 
    category, COUNT(quantity)
FROM
    pizza_types pt
        JOIN
    pizzas p ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY category;


-- Determine the distribution of orders by hour of the day
SELECT 
    HOUR(time), COUNT(quantity)
FROM
    orders o
        JOIN
    order_details od ON od.order_id = o.order_id
GROUP BY HOUR(time);

-- Join relevant tables to find the category-wise distribution of pizzas
SELECT 
    category, COUNT(pizza_id)
FROM
    pizza_types pt
        JOIN
    pizzas p ON p.pizza_type_id = pt.pizza_type_id
GROUP BY category;

-- Group the orders by date and calculate the average number of pizzas ordered per day
SELECT 
    DAY(date), AVG(quantity)
FROM
    orders o
        JOIN
    order_details od ON p.pizza_type_id = pt.pizza_type_id
GROUP BY DAY(date);

-- Determine the top 3 most ordered pizza types based on revenue
SELECT 
    name, SUM(price * quantity) AS TOTAL_AMOUNT
FROM
    pizza_types pt
        JOIN
    pizzas p ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY name
ORDER BY SUM(price * quantity) DESC
LIMIT 3;

-- Calculate the percentage contribution of each pizza type to the total revenue
SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                2) AS total_sales
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100,
            2) AS REVENUE
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;


-- Analyze the cumulative revenue generated over time. 
SELECT date,SUM(revenue) OVER(ORDER BY date) AS cum_revenue
FROM 
(SELECT orders.date,SUM(order_details.quantity * pizzas.price) AS revenue
FROM order_details JOIN pizzas ON  order_details.pizza_id = pizzas.pizza_id
JOIN orders ON orders.order_id = order_details.order_id
GROUP BY orders.date) AS sales;


-- Determine the top 3 most ordered pizza types
-- based on revenue for each pizza category
SELECT name , revenue FROM
(SELECT  category, name ,revenue,
RANK() OVER(PARTITION BY category ORDER BY revenue DESC) AS rn 
FROM 
(SELECT pizza_types.category, pizza_types.NAME,
SUM((order_details.quantity) * pizzas.price) AS revenue
FROM pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details 
ON order_details.pizza_id = pizzas.pizza_id 
GROUP BY pizza_types.category, pizza_types.name) as a ) as b 
where rn <= 3;