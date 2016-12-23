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

/////////////////////////////////////


CREATE TABLE TablesTracking(
TableName VARCHAR(50),
Action VARCHAR(50),
ActionDate Date DEFAULT SYSDATE
);

CREATE OR REPLACE TRIGGER Create_Tables_Tracking
  AFTER DROP   ON SCHEMA    
BEGIN
  IF (SYS.DICTIONARY_OBJ_TYPE = 'TABLE' ) THEN
     INSERT INTO  TablesTracking(TableName, Action) VALUES(SYS.dictionary_obj_name,'CREATE Table');
  END IF;
END;

CREATE OR REPLACE TRIGGER Drop_Tables_Tracking
  AFTER CREATE   ON SCHEMA    
BEGIN
  IF (SYS.DICTIONARY_OBJ_TYPE = 'TABLE' ) THEN
     INSERT INTO  TablesTracking(TableName, Action) VALUES(SYS.dictionary_obj_name,'DROP Table'  );
  END IF;
END;

CREATE TABLE Visitor (
  Visitor_ID INT NOT NULL,
  FirstName VARCHAR(50),
  LastName VARCHAR(50)
);

DROP TABLE Visitor;
DROP TABLE TOTO;
SELECT * FROM TablesTracking;


SELECT * 
  FROM Car ca  
  JOIN ServiceTicket st
    ON ca.Car_ID = st.Car_ID
  JOIN ServiceMachine sm
    ON sm.ServiceTicket_ID = st.ServiceTicket_ID
  JOIN Service se
    ON se.Service_ID = sm.Service_ID
  WHERE ca.Car_ID=1 AND se.Service_ID=1;
  select * from Service
  select * from ServiceMachine
  select * from ServiceTicket

insert into ServiceTicket(ServiceTicket_ID,ServiceTicketNumber ,Car_ID ,Customer_ID ,DateReceived ,DateReturnedToCustomer ) 
  values (3,3,1,1,to_date('2000/01/01','yyyy/mm/dd'),to_date('2000/01/10','yyyy/mm/dd'));

insert into service values(1,'cleaning',2);

insert into ServiceMachine (ServiceMachine_ID ,ServiceTicket_ID ,Service_ID )
        values (1,1,1);
insert into ServiceMachine (ServiceMachine_ID ,ServiceTicket_ID ,Service_ID )
        values (2,1,1);  
insert into ServiceMachine (ServiceMachine_ID ,ServiceTicket_ID ,Service_ID )
        values (3,3,1);     
        
        
SELECT get_car_service_hours(1,1) SUM_OF_HOURS FROM dual;

insert into service values(2,'changing color',7);

insert into service values(3,'changing oil',4);

//////////////////////////////////////////////////////////

CREATE OR REPLACE FUNCTION get_car_service_hours( carID IN Car.Car_ID%TYPE, serviceID IN Service.Service_ID%TYPE)
  RETURN INTEGER
IS
  sum_of_hours INTEGER; 
BEGIN

  SELECT SUM(se.HourlyRate) INTO sum_of_hours
  FROM Car ca  
  JOIN ServiceTicket st
    ON ca.Car_ID = st.Car_ID
  JOIN ServiceMachine sm
    ON sm.ServiceTicket_ID = st.ServiceTicket_ID
  JOIN Service se
    ON se.Service_ID = sm.Service_ID
  WHERE ca.Car_ID=carID AND se.Service_ID=serviceID;
  
  RETURN sum_of_hours;
END;

SELECT get_car_service_hours(1,1) SUM_OF_HOURS FROM dual;