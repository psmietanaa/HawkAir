-- Query 1-3 --
DELIMITER //
CREATE PROCEDURE SearchFlights(IN fromCity VARCHAR(3), IN toCity VARCHAR(3), IN passengers INT, IN weekDay VARCHAR(9))
BEGIN
    SET @sql = CONCAT('SELECT flights.FlightID FROM aircrafts, flights, schedule WHERE aircrafts.AircraftID = flights.AircraftID AND flights.FlightID = schedule.FlightID AND (aircrafts.TotalEconomySeats - flights.BookedEconomySeats > ', passengers, ' OR aircrafts.TotalFirstClassSeats - flights.BookedFirstClassSeats > ', passengers, ') AND flights.From = ''', fromCity, ''' AND flights.To = ''', toCity, ''' AND schedule.', weekDay, ' = 1;');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;

-- CALL SearchFlights('ORD', 'JFK', 5, 'Monday')

-- Query 4 --
DELIMITER //
CREATE PROCEDURE GetFare(IN flightNumber VARCHAR(6))
BEGIN
    SELECT PriceEconomy, PriceFirstClass
    FROM flights
    WHERE FlightID = flightNumber;
END //
DELIMITER ;

-- CALL GetFare('AA6846')

-- Query 5 --
DELIMITER //
CREATE PROCEDURE GetSeats(IN flightNumber VARCHAR(6))
BEGIN
    SELECT aircrafts.TotalEconomySeats - flights.BookedEconomySeats as AvailableEconomySeats, aircrafts.TotalFirstClassSeats - flights.BookedFirstClassSeats as AvailableFirstClassSeats
    FROM aircrafts, flights
    WHERE flights.FlightID = flightNumber AND aircrafts.AircraftID = flights.AircraftID;
END //
DELIMITER ;

-- CALL GetSeats('AA6846')

-- Query 6 --
DELIMITER //
CREATE PROCEDURE FindTrip(IN fName VARCHAR(45), IN lName VARCHAR(45), IN bookingNumber VARCHAR(6))
BEGIN
    SELECT bookings.FlightID
    FROM bookings, users
    WHERE bookings.UserID = users.UserID AND users.FirstName = fname AND users.LastName = lname AND bookings.BookingID = bookingNumber;
END //
DELIMITER ;

-- INSERT INTO `HawkAir`.`Bookings` VALUES
-- ('MXCDSA', '16B', 'FirstClass', 100001, 'AA6846')
-- CALL FindTrip('Roger', 'McCubbin', 'MXCDSA')

-- Query 7 --
DELIMITER //
CREATE PROCEDURE GetFlightsStatusDate(IN fromCity VARCHAR(3), IN toCity VARCHAR(3), IN weekDay VARCHAR(9))
BEGIN
    SET @sql = CONCAT('SELECT flights.FlightID FROM flights, schedule WHERE flights.FlightID = schedule.FlightID AND flights.From = ''', fromCity, ''' AND flights.To = ''', toCity, ''' AND schedule.', weekDay, ' = 1 ORDER BY flights.DepartTime');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;

-- CALL GetFlightsStatusDate('ORD', 'JFK', 'Monday')

-- Query 8 --
DELIMITER //
CREATE PROCEDURE GetFlightsStatusNumber(IN flightNumber VARCHAR(6), IN weekDay VARCHAR(9))
BEGIN
    SET @sql = CONCAT('SELECT flights.FlightID FROM flights, schedule WHERE flights.FlightID = schedule.FlightID AND flights.FlightID = ''', flightNumber, ''' AND schedule.', weekDay, ' = 1 ORDER BY flights.DepartTime');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;

-- CALL GetFlightsStatusNumber('AA6846', 'Monday')

-- Query 9 --
DELIMITER //
CREATE PROCEDURE ValidateUser(IN user VARCHAR(45), IN pass VARCHAR(64))
BEGIN
    SELECT UserID
    FROM users
    WHERE (UserID = user AND Password = pass)
    OR (Username = user AND Password = pass);
END //
DELIMITER ;

-- CALL ValidateUser('100001', 'e45582512e2f8d730ce143a7c5021ef412b87ed7ea6eb5d32ffa64087bb3df69')
-- CALL ValidateUser('Quinnow', 'e45582512e2f8d730ce143a7c5021ef412b87ed7ea6eb5d32ffa64087bb3df69')

-- Query 10 --
DELIMITER //
CREATE PROCEDURE ValidateAdmin(IN user VARCHAR(45), IN pass VARCHAR(64))
BEGIN
    SELECT *
    FROM admin
    WHERE Username = user AND Password = pass;
END //
DELIMITER ;

-- CALL ValidateAdmin('admin', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8')

-- Query 11 --
-- MISSING --

-- Query 12 --
DELIMITER //
CREATE PROCEDURE MyTrips(IN userNumber INT)
BEGIN
    SELECT *
    FROM bookings
    WHERE UserID = userNumber;
END //
DELIMITER ;

-- CALL MyTrips(100001)

-- Query 13 --
-- MISSING --

-- Query 14 --
-- MISSING --

-- Query 24 --
DELIMITER //
CREATE PROCEDURE GetNews(IN count INT)
BEGIN
    SELECT Headline, Picture, Content
    FROM news
    ORDER BY Date DESC
    LIMIT count;
END //
DELIMITER ;

-- CALL GetNews(3)

-- Query 25 --
DELIMITER //
CREATE PROCEDURE GetContactDetails()
BEGIN
    SELECT *
    FROM contactus;
END //
DELIMITER ;

-- CALL GetContactDetails()

-- Getters Here --
DELIMITER //
CREATE PROCEDURE GetDepartLocations()
BEGIN
    SELECT DISTINCT `From` FROM flights;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetArrivalLocations()
BEGIN
    SELECT DISTINCT `To` FROM flights;
END //
DELIMITER ;
