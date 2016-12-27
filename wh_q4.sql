SELECT DISTINCT time_id, serial_no, total_parts_cost,
                sum(total_parts_cost) over (PARTITION BY time_id, serial_no ORDER BY id
                                            RANGE BETWEEN UNBOUNDED PRECEDING AND current row) as total_cost_up_now
FROM Fact_Services, Dim_Car
WHERE Fact_Services.car_id = Dim_Car.car_id
ORDER BY time_id,serial_no,total_cost_up_now;
