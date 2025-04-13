/*ES.1 Implementa una vista denominata Product al fine di creare unʼanagrafica (dimensione) prodotto completa.
La vista, se interrogata o utilizzata come sorgente dati, deve esporre il nome prodotto,
il nome della sottocategoria associata e il nome della categoria associata.*/
CREATE VIEW View_Prodotto AS
( SELECT Prod.ProductKey AS ID_Prodotto
, Prod.EnglishProductName AS Nome_Prodotto
, SubCat.EnglishProductSubcategoryName AS Nome_SottoCategoria
, Cat.EnglishProductCategoryName AS Nome_Categoria
, Prod.FinishedGoodsFlag AS Flag_Prodotto_Finito
, Prod.ListPrice AS Prezzo_Listino
FROM dimproduct AS Prod
INNER JOIN dimproductsubcategory AS SubCat
ON Prod.ProductSubcategoryKey = SubCat.ProductSubcategoryKey
INNER JOIN dimproductcategory AS Cat
ON Cat.ProductCategoryKey = SubCat.ProductCategoryKey
ORDER BY ProductKey);
/*
SELECT * 
FROM view_prodotto;
*/
/*ES.2 Implementa una vista denominata Reseller al fine di creare unʼanagrafica (dimensione) reseller completa.
La vista, se interrogata o utilizzata come sorgente dati, deve esporre il nome del reseller,
il nome della città e il nome della regione.*/
CREATE VIEW View_Vendite AS
( SELECT SalesOrderNumber AS Num_ordine
, SalesOrderLineNumber AS Linea_Num_Ordine
, Prod.ProductKey AS ID_Prodotto
, ResellerKey AS ID_Rivenditore
, OrderQuantity AS Quant
, UnitPrice AS Prezzo_Unitario
, SalesAmount AS Totale_Vendita
, IFNULL(TotalProductCost, StandardCost*OrderQuantity) AS Costo_Totale -- Imputazione dati mancanti. 
FROM factresellersales AS Sales
INNER JOIN dimproduct AS Prod
ON Prod.ProductKey = Sales.ProductKey
ORDER BY SalesOrderNumber, SalesOrderLineNumber);
/*
SELECT * 
FROM view_vendite;
*/
/*ES.3 Crea una vista denominata Sales che deve restituire la data dellʼordine, il codice documento,
la riga di corpo del documento, la quantità venduta, lʼimporto totale e il profitto.*/
CREATE VIEW View_Rivenditori AS
( SELECT ResellerKey AS ID_Rivenditore
, ResellerName AS Nome_Rivenditore
, BusinessType AS Modello_Business
, City AS Citta
, StateProvinceName AS Nome_Provincia
, EnglishCountryRegionName AS Nome_Regione
FROM dimreseller AS Res
INNER JOIN dimgeography AS Geo
ON RES.GeographyKey = Geo.GeographyKey
ORDER BY ResellerKey);
/*
SELECT *
FROM view_rivenditori;
*/