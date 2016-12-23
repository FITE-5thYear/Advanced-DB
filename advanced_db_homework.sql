CREATE TABLE SalesInvoice_Tracking
(
SalesInvoice_Tracking_ID int NOT NULL,
SalesInvoice_ID int NOT NULL,
InvoiceNumber int,
DateOfInvoice Date,
Car_ID int,
Customer_ID int,
SalesPerson_ID int,
ActionType VARCHAR(1) CONSTRAINT action_check CHECK (ActionType IN('I','U','D')),
ActionDateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
PRIMARY KEY (SalesInvoice_Tracking_ID)
);

CREATE OR REPLACE TRIGGER SalesInvoiceTracking
BEFORE 
 INSERT OR UPDATE OR DELETE
ON SalesInvoice 

FOR EACH ROW

BEGIN

   IF (INSERTING ) THEN
     INSERT INTO SalesInvoice_Tracking
     (SalesInvoice_ID,InvoiceNumber,DateOfInvoice,Car_ID,Customer_ID,SalesPerson_ID,ActionType)
     VALUES(:NEW.SalesInvoice_ID,:NEW.InvoiceNumber,:NEW.DateOfInvoice,:NEW.Car_ID,:NEW.Customer_ID,:NEW.SalesPerson_ID,'I');
   END IF;
   
  IF (UPDATING ) THEN
     INSERT INTO SalesInvoice_Tracking
     (SalesInvoice_ID,InvoiceNumber,DateOfInvoice,Car_ID,Customer_ID,SalesPerson_ID,ActionType)
     VALUES(:OLD.SalesInvoice_ID,:OLD.InvoiceNumber,:OLD.DateOfInvoice,:OLD.Car_ID,:OLD.Customer_ID,:OLD.SalesPerson_ID,'U' );
   END IF;
   
  IF (DELETING ) THEN
     INSERT INTO SalesInvoice_Tracking
     (SalesInvoice_ID,InvoiceNumber,DateOfInvoice,Car_ID,Customer_ID,SalesPerson_ID,ActionType)
     VALUES(:OLD.SalesInvoice_ID,:OLD.InvoiceNumber,:OLD.DateOfInvoice,:OLD.Car_ID,:OLD.Customer_ID,:OLD.SalesPerson_ID,'D');
   END IF;
END;

SELECT * FROM SalesInvoice;



INSERT INTO SalesInvoice VALUES(10,14,to_date('2000/01/01','yyyy/mm/dd'),1,1,1);

select * from CAR;
SELECT * FROM SalesInvoice_Tracking;

UPDATE SalesInvoice SET CAR_ID=2 WHERE SALESINVOICE_ID=9;

SELECT * FROM SalesInvoice_Tracking;

