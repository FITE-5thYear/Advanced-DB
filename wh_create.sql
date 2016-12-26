---- Dimensions:
----    Time:
CREATE TABLE Dim_Time (
  Time_Id      DATE        PRIMARY KEY NOT NULL,
  Day_Name     VARCHAR(10)             NOT NULL,
  Month_Name   VARCHAR(10)             NOT NULL,
  Quarter_Name VARCHAR(2)              NOT NULL,
  Year         NUMBER(4)               NOT NULL);
  
----     Service:
CREATE TABLE Dim_Service (
  Service_Id   NUMBER(5)   NOT NULL PRIMARY KEY,
  Name         VARCHAR(25) NOT NULL,
  Hourly_Rate  Number(5)   NOT NULL
  );
  
----     Car:
CREATE TABLE Dim_Car (
  Car_Id       NUMBER(5)  NOT NULL PRIMARY KEY,
  Serial_No    NUMBER(5)  NOT NULL,
  Maker        VARCHAR(10) NOT NULL,
  Model        VARCHAR(10) NOT NULL,
  Color        VARCHAR(10) NOT NULL,
  Year         NUMBER(4)   NOT NULL,
  CarForSale   NUMBER(1,0)   NOT NULL
);

----     Mechanic:
CREATE TABLE Dim_Mechanic (
  Mechanic_Id  NUMBER(5)   NOT NULL PRIMARY KEY,
  First_Name   VARCHAR(10) NOT NULL,
  Last_Name    VARCHAR(10) NOT NULL
);

---- Fact Table:
CREATE TABLE Fact_Services (
  Id                   NUMBER(5) NOT NULL PRIMARY KEY,
  ---- Measures:
  Total_Hours          NUMBER(5) NOT NULL, -- total hours spent on the service
  Total_Cost           NUMBER(5) NOT NULL, -- total cost of the service (parts + mechanics)
  Total_Mechanics_Cost NUMBER(5) NOT NULL, -- total cost of mechanics spent on this service
  Total_Parts_Cost     NUMBER(5) NOT NULL, -- total cost of parts spent on this service
  
  ---- Foreigns:
  Time_Id      DATE      NOT NULL,
  Service_Id   NUMBER(5) NOT NULL,
  Car_Id       NUMBER(5) NOT NULL,
  CONSTRAINT fk_fact_time     FOREIGN KEY (Time_Id)     REFERENCES Dim_Time(Time_Id),
  CONSTRAINT fk_fact_service  FOREIGN KEY (Service_id)  REFERENCES Dim_Service(Service_Id),
  CONSTRAINT fk_fact_car      FOREIGN KEY (Car_Id)      REFERENCES Dim_Car(Car_Id)
);

CREATE TABLE Fact_Works (
  Id            NUMBER(5) NOT NULL PRIMARY KEY,
  
  -- Measures:
  Total_Hours   NUMBER(5) NOT NULL, -- total hours spent by the mechanic on the service
  
  -- Foreigns:
  Service_Id    NUMBER(5) NOT NULL,
  Mechanic_Id   NUMBER(5) NOT NULL,
  
  CONSTRAINT fk_fact_works_mechanic   FOREIGN KEY (Mechanic_Id) REFERENCES Dim_Mechanic(Mechanic_Id),
  CONSTRAINT fk_fact_works_service    FOREIGN KEY (Service_Id)  REFERENCES Dim_Service(Service_Id)  
);
