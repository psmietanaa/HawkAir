INSERT INTO `HawkAir`.`Airports` VALUES
('KRK', 'Krakow International Airport', 'Krakow', '', 'Poland');

INSERT INTO `HawkAir`.`Flights` VALUES
('AA5144','Airbus 319','ORD','DEN','14:57','1:52','On time',240,160,0,0),
('AA8623','Airbus 319','ORD','DEN','19:25','1:52','On time',280,150,0,0),
('AA3287','Airbus 319','DEN','ORD','10:30','1:52','On time',195,270,0,0),
('AA6527','Airbus 319','DEN','LAX','10:30','2:00','On time',200,235,0,0),
('AA3212','CRJ 700','DEN','LAX','6:30','2:00','On time',175,280,0,0),
('AA1423','Boeing 737','LAX','KRK','13:30','6:00','On time',450,960,0,0);

INSERT INTO `HawkAir`.`Schedule` VALUES
(1,1,1,1,1,1,1,'AA5144'),
(1,1,1,1,1,1,1,'AA8623'),
(1,1,1,1,1,1,1,'AA3287'),
(1,1,1,1,1,1,1,'AA3287'),
(1,1,1,1,1,1,1,'AA3212'),
(1,1,1,1,1,1,1,'AA1423');

--------------------------------------------------------------------------------------

-- 0 connections
-- Should be one result AA2470
SELECT FlightID
FROM flights
WHERE flights.From = 'ORD' AND flights.To = 'LAX';

-- 1 connection
-- Should be one result AA4594 -> AA6527
SELECT f1.FlightID, f2.FlightID
FROM flights AS f1 JOIN flights AS f2 ON (f1.To = f2.From AND TIMEDIFF(f2.DepartTime, f1.DepartTime + f1.Duration) > '01:00:00' AND TIMEDIFF(f2.DepartTime, f1.DepartTime + f1.Duration) < '5:00:00')
WHERE f1.From = 'ORD' AND f2.To = 'LAX'

-- 2 connections
-- Should be AA4594 -> AA6527 -> AA1423
SELECT f1.FlightID, f2.FlightID, f3.FlightID
FROM ...
WHERE f1.From = 'ORD' AND f2.To = 'KRK'

-- Then we will need a query that checks which flights happen before the returning ones
-- For example if an outgoing and incoming flight is on the same day, the query should show only options where outgoing flight happens before the returning one
-- Let's say that we want a round trip from ORD to DEN. We call the 0 connections procedure
SELECT *
FROM flights
WHERE flights.From = 'ORD' AND flights.To = 'DEN';
-- We get 3 results: AA4594, AA5144, AA8623
-- On the website we would call it again from DEN to ORD for a returning flight
SELECT *
FROM flights
WHERE flights.From = 'DEN' AND flights.To = 'ORD'; 
-- Results: AA3287
-- Only flight AA4594 is before AA3287 which should be the result.
-- It's impossible to take other flights

