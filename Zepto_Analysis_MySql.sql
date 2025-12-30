-- Creating Database 'Zepto'
CREATE DATABASE zepto;


-- Using 'zepto' Database
USE zepto;



-- Creating 'zepto' Table
-- Importing .csv data into 'zepto' Table With Help of Table data Import Wizard
CREATE TABLE zepto(
	Category Text NOT NULL,
    name TEXT NOT NULL,
    mrp INT NOT NULL,
    discountPercent INT NOT NULL,
    availableQuantity INT NOT NULL,
    discountedSellingPrice INT NOT NULL,
    weightInGms INT NOT NULL,
    outOfStock TEXT NOT NULL,
    quantity INT NOT NULL
);



-- Q1)Checking The Data
SELECT * FROM zepto;



-- Q2)Display all columns and records from the table.
SELECT * FROM zepto;



-- Q3) Show the first 10 rows of the zepto_v2 table.
SELECT * FROM zepto
LIMIT 10;



-- Q4) Display all unique product category from the dataset.
SELECT DISTINCT Category AS Category_Name
FROM zepto;



-- Q5) Find the total number of products available in the dataset.
SELECT SUM(availableQuantity) AS Total_Number_of_Products
FROM zepto;


SELECT COUNT(DISTINCT name) AS Total_Products
FROM zepto;



-- Q6) Retrieve all products that are currently out of stock.
SELECT Category, name
FROM zepto
WHERE outOfStock='True';



-- Q7) List all products having a discount percentage greater than 10.
SELECT Category, name, mrp, discountPercent
FROM zepto
WHERE  discountPercent > 10;



-- Q8) Find the average MRP of products in each category.
SELECT Category, ROUND(AVG(mrp), 2) AS Average_MRP
FROM zepto
GROUP BY Category
ORDER BY Average_MRP DESC;



-- Q9) Show the top 5 most expensive products based on MRP.
SELECT * FROM (
	SELECT Category, name, mrp, 
    DENSE_RANK() OVER(ORDER BY mrp DESC) AS TOP_5
    FROM zepto
) ranked_products
WHERE TOP_5 <= 5;



-- Q10) Calculate the total available quantity of products per category.
SELECT Category, SUM(availableQuantity) AS Total_Quantity
FROM zepto
GROUP BY Category
ORDER BY Total_Quantity DESC;



-- Q11) Find the average discount percentage for each category.
SELECT Category, ROUND(AVG(discountPercent), 2) AS Avg_Percentage
FROM zepto
GROUP BY Category;



-- Q12) Identify products where the discounted selling price is less than 80% of the MRP.
SELECT name, Category, mrp, discountedSellingPrice, availableQuantity
FROM zepto
WHERE discountedSellingPrice < (0.8 * mrp);



-- Q13) Find the category with the highest total sales value (discountedSellingPrice × availableQuantity).
WITH Total_Sales AS (
	SELECT Category, SUM(discountedSellingPrice * availableQuantity) AS Total_Sales
	FROM zepto
	GROUP BY Category
), 
ranked_category AS (
	SELECT Category, Total_Sales,
    DENSE_RANK() OVER(ORDER BY Total_Sales DESC) AS Highest_Total_Sales
    FROM Total_Sales
) SELECT * FROM ranked_category
WHERE Highest_Total_Sales = 1;



-- Q14) Determine which category has the highest average discount percentage.
SELECT *
FROM (
    SELECT 
        Category,
        AVG(discountPercent) AS Average_Discount,
        RANK() OVER (ORDER BY AVG(discountPercent) DESC) AS Discount_Rank
    FROM zepto
    GROUP BY Category
) AS ranked_categories
WHERE Discount_Rank = 1;



-- Q15) Find the average price per gram for each product and sort them by the lowest first.
SELECT Category, name, mrp, weightInGms, (mrp / weightInGms) AS Price_Per_Grams
FROM zepto
WHERE weightInGms > 0
ORDER BY Price_Per_Grams ASC;



-- Q16) Calculate the category-wise stock availability ratio (products in stock ÷ total products).
SELECT 
    Category,
    ROUND(
        SUM(CASE WHEN outOfStock = FALSE THEN 1 ELSE 0 END) / COUNT(*), 
        2
    ) AS stock_availability_ratio
FROM zepto
GROUP BY Category
ORDER BY stock_availability_ratio DESC;



-- Q17) List the top 3 categories contributing the most to total discounted sales.
WITH ranked_sales AS (
    SELECT 
        Category,
        SUM(discountedSellingPrice * availableQuantity) AS total_discounted_sales,
        DENSE_RANK() OVER (ORDER BY SUM(discountedSellingPrice * availableQuantity) DESC) AS sales_rank
    FROM zepto
    GROUP BY Category
)
SELECT *
FROM ranked_sales
WHERE sales_rank <= 3;