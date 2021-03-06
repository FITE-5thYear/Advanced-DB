
--create tables:

CREATE TABLE Salesperson
(
Salesperson_ID int NOT NULL,
LastName varchar(50),
FirstName varchar(50),
PRIMARY KEY (Salesperson_ID)
)

CREATE TABLE Customer
(
Customer_ID int NOT NULL,
LastName varchar(50),
FirstName varchar(50),
PhoneNumber int,
Address varchar(200),
City varchar(200),
Province varchar(200),
Country varchar(200),
PostalCard int,
PRIMARY KEY (Customer_ID)
)

CREATE TABLE Car
(
Car_ID int NOT NULL,
SerialNumber int,
Make varchar(50),
ModelCar varchar(50),
Colour varchar(50),
YearOfProduct varchar(200),
CarForSale NUMBER(1,0),
PRIMARY KEY (Car_ID)
)


CREATE TABLE Service
(
Service_ID int NOT NULL,
ServiceName varchar(50),
HourlyRate int,
PRIMARY KEY (Service_ID)
)


CREATE TABLE Machine
(
Machine_ID int NOT NULL,
LastName  varchar(50),
FirstName varchar(5),
PRIMARY KEY (Machine_ID)
)


CREATE TABLE Part
(
Part_ID int NOT NULL,
PartNumber int,
Description varchar(200),
PurchasePrice int,
RetailPrice int,
PRIMARY KEY (Part_ID)
)


CREATE TABLE SalesInvoice
(
SalesInvoice_ID int NOT NULL,
InvoiceNumber int,
DateOfInvoice Date,
Car_ID int,
Customer_ID int,
SalesPerson_ID int,
PRIMARY KEY (SalesInvoice_ID),
FOREIGN KEY (Car_ID) REFERENCES Car(Car_ID),
FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
FOREIGN KEY (SalesPerson_ID) REFERENCES SalesPerson(SalesPerson_ID)
)

CREATE TABLE ServiceTicket
(
ServiceTicket_ID int NOT NULL,
ServiceTicketNumber int,
Car_ID int,
Customer_ID int,
DateReceived Date,
Note varchar(200),
DateReturnedToCustomer Date
);

ALTER TABLE ServiceTicket
ADD CONSTRAINT ServiceTicket_fk
FOREIGN KEY (Car_ID) REFERENCES Car(Car_ID);

Alter Table ServiceTicket 
ADD CONSTRAINT ServiceTicket_fk2 
FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID);


Alter Table ServiceTicket 
ADD CONSTRAINT ServiceTicket_pk 
PRIMARY KEY (ServiceTicket_ID);

CREATE TABLE PartUsed
(
PartUsed_ID int NOT NULL,
ServiceTicket_ID int,
Part_ID int,
NumberUsed int,
Price int
);


ALTER TABLE PartUsed
ADD CONSTRAINT PartUsed_fk
FOREIGN KEY (ServiceTicket_ID) REFERENCES ServiceTicket(ServiceTicket_ID);

Alter TABLE PartUsed 
ADD CONSTRAINT PartUsed_fk2 
FOREIGN KEY (Part_ID) REFERENCES Part(Part_ID);

Alter Table PartUsed 
ADD CONSTRAINT PartUsed_pk 
PRIMARY KEY (PartUsed_ID);

CREATE TABLE ServiceMachine
(
ServiceMachine_ID int NOT NULL,
ServiceTicket_ID int,
Service_ID int,
Machine_ID int,
Hours int,
Comments varchar(200),
Rate int
);

ALTER TABLE ServiceMachine
ADD CONSTRAINT ServiceMachine_fk
FOREIGN KEY (ServiceTicket_ID) REFERENCES ServiceTicket(ServiceTicket_ID);

Alter TABLE ServiceMachine 
ADD CONSTRAINT ServiceMachine_fk2 
FOREIGN KEY (Service_ID) REFERENCES Service(Service_ID);

Alter TABLE ServiceMachine 
ADD CONSTRAINT ServiceMachine_fk3
FOREIGN KEY (Machine_ID) REFERENCES Machine(Machine_ID);

Alter Table ServiceMachine 
ADD CONSTRAINT ServiceMachine_pk 
PRIMARY KEY (ServiceMachine_ID);
