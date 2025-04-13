/*ES.1 Scrivi una query per verificare che il campo
ProductKey nella tabella DimProduct sia una chiave primaria.
Quali considerazioni/ragionamenti è necessario che tu faccia?*/
SELECT ProductKey
, count(*)
FROM dimproduct
GROUP BY ProductKey
HAVING count(*) > 1;
/*ES.2 Scrivi una query per verificare che la combinazione dei campi
SalesOrderNumber e SalesOrderLineNumbersia una PK.*/
SELECT SalesOrderNumber
, SalesOrderLineNumber
, count(*)
FROM factresellersales
GROUP BY SalesOrderNumber
, SalesOrderLineNumber
HAVING count(*) > 1;
-- ES.3 Conta il numero transazioni SalesOrderLineNumber) realizzate ogni giorno a partire dal 1 Gennaio 2020.
SELECT OrderDate
, count(*) NUM_ORDINI
FROM(
SELECT OrderDate
FROM factresellersales
WHERE OrderDate >= '2020-01-01'
UNION ALL
SELECT OrderDate
FROM factinternetsales
WHERE OrderDate >= '2020-01-01') AS DATE_ORDINI
GROUP BY OrderDate;
/*ES.4 Calcola il fatturato totale FactResellerSales.SalesAmount), la quantità totale venduta FactResellerSales.OrderQuantity)
e il prezzo medio di vendita FactResellerSales.UnitPrice) per prodotto DimProduct) a partire dal 1 Gennaio 2020.
Il result set deve esporre pertanto il nome del prodotto, il fatturato totale, la quantità totale venduta e il prezzo medio di vendita.
I campi in output devono essere parlanti!*/
SELECT Sales.ProductKey AS ID
, Products.EnglishProductName AS Prodotto
, sum(SalesAmount) AS Fatturato_Tot
, sum(OrderQuantity) AS Quantità_Tot_Vendita
, avg(UnitPrice) AS Prezzo_Medio_Vendita 
, OrderDate AS Data 
FROM factresellersales AS Sales
INNER JOIN dimproduct AS Products
ON Sales.ProductKey = Products.ProductKey
WHERE OrderDate >= '2020-01-01'
GROUP BY Products.ProductKey;
/*ES.5 Calcola il fatturato totale FactResellerSales.SalesAmount) e la quantità totale venduta FactResellerSales.OrderQuantity)
per Categoria prodotto DimProductCategory). Il result set deve esporre pertanto il nome della categoria prodotto,
il fatturato totale e la quantità totale venduta. I campi in output devono essere parlanti!*/
SELECT Categoria_prodotto.EnglishProductCategoryName
, sum(Rivenditore.SalesAmount) AS Sales_Amount
, sum(Rivenditore.OrderQuantity) AS Order_Quantity
FROM dimproductcategory AS Categoria_prodotto
INNER JOIN dimproductsubcategory AS Categoria_Sotto_Prodotto
ON Categoria_prodotto.ProductCategoryKey = Categoria_Sotto_Prodotto.ProductcategoryKey
INNER JOIN dimproduct AS Prodotto
ON Categoria_Sotto_Prodotto.ProductSubcategoryKey = Prodotto.ProductSubcategoryKey
INNER JOIN factinternetsales AS Rivenditore
ON Prodotto.ProductKey = Rivenditore.ProductKey
GROUP BY Categoria_prodotto.EnglishProductCategoryName;
/*ES.6 Calcola il fatturato totale per area città DimGeography.City) realizzato a partire dal 1 Gennaio 2020.
Il result set deve esporre lʼelenco delle città con fatturato realizzato superiore a 60K.*/
SELECT Geo.City
, sum(Frs.SalesAmount)
FROM dimgeography AS Geo
INNER JOIN dimreseller AS Dr
ON Geo.GeographyKey = Dr.GeographyKey
INNER JOIN factresellersales AS Frs
ON Frs.ResellerKey = Dr.ResellerKey
WHERE Frs.OrderDate > '2020-01-01'
GROUP BY Geo.City
HAVING sum(Frs.SalesAmount)> 60000;