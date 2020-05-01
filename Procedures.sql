DELIMITER //
CREATE PROCEDURE SearchFlights(IN fromCity VARCHAR(3), IN toCity VARCHAR(3), IN weekDay VARCHAR(9))
BEGIN
    SET @sql = CONCAT('SELECT flights.FlightID FROM flights, routes, schedules WHERE flights.RouteID = routes.RouteID AND flights.ScheduleID = schedules.ScheduleID AND routes.From = ''', fromCity, ''' AND routes.To = ''', toCity, ''' AND schedules.', weekDay, ' = 1 ORDER BY flights.DepartTime;');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;

# CALL SearchFlights('ORD', 'LAX', 'Monday')

DELIMITER //
CREATE PROCEDURE CheckSeats(IN flightNumber VARCHAR(6), IN fDate DATE, IN passengers INT)
BEGIN
    SELECT routes.From, routes.To, flights.DepartTime, flights.FlightID, flights.AircraftID, routes.Duration,
        aircrafts.EconomySeats - (SELECT COUNT(*) FROM multiplebookings WHERE multiplebookings.FlightID = flightNumber AND FlightDate = fDate AND Class = 'Economy') AS AvailableEconomySeats,
        aircrafts.FirstClassSeats - (SELECT COUNT(*) FROM multiplebookings WHERE multiplebookings.FlightID = flightNumber AND FlightDate = fDate AND Class = 'First Class') AS AvailableFirstClassSeats
    FROM aircrafts, flights, routes
    WHERE aircrafts.AircraftID = flights.AircraftID AND flights.RouteID = routes.RouteID AND flights.FlightID = flightNumber AND
        (aircrafts.EconomySeats - (SELECT COUNT(*) FROM multiplebookings WHERE multiplebookings.FlightID = flightNumber AND FlightDate = fDate AND Class = 'Economy') >= passengers OR
        aircrafts.FirstClassSeats - (SELECT COUNT(*) FROM multiplebookings WHERE multiplebookings.FlightID = flightNumber AND FlightDate = fDate AND Class = 'First Class') >= passengers);
END //
DELIMITER ;

# CALL CheckSeats('AA2470', '2020-03-24', 5)

DELIMITER //
CREATE PROCEDURE GetFare(IN flightNumber VARCHAR(6))
BEGIN
    SELECT fares.PriceEconomy, fares.PriceFirstClass
    FROM fares, flights
    WHERE fares.FareID = flights.FareID AND flights.FlightID = flightNumber;
END //
DELIMITER ;

# CALL GetFare('AA2470')

DELIMITER //
CREATE PROCEDURE GetBookingIDs()
BEGIN
    SELECT DISTINCT BookingID
    FROM bookings;
END //
DELIMITER ;

# CALL GetBookingIDs()

DELIMITER //
CREATE PROCEDURE CreateBooking(IN bookingID VARCHAR(6), IN userID VARCHAR(45))
BEGIN
    INSERT INTO bookings VALUES
    (bookingID, userID);
END //
DELIMITER ;

# CALL CreateBooking('ABCXYZ', 100001)

DELIMITER //
CREATE PROCEDURE CreateMultipleBookings(IN bookingID VARCHAR(6), IN flightID VARCHAR(6), IN flightDate Date, IN passenger VARCHAR(100), IN class VARCHAR(20))
BEGIN
    INSERT INTO multiplebookings VALUES
    (bookingID, flightID, flightDate, passenger, class, '');
END //
DELIMITER ;

# CALL CreateMultipleBookings('ABCXYZ', 'AA2470', '2020-03-24', 'Test', 'First Class')

DELIMITER //
CREATE PROCEDURE GetBooking(IN bookingNumber VARCHAR(6))
BEGIN
    SELECT multiplebookings.BookingID, routes.From, routes.To, multiplebookings.FlightDate, flights.DepartTime, flights.FlightID, routes.Duration, multiplebookings.Class, multiplebookings.Passenger
    FROM flights, multiplebookings, routes
    WHERE multiplebookings.FlightID = flights.FlightID AND flights.RouteID = routes.RouteID AND multiplebookings.BookingID = bookingNumber;
END //
DELIMITER ;

# CALL GetBooking('ABCDEF')

DELIMITER //
CREATE PROCEDURE YourTrip(IN fName VARCHAR(45), IN lName VARCHAR(45), IN bookingNumber VARCHAR(6))
BEGIN
    SELECT bookings.BookingID, routes.From, routes.To, multiplebookings.FlightDate, flights.DepartTime, flights.FlightID, routes.Duration, multiplebookings.Class, multiplebookings.Passenger
    FROM bookings, flights, multiplebookings, routes, users
    WHERE multiplebookings.FlightID = flights.FlightID AND flights.RouteID = routes.RouteID AND bookings.BookingID = multiplebookings.BookingID AND bookings.UserID = users.UserID AND
        UCASE(users.FirstName) = UCASE(fname) AND UCASE(users.LastName) = UCASE(lname) AND UCASE(bookings.BookingID) = UCASE(bookingNumber);
END //
DELIMITER ;

# CALL YourTrip('Roger', 'McCubbin', 'ABCDEF')

DELIMITER //
CREATE PROCEDURE GetFlightsStatusDate(IN fromCity VARCHAR(3), IN toCity VARCHAR(3), IN fDate Date)
BEGIN
    SELECT multiplebookings.BookingID, routes.From, routes.To, multiplebookings.FlightDate, flights.DepartTime, flights.FlightID, routes.Duration, flights.AircraftID, flights.FlightStatus
    FROM multiplebookings, flights, routes
    WHERE multiplebookings.FlightID = flights.FlightID AND flights.RouteID = routes.RouteID AND routes.From = fromCity AND routes.To = toCity AND multiplebookings.FlightDate = fDate ORDER BY flights.DepartTime;
END //
DELIMITER ;

# CALL GetFlightsStatusDate('ORD', 'LAX', '2020-03-24')

DELIMITER //
CREATE PROCEDURE GetFlightsStatusNumber(IN flightNumber VARCHAR(6), IN fDate Date)
BEGIN
    SELECT multiplebookings.BookingID, routes.From, routes.To, multiplebookings.FlightDate, flights.DepartTime, flights.FlightID, routes.Duration, flights.AircraftID, flights.FlightStatus
    FROM multiplebookings, flights, routes
    WHERE multiplebookings.FlightID = flights.FlightID AND flights.RouteID = routes.RouteID AND UCASE(flights.FlightID) = UCASE(flightNumber) AND multiplebookings.FlightDate = fDate ORDER BY flights.DepartTime;
END //
DELIMITER ;

# CALL GetFlightsStatusNumber('AA2470', '2020-03-24')

DELIMITER //
CREATE PROCEDURE ValidateUser(IN user VARCHAR(45))
BEGIN
    SELECT UserID, Username, Password
    FROM users
    WHERE UserID = user OR Username = user;
END //
DELIMITER ;

# CALL ValidateUser('Quinnow')
# CALL ValidateUser('100001')

DELIMITER //
CREATE PROCEDURE RecoverCredentials(IN email VARCHAR(100))
BEGIN
    SELECT users.UserID, users.Email, users.Username
    FROM users
    WHERE users.Email = email;
END //
DELIMITER ;

# CALL RecoverCredentials('piotrromuald-smietana@uiowa.edu')

DELIMITER //
CREATE PROCEDURE ResetPassword(IN user VARCHAR(45), IN pass VARCHAR(64))
BEGIN
    UPDATE users
    SET Password = pass
    WHERE UserID = user;
END //
DELIMITER ;

# CALL ChangePassword(100006, '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08')

DELIMITER //
CREATE PROCEDURE ValidateAdmin(IN user VARCHAR(45), IN pass VARCHAR(64))
BEGIN
    SELECT *
    FROM admin
    WHERE Username = user AND Password = pass;
END //
DELIMITER ;

# CALL ValidateAdmin('admin', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8')

DELIMITER //
CREATE PROCEDURE CreateUser(IN Title INT, IN FirstName VARCHAR(45), IN MiddleName VARCHAR(45), IN LastName VARCHAR(45), IN PreferredName VARCHAR(45), IN Sex VARCHAR(6), IN DOB Date, IN Street VARCHAR(100), IN City VARCHAR(45), IN ZipCode VARCHAR(10), IN State VARCHAR(45), IN Country VARCHAR(45), IN Phone VARCHAR(20), IN Email VARCHAR(100), IN Username VARCHAR(45), IN Pass VARCHAR(64), IN SecurityQuestion INT, IN SecurityAnswer VARCHAR(45))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN
            ROLLBACK;
        END;
    COMMIT;
    
    START TRANSACTION;
    INSERT INTO users VALUES
    (NULL, Title, FirstName, MiddleName, LastName, PreferredName, Sex, DOB, Phone, Email, Username, Pass, SecurityQuestion, SecurityAnswer);
    INSERT INTO addresses VALUES
    ((SELECT UserID from users WHERE users.Username = Username), Street, City, ZipCode, State, Country);
    INSERT INTO hawkadvantage VALUES
    ((SELECT UserID FROM users WHERE users.Username = Username), 0);
    COMMIT;
END //
DELIMITER ;

# CALL CreateUser(1,'Piotr', 'Romuald', 'Smietana', 'Peter', 'Male', '1998-04-27', 'Kamieniecka 6', 'Krakow', '30389', '', 'Poland', '319-834-0276', 'piotrromuald-smietana@uiowa.edu', 'psmietana', 'hash@hash', 1, 'Tennis')

DELIMITER //
CREATE PROCEDURE MyInfo(IN user VARCHAR(45))
BEGIN
    SELECT users.UserID, titles.Title, users.FirstName, users.MiddleName, users.LastName, users.PreferredName, users.Sex, users.DOB,
        addresses.Street, addresses.City, addresses.ZipCode, addresses.State, users.Phone, users.Email, users.Username, hawkadvantage.Miles
    FROM addresses, hawkadvantage, titles, users 
    WHERE addresses.UserID = users.UserID AND users.TitleID = titles.TitleID AND users.UserID = hawkadvantage.UserID AND users.Username = user;
END //
DELIMITER ;

# CALL MyInfo('Quinnow')

DELIMITER //
CREATE PROCEDURE MyTrips(IN user VARCHAR(45))
BEGIN
    SELECT bookings.BookingID, routes.From, routes.To, multiplebookings.FlightDate, flights.DepartTime, flights.FlightID, routes.Duration, multiplebookings.Class, multiplebookings.Passenger
    FROM bookings, flights, multiplebookings, routes, users
    WHERE multiplebookings.FlightID = flights.FlightID AND flights.RouteID = routes.RouteID AND bookings.BookingID = multiplebookings.BookingID AND bookings.UserID = users.UserID AND users.Username = user;
END //
DELIMITER ;

# CALL MyTrips('Quinnow')

DELIMITER //
CREATE PROCEDURE ValidateBookingChange(IN user VARCHAR(45), IN bookingNumber VARCHAR(6), IN flightNumber VARCHAR(6), IN passengerName VARCHAR(100))
BEGIN
    SELECT bookings.BookingID
    FROM bookings, multiplebookings, users
    WHERE bookings.BookingID = multiplebookings.BookingID AND bookings.UserID = users.UserID AND users.Username = user AND bookings.BookingID = bookingNumber AND multiplebookings.FlightID = flightNumber AND multiplebookings.Passenger = passengerName AND DATEDIFF(multiplebookings.FlightDate, CURDATE()) >= 2;
END //
DELIMITER ;

# CALL ValidateBookingChange('Quinnow', 'ABCDEF', 'AA2470', 'Roger McCubbin')

DELIMITER //
CREATE PROCEDURE UpdateBooking(IN bookingNumber VARCHAR(6), IN flightNumber VARCHAR(6), IN passengerName VARCHAR(100), IN fDate DATE, IN newFlightNumber VARCHAR(6), IN newDate DATE)
BEGIN
    UPDATE multiplebookings
    SET FlightID = newFlightNumber, FlightDate = newDate
    WHERE BookingID = bookingNumber AND FlightID = flightNumber AND Passenger = passengerName AND FlightDate = fDate;
END //
DELIMITER ;

# CALL UpdateBooking('ABCDEF', 'AA2470', 'Roger McCubbin', '2020-03-24', 'AA8623', '2020-04-30')

DELIMITER //
CREATE PROCEDURE DeleteBooking(IN bookingNumber VARCHAR(6), IN flightNumber VARCHAR(6), IN passengerName VARCHAR(100))
BEGIN
    DELETE FROM multiplebookings
    WHERE BookingID = bookingNumber AND FlightID = flightNumber AND Passenger = passengerName;
    
    DELETE FROM bookings
    WHERE BookingID = bookingNumber AND
        NOT EXISTS(SELECT 1 FROM multiplebookings WHERE BookingID = bookingNumber);
END //
DELIMITER ;

# CALL DeleteBooking('XXXAAA', 'AA2470', 'Roger McCubbin')

DELIMITER //
CREATE PROCEDURE GetDepartLocations()
BEGIN
    SELECT DISTINCT `From` FROM routes;
END //
DELIMITER ;

# CALL GetDepartLocations()

DELIMITER //
CREATE PROCEDURE GetArrivalLocations()
BEGIN
    SELECT DISTINCT `To` FROM routes
    ORDER BY `To` DESC;
END //
DELIMITER ;

# CALL GetArrivalLocations()

DELIMITER //
CREATE PROCEDURE GetTitles()
BEGIN
    SELECT * FROM titles;
END //
DELIMITER ;

# CALL GetTitles()

DELIMITER //
CREATE PROCEDURE GetSecurityQuestions()
BEGIN
    SELECT * FROM securityquestions;
END //
DELIMITER ;

# CALL GetSecurityQuestions()

DELIMITER //
CREATE PROCEDURE GetNews(IN count INT)
BEGIN
    SELECT Headline, Picture, Content
    FROM news
    ORDER BY Date DESC
    LIMIT count;
END //
DELIMITER ;

# CALL GetNews(3)

DELIMITER //
CREATE PROCEDURE GetContactDetails()
BEGIN
    SELECT *
    FROM contactus;
END //
DELIMITER ;

# CALL GetContactDetails()
