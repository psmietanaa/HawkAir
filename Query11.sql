INSERT INTO `HawkAir`.`Flights` VALUES
('AA5144','Airbus 319','ORD','DEN','14:57','1:52','On time',240,160,0,0);

INSERT INTO `HawkAir`.`Schedule` VALUES
(1,1,1,1,1,1,1,'AA5144');

INSERT INTO `HawkAir`.`Flights` VALUES
('AA8623','Airbus 319','ORD','DEN','19:25','1:52','On time',280,150,0,0);

INSERT INTO `HawkAir`.`Schedule` VALUES
(1,1,1,1,1,1,1,'AA8623');

---------------------------------------------------------------------------------

INSERT INTO `HawkAir`.`Flights` VALUES
('AA3287','Airbus 319','DEN','ORD','10:30','1:52','On time',195,235,0,0);

INSERT INTO `HawkAir`.`Schedule` VALUES
(1,1,1,1,1,1,1,'AA3287');


--------------------------------------------------------------------------------------

DELIMITER //
CREATE PROCEDURE ConnectingFlights(IN fromCity VARCHAR(3), IN toCity VARCHAR(3), IN weekDay VARCHAR(9))
BEGIN
SELECT Dept1 = Flights.fromCity, Arr2 = flights.toCity, Arr1 = Dept2 = Flights.From = (Select RAND() * Flights.From from Flights != fromCity AND TIMEDIFF('ArrivalTime.fromCity', 'DepartTime.Dept2'  = 1:30:00) 
FROM Flights
END //
DELIMITER ;

" I have written this query with the following logic in my mind -
         Dept1 (FromCity Location) -------> Arr1 (Intermediate Location)
         Dept2 (Intermediate Location same as Arr1) -----------> Arr2 (ToCity location which is the final destination)
  So the Arr1 (Intermediate Location) has to be selected in a way that Both Arr1 and Dept2 are the same and they are not equal to Dept1.
  Also, The time difference between ArrivalTime of Dept1 Flight - DepartTime of Dept2 Flight should be 1.5 Hrs(which can be modified)
  For this we would need to have a track of ArrivalTime of each flight just like how we are having the DepartTime."
                                                                                       
