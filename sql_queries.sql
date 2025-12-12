CREATE DATABASE TASK3;
USE TASK3;
SELECT * FROM [dbo].[sirajunisha super store dataset];

--. Total sales, profit, quantity

SELECT
    ROUND(SUM(Sales), 2)    AS Total_Sales,
    ROUND(SUM(Profit), 2)   AS Total_Profit,
    ROUND(SUM(Quantity), 0) AS Total_Quantity
FROM [dbo].[sirajunisha super store dataset];

--Monthly sales trend

SELECT
    
  FORMAT(Order_Date, 'MMM') AS Month,
  ROUND(SUM(Sales),0)  AS Monthly_Sales
FROM [dbo].[sirajunisha super store dataset]
GROUP BY
   
    FORMAT(Order_Date, 'MMM'),
    MONTH(Order_Date)
ORDER BY
    Monthly_Sales DESC

-- YoY sales comparison 


WITH yearly_sales AS (
    SELECT
        YEAR(Order_Date) AS [Year],
        ROUND(SUM(Sales),0) AS Total_Sales
    FROM [dbo].[sirajunisha super store dataset]
    GROUP BY YEAR(Order_Date)
)

SELECT
    [Year],
    Total_Sales,
   ROUND( LAG(Total_Sales) OVER (ORDER BY [Year]),0) AS Prev_Year_Sales,
    ROUND(
        (
            (Total_Sales - LAG(Total_Sales) OVER (ORDER BY [Year])) * 100.0
            / NULLIF(LAG(Total_Sales) OVER (ORDER BY [Year]), 0)
        ),
        2
    ) AS YoY_Growth_Percent
FROM yearly_sales
ORDER BY [Year];

--Top 10 products by sales 

SELECT TOP 10
    Product_Name,
    ROUND(SUM(Sales),0) AS Total_Sales
FROM [dbo].[sirajunisha super store dataset]
GROUP BY Product_Name
ORDER BY Total_Sales DESC;

--Top 10 customers by revenue 

SELECT TOP 10
    Customer_ID,
    ROUND(SUM(Sales),0) AS Total_Revenue
FROM [dbo].[sirajunisha super store dataset]
GROUP BY Customer_ID
ORDER BY Total_Revenue DESC;

--Category-wise profit margin 

SELECT
    Category,
    
    ROUND(
        (SUM(Profit) * 100.0) / NULLIF(SUM(Sales), 0),
        2
    ) AS Profit_Margin_Percent
FROM [dbo].[sirajunisha super store dataset]
GROUP BY Category
ORDER BY Profit_Margin_Percent DESC

-- Region performance (sales + profit) 

SELECT
    Region,
    ROUND(SUM(Sales),0)  AS Total_Sales,
    ROUND(SUM(Profit),0) AS Total_Profit
FROM [dbo].[sirajunisha super store dataset]
GROUP BY Region
ORDER BY Total_Sales DESC;


-- Discount impact on profitability 

SELECT
    Discount,
    COUNT(*) AS Orders_Count,
    ROUND(SUM(Profit),0) AS Total_Profit,
    ROUND(
        (SUM(Profit) * 100.0) / NULLIF(SUM(Sales), 0),
        2
    ) AS Profit_Margin_Percent
FROM [dbo].[sirajunisha super store dataset]
GROUP BY Discount
ORDER BY Discount;

--Profit loss analysis (items with negative profit) 

SELECT
    Product_Name,
    ROUND(SUM(Profit),0) AS Total_Profit,
    ROUND(SUM(Sales),0) AS Total_Sales
FROM [dbo].[sirajunisha super store dataset]
GROUP BY Product_Name
HAVING SUM(Profit) < 0
ORDER BY Total_Profit ASC;

-- Segment contribution 

SELECT
    Segment,round(sum(Sales),0)
     AS Segment_Contribution
FROM [dbo].[sirajunisha super store dataset]
GROUP BY Segment

--Shipping time calculation (Ship Date – Order Date)

SELECT
    Order_ID,
    Order_Date,
    Ship_Date,
    DATEDIFF(day, Order_Date, Ship_Date) AS Shipping_Days
FROM [dbo].[sirajunisha super store dataset]
ORDER BY Shipping_Days DESC;

--Identify outlier orders (High sales or loss) 

SELECT
    Order_ID,
    Sales,
    Profit
FROM [dbo].[sirajunisha super store dataset] 
WHERE
    Sales > (SELECT AVG(Sales) + 2 * STDEV(Sales) FROM [dbo].[sirajunisha super store dataset])  -- high sales outliers
    OR Profit < 0                                                   -- loss orders
ORDER BY Sales DESC, Profit ASC;

--END REPORT--
   
