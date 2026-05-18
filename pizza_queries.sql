-- ================================================
-- PIZZA SALES ANALYSIS — SQL QUERIES
-- Tool: MS SQL Server
-- Author: Thahir | github.com/thahirsd01
-- ================================================


-- ================================================
-- A. KEY PERFORMANCE INDICATORS (KPIs)
-- ================================================

-- 1. Total Revenue
SELECT 
    ROUND(SUM(total_price), 2) AS Total_Revenue 
FROM pizza_sales;

-- 2. Average Order Value
SELECT 
    ROUND(SUM(total_price) / COUNT(DISTINCT order_id), 2) AS Avg_Order_Value 
FROM pizza_sales;

-- 3. Total Pizzas Sold
SELECT 
    SUM(quantity) AS Total_Pizzas_Sold 
FROM pizza_sales;

-- 4. Total Orders
SELECT 
    COUNT(DISTINCT order_id) AS Total_Orders 
FROM pizza_sales;

-- 5. Average Pizzas Per Order
SELECT 
    ROUND(
        CAST(SUM(quantity) AS DECIMAL(10,2)) / 
        CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)), 
    2) AS Avg_Pizzas_Per_Order
FROM pizza_sales;


-- ================================================
-- B. TREND ANALYSIS
-- ================================================

-- 6. Daily Order Trend
SELECT 
    DATENAME(DW, order_date) AS Order_Day,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY DATENAME(DW, order_date)
ORDER BY Total_Orders DESC;

-- 7. Monthly Order Trend
SELECT 
    DATENAME(MONTH, order_date) AS Month_Name,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY DATENAME(MONTH, order_date)
ORDER BY Total_Orders DESC;

-- 8. Hourly Order Trend
SELECT 
    DATEPART(HOUR, order_time) AS Order_Hour,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY DATEPART(HOUR, order_time)
ORDER BY Order_Hour;


-- ================================================
-- C. SALES BY CATEGORY & SIZE
-- ================================================

-- 9. % Sales by Pizza Category
SELECT 
    pizza_category,
    ROUND(SUM(total_price), 2) AS Total_Revenue,
    ROUND(
        SUM(total_price) * 100 / 
        (SELECT SUM(total_price) FROM pizza_sales), 
    2) AS Percentage_of_Sales
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Total_Revenue DESC;

-- 10. % Sales by Pizza Size
SELECT 
    pizza_size,
    ROUND(SUM(total_price), 2) AS Total_Revenue,
    ROUND(
        SUM(total_price) * 100 / 
        (SELECT SUM(total_price) FROM pizza_sales), 
    2) AS Percentage_of_Sales
FROM pizza_sales
GROUP BY pizza_size
ORDER BY Total_Revenue DESC;

-- 11. Total Pizzas Sold by Category
SELECT 
    pizza_category,
    SUM(quantity) AS Total_Pizzas_Sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Total_Pizzas_Sold DESC;


-- ================================================
-- D. TOP & BOTTOM PERFORMERS
-- ================================================

-- 12. Top 5 Pizzas by Revenue
SELECT TOP 5 
    pizza_name,
    ROUND(SUM(total_price), 2) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC;

-- 13. Bottom 5 Pizzas by Revenue
SELECT TOP 5 
    pizza_name,
    ROUND(SUM(total_price), 2) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue ASC;

-- 14. Top 5 Pizzas by Quantity Sold
SELECT TOP 5 
    pizza_name,
    SUM(quantity) AS Total_Quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity DESC;

-- 15. Bottom 5 Pizzas by Quantity Sold
SELECT TOP 5 
    pizza_name,
    SUM(quantity) AS Total_Quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity ASC;

-- 16. Top 5 Pizzas by Number of Orders
SELECT TOP 5 
    pizza_name,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders DESC;

-- 17. Bottom 5 Pizzas by Number of Orders
SELECT TOP 5 
    pizza_name,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders ASC;


-- ================================================
-- E. ADVANCED ANALYSIS
-- ================================================

-- 18. Revenue Contribution by Category (Window Function)
SELECT 
    pizza_category,
    pizza_name,
    ROUND(SUM(total_price), 2) AS Pizza_Revenue,
    ROUND(
        SUM(SUM(total_price)) OVER (PARTITION BY pizza_category), 
    2) AS Category_Total,
    ROUND(
        SUM(total_price) * 100 / 
        SUM(SUM(total_price)) OVER (PARTITION BY pizza_category), 
    2) AS Pct_Within_Category
FROM pizza_sales
GROUP BY pizza_category, pizza_name
ORDER BY pizza_category, Pizza_Revenue DESC;

-- 19. Running Total Revenue by Month (Window Function)
SELECT 
    DATENAME(MONTH, order_date) AS Month_Name,
    MONTH(order_date) AS Month_Num,
    ROUND(SUM(total_price), 2) AS Monthly_Revenue,
    ROUND(
        SUM(SUM(total_price)) OVER (ORDER BY MONTH(order_date)), 
    2) AS Running_Total
FROM pizza_sales
GROUP BY DATENAME(MONTH, order_date), MONTH(order_date)
ORDER BY Month_Num;

-- 20. Pizza Rank by Revenue Within Each Category
SELECT 
    pizza_category,
    pizza_name,
    ROUND(SUM(total_price), 2) AS Total_Revenue,
    RANK() OVER (
        PARTITION BY pizza_category 
        ORDER BY SUM(total_price) DESC
    ) AS Revenue_Rank
FROM pizza_sales
GROUP BY pizza_category, pizza_name
ORDER BY pizza_category, Revenue_Rank;
