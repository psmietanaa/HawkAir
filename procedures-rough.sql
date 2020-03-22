/*Query 1-3*/
CREATE PROCEDURE SearchFlights @From VARCHAR(3), @To VARCHAR(3), @Day VARCHAR(10)
AS
SELECT * FROM Schedule where Day = @Day 
GO;
/* Essentially for the first 3 queries this remains the same. We modify as per our needs in the python script i.e. EXEC command 
Another value called Day is needed to store the convert date in the database and then lookup based on it. This day should also be made a Foriegn Key for easy purpose
*/

/*Query 4*/
CREATE PROCEDURE Fares @From VARCHAR(3), @To VARCHAR(3)
AS
SELECT PriceFirstClass, PriceEconomy FROM Flights
GO;

/*Query 5*/
CREATE PROCEDURE Seats @AircraftID VARCHAR(20)
AS
SELECT Aircrafts.TotalFirstClassSeats - Flights.BookedFirstClassSeats as Diff 1 AND Aircrafts.TotalEconomySeats - Flights.BookedEconomySeats as Diff 2 FROM Aircrafts, Flights
GO;

/*Query 6*/
CREATE PROCEDURE FindTrip @FirstName VARCHAR(45), @LastName VARCHAR(45), @BookingID INT
AS
Select * FROM Bookings Where BookingId = @BookingID
GO;

/*Query 7*/
CREATE PROCEDURE FlightsbyTime @From VARCHAR(3), @To VARCHAR(3), @Day VARCHAR(10)
AS
SELECT From, To, DepartTime FROM Flights Order by DepartTime 
GO;

/*Query 8*/
CREATE PROCEDURE FindFlight @FlightID VARCHAR(6), @TravelDate INT
AS
Select FlightStatus FROM Flights where FlightID = @FlightID AND TravelDate = @TravelDate
GO;
/* I feel we need a date column because a day value alone wont work as suggested, since we have find a flight based on a date.
So if we dont give a date value and use it as a day value alone then we will not get the right results
I do not understand the difference between 8th and 9th query too. By find the flight what do we need to return???*/

/*Query 10*/
CREATE PROCEDURE ValidateUser @Username VARCHAR(45), @LastName VARCHAR(45), @Password VARCHAR(128)
AS
IF EXISTS (SELECT Username, LastName, Password from Users Where Username = @Username AND LastName = @LastName AND Password = @Password)
SELECT 'True' 
ELSE
SELECT 'False'
GO;

/*Query 11*/
CREATE PROCEDURE ValidateAdmin @Username VARCHAR(45), @Password VARCHAR(128)
AS
IF EXISTS (SELECT Username, Password from Admin Where Username = @Username AND Password = @Password)
SELECT 'True' 
ELSE
SELECT 'False'
GO;

/* Query 10 and 11
Password and Admin both are keywords in SQL so we have to give the fields a different name*/

/*Query 13*/
CREATE PROCEDURE Mytrips @Username VARCHAR(45), @Password VARCHAR(128)
AS
SELECT * FROM Bookings Full Outer Join Users on Bookings.UserID = Users.UserID
GO;

/*Query 23*/
CREATE PROCEDURE News
AS
SELECT * FROM News
GO;

/*Query 24*/
CREATE PROCEDURE ContactUs
AS
SELECT * FROM ContactUs
GO;


