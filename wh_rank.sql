SELECT Year, Month_Name as Month, Year_Total, Month_Total,
       DENSE_RANK() OVER (ORDER BY Month_Total DESC) Month_Rank,
       DENSE_RANK() OVER (ORDER BY Year_Total  DESC) Year_Rank
FROM 
  (SELECT Month_Name, SUM(Total_Parts_Cost) as Month_Total
   FROM Fact_Services, Dim_Time
   WHERE Fact_Services.time_id = Dim_Time.time_id
   GROUP BY Month_Name)
  ,
  (SELECT Year, SUM(Total_Parts_Cost) as Year_Total
   FROM Fact_Services, Dim_Time
   WHERE Fact_Services.time_id = Dim_Time.time_id
   GROUP BY Dim_Time.Year)
ORDER BY Year_Rank, Month_Rank;
