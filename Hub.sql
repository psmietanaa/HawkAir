-- Flight Connections

-- 0 connections
-- Should be one result AA2470
SELECT flights.FlightID, flights.DepartTime, routes.From, routes.To, routes.Duration
FROM flights, routes
WHERE flights.RouteID = routes.RouteID AND routes.From = 'ORD' AND routes.To = 'LAX';

-- 1 connection
-- Should be one result AA8901 -> AA6846
SELECT f1.FlightID, f2.FlightID
FROM (SELECT flights.FlightID, flights.DepartTime, routes.From, routes.To, routes.Duration FROM flights, routes WHERE flights.RouteID = routes.RouteID) AS f1
JOIN (SELECT flights.FlightID, flights.DepartTime, routes.From, routes.To, routes.Duration FROM flights, routes WHERE flights.RouteID = routes.RouteID) AS f2
ON (f1.To = f2.From AND TIMEDIFF(f2.DepartTime, ADDTIME(f1.DepartTime, f1.Duration)) > '01:00:00' AND TIMEDIFF(f2.DepartTime, ADDTIME(f1.DepartTime, f1.Duration)) < '5:00:00')
WHERE f1.From = 'CID' AND f2.To = 'JFK';

-- 2 connections
-- Should be AA8901 -> AA6846 -> AA6881
SELECT f1.FlightID, f2.FlightID, f3.FlightID
FROM (SELECT flights.FlightID, flights.DepartTime, routes.From, routes.To, routes.Duration FROM flights, routes WHERE flights.RouteID = routes.RouteID) AS f1
JOIN (SELECT flights.FlightID, flights.DepartTime, routes.From, routes.To, routes.Duration FROM flights, routes WHERE flights.RouteID = routes.RouteID) AS f2
JOIN (SELECT flights.FlightID, flights.DepartTime, routes.From, routes.To, routes.Duration FROM flights, routes WHERE flights.RouteID = routes.RouteID) AS f3
ON (f1.To = f2.From AND TIMEDIFF(f2.DepartTime, ADDTIME(f1.DepartTime, f1.Duration)) > '01:00:00' AND TIMEDIFF(f2.DepartTime, ADDTIME(f1.DepartTime, f1.Duration)) < '5:00:00' AND
    f2.To = f3.From AND TIMEDIFF(f3.DepartTime, ADDTIME(f2.DepartTime, f2.Duration)) > '01:00:00' AND TIMEDIFF(f3.DepartTime, ADDTIME(f2.DepartTime, f2.Duration)) < '5:00:00')
WHERE f1.From = 'CID' AND f3.To = 'MIA';
