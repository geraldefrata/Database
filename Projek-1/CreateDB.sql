CREATE DATABASE BaksoLoncatokE
GO
USE BaksoLoncatokE
GO

CREATE TABLE MsSupplier (
    SupplierID CHAR (5) PRIMARY KEY CONSTRAINT Check_SupplierID CHECK (SupplierID LIKE 'SP[0-9][0-9][0-9]'),
    SupplierName VARCHAR (50) NOT NULL CHECK (LEN(SupplierName) > 5),
    SupplierPhoneNumber VARCHAR (50) NOT NULL CHECK (SupplierPhoneNumber LIKE '08%'),
    SupplierAddress VARCHAR (100) NOT NULL CHECK (SupplierAddress LIKE '%Street'),
    SupplierGender VARCHAR(8) NOT NULL CHECK (SupplierGender IN ('Male', 'Female')),
    SupplierDOB DATE NOT NULL CHECK (DATEDIFF(YEAR, SupplierDOB, GETDATE) > 17),
    SupplierEmail VARCHAR (100) NOT NULL CHECK (SupplierEmail LIKE '%@gmail.com' OR SupplierEmail LIKE '%@yahoo.com'),
)

CREATE TABLE MsCustomer (
    CustomerID CHAR (5) PRIMARY KEY CONSTRAINT Check_CustomerID CHECK (CustomerID LIKE 'CT[0-9][0-9][0-9]'),
    CustomerName VARCHAR (50) NOT NULL CHECK (LEN(CustomerName) > 5),
    CustomerPhoneNumber VARCHAR (50) NOT NULL CHECK (CustomerPhoneNumber LIKE '08%'),
    CustomerAddress VARCHAR (100) NOT NULL CHECK (CustomerAddress LIKE '%Street'),
    CustomerGender VARCHAR(8) NOT NULL CHECK (CustomerGender IN ('Male', 'Female')),
    CustomerDOB DATE NOT NULL CHECK (DATEDIFF(YEAR, CustomerDOB, GETDATE) > 17),
    CustomerEmail VARCHAR (100) NOT NULL CHECK (CustomerEmail LIKE '%@gmail.com' OR CustomerEmail LIKE '%@yahoo.com'),
)

CREATE TABLE MsStaff (
    StaffID CHAR (5) PRIMARY KEY CONSTRAINT Check_StaffID CHECK (StaffID LIKE 'SF[0-9][0-9][0-9]'),
    StaffName VARCHAR (50) NOT NULL CHECK (LEN(StaffName) > 5),
    StaffPhoneNumber VARCHAR (50) NOT NULL CHECK (StaffPhoneNumber LIKE '08%'),
    StaffAddress VARCHAR (100) NOT NULL CHECK (StaffAddress LIKE '%Street'),
    StaffGender VARCHAR(8) NOT NULL CHECK (StaffGender IN ('Male', 'Female')),
    StaffDOB DATE NOT NULL CHECK (DATEDIFF(YEAR, StaffDOB, GETDATE) > 17),
    StaffEmail VARCHAR (100) NOT NULL CHECK (StaffEmail LIKE '%@gmail.com' OR StaffEmail LIKE '%@yahoo.com'),
)

CREATE TABLE MsMeatBall(
    MeatBallID CHAR (5) PRIMARY KEY CONSTRAINT check_MeatBallID CHECK (MeatBallID LIKE 'MB[0-9][0-9][0-9]'),
    MeatBallName VARCHAR (50) NOT NULL,
    MeatBallPrice INT NOT NULL CHECK (IngredientPrice BETWEEN 5000 AND 500000) 
)

CREATE TABLE MsIngredient(
    IngredientID CHAR (5) PRIMARY KEY CONSTRAINT check_IngredientID CHECK (IngredientID LIKE 'IG[0-9][0-9][0-9]'),
    IngredientName VARCHAR (50) NOT NULL,
    IngredientPrice INT NOT NULL CHECK (IngredientPrice BETWEEN 5000 AND 500000) 
)

CREATE TABLE MsRecipe(
    MeatBallID CHAR (5) PRIMARY KEY CONSTRAINT check_MeatBallID CHECK (MeatBallID LIKE 'MB[0-9][0-9][0-9]'),
    IngredientID CHAR (5) PRIMARY KEY CONSTRAINT check_IngredientID CHECK (IngredientID LIKE 'IG[0-9][0-9][0-9]'),
    IngredientQTY INT NOT NULL CHECK (IngredientQTY > 0),
    PRIMARY KEY (MeatBallID, IngredientID),
    CONSTRAINT MeatBallID_Recipe_FK FOREIGN KEY (MeatBallID) REFERENCES MsMeatBall(MeatBallID) on delete cascade on update cascade,
    CONSTRAINT IngredientID_Recipe_FK FOREIGN KEY (IngredientID) REFERENCES MsIngredient(IngredientID) on delete cascade on update cascade,    
)

CREATE TABLE MsHeaderPurchaseTransaction(
    PurchaseTransactionID CHAR (5) PRIMARY KEY CONSTRAINT check_PurchaseTransactionID CHECK (PurchaseTransactionID LIKE 'PT[0-9][0-9][0-9]'),
    StaffID CHAR (5) PRIMARY KEY CONSTRAINT check_StaffID CHECK (StaffID LIKE 'SF[0-9][0-9][0-9]'),
    SupplierID CHAR (5) PRIMARY KEY CONSTRAINT check_SupplierID CHECK (SupplierID LIKE 'SP[0-9][0-9][0-9]'),
    PurchaseTransictaonDate DATE NOT NULL,
    CONSTRAINT StaffID_PurchaseTransaction_FK FOREIGN KEY (StaffID) REFERENCES MsStaff(StaffID) on delete cascade on update cascade,
    CONSTRAINT SupplierID_PurchaseTransaction_FK FOREIGN KEY (SupplierID) REFERENCES MsSupplier(SupplierID) on delete cascade on update cascade,    
)

CREATE TABLE MsDetailPurchaseTransaction(
    PurchaseTransactionID CHAR (5) PRIMARY KEY CONSTRAINT check_PurchaseTransactionID CHECK (PurchaseTransactionID LIKE 'PT[0-9][0-9][0-9]'),
    IngredientID CHAR (5) PRIMARY KEY CONSTRAINT check_IngredientID CHECK (IngredientID LIKE 'IG[0-9][0-9][0-9]'),
    PurchaseTransactionQTY INT NOT NULL CHECK (PurchaseTransactionQTY > 0),
    PRIMARY KEY (PurchaseTransactionID, IngredientID),
    CONSTRAINT PurchaseTransactionID_DetailPurchaseTransaction_FK FOREIGN KEY (PurchaseTransactionID) REFERENCES MsHeaderPurchaseTransaction(PurchaseTransactionID) on delete cascade on update cascade,
    CONSTRAINT IngredientID_DetailPurchaseTransaction_FK FOREIGN KEY (IngredientID) REFERENCES MsIngredient(IngredientID) on delete cascade on update cascade,    
)

CREATE TABLE MsHeaderSalesTransaction(
    SalesTransactionID CHAR (5) PRIMARY KEY CONSTRAINT check_SalesTransactionID CHECK (SalesTransactionID LIKE 'ST[0-9][0-9][0-9]'),
    StaffID CHAR (5) PRIMARY KEY CONSTRAINT check_StaffID CHECK (StaffID LIKE 'SF[0-9][0-9][0-9]'),
    CustomerID CHAR (5) PRIMARY KEY CONSTRAINT check_CustomerID CHECK (CustomerID LIKE 'CT[0-9][0-9][0-9]'),
    SalesTransictaonDate DATE NOT NULL,
    CONSTRAINT StaffID_HeaderSalesTransaction_FK FOREIGN KEY (StaffID) REFERENCES MsStaff(StaffID) on delete cascade on update cascade,
    CONSTRAINT CustomerID_HeaderSalesTransaction_FK FOREIGN KEY (CustomerID) REFERENCES MsCustomer(CustomerID) on delete cascade on update cascade,    
)

CREATE TABLE MsDetailSalesTransaction(
    SalesTransactionID CHAR (5) PRIMARY KEY CONSTRAINT check_SalesTransactionID CHECK (SalesTransactionID LIKE 'ST[0-9][0-9][0-9]'),
    MeatBallID CHAR (5) PRIMARY KEY CONSTRAINT check_MeatBallID CHECK (MeatBallID LIKE 'MB[0-9][0-9][0-9]'),
    SalesTransactionQTY INT NOT NULL CHECK (SalesTransactionQTY > 0),
    PRIMARY KEY (SalesTransactionID, MeatBallID),
    CONSTRAINT SalesTransactionID_DetailSalesTransaction_FK FOREIGN KEY (SalesTransactionID) REFERENCES MsHeaderSalesTransaction(SalesTransactionID) on delete cascade on update cascade,
    CONSTRAINT MeatBallID_DetailSalesTransaction_FK FOREIGN KEY (MeatBallID) REFERENCES MsMeatBall(MeatBallID) on delete cascade on update cascade,    
)