DELIMITER //
CREATE PROCEDURE SearchFlights(IN fromCity VARCHAR(3), IN toCity VARCHAR(3), IN passengers INT, IN weekDay VARCHAR(9))
BEGIN
    SET @sql = CONCAT('SELECT flights.FlightID FROM aircrafts, flights, schedule WHERE aircrafts.AircraftID = flights.AircraftID AND flights.FlightID = schedule.FlightID AND (aircrafts.TotalEconomySeats - flights.BookedEconomySeats > ', passengers, ' OR aircrafts.TotalFirstClassSeats - flights.BookedFirstClassSeats > ', passengers, ') AND flights.From = ''', fromCity, ''' AND flights.To = ''', toCity, ''' AND schedule.', weekDay, ' = 1;');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetFare(IN flightNumber VARCHAR(6))
BEGIN
    SELECT PriceEconomy, PriceFirstClass
    FROM flights
    WHERE FlightID = flightNumber;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetSeats(IN flightNumber VARCHAR(6))
BEGIN
    SELECT aircrafts.TotalEconomySeats - flights.BookedEconomySeats as AvailableEconomySeats, aircrafts.TotalFirstClassSeats - flights.BookedFirstClassSeats as AvailableFirstClassSeats
    FROM aircrafts, flights
    WHERE flights.FlightID = flightNumber AND aircrafts.AircraftID = flights.AircraftID;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE FindTrip(IN fName VARCHAR(45), IN lName VARCHAR(45), IN bookingNumber VARCHAR(6))
BEGIN
    SELECT bookings.BookingID, flights.From, flights.To, flights.DepartTime, flights.Duration, flights.FlightID, flights.AircraftID, bookings.Class, bookings.SeatNumber
    FROM bookings, flights, users
    WHERE bookings.UserID = users.UserID AND bookings.FlightID = flights.FlightID AND users.FirstName = fname AND users.LastName = lname AND bookings.BookingID = bookingNumber;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetFlightsStatusDate(IN fromCity VARCHAR(3), IN toCity VARCHAR(3), IN weekDay VARCHAR(9))
BEGIN
    SET @sql = CONCAT('SELECT flights.FlightID FROM flights, schedule WHERE flights.FlightID = schedule.FlightID AND flights.From = ''', fromCity, ''' AND flights.To = ''', toCity, ''' AND schedule.', weekDay, ' = 1 ORDER BY flights.DepartTime');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetFlightsStatusNumber(IN flightNumber VARCHAR(6), IN weekDay VARCHAR(9))
BEGIN
    SET @sql = CONCAT('SELECT flights.FlightID FROM flights, schedule WHERE flights.FlightID = schedule.FlightID AND flights.FlightID = ''', flightNumber, ''' AND schedule.', weekDay, ' = 1 ORDER BY flights.DepartTime');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ValidateUser(IN user VARCHAR(45))
BEGIN
    SELECT UserID, Password
    FROM users
    WHERE UserID = user OR Username = user;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ValidateAdmin(IN user VARCHAR(45), IN pass VARCHAR(64))
BEGIN
    SELECT *
    FROM admin
    WHERE Username = user AND Password = pass;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE MyInfo(IN user VARCHAR(45))
BEGIN
    SELECT *
    FROM users
    WHERE users.Username = user;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE MyTrips(IN user VARCHAR(45))
BEGIN
    SELECT bookings.BookingID, flights.From, flights.To, bookings.FlightDate, flights.DepartTime, flights.FlightID, flights.Duration, bookings.Class, bookings.SeatNumber
    FROM bookings, flights, users
    WHERE bookings.UserID = users.UserID AND bookings.FlightID = flights.FlightID AND users.Username = user;
END //
DELIMITER ;

-- Create --
DELIMITER //
CREATE PROCEDURE CreateUser(IN Title VARCHAR(6), IN FirstName VARCHAR(45), IN MiddleName VARCHAR(45), IN LastName VARCHAR(45), IN PreferredName VARCHAR(45), IN Sex VARCHAR(6), IN DOB Date, IN Street VARCHAR(100), IN City VARCHAR(45), IN ZipCode VARCHAR(10), IN State VARCHAR(45), IN Country VARCHAR(45), IN Phone VARCHAR(20), IN Email VARCHAR(100), IN Username VARCHAR(45), IN Pass VARCHAR(64), IN SecurityQuestion VARCHAR(100), IN SecurityAnswer VARCHAR(45))
BEGIN
    INSERT INTO users VALUES
    (NULL, Title, FirstName, MiddleName, LastName, PreferredName, Sex, DOB, Street, City, ZipCode, State, Country, Phone, Email, Username, Pass, SecurityQuestion, SecurityAnswer, 1, 0);
END //
DELIMITER ;

-- Read --
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

DELIMITER //
CREATE PROCEDURE GetNews(IN count INT)
BEGIN
    SELECT Headline, Picture, Content
    FROM news
    ORDER BY Date DESC
    LIMIT count;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetContactDetails()
BEGIN
    SELECT *
    FROM contactus;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetBookingIDs()
BEGIN
    SELECT BookingID
    FROM bookings;
END //
DELIMITER ;

-- Update --

-- Delete --
