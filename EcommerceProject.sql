--Create Database
CREATE DATABASE ECOMMERCE;

--Create Tables and Define Relationships

CREATE TABLE Customers(
	CustomerID INT PRIMARY KEY IDENTITY(1,1),
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	Email VARCHAR(100) UNIQUE,
	PhoneNumber VARCHAR(20),
	JoinDate DATE
);

ALTER TABLE Customers ALTER COLUMN PhoneNumber VARCHAR(50);

CREATE TABLE Suppliers(
	SupplierID INT PRIMARY KEY IDENTITY(1,1),
	SupplierName VARCHAR(100),
	ContactInfo VARCHAR(100)
);

CREATE TABLE Products(
	ProductID INT PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(100),
	Category VARCHAR(50),
	Price DECIMAL(10,2),
	StockQuantity INT,
	SupplierID INT FOREIGN KEY REFERENCES Suppliers(SupplierID),
	CreatedDate DATE
);

CREATE TABLE Orders(
	OrderID INT PRIMARY KEY IDENTITY(1,1),
	CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
	OrderDate DATE,
	OrderStatus VARCHAR(20),
	PaymentMethod VARCHAR(50),
);

CREATE TABLE OrderDetails(
	OrderDetailsID INT PRIMARY KEY IDENTITY(1,1),
	OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
	ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
	Quantity INT CHECK (Quantity >0),
	CONSTRAINT UQ_Order_Product UNIQUE (OrderID, ProductID) 
);


USE ECOMMERCE
SELECT * FROM Customers;
SELECT * FROM Suppliers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;

-- Rename Price to CostOfProduct in Products table
EXEC sp_rename 'Products.Price', 'CostOfProduct', 'COLUMN';


ALTER TABLE OrderDetails
ADD PriceAtPOS DECIMAL(10,2);

UPDATE OrderDetails
SET PriceAtPOS = 
    ROUND(
        p.CostOfProduct * (1 + ((RAND(CHECKSUM(NEWID())) * 0.2) - 0.1)), 2
    )
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID;




-- Indexes to Improve Performance of regularly queried fields

CREATE INDEX idx_orders_status
ON Orders(OrderStatus);


CREATE INDEX idx_orders_orderdate 
ON Orders(OrderDate);


CREATE INDEX idx_orderdetails_orderid 
ON OrderDetails(OrderID);


CREATE INDEX idx_orderdetails_revenue 
ON OrderDetails(OrderID, PriceAtPOS, Quantity);


CREATE INDEX idx_OrderDetails_ProductID 
ON OrderDetails (ProductID);

CREATE INDEX idx_OrderDetails_PriceQuantity 
ON OrderDetails (PriceAtPOS, Quantity);


CREATE INDEX idx_Products_SupplierID 
ON Products (SupplierID);


CREATE INDEX idx_Suppliers_SupplierID 
ON Suppliers (SupplierID);


CREATE INDEX idx_CustomerID 
ON Orders(CustomerID);

-- TOTAL REVENUE OVER TIME
-- MONTHLY REVENUE
SELECT 
SUM(od.PriceAtPOS * od.Quantity) AS TotalRevenue,
FORMAT(o.OrderDate, 'MMM') AS MonthName,
MONTH(o.OrderDate) AS MonthNumber
FROM OrderDetails od
JOIN Orders o ON o.OrderID = od.OrderID
WHERE o.OrderStatus IN ('Shipped','Delivered') AND YEAR(o.OrderDate) != 2025
GROUP BY FORMAT(o.OrderDate, 'MMM'), MONTH(o.OrderDate)
ORDER BY MonthNumber;

-- ANNUAL REVENUE
SELECT 
SUM(od.PriceAtPOS * od.Quantity) AS TotalRevenue, 
YEAR(o.OrderDate) AS Year
FROM OrderDetails od
JOIN Orders o ON o.OrderID = od.OrderID
WHERE o.OrderStatus IN ('Shipped','Delivered')  AND YEAR(o.OrderDate) != 2025
GROUP BY YEAR(o.OrderDate)
ORDER BY Year;

-- REVENUE GROWTH BY MONTH,YEAR
SELECT 
SUM(od.PriceAtPOS * od.Quantity) AS TotalRevenue,
FORMAT(o.OrderDate, 'MMM') AS MonthName,
MONTH(o.OrderDate) AS MonthNumber, YEAR(o.OrderDate) AS Year
FROM OrderDetails od
JOIN Orders o ON o.OrderID = od.OrderID
WHERE o.OrderStatus IN ('Shipped','Delivered')  AND YEAR(o.OrderDate) != 2025
GROUP BY YEAR(o.OrderDate),MONTH(o.OrderDate), FORMAT(o.OrderDate, 'MMM')
ORDER BY Year, MonthNumber;



-- BEST SELLING PRODUCTS BY REVENUE & VOLUME
SELECT 
RANK() OVER (ORDER BY SUM(od.PriceAtPOS * od.Quantity) DESC) AS RevenueRank,
p.Name , 
s.SupplierName, 
SUM(od.PriceAtPOS * od.Quantity) AS TotalRevenue,
SUM(od.Quantity) AS TotalVolume
FROM OrderDetails od
JOIN Products p on p.ProductID = od.ProductID
JOIN Suppliers s on s.SupplierID = p.SupplierID
JOIN Orders o on od.OrderID = o.OrderID
WHERE o.OrderStatus IN ('Shipped','Delivered')
GROUP BY p.Name,s.SupplierName;


--REVENUE BREAKDOWN BY CATEGORY
WITH RevenuePerCategory AS(
SELECT
p.Category, 
SUM(od.PriceAtPOS * od.Quantity) AS TotalRevenue
FROM OrderDetails od
JOIN Products p on p.ProductID = od.ProductID
JOIN Orders o on od.OrderID = o.OrderID
WHERE o.OrderStatus IN ('Shipped','Delivered')
GROUP BY p.Category
)
SELECT 
    Category, 
    TotalRevenue
FROM RevenuePerCategory
ORDER BY TotalRevenue DESC;


-- CUSTOMER LIFETIME VALUE AND CHURN ANALYSIS FOR RETENTION ANALYSIS
WITH CLV_CHURN AS(
SELECT 
c.CustomerID,
c.FirstName,
c.LastName,
c.Email, 
SUM(od.PriceAtPOS * od.Quantity) AS CustomerValue,
COUNT(DISTINCT o.OrderID) AS OrderCount, 
MAX(o.OrderDate) as LastOrderDate,
CASE 
		WHEN MAX(o.OrderDate) IS NULL THEN 'No Orders'
		WHEN MAX(o.OrderDate) < DATEADD(MONTH, -7, (SELECT MAX(OrderDate) FROM Orders)) THEN 'Churned'
		ELSE 'Active'
    END AS CustomerStatus
FROM Orders o
JOIN OrderDetails od on o.OrderID = od.OrderID
JOIN Customers c on c.CustomerID = o.CustomerID
WHERE o.OrderStatus IN ('Shipped','Delivered')
GROUP BY c.CustomerID,c.FirstName, c.LastName,c.Email
)
SELECT RANK() OVER (ORDER BY CustomerValue DESC) AS CustomerRank,
CustomerID,FirstName,LastName, Email,CustomerValue, OrderCount, LastOrderDate,
NTILE(4) OVER (ORDER BY CustomerValue DESC) AS ValueTier,
CustomerStatus
FROM CLV_CHURN
ORDER BY CustomerValue DESC;


-- AVERAGE ORDER VALUE
SELECT
SUM(od.PriceAtPOS * od.Quantity) AS TotalRevenue,
NULLIF(COUNT(DISTINCT o.OrderID), 0) AS TotalOrders,
(SUM(od.PriceAtPOS * od.Quantity)/COUNT(DISTINCT o.OrderID)) AS AverageOrderValue,
MONTH(o.OrderDate) AS MonthNumber, 
FORMAT(o.OrderDate, 'MMM') AS MonthName,
YEAR(o.OrderDate) AS Year
FROM Orders o
JOIN OrderDetails od on od.OrderID = o.OrderID
WHERE o.OrderStatus IN ('Shipped','Delivered')
GROUP BY MONTH(o.OrderDate),FORMAT(o.OrderDate, 'MMM'), YEAR(o.OrderDate)
ORDER BY Year, MonthNumber;

-- MONTHLY GROWTH RATE
WITH MonthlyData AS(
	SELECT
	MONTH(o.OrderDate) AS MonthNumber, 
	FORMAT(o.OrderDate, 'MMM') AS MonthName,
	YEAR(o.OrderDate) AS Year,
	SUM(od.PriceAtPOS * od.Quantity) AS TotalRevenue,
	COUNT(DISTINCT o.OrderID) AS TotalOrders
	FROM Orders o
	JOIN OrderDetails od ON o.OrderID = od.OrderID
	WHERE o.OrderStatus IN ('Shipped','Delivered')
	GROUP BY MONTH(o.OrderDate), FORMAT(o.OrderDate, 'MMM'),YEAR(o.OrderDate)
)
SELECT 
MonthNumber,
MonthName,
Year,
TotalRevenue,
TotalOrders,
LAG(TotalRevenue) OVER (ORDER BY Year, MonthNumber) AS PrevMonthRevenue,
LAG(TotalOrders) OVER (ORDER BY Year, MonthNumber) AS PrevMonthOrders,
(TotalRevenue - LAG(TotalRevenue) OVER (ORDER BY Year, MonthNumber))/ NULLIF(LAG(TotalRevenue) OVER (ORDER BY Year, MonthNumber), 0) * 100 AS RevenueGrowthRate,
(TotalOrders - LAG(TotalOrders) OVER (ORDER BY Year, MonthNumber))/ NULLIF(CAST(LAG(TotalOrders) OVER (ORDER BY Year, MonthNumber) AS DECIMAL), 0) * 100 AS OrderGrowthRate
FROM MonthlyData
ORDER BY Year,MonthNumber;


