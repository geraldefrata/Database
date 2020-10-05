USE BaksoLoncatokE
GO

--Nomor 1
SELECT
CustomerName,
[SalesTransactionID] = 'SalesID' + RIGHT(X.SalesTransactionID, 3),
[Total] = SUM(SalesTransactionQTY)
FROM MsCustomer Y
JOIN MsHeaderSalesTransaction X
ON Y.CustomerID = X.CustomerID
JOIN MsDetailSalesTransaction Z
ON X.SalesTransactionID = Z.SalesTransactionID
WHERE CustomerGender LIKE 'Female' AND DATEPART(YEAR, X.SalesTransactionID) > 2015
GROUP BY CustomerName, X.SalesTransactionID

--Nomor 2
SELECT
Staff Gender,
[CustomerCount] = COUNT(Y.CustomerID)
FROM MsStaff A
JOIN MsHeaderSalesTransaction X
ON A.StaffID = X.StaffID
JOIN MsCustomer B
ON B.CustomerID = X.CustomerID
WHERE DATEPART(MONTH, X.SalesTransactionDate) < 6 AND DATEDIFF(YEAR, StaffDOB, GETDATE()) < 30
GROUP BY StaffGender

--Nomor 3
SELECT
A.SupplierID,
[Ingredient_Count] = SUM(PurchaseTransactionQTY),
[Total] = 'Rp.' + CAST(SUM(PurchaseTransactionQTY) * IngredientPrice as VARCHAR (50))
FROM MsSupplier A
JOIN MsHeaderPurchaseTransaction C
ON A.SupplierID = C.SupplierID
JOIN MsDetailPurchaseTransaction D
ON C.PurchaseTransactionID = D.PurchaseTransactionID
JOIN MsIngredient E
ON E.IngredientID = D.IngredientID
WHERE DATEPART(MONTH, C.PurchaseTransactionDate) > 6 AND GROUP BY A.SupplierID, IngredientPrice

--Nomor 4
SELECT StaffGender
[average] = AVG(DATEDIFF(YEAR, StaffDOB, GETDATE())),
[Supp_Count] = COUNT(F.SupplierID)
FROM MsStaff A
JOIN MsHeaderPurchaseTransaction C
ON A.StaffID = C.StaffID
JOIN MsSupplier F
ON F.SupplierID = C.SupplierID
WHERE DATEDIFF(DAY, PurchaseTransactionDate, GETDATE()) >=15 AND DATENAME(MONTH, StaffDOB) IN ('January', 'February', 'April', 'May', 'November', 'December')
GROUP BY StaffGender

--Nomor 5
SELECT DISTINCT SupplierName
[Supplier_Phone] = STUFF(A.SupplierPhoneNumber, 1, 2, '+62')
FROM(
    SELECT MAX(IngredientPrice / 2) AS 'HALF' FROM MsIngredient
)AS HALFPRICE,
MsSupplier A
JOIN MsHeaderPurchaseTranscaction C
ON A.SupplierID = C.SupplierID
JOIN MsDetailPurchaseTransaction D
ON C.PurchaseTransactionID = D.PurchaseTransactionID
JOIN MsIngredient E
ON E.MsIngredient = D.IngredientID
WHERE IngredientPrice <= HALFPRICE.HALF AND SupplierEmail LIKE '%@gmail.com'
GROUP BY SupplierPhoneNumber, SupplierName
ORDER BY SupplierName DESC

--Nomor 6
SELECT DISTINCT CustomerName
[username] = Supplier.username
FROM (
    SELECT AVG(MeatBallPrice) AS AVERAGEPrice FROM MsMeatBall
)AS MsMeatBall,(
    SELECT SUBSTRING(SupplierEmail, 1, CHARINDEX('@', SupplierEmail)-1) AS username FROM MsSupplier
)AS Supplier, MsCustomer X
JOIN MsHeaderSalesTransaction Y
ON Y.CustomerID = X.CustomerID
JOIN MsDetailSalesTransaction Z
ON Z.SalesTransactionID = Y.SalesTransactionID
JOIN MsMeatBall G
ON G.MeatBallID = Z.MeatBallID
WHERE MeatBallPrice > MeatBall.AVERAGEPrice AND CustomerName LIKE '% %'

--Nomor 7
SELECT A.SupplierID,
CASE WHEN CHARINDEX(' ', SupplierName) = 0
THEN SupplierName
ELSE SUBSTRING(SupplierName, 1, CHARINDEX(' ', SupplierName))
END AS [First Name]
FROM (
    SELECT (4/3 * MIN(IngredientPrice)) AS BOTTOM FROM MsIngredient
)AS MINIMUM,
(
    SELECT AVG(IngredientPrice) AS AVERAGEPrice FROM MsIngredient
)AS Maximum, MsSupplier A
JOIN MsHeaderPurchaseTransaction C
ON C.SupplierID = A.SupplierID
JOIN MsDetailPurchaseTransaction D
ON D.PurchaseTransactionID = C.PurchaseTransactionID
JOIN MsIngredient E
ON E.IngredientID = D.IngredientID
WHERE IngredientPrice BETWEEN MINIMUM.BOTTOM AND Maximum.AVERAGEPrice AND DATEPART(MONTH, C.PurchaseTransactionDate) > 5

--Nomor 8
SELECT DISTINCT X.CustomerID,
CustomerName,
[Transaction Monthly] = DATENAME(MONTH, SalesTransactionDate)
FROM(
    SELECT AVG(MeatBallPrice) AS AVERAGEPrice FROM MsMeatBall
)AS MeatBallMin,
(
    SELECT MAX(MeatBallPrice) AS MAXPrice FROM MsMeatBall
)AS MeatBallMax,
MsCustomer X
JOIN MsHeaderSalesTransaction Y
ON X.CustomerID = Y.CustomerID
JOIN MsDetailSalesTransaction Z
ON Z.SalesTransactionID = Y.SalesTransactionID
JOIN MsMeatBall G
ON G.MeatBallID = Z.MeatBallID
WHERE MeatBallPrice < MeatBallMin.AVERAGEPrice OR MeatBallPrice = MeatBallMax.MAXPrice AND DATEDIFF(MONTH, SalesTransactionDate, GETDATE()) > 1

--Nomor 9
CREATE VIEW[ViewMeatBallStatistic] AS
SELECT G.MeatBallID,
[MeatBallCode] = UPPER(SUBSTRING(MeatBallName, 1, 3)) + CAST(SUBSTRING(G.MeatBallID, 3, 5) AS VARCHAR (5)),
[MeatBallCount] = SUM(SalesTransactionQTY),
[Total] = SUM(SalesTransactionQTY) * MeatBallPrice
FROM MsMeatBall G
JOIN MsDetailSalesTransaction Z
ON Z.MeatBallID = G.MeatBallID
JOIN MsRecipe H
ON H.MeatBallID = G.MeatBallID
WHERE MeatBallPrice < 50000 AND IngredientQTY > 50
GROUP BY G.MeatBallID, MeatBallName, MeatBallPrice
SELECT * FROM [ViewMeatBallStatistic]

--Nomor 10
CREATE VIEW [ViewIngredientSpending] AS
SELECT
E.IngredientID,
[Total_Item] = COUNT(Z.SalesTransactionID),
[Total_Spending] = CAST(SUM(SalesTransactionQTY) - (IngredientQTY * (IngredientPrice / 1000)) AS VARCHAR(100)) + 'K'
FROM MsIngredient E
JOIN MsRecipe H
ON H.IngredientID = E.IngredientID
JOIN MsMeatball G
ON G.MeatballID = H.MeatballID
JOIN MsDetailSalesTransaction Z
ON Z.MeatballID = G.MeatballID
JOIN MsHeaderSalesTransaction Y
ON Y.SalesTransactionID = Z.SalesTransactionID
WHERE SalesTransactionQTY < 200 AND DATEPART(DAY, SalesTransactionDate) >= 15
GROUP BY E.IngredientID, IngredientQTY, IngredientPrice

GO
SELECT * FROM [ViewIngredientSpending]