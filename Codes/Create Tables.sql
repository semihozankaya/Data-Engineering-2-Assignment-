DROP SCHEMA IF EXISTS DE2Project;
CREATE SCHEMA DE2Project;
USE DE2Project;

DROP TABLE IF EXISTS Sales;
CREATE TABLE Sales 
(InvoiceNo INT,
Quantity INT,
InvoiceDate DATETIME,
UnitPrice DECIMAL(10,2),
CustomerID INT,
Country VARCHAR(255),
TotalSale DECIMAL(10,2));

LOAD DATA LOCAL INFILE '/home/ozzy/Documents/CEU/DE2/Assignment/Data/Clean/sales.csv'
INTO TABLE Sales
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(InvoiceNo, 
Quantity, 
InvoiceDate, 
UnitPrice, 
CustomerID, 
Country,
TotalSale);
