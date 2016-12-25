
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

SELECT * FROM ServTick_ServMech_view;

CREATE OR REPLACE TRIGGER tg_ServTick_ServMech_view
INSTEAD OF 
  DELETE
ON ServTick_ServMech_view
FOR EACH ROW 
DECLARE 
  serviceID Service.Service_ID%TYPE;
BEGIN
        if(:OLD.ServiceName IS NOT NULL) THEN 
          SELECT SERVICE_ID INTO serviceID
          FROM Service 
          WHERE SERVICENAME=:OLD.ServiceName;
      
          --delete from ServiceMachinic
          DELETE FROM ServiceMachine 
          WHERE Service_ID =serviceID;
          
             -- delete from service        
          DELETE FROM Service 
          WHERE Service_ID =serviceID;
          
        END IF;
END;

SELECT * FROM ServTick_ServMech_view;

DELETE  FROM  ServTick_ServMech_view WHERE ServiceName='renovating';
SELECT * FROM ServTick_ServMech_view;

DELETE FROM ServTick_ServMech_view  WHERE ServiceName  ='changing oil';
SELECT * FROM ServTick_ServMech_view;

DELETE FROM ServTick_ServMech_view  WHERE ServiceName  ='cleaning';


DELETE FROM ServTick_ServMech_view  WHERE SerialNumber  ='48773';
SELECT * FROM ServTick_ServMech_view;


  insert into ServiceTicket(ServiceTicket_ID, ServiceTicketNumber, Car_ID, Customer_ID ,DateReceived, DateReturnedToCustomer ) 
  values (7,7978,1,1,to_date('2000/01/01','yyyy/mm/dd'),to_date('2000/01/10','yyyy/mm/dd'));
  insert into service values(4,'renovating', 99);
   insert into service values(3,'changing oil', 1);
insert into ServiceMachine (ServiceMachine_ID, ServiceTicket_ID, Service_ID, Hours)
        values (7,7,4,5);
        delete from  ServTick_ServMech_view where ServiceName='renovating';
        select * from  ServTick_ServMech_view;
        
        select * from ServiceMachine;
        
        
        

create or replace TRIGGER SalesInvoiceTracking
BEFORE 
 INSERT OR UPDATE OR DELETE
ON SalesInvoice 

FOR EACH ROW

BEGIN
  IF (UPDATING ) THEN
     INSERT INTO SalesInvoice_Tracking
     (SalesInvoice_ID,InvoiceNumber,DateOfInvoice,Car_ID,Customer_ID,SalesPerson_ID,ActionType)
     VALUES(:OLD.SalesInvoice_ID,:OLD.InvoiceNumber,:OLD.DateOfInvoice,:OLD.Car_ID,:OLD.Customer_ID,:OLD.SalesPerson_ID,'U' );
   END IF;
END;