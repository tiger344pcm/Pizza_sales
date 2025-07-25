--  'EDA PROJECTS WITH THE MYSQL ,,,,
-- Using Dataset Diamond for analysing

-- Q1 Find how many types of diamond in this dataset
SELECT 
    count(carat), carat
FROM
    diamonds
GROUP BY carat;

-- How many kind of 'cuts' the diamond has
SELECT 
    COUNT(cut), cut
FROM
    diamonds
GROUP BY cut;

-- How many 'colors' the diamond has 
SELECT 
    COUNT(color), color
FROM
    diamonds
GROUP BY color;

-- Find the average price of the diamond with thier carat 
SELECT 
    carat, AVG(price)
FROM
    diamonds
GROUP BY (carat);

--  Find the carat of diamond which is most expensive
SELECT DISTINCT
    MAX(price), carat
FROM
    diamonds
GROUP BY carat
ORDER BY MAX(price) DESC
LIMIT 3;

-- --  Find the carat of diamond which is the third in number of expensive
SELECT DISTINCT
    MAX(price), carat
FROM
    diamonds
GROUP BY carat
ORDER BY MAX(price) DESC
LIMIT 1 OFFSET 2;

-- For each carat calculate the difrence between price and avgerage price,
SELECT 
    carat,
    price,
    price - (SELECT 
            AVG(price)
        FROM
            diamonds) AS diff_price
FROM
    diamonds;
   
-- Case function
-- categorized with their 'depth' if depth > 60 'Long_Lasting',   else "It_should_have_'
SELECT 
    carat,
    cut,
    color,
    depth,
    CASE
        WHEN depth > 60 THEN 'Long_Lasting'
        ELSE 'It_should_have'
    END AS Lasting_Life
FROM
    diamonds;   
   
-- Window function
-- Display the carat, cut,price columns and thier rank order by price 
select carat,
cut,
price,
 dense_rank()over(order by price desc) as Expensive
from diamonds;  