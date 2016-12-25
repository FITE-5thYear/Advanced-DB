---- Filling procedures:
----     Dim_Time:
CREATE OR REPLACE PROCEDURE FILL_DIM_TIME
IS
  date_ Date := TO_DATE('2015/01/01','YYYY/MM/DD');
  i    Int  := 0;
  
 BEGIN
  FOR i IN 0..730 LOOP
  
      INSERT INTO Dim_Time VALUES(date_ + i,
                                  TO_CHAR(date_ + i, 'DAY'),
                                  TO_CHAR(date_ + i, 'MONTH'),
                                  TO_CHAR(date_ + i, 'Q'),
                                  TO_CHAR(date_ + i, 'YYYY'));
      
  END LOOP;
 END;


----   Dim_Car:
CREATE OR REPLACE PROCEDURE FILL_DIM_CAR
IS 
BEGIN  
  INSERT INTO Dim_Car VALUES(1,12345, 'Acura', 'Integra','Red', 1993, 0);
  INSERT INTO Dim_Car VALUES(2,32541,'Acura', 'Legend', 'Black', 1994, 1);
  INSERT INTO Dim_Car VALUES(3,15478,'Audi', '90', 'Yellow', 2000, 0);
  INSERT INTO Dim_Car VALUES(4,13468,'BMW', '535i', 'Orange', 1985, 0);
  INSERT INTO Dim_Car VALUES(5,12478,'Buick', 'Century', 'Black', 1993, 0);
  INSERT INTO Dim_Car VALUES(6,13695,'Buick', 'LeSpare', 'White', 2000, 1);
  INSERT INTO Dim_Car VALUES(7,98541,'Buick', 'RoadMaster', 'Brown', 2010, 1);
  INSERT INTO Dim_Car VALUES(8,96324,'Buick', 'Riviera', 'Blue', 1994, 0);
  INSERT INTO Dim_Car VALUES(9,87452,'Cadillac', 'DeVille', 'Red', 1998, 1);
  INSERT INTO Dim_Car VALUES(10,75620,'Cadillac', 'SeVille', 'Black', 1999, 0);
  INSERT INTO Dim_Car VALUES(11,75234,'Chevrolet', 'Cavalier', 'Blue', 1975, 1);
  INSERT INTO Dim_Car VALUES(12,65234,'Chevrolet', 'Corsica','Green', 1970, 0);
  INSERT INTO Dim_Car VALUES(13,65871,'Chevrolet', 'Camaro', 'Yellow', 1995, 1);
  INSERT INTO Dim_Car VALUES(14,52149,'Chevrolet', 'Lumina','Red', 1999, 0);
  INSERT INTO Dim_Car VALUES(15,52647,'Chevrolet', 'Lumina APV', 'Black', 2005, 1);
  INSERT INTO Dim_Car VALUES(16,42358,'Chevrolet', 'Astro', 'White', 2005, 0);
  INSERT INTO Dim_Car VALUES(17,41268,'Chevrolet', 'Caprice','White', 1995, 1);
  INSERT INTO Dim_Car VALUES(18,32487,'Chevrolet', 'Corvette','Black', 1993, 0);
  INSERT INTO Dim_Car VALUES(19,32447,'Chrylser', 'Concorde', 'Red', 2000, 1);
  INSERT INTO Dim_Car VALUES(20,22658,'Chrylser', 'LeBaron', 'Blue', 2000, 0);
  INSERT INTO Dim_Car VALUES(21,24985,'Chrylser', 'Imperial', 'White', 1970, 1);
  INSERT INTO Dim_Car VALUES(22,18987,'Dodge', 'Colt', 'Red', 2005, 0);
  INSERT INTO Dim_Car VALUES(23,99999,'Dodge', 'Shadow', 'Blue', 1993, 0);
  INSERT INTO Dim_Car VALUES(24,88888,'Dodge', 'Spirit', 'Red', 1993, 1);  
END;

---- Dim_Mechanic:
CREATE OR REPLACE PROCEDURE FILL_DIM_MECHANIC 
IS
BEGIN
  INSERT INTO Dim_Mechanic VALUES(1, 'Henry', 'Ford');
  INSERT INTO Dim_Mechanic VALUES(2, 'Bill', 'Gates');
  INSERT INTO Dim_Mechanic VALUES(3, 'Muskan', 'Shaikh');
  INSERT INTO Dim_Mechanic VALUES(4, 'Richard', 'Thrubin');
  INSERT INTO Dim_Mechanic VALUES(5, 'Emma', 'Wattson');
END;

---- Dim_Service:
CREATE OR REPLACE PROCEDURE FILL_DIM_SERVICE
IS
BEGIN
  INSERT INTO Dim_Service VALUES(1,'Brakes Repair', 50);
  INSERT INTO Dim_Service VALUES(2,'Oil Change', 20);
  INSERT INTO Dim_Service VALUES(3,'Steering and Suspension', 100);
  INSERT INTO Dim_Service VALUES(4,'Tires Repair', 100);
  INSERT INTO Dim_Service VALUES(5,'Batteries and Charging', 50);
  INSERT INTO Dim_Service VALUES(6,'Lights Change', 50);
  INSERT INTO Dim_Service VALUES(7,'Accessories', 100);
  INSERT INTO Dim_Service VALUES(8,'Heating and AC', 50);
  INSERT INTO Dim_Service VALUES(9,'Radiator and Engine Check', 200);
END;
