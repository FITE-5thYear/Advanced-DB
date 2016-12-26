CREATE MATERIALIZED VIEW mechanics_mv 
BUILD IMMEDIATE 
REFRESH COMPLETE
AS
  SELECT m.name        as Mechanic_Name, 
         s.name        as Service_Name,
         f.total_hours as Total_Hours
  FROM
         Fact_Works f, Dim_Mechanic m, Dim_Service s
  WHERE 
        f.service_id  = s.service_id 
   AND  f.mechanic_id = m.mechanic_id;
