-- ES.1 Esponi lʼanagrafica dei prodotti indicando per ciascun prodotto anche la sua sottocategoria DimProduct, DimProductSubcategory).
SELECT 
dimproduct.productkey AS ChiaveProdotto
, dimproduct.EnglishProductName AS NomeProdotto
, dimproductsubcategory.productsubcategorykey AS ChiaveSottoCategoria
, dimproductsubcategory.EnglishProductSubcategoryName AS SottoCategoria
FROM dimproduct 
INNER JOIN dimproductsubcategory
ON dimproduct.productsubcategorykey = dimproductsubcategory.productsubcategorykey;
/*ES.2 Esponi lʼanagrafica dei prodotti indicando per ciascun prodotto la sua sottocategoria
e la sua categoria DimProduct, DimProductSubcategory, DimProductCategory).*/
SELECT 
dimproduct.productkey AS ChiaveProdotto
, dimproduct.EnglishProductName AS NomeProdotto
, dimproductsubcategory.productsubcategorykey AS ChiaveSottoCategoria
, dimproductsubcategory.EnglishProductSubcategoryName AS SottoCategoria
, dimproductcategory.ProductCategoryKey AS 	ChiaveCategoria
, dimproductcategory.EnglishProductCategoryName AS Categoria
FROM dimproduct 
INNER JOIN dimproductsubcategory
ON dimproduct.productsubcategorykey = dimproductsubcategory.productsubcategorykey
INNER JOIN dimproductcategory
ON dimproductsubcategory.ProductCategoryKey = dimproductcategory.ProductCategoryKey;
-- ES.3 Esponi lʼelenco dei soli prodotti venduti DimProduct, FactResellerSales).
SELECT DISTINCT
dimproduct.EnglishProductName AS NomeProdotto
, dimproduct.productkey AS CodiceProdotto
FROM dimproduct
INNER JOIN factresellersales
ON dimproduct.productkey = factresellersales.productkey;
-- ES.4 Esponi lʼelenco dei prodotti non venduti (considera i soli prodotti finiti cioè quelli per i quali il campo FinishedGoodsFlag è uguale a 1.
SELECT
dimproduct.EnglishProductName AS NomeProdotto
, dimproduct.ProductKey AS ChiaveProdotto
, dimproduct.FinishedGoodsFlag
FROM dimproduct
LEFT OUTER JOIN factresellersales
ON dimproduct.ProductKey = factresellersales.ProductKey
WHERE FinishedGoodsFlag = 1
AND factresellersales.ProductKey IS NULL;
-- ES.5 Esponi lʼelenco delle transazioni di vendita FactResellerSales) indicando anche il nome del prodotto venduto DimProduct)
SELECT
dimproduct.EnglishProductName AS NomeProdotto
, dimproduct.productkey AS CodiceProdotto
, factresellersales.*
FROM dimproduct
INNER JOIN factresellersales
ON dimproduct.productkey = factresellersales.productkey;
-- ES.6 Esponi lʼelenco delle transazioni di vendita indicando la categoria di appartenenza di ciascun prodotto venduto.
SELECT
dimproduct.productkey AS ChiaveProdotto
, dimproduct.EnglishProductName AS NomeProdotto
, dimproductsubcategory.productsubcategorykey AS ChiaveSottoCategoria
, dimproductsubcategory.EnglishProductSubcategoryName AS SottoCategoria
, dimproductcategory.productcategorykey AS ChiaveCategoria
, dimproductcategory.EnglishProductCategoryName AS Categoria
, factresellersales.*
FROM dimproduct 
INNER JOIN  dimproductsubcategory
ON dimproduct.productsubcategorykey = dimproductsubcategory.productsubcategorykey
INNER JOIN dimproductcategory
ON dimproductsubcategory.productcategorykey = dimproductcategory.productcategorykey
INNER JOIN factresellersales
ON dimproduct.productkey = factresellersales.productkey
WHERE YEAR(orderdate) BETWEEN 2019 AND 2020
AND dimproductcategory.EnglishProductCategoryName = "Bikes";
-- ES.7 Esplora la tabella DimReseller.
SELECT * 
FROM dimreseller;
-- ES.7 Esponi in output lʼelenco dei reseller indicando, per ciascun reseller, anche la sua area geografica.
SELECT
R.ResellerKey
, G.GeographyKey
, R.ResellerName AS Reseller
, G.EnglishCountryRegionName AS Country
, G.StateProvinceName AS Province
, G.City AS City
, ST.* 
FROM dimreseller AS R
LEFT JOIN dimgeography AS G
ON R.GeographyKey = G. GeographyKey
LEFT JOIN dimsalesterritory AS ST
ON ST.SalesTerritoryKey = G.SalesTerritoryKey;
/*ES.8 Esponi lʼelenco delle transazioni di vendita. Il result set deve esporre i campi:
SalesOrderNumber, SalesOrderLineNumber, OrderDate, UnitPrice, Quantity, TotalProductCost.
Il result set deve anche indicare il nome del prodotto, il nome della categoria del prodotto,
il nome del reseller e lʼarea geografica.*/
SELECT
A.*
, A.SalesAmount - A.TotalProductCost AS Markup
, PC.EnglishProductCategoryName AS ProductCategory
, R.ResellerName
, G.EnglishCountryRegionName
FROM (
SELECT 
P.ProductKey
, P.ProductSubcategoryKey
, RS.SalesOrderNumber
, SalesOrderLineNumber
, RS.OrderDate
, RS.UnitPrice
, RS.OrderQuantity
-- , RS.TotalProductCost
, CASE WHEN RS.TotalProductCost IS NULL THEN P.StandardCost*RS.OrderQuantity 
		ELSE RS.TotalProductCost END AS TotalProductCost
, RS.SalesAmount
, RS.ResellerKey
/*, P.StandardCost
, RS.TotalProductCost/RS.OrderQuantity
, (RS.TotalProductCost/RS.OrderQuantity)-P.StandardCost AS DIFF*/
FROM factresellersales AS RS
LEFT OUTER JOIN 
dimproduct AS P 
ON RS.ProductKey = P.ProductKey
) AS A
left join dimproductsubcategory AS PS
ON PS.ProductSubcategoryKey = A.ProductSubcategoryKey 
left join dimproductcategory AS PC
ON PC.ProductCategoryKey = PS.ProductCategoryKey
LEFT JOIN dimreseller R
ON R.ResellerKey= A.ResellerKey
LEFT JOIN dimgeography AS G
ON G.GeographyKey = R.GeographyKey;

