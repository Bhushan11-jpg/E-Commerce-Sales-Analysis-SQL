create database ecommerce;
use ecommerce;
show tables;

-- 1) top selling products and category
 
SELECT CustomerID,
COUNT(DISTINCT OrderID) AS Total_orders,
SUM(Quantity) AS Total_Quantity,
SUM(TotalAmount) AS Total_Revenue
FROM eco_data
GROUP BY CustomerID
ORDER BY Total_Revenue DESC
LIMIT 10;


-- 2) coustomers buying behaivor
SELECT PaymentMethod,
COUNT(*) AS usage_count FROM eco_data GROUP BY PaymentMethod
ORDER BY 
usage_count DESC;


-- Join Tables

SELECT 
e.Order_ID,
e.OrderDate,
e.CustomerID,
c.First_Name,
c.Last_Name,
c.Email,
eco.ProductID,
eco.TotalAmount,
eco.Status,
eco.PaymentMethod
FROM 
edata e
JOIN 
eco_data eco ON e.Order_ID = eco.OrderID 
JOIN 
ee_sql c ON e.CustomerID = c.Customer_ID;

-- Most popular poducts

SELECT  
    eco.ProductID,  
    COUNT(*) AS OrderCount  
FROM  
    eco_data eco  
GROUP BY eco.ProductID  
ORDER BY OrderCount DESC  
LIMIT 10;


-- 2) Monthly Revenue Trend

SELECT  
    DATE_FORMAT(e.OrderDate, '%Y-%m') AS Month,  
    SUM(eco.TotalAmount) AS MonthlyRevenue  
FROM  
    edata e  
JOIN eco_data eco ON e.Order_ID = eco.OrderID  
GROUP BY Month  
ORDER BY Month;

-- 3) Average Order Value by Payment Method
SELECT  
    eco.PaymentMethod,  
    AVG(eco.TotalAmount) AS AvgOrderValue  
FROM  
    eco_data eco  
GROUP BY eco.PaymentMethod;

-- 5)Top 10 most ordesred Product 
SELECT  
    eco.ProductID,  
    COUNT(*) AS OrderCount  
FROM  
    eco_data eco  
GROUP BY eco.ProductID  
ORDER BY OrderCount DESC  
LIMIT 10;

-- Orders by Payment Method

SELECT eco.PaymentMethod, COUNT(*) AS OrderCount
FROM eco_data eco
GROUP BY eco.PaymentMethod;


-- Avergae Order value by Status

SELECT eco.Status, ROUND(AVG(eco.TotalAmount), 2) AS AvgOrderValue
FROM eco_data eco
GROUP BY eco.Status;


-- Orders with High Value (Above 10k)

SELECT e.Order_ID, eco.TotalAmount
FROM edata e
JOIN eco_data eco ON e.Order_ID = eco.OrderID
WHERE eco.TotalAmount > 10000;

-- Top 5 Most Ordered Products
SELECT eco.ProductID, COUNT(*) AS Frequency
FROM eco_data eco
GROUP BY eco.ProductID
ORDER BY Frequency DESC
LIMIT 5;

-- Order per Day

SELECT e.OrderDate, COUNT(*) AS DailyOrders
FROM edata e
GROUP BY e.OrderDate
ORDER BY e.OrderDate;

-- Cancelled Orders and their value

SELECT eco.OrderID, eco.TotalAmount
FROM eco_data eco
WHERE eco.Status = 'Cancelled';

--  Most Common Order Status

SELECT eco.Status, COUNT(*) AS Frequency
FROM eco_data eco
GROUP BY eco.Status
ORDER BY Frequency DESC
LIMIT 2;

-- Orders with Same Customer and Same Amount
SELECT e.CustomerID, eco.TotalAmount, COUNT(*) AS Frequency
FROM edata e
JOIN eco_data eco ON e.Order_ID = eco.OrderID
GROUP BY e.CustomerID, eco.TotalAmount
HAVING Frequency > 1;

-- Orders with Same Product Across Customers
SELECT eco.ProductID, COUNT(DISTINCT e.CustomerID) AS UniqueBuyers
FROM eco_data eco
JOIN edata e ON eco.OrderID = e.Order_ID
GROUP BY eco.ProductID
HAVING UniqueBuyers > 1;

-- Customers with Orders in Consecutive Months
SELECT DISTINCT e.CustomerID
FROM edata e
WHERE EXISTS (
    SELECT 1 FROM edata e2
    WHERE e.CustomerID = e2.CustomerID
    AND PERIOD_DIFF(DATE_FORMAT(e.OrderDate, '%Y%m'), DATE_FORMAT(e2.OrderDate, '%Y%m')) = 1
);

-- Avergae Spend per Payment Method

SELECT eco.PaymentMethod, ROUND(AVG(eco.TotalAmount), 2) AS AvgSpend
FROM eco_data eco
GROUP BY eco.PaymentMethod;

--  Customers with No Orders

SELECT c.Customer_ID, c.First_Name
FROM ee_sql c
LEFT JOIN edata e ON c.Customer_ID = e.CustomerID
WHERE e.Order_ID IS NULL;

-- Orders with Same Customer and Same Date
SELECT e.CustomerID, e.OrderDate, COUNT(*) AS Frequency
FROM edata e
GROUP BY e.CustomerID, e.OrderDate
HAVING Frequency > 1;

-- Customer Order Gaps (Time Between Orders)

SELECT e.CustomerID, DATEDIFF(MAX(e.OrderDate), MIN(e.OrderDate)) AS DaysBetween
FROM edata e
GROUP BY e.CustomerID;

-- Orders with Same Product and Same Amount

SELECT eco.ProductID, eco.TotalAmount, COUNT(*) AS Frequency
FROM eco_data eco
GROUP BY eco.ProductID, eco.TotalAmount
HAVING Frequency > 1;

-- Orders with Missing Customer Info

SELECT e.Order_ID
FROM edata e
LEFT JOIN ee_sql c ON e.CustomerID = c.Customer_ID
WHERE c.First_Name IS NULL OR c.Email IS NULL;

-- Orders with Status 'Pending' Older Than 30 Days

SELECT eco.OrderID, e.OrderDate, eco.Status
FROM eco_data eco
JOIN edata e ON eco.OrderID = e.Order_ID
WHERE eco.Status = 'Pending' AND e.OrderDate < CURDATE() - INTERVAL 30 DAY;

-- show all total amount where amount>12000.
select * from eco_data where TotalAmount >12000;

