--first

CREATE OR REPLACE TRIGGER price_during_guarantee
BEFORE 
  INSERT OR
  UPDATE OF Price
ON PartUsed
FOR EACH ROW

DECLARE 
  sale_date SalesInvoice.DateOfInvoice%TYPE;
  retail_price Part.RetailPrice%TYPE;
  
BEGIN
  SELECT  si.DateOfInvoice INTO sale_date
  FROM PartUsed pu
  FULL JOIN ServiceTicket st
    ON pu.ServiceTicket_ID = st.ServiceTicket_ID
  INNER JOIN  Car ca
    ON ca.Car_ID = st.CAR_ID
  INNER JOIN SalesInvoice si
    ON si.CAR_ID = ca.CAR_ID
  WHERE  st.ServiceTicket_ID = :NEW.ServiceTicket_ID;
  
  
  IF(sale_date >= trunc(CURRENT_DATE -365) ) THEN
    SELECT pa.RetailPrice INTO retail_price
    FROM PartUsed pu
    FULL JOIN Part pa
      ON pu.Part_ID = pa.Part_ID
    WHERE pa.Part_ID = :NEW.Part_ID;
    :NEW.Price :=retail_price;
  END IF;

END;


--------------------------------------
--second


create or replace TRIGGER block_updating_exist_value
BEFORE 
  UPDATE OF DateReturnedToCustomer
ON ServiceTicket
FOR EACH ROW
DECLARE
   PRAGMA AUTONOMOUS_TRANSACTION;
   date_retuned ServiceTicket.DateReturnedToCustomer%TYPE;
BEGIN
   SELECT DateReturnedToCustomer  INTO date_retuned
   FROM ServiceTicket 
   WHERE ServiceTicket_ID = :NEW.ServiceTicket_ID;  
  
   IF (date_retuned  IS NOT NULL ) THEN
      RAISE_APPLICATION_ERROR(-20101, 'A value for DateReturnedToCustomer is already exist, you can not update it!');
   END IF;
END;


------------
SELECT DateReturnedToCustomer
FROM ServiceTicket
WHERE ServiceTicket_ID =2;

UPDATE ServiceTicket
SET DATERETURNEDTOCUSTOMER =to_date('2000/01/01','yyyy/mm/dd')
WHERE SERVICETICKET_ID=2;


UPDATE ServiceTicket
SET DATERETURNEDTOCUSTOMER =to_date('1999/10/10','yyyy/mm/dd')
WHERE SERVICETICKET_ID=2;


--------------------------------------
--third





CREATE VIEW ServTick_ServMech_view
AS
SELECT  ca.SerialNumber , st.ServiceTicketNumber, st.DateReceived, se.ServiceName 
FROM Car ca
FULL JOIN  ServiceTicket st
ON ca.Car_ID=st.Car_ID
FULL JOIN  ServiceMachine sm
ON st.ServiceTicket_ID  = sm.ServiceTicket_ID
FULL JOIN Service se
ON se.Service_ID=sm.Service_ID;

CREATE OR REPLACE TRIGGER tg_ServTick_ServMech_view
INSTEAD OF 
  DELETE
ON ServTick_ServMech_view
DECLARE 
  serviceID Service.Service_ID%TYPE;
  count_service_machanic INTEGER;
BEGIN
        if(:OLD.ServiceName IS NOT NULL) THEN 
          SELECT SERVICE_ID INTO serviceID
          FROM Service 
          WHERE SERVICENAME=:OLD.ServiceName;
      
          --delete from ServiceMachinic
          DELETE FROM ServiceMachine 
          WHERE Service_ID =serviceID;
          
        END IF;
        SELECT count(*) into count_service_machanic from ServiceMachine where Service_ID =serviceID ;
        IF (count_service_machanic = 0) THEN
         DELETE FROM SERVICE 
          WHERE SERVICENAME =:OLD.SERVICENAME;
        END IF;
         
          
END;
------------
SELECT * FROM ServTick_ServMech_view;

DELETE  FROM  ServTick_ServMech_view WHERE ServiceName='renovating';
SELECT * FROM ServTick_ServMech_view;

DELETE FROM ServTick_ServMech_view  WHERE ServiceName  ='changing oil';
SELECT * FROM ServTick_ServMech_view;



--------------------------------------
--fourth

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


CREATE SEQUENCE tracking_seq START WITH 1;

CREATE OR REPLACE TRIGGER tracking_tg 
BEFORE INSERT ON SalesInvoice_Tracking 
FOR EACH ROW

BEGIN
  SELECT tracking_seq.NEXTVAL
  INTO   :new.SalesInvoice_Tracking_ID
  FROM   dual;
END;



create or replace TRIGGER SalesInvoiceTracking
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
------------
INSERT INTO SalesInvoice VALUES(10,14,to_date('2000/01/01','yyyy/mm/dd'),1,1,1);

SELECT * FROM SalesInvoice_Tracking;

UPDATE SalesInvoice SET CAR_ID=2 WHERE SalesInvoice _ID=9;
SELECT * FROM SalesInvoice_Tracking;
--------------------------------------
--fifth

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

------------
CREATE TABLE Visitor (
  Visitor_ID INT NOT NULL,
  FirstName VARCHAR(50),
  LastName VARCHAR(50)
);

DROP TABLE Visitor;

SELECT * FROM TablesTracking;


--------------------------------------
--sixth

CREATE OR REPLACE FUNCTION get_car_service_hours(carID IN Car.Car_ID%TYPE, serviceID IN Service.Service_ID%TYPE)
  RETURN INTEGER
IS
  sum_of_hours FLOAT; 
BEGIN

  SELECT SUM(sm.Hours ) INTO sum_of_hours  
  FROM ServiceTicket st
  JOIN ServiceMachine sm
    ON sm.ServiceTicket_ID = st.ServiceTicket_ID
  WHERE st.Car_ID=carID AND sm.Service_ID=serviceID;
  
  RETURN sum_of_hours;
END;


------------
insert into ServiceTicket(ServiceTicket_ID, ServiceTicketNumber, Car_ID, Customer_ID ,DateReceived, DateReturnedToCustomer ) 
  values (3,3,1,1,to_date('2000/01/01','yyyy/mm/dd'),to_date('2000/01/10','yyyy/mm/dd'));

insert into service values(1,'cleaning',2);

insert into ServiceMachine (ServiceMachine_ID, ServiceTicket_ID, Service_ID, Hours)
        values (1,1,1,5);
insert into ServiceMachine (ServiceMachine_ID, ServiceTicket_ID, Service_ID, Hours)
        values (2,1,1,8);  
insert into ServiceMachine (ServiceMachine_ID, ServiceTicket_ID, Service_ID, Hours)
        values (3,3,1,9);     
        
        
SELECT get_car_service_hours(1,1) SUM_OF_HOURS FROM dual;