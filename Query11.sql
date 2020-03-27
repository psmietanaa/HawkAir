-- Query #11

-- 0 connections
-- Should be one result AA2470
SELECT FlightID
FROM flights
WHERE flights.From = 'ORD' AND flights.To = 'LAX';

-- 1 connection
-- Should be one result AA8901 -> AA6846
SELECT f1.FlightID, f2.FlightID
FROM flights AS f1 JOIN flights AS f2 ON (f1.To = f2.From AND TIMEDIFF(f2.DepartTime, f1.DepartTime + f1.Duration) > '01:00:00' AND TIMEDIFF(f2.DepartTime, f1.DepartTime + f1.Duration) < '5:00:00')
WHERE f1.From = 'CID' AND f2.To = 'JFK'

-- 2 connections
-- Should be AA8901 -> AA6846 -> AA6881
SELECT f1.FlightID, f2.FlightID, f3.FlightID
FROM ...
WHERE f1.From = 'CID' AND f2.To = 'MIA'

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
-- In conclusion, only flight AA4594 is before AA3287 which should be the result.
-- It's impossible to take other flights

-- Then we will a query that will combine all these options and display a final result
-- Yes I found a possible trip and here it is
-- No I did not find such a trip
