-- ES.1 Connettiti al db aziendale o esegui il restore del db
-- ES.2 Esplora la tabelle dei prodotti DimProduct)
SELECT *
FROM dimproduct;
/*ES.3 Interroga la tabella dei prodotti DimProduct) ed esponi in output i campi
 ProductKey, ProductAlternateKey, EnglishProductName, Color, StandardCost, FinishedGoodsFlag. 
 Il result set deve essere parlante per cui assegna un alias se lo ritieni opportuno. */
SELECT
 ProductKey AS Codice_Prodotto
, ProductAlternateKey AS Codice_Alternativo_Prodotto
, EnglishProductName AS Nome_Prodotto
, Color AS Colore
, StandardCost AS Costo
, FinishedGoodsFlag AS Prodotto_Finito
FROM dimproduct;
 -- ES.4 Partendo dalla query scritta nel passaggio precedente, esponi in output i soli prodotti finiti cioè quelli per cui il campo FinishedGoodsFlag è uguale a 1.
 SELECT
 ProductKey AS Codice_Prodotto
, ProductAlternateKey AS Codice_Alternativo_Prodotto
, EnglishProductName AS Nome_Prodotto
, Color AS Colore
, StandardCost AS Costo
, FinishedGoodsFlag AS Prodotto_Finito
FROM dimproduct
WHERE FinishedGoodsFlag = 1;
/*ES.5 Scrivi una nuova query al fine di esporre in output i prodotti il cui codice modello ProductAlternateKey) comincia con FR oppure BK.
Il result set deve contenere il codice prodotto ProductKey), il modello, il nome del prodotto,
il costo standard StandardCost) e il prezzo di listino ListPrice).*/
 SELECT
 ProductKey AS Codice_Prodotto
, ProductAlternateKey AS Codice_Alternativo_Prodotto
, EnglishProductName AS Nome_Prodotto
, Color AS Colore
, StandardCost AS Costo
, FinishedGoodsFlag AS Prodotto_Finito
, ListPrice AS PREZZO
FROM dimproduct
WHERE
ProductAlternateKey LIKE 'FR%' OR ProductAlternateKey LIKE 'BK%';
-- ES.6 Arricchisci il risultato della query scritta nel passaggio precedente del Markup applicato dallʼazienda ListPrice - StandardCost)
SELECT
 ProductKey
, ProductAlternateKey 
, EnglishProductName
, Color 
, StandardCost
, ListPrice
, FinishedGoodsFlag 
, ListPrice - StandardCost AS Markup
FROM dimproduct
ORDER BY Markup DESC;
-- ES.7 Scrivi unʼaltra query al fine di esporre lʼelenco dei prodotti finiti il cui prezzo di listino è compreso tra 1000 e 2000.
SELECT
 ProductKey
, ProductAlternateKey 
, EnglishProductName
, Color 
, StandardCost
, ListPrice
, FinishedGoodsFlag
FROM dimproduct
WHERE FinishedGoodsFlag = 1
AND ListPrice BETWEEN 1000 AND 2000
ORDER BY ListPrice DESC;
-- ES.8 Esplora la tabella degli impiegati aziendali DimEmployee)
SELECT *
FROM dimemployee;
/*ES.9 Esponi, interrogando la tabella degli impiegati aziendali,
lʼelenco dei soli agenti. Gli agenti sono i dipendenti per i quali il campo SalespersonFlag è uguale a 1.*/
SELECT *
FROM dimemployee
WHERE SalesPersonFlag = 1
ORDER BY EmployeeKey;
/*ES.10 Interroga la tabella delle vendite FactResellerSales).
Esponi in output lʼelenco delle transazioni registrate a partire dal 1 gennaio 2020 dei soli codici prodotto:
597, 598, 477, 214. Calcola per ciascuna transazione il profitto SalesAmount - TotalProductCost).*/
SELECT *
, SalesOrderNumber
, OrderDate
, ProductKey
, SalesTerritoryKey
, OrderQuantity
, UnitPrice
, TotalProductCost
, SalesAmount
, SalesAmount - TotalProductCost AS Murkap
FROM factinternetsales
WHERE OrderDate > "2020-01-01"
AND ProductKey IN (597,598,477,214);