-- NEW VS RETURNING CUSTOMERS
WITH Purchase AS (
    SELECT
        o.CustomerID,
        MIN(o.OrderDate) AS FirstOrder,
        SUM(od.Quantity * od.PriceAtPOS) AS TotalRevenue,
        COUNT(DISTINCT o.OrderID) AS TotalOrders
    FROM Orders o
    JOIN OrderDetails od ON od.OrderID = o.OrderID
    WHERE o.OrderStatus IN ('Shipped', 'Delivered')
    GROUP BY o.CustomerID
),

CustomerClassification AS (  
    SELECT  
        CustomerID,  
        FirstOrder,  
        TotalOrders,  
        TotalRevenue,  
        CASE   
            WHEN FirstOrder >= DATEADD(MONTH, -6, (SELECT MAX(OrderDate) FROM Orders)) THEN 'New Customer'  -- First Purchase in Last 6 months
            ELSE 'Returning Customer'  
        END AS CustomerType  
    FROM Purchase  
)  

SELECT  
    CustomerType,  
    COUNT(*) AS CustomerCount,  
    SUM(TotalOrders) AS TotalOrders,  
    SUM(TotalRevenue) AS TotalRevenue  
FROM CustomerClassification  
GROUP BY CustomerType  
ORDER BY TotalRevenue DESC;


-- SUPPLIER PERFORMANCE
WITH SupplierRevenue AS (
    SELECT 
		RANK() OVER(ORDER BY SUM(od.Quantity * od.PriceAtPOS) DESC) AS SupplierRank,
		s.SupplierName,
        SUM(od.Quantity * od.PriceAtPOS) AS TotalRevenue
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
	JOIN Products p ON p.ProductID = od.ProductID
	JOIN Suppliers s ON s.SupplierID = p.SupplierID
    WHERE o.OrderStatus IN ('Shipped', 'Delivered')  -- Only count shipped or delivered orders
    GROUP BY s.SupplierName
)
SELECT 
	SupplierRank,
    SupplierName,
    TotalRevenue
FROM SupplierRevenue
ORDER BY TotalRevenue DESC;

-- MONTHLY SUPPLIER PERFORMANCE
WITH MonthlySupplierRevenue AS (
    SELECT 
        s.SupplierName,
        YEAR(o.OrderDate) AS Year,
		MONTH(o.OrderDate) AS MonthNumber,
        FORMAT(o.OrderDate, 'MMM') AS MonthName,
        SUM(od.Quantity * od.PriceAtPOS) AS TotalRevenue
   FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
	JOIN Products p ON p.ProductID = od.ProductID
	JOIN Suppliers s ON s.SupplierID = p.SupplierID
    WHERE o.OrderStatus IN ('Shipped', 'Delivered')
    GROUP BY s.SupplierName, YEAR(o.OrderDate),MONTH(o.OrderDate),FORMAT(o.OrderDate, 'MMM')
)
SELECT 
    SupplierName,
    Year,
	MonthNumber,
    MonthName,
    TotalRevenue
FROM MonthlySupplierRevenue
ORDER BY Year, MonthNumber;


-- PROFIT MARGIN ANALYSIS
WITH MARGIN AS(
SELECT 
p.ProductID,
p.Name,
p.CostOfProduct,
od.PriceAtPOS,
(od.PriceAtPOS - p.CostOfProduct) AS ProfitMarginPerUnit,
((od.PriceAtPOS - p.CostOfProduct) / NULLIF(od.PriceAtPOS, 0)) * 100 AS ProfitMarginPercentage,
od.Quantity,
CASE
	WHEN p.CostOfProduct > od.PriceAtPOS THEN 'Discount'
	ELSE 'Full Price'
END AS PriceCategory
FROM Orders o
JOIN OrderDetails od ON od.OrderID = o.OrderID
JOIN Products p ON p.ProductID = od.ProductID
WHERE o.OrderStatus IN ('Shipped', 'Delivered')
)
SELECT
ProductID,
Name,
PriceCategory,
COUNT(*) AS OrderCount,
SUM(ProfitMarginPerUnit * Quantity) AS TotalProfit,
AVG(ProfitMarginPercentage) AS AvgProfitMargin
FROM MARGIN
GROUP BY ProductID,Name, PriceCategory
ORDER BY AvgProfitMargin;

-- Profit By Month
WITH ProfitByMonth AS (
    SELECT
        YEAR(o.OrderDate) AS Year,
        MONTH(o.OrderDate) AS MonthNumber,
        FORMAT(o.OrderDate, 'MMM') AS MonthName,
        SUM(od.PriceAtPOS * od.Quantity) - SUM(p.CostOfProduct * od.Quantity) AS TotalProfit  -- Total profit per month
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON p.ProductID = od.ProductID
    WHERE o.OrderStatus IN ('Shipped', 'Delivered')
    GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate), FORMAT(o.OrderDate, 'MMM')
)
SELECT
    Year,
    MonthNumber,
    MonthName,
    TotalProfit
FROM ProfitByMonth
ORDER BY TotalProfit DESC;  -- Order by Total Profit in descending order
