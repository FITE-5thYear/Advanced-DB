---- Partitioning by date
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
) 
  PARTITION BY RANGE (time_id) (
    PARTITION q1_2015 VALUES LESS THAN (TO_DATE('01/04/2015','DD/MM/YYYY')),
    PARTITION q2_2015 VALUES LESS THAN (TO_DATE('01/07/2015','DD/MM/YYYY')),
    PARTITION q3_2015 VALUES LESS THAN (TO_DATE('01/10/2015','DD/MM/YYYY')),
    PARTITION q4_2015 VALUES LESS THAN (TO_DATE('01/01/2016','DD/MM/YYYY')),
    PARTITION q1_2016 VALUES LESS THAN (TO_DATE('01/04/2016','DD/MM/YYYY')),
    PARTITION q2_2016 VALUES LESS THAN (TO_DATE('01/07/2016','DD/MM/YYYY')),
    PARTITION q3_2016 VALUES LESS THAN (TO_DATE('01/10/2016','DD/MM/YYYY')),
    PARTITION q4_2016 VALUES LESS THAN (TO_DATE('01/01/2017','DD/MM/YYYY'))
);
