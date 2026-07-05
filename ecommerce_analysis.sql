-- E-COMMERCE DATA ANALYSIS PROJECT
-- 1. CREATE RAW TABLE
CREATE TABLE retail_raw (InvoiceNo TEXT,
StockCode TEXT,
Description TEXT,
Quantity INT,
InvoiceDate TIMESTAMP,
UnitPrice NUMERIC, 
CustomerID NUMERIC,
Country TEXT );
-- 2. DATA EXPLORATION
SELECT COUNT(*) FROM retail_raw;
-- Missing Customer IDs
SELECT COUNT(*) FROM retail_raw WHERE CustomerID IS NULL;
-- Invalid transactions (returns / zero price)
SELECT * FROM retail_raw WHERE Quantity <= 0 OR UnitPrice <= 0 LIMIT 100;
--3. DATA CLEANING
DROP TABLE IF EXISTS retail_cleaned;
CREATE TABLE retail_cleaned AS 
SELECT * FROM retail_raw WHERE Quantity > 0 
AND UnitPrice > 0 
AND CustomerID IS NOT NULL;
-- 4.FEATURE ENGINEERING 
-- Add Revenue column
ALTER TABLE retail_cleaned 
ADD COLUMN Revenue NUMERIC;
-- Calculate Revenue
UPDATE retail_cleaned
SET Revenue = Quantity * UnitPrice;
-- 5. KEY PERFORMANCE INDICATORS (KPIs)
-- Total Revenue
SELECT SUM(Revenue) AS Total_Revenue 
FROM retail_cleaned;
-- 6. SALES ANALYSIS
-- MONTHLY REVENUE TREND
SELECT * FROM retail_cleaned LIMIT 10;
-- Insight: Identifies monthly sales trends and seasonality
SELECT COUNT(*) FROM retail_cleaned;
SELECT DATE_TRUNC('month', InvoiceDate) AS Month, SUM(Revenue) AS
Total_Revenue FROM retail_cleaned GROUP BY Month ORDER BY Month;
-- Top 10 PRODUCTS
SELECT  Description, SUM(Revenue) AS Total_Revenue FROM retail_cleaned 
GROUP BY Description ORDER BY Total_Revenue DESC LIMIT 10;
-- Top 10 Customers
SELECT CustomerID,SUM(Revenue) AS Total_Revenue FROM retail_cleaned 
GROUP BY CustomerID ORDER BY Total_Revenue DESC LIMIT 10;
-- Country-wise Sales
SELECT  Country, SUM(Revenue) AS Total_Revenue FROM retail_cleaned 
GROUP BY Country ORDER BY Total_Revenue DESC;
-- Total Revenue
SELECT SUM(Revenue) FROM retail_cleaned;
-- Total Orders
SELECT COUNT(DISTINCT InvoiceNo) FROM retail_cleaned;
-- Average Order Value (AOV)
SELECT  SUM(Revenue) / COUNT(DISTINCT InvoiceNo) AS
AOV FROM retail_cleaned;
-- 7. ADVANCED ANALYSIS
-- Customer Revenue Distribution (Pareto Analysis)
SELECT CustomerID, SUM(Revenue) AS Revenue FROM retail_cleaned 
GROUP BY CustomerID ORDER BY Revenue DESC;
-- Monthly Growth Analysis
SELECT  Month, Total_Revenue, LAG(Total_Revenue) OVER (ORDER BY Month) AS 
Prev_Revenue FROM ( SELECT DATE_TRUNC('month', InvoiceDate) AS Month, SUM(Revenue) AS 
Total_Revenue FROM retail_cleaned GROUP BY Month
) t;