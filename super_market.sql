-- SuperMarket Sales Analysis

-- At first let's start with the alter for renaming the columns name
-- alter table super_market rename column  `customer type` to customer_type;
-- alter table super_market rename column  `ï»¿Invoice ID` to Invoice_ID;
-- alter table super_market rename column  `Product line` to Product_line;
-- alter table super_market rename column  `Unit price` to Unit_price;
-- alter table super_market rename column  `gross margin percentage` to gross_margin_percentage;
-- alter table super_market rename column  `gross income` to gross_income;
-- alter table super_market rename column  `Tax 5%` to tax_5_percent;
-- 1. Sales Volume Analysis:
      -- What is the total sales volume for each product category-
SELECT 
    branch, ROUND(SUM(unit_price * quantity), 2)
FROM
    super_market
GROUP BY branch;    

	-- How do sales figures vary across diffrent branches (e.g Mandalay vs. Yangon)
 SELECT 
    City, ROUND(SUM(unit_price * quantity), 2)
FROM
    super_market
GROUP BY City;    
      
      
   -- 2 Customer Insights : 
          -- What is the distribution of sales between different customer types(e.g. member vs. normal)
SELECT 
    customer_type, ROUND(SUM(unit_price * quantity), 2)
FROM
    super_market
GROUP BY customer_type;      

                 -- How do gender demographics influence purchasing behavior?
                -- Are there any notable differences in product preferences between male female customers ?
SELECT 
    Gender, ROUND(SUM(unit_price * quantity), 2)
FROM
    super_market
GROUP BY Gender;  

-- 3 Product Performance:
        -- Which products have the highest sales(in the term of quantity and total revenue)
SELECT 
    Product_line, ROUND(SUM(unit_price * quantity), 2)
FROM
    super_market
GROUP BY product_line
ORDER BY ROUND(SUM(unit_price * quantity), 2) DESC
LIMIT 1;     

           -- Are there any seasonal trends in product sales
SELECT 
    Invoice_ID, ROUND(SUM(unit_price * quantity), 2)
FROM
    super_market
GROUP BY Invoice_ID
ORDER BY ROUND(SUM(unit_price * quantity), 2) DESC
LIMIT 1; 

   -- 4 Payment Method Analysis:
        -- What payment methods are most commonlyused by customers
SELECT 
    payment, COUNT(Invoice_ID)
FROM
    super_market
GROUP BY payment
ORDER BY COUNT(Invoice_ID) DESC
LIMIT 1;

          -- How does the coice of payment method vary by customer type or product category
SELECT 
    payment, COUNT(*), Product_line
FROM
    super_market
GROUP BY payment , product_line;  

 -- 5 . Pricing Strategy:
		-- What is the average price of products sold?
        -- Are there any products with significantly higher and lower price points
SELECT 
    product_line, ROUND(AVG(unit_price), 2)
FROM
    super_market
GROUP BY product_line;  

SELECT 
    product_line, unit_price
FROM
    super_market
WHERE
    unit_price > (SELECT 
            AVG(Unit_price)
        FROM
            super_market);
            
            -- How does pricing affect the quantity sold ?
            -- Is there evidence of prices affecting customer purchasing decisions?
select product_line , 
     quantity, 
     unit_price ,
 dense_rank()over(order by quantity asc) as Pricing 
      from super_market
            limit 1;    
            
   -- 6 . Profitability Analysis:
        -- What are the gross margins for each products?
        -- Which products yield the highest profit?
        
SELECT 
    product_line,
    ROUND(unit_price / 100 * gross_margin_percentage,
            2) AS Margin_Price
FROM
    super_market;       

            -- How do tax rates affect overall sales volume and profitablility?
select product_line,
    quantity,
     round(tax_5_percent, 2) ,
rank()over(order By quantity asc) 
                 as quantity_rank,
rank() over(order by round(tax_5_percent, 2) desc)  
                  as Rank_system
                from super_market;


-- Conclusion:

-- This project provided valuable insights that can guide
-- future business strategies for the supermarket. 
-- By understanding customer behavior and preferences 
-- through data analysis, the supermarket can tailor its 
-- offerings and optimize its checkout processes to enhance 
-- customer satisfaction and drive sales.

            