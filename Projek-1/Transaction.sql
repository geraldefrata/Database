USE BaksoLoncatokE
GO

CREATE PROC [Insert_Header_Purchase_Transaction]
@PurchaseTransactionId CHAR (5),
@StaffID CHAR (5),
@SupplierID CHAR (5),
@TransactionDate VARCHAR (50)
AS
BEGIN
	IF(LEN(@PurchaseTransactionID) > 0)
	BEGIN
		IF(NOT EXISTS(SELECT * FROM MsHeaderPurchaseTransaction WHERE PurchaseTransactionID LIKE @PurchaseTransactionID))
		BEGIN
			IF(LEN(@StaffID) > 0)
			BEGIN
				IF(EXISTS(SELECT * FROM MsStaff WHERE StaffID LIKE @StaffID))
				BEGIN
					IF(LEN(@SupplierID) > 0)
					BEGIN
						IF(EXISTS(SELECT * FROM MsSupplier WHERE SupplierID LIKE @SupplierID))
						BEGIN
							IF(LEN(@TransactionDate) > 0)
							BEGIN
								IF(ISDATE(@TransactionDate) = 1)
								BEGIN
									INSERT INTO MsHeaderPurchaseTransaction
										(PurchaseTransactionID,StaffID,SupplierID,PurchaseTransactionDate)
									VALUES
										(@PurchaseTransactionID,@StaffID,@SupplierID,@TransactionDate)
									PRINT 'Successfullly Insert Header Purchase Transaction Data';
								END
								ELSE
								BEGIN
									PRINT  'Error... Date Format wrong [YYYY-MM-DD]';
								END
							END
							ELSE
							BEGIN
								PRINT 'Error... Transaction Date is empty';
							END
						END
						ELSE
						BEGIN
							PRINT 'Error... Supplier Not Found';
						END
					END
					ELSE
					BEGIN
						PRINT 'Error... Supplier ID is empty';
					END
				END
				ELSE
				BEGIN
					PRINT 'Error... Staff Not Found';
				END
			END
			ELSE
			BEGIN
				PRINT 'Error... Staff ID is empty ';
			END
		END
		ELSE
		BEGIN
			PRINT 'Error... Purchase ID is being Duplicated';
		END
	END
	ELSE
	BEGIN
		PRINT 'Error... Purchase ID is empty';
	END
END

Insert_Header_Purchase_Transaction'PT016','SF001','SP001','2020-01-20'

SELECT * FROM MsHeaderPurchaseTransaction

--Insert Detail Purchase Transaction
CREATE PROC [Insert_Detail_Purchase_Transaction]
@PurchaseTransactionID CHAR (5),
@IngredienID CHAR (5),
@Quantity VARCHAR (10)
AS
BEGIN
	IF(LEN(@PurchaseTransactionID) > 0)
	BEGIN
		IF(EXISTS(SELECT * FROM MsHeaderPurchaseTransaction WHERE PurchaseTransactionID LIKE @PurchaseTransactionID))
		BEGIN
			IF(LEN(@IngredienID) > 0)
			BEGIN
				IF(EXISTS(SELECT * FROM MsIngredient WHERE IngredientID LIKE @IngredienID))
				BEGIN
					IF(LEN(@Quantity) > 0)
					BEGIN
						IF(CAST(@Quantity AS INT) > 0)
						BEGIN
							INSERT INTO MsDetailPurchaseTransaction
							(PurchaseTransactionID,IngredientID,PurchaseTransactionQTY)
						VALUES
							(@PurchaseTransactionID,@IngredientID,@Quantity)
							PRINT 'Successfully Insert Detail Transaction Data'
						END
						ELSE
						BEGIN
							PRINT 'Error... Quantity must be more than 0';
						END
					END
					ELSE
					BEGIN
						PRINT 'Error... Quantity is empty';
					END
				END
				ELSE
				BEGIN
					PRINT 'Error... Ingridient Not Found';
				END
			END
			ELSE
			BEGIN
				PRINT 'Error... IngridientID is empty';
			END
		END
		ELSE
		BEGIN
			PRINT 'Error... PurchaseID not found';
		END
	END
	ELSE
	BEGIN
		PRINT 'Error... PurchaseID is empty';
	END
END

Insert_Detail_Purchase_Transaction'PT016','IG001','2'

SELECT * FROM MsDetailPurchaseTransaction

--Insert Header Sales Transaction
CREATE PROC [Insert_Header_Sales_Transaction]
@SalesTransactionID CHAR (5),
@CustomerID CHAR (5),
@StaffID CHAR (5),
@TransactionDate VARCHAR (50)
AS
BEGIN
	IF(LEN(@SalesTransactionID) > 0)
	BEGIN
		IF(NOT EXISTS(SELECT * FROM MsHeaderSalesTransaction WHERE SalesTransactionID LIKE @SalesTransactionID))
		BEGIN
			IF(LEN(@CustomerID) > 0)
			BEGIN
				IF(EXISTS(SELECT * FROM MsCustomer WHERE CustomerID LIKE @CustomerID))
				BEGIN
					IF(LEN(@StaffID) > 0)
					BEGIN
						IF(EXISTS(SELECT * FROM MsStaff WHERE StaffID LIKE @StaffID))
						BEGIN
							IF(LEN(@TransactionDate) > 0)
							BEGIN
								IF(ISDATE(@TransactionDate) = 1)
								BEGIN
									INSERT INTO MsHeaderSalesTransaction
										(SalesTransactionID,CustomerID,StaffID,SalesTransactionDate)
									VALUES
										(@SalesTransactionID,@CustomerID,@StaffID,@TransactionDate)
									PRINT 'Successfullly Insert Header Sales Transaction Data';
								END
								ELSE
								BEGIN
									PRINT  'Error... Date Format wrong [YYYY-MM-DD]';
								END
							END
							ELSE
							BEGIN
								PRINT 'Error... Transaction Date is empty';
							END
						END
						ELSE
						BEGIN
							PRINT 'Error... Staff Not Found';
						END
					END
					ELSE
					BEGIN
						PRINT 'Error... StaffID is empty ';
					END
				END
				ELSE
				BEGIN
					PRINT 'Error... Customer Not Found';
				END

			END
			ELSE
			BEGIN
				PRINT 'Error... CustomerID is empty';
			END
		END
		ELSE
		BEGIN
			PRINT 'Error... SalesID is being Duplicated';
		END
	END
	ELSE
	BEGIN
		PRINT 'Error... SalesID is empty';
	END
END

Insert_Header_Sales_Transaction'ST016','CT010','SF001','2020-01-20'

SELECT * FROM MsHeaderSalesTransaction

--Insert Detail Sales Transaction
CREATE PROC [Insert_Detail_Sales_Transaction]
@SalesTransactionID CHAR (5),
@MeatballID CHAR (5),
@Quantity VARCHAR (10)
AS
BEGIN
	IF(LEN(@SalesTransactionID) > 0)
	BEGIN
		IF(EXISTS(SELECT * FROM MsHeaderSalesTransaction WHERE SalesTransactionID LIKE @SalesTransactionID))
		BEGIN
			IF(LEN(@MeatballID) > 0)
			BEGIN
				IF(EXISTS(SELECT * FROM MsMeatball WHERE MeatballID LIKE @MeatballID))
				BEGIN
					IF(LEN(@Quantity) > 0)
					BEGIN
						IF(CAST(@Quantity AS INT) > 0)
						BEGIN
							INSERT INTO MsDetailSalesTransaction
								(SalesTransactionID,MeatballID,SalesTransactionQTY)
							VALUES
								(@SalesTransactionID,@MeatballID,@Quantity)
							PRINT 'Successfully Insert Detail Transaction Data'
						END
						ELSE
						BEGIN
							PRINT 'Error... Quantity must be more than 0';
						END
					END
					ELSE
					BEGIN
						PRINT 'Error... Quantity is empty';
					END
				END
				ELSE
				BEGIN
					PRINT 'Error... Meatball Not Found';
				END
			END
			ELSE
			BEGIN
				PRINT 'Error... MeatballID is empty';
			END
		END
		ELSE
		BEGIN
			PRINT 'Error... SalesID not found';
		END
	END
	ELSE
	BEGIN
		PRINT 'Error... SalesID is empty';
	END
END

Insert_Detail_Sales_Transaction'ST016','MB003','3'

SELECT * FROM MsDetailSalesTransaction