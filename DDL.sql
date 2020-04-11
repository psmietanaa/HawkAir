-- -----------------------------------------------------
-- Schema HawkAir
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `HawkAir`;
CREATE SCHEMA `HawkAir` DEFAULT CHARACTER SET utf8 ;
USE `HawkAir` ;

-- -----------------------------------------------------
-- Table `HawkAir`.`Address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Address` (
  `AddressID` INT NOT NULL AUTO_INCREMENT,
  `Street` VARCHAR(100) NOT NULL,
  `City` VARCHAR(45) NOT NULL,
  `ZipCode` VARCHAR(10) NOT NULL,
  `State` VARCHAR(45) NULL,
  `Country` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`AddressID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `HawkAir`.`Users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Users` (
  `UserID` INT NOT NULL AUTO_INCREMENT,
  `Title` VARCHAR(3) NULL,
  `FirstName` VARCHAR(45) NOT NULL,
  `MiddleName` VARCHAR(45) NULL,
  `LastName` VARCHAR(45) NOT NULL,
  `PreferredName` VARCHAR(45) NULL,
  `Sex` VARCHAR(6) NOT NULL,
  `DOB` DATE NOT NULL,
  `AddressID` INT NOT NULL,
  `Phone` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`UserID`),
  INDEX `fk_Users_Address1_idx` (`AddressID` ASC) VISIBLE,
  CONSTRAINT `fk_Users_Address1`
    FOREIGN KEY (`AddressID`)
    REFERENCES `HawkAir`.`Address` (`AddressID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 1;


-- -----------------------------------------------------
-- Table `HawkAir`.`Aircrafts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Aircrafts` (
  `AircraftID` VARCHAR(20) NOT NULL,
  `EconomySeats` SMALLINT NOT NULL,
  `FirstClassSeats` SMALLINT NOT NULL,
  PRIMARY KEY (`AircraftID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `HawkAir`.`Schedule`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Schedule` (
  `ScheduleID` INT NOT NULL AUTO_INCREMENT,
  `Monday` TINYINT(1) NOT NULL,
  `Tuesday` TINYINT(1) NOT NULL,
  `Wednesday` TINYINT(1) NOT NULL,
  `Thursday` TINYINT(1) NOT NULL,
  `Friday` TINYINT(1) NOT NULL,
  `Saturday` TINYINT(1) NOT NULL,
  `Sunday` TINYINT(1) NOT NULL,
  PRIMARY KEY (`ScheduleID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `HawkAir`.`Fares`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Fares` (
  `FareID` INT NOT NULL AUTO_INCREMENT,
  `PriceEconomy` MEDIUMINT NOT NULL,
  `PriceFirstClass` MEDIUMINT NOT NULL,
  PRIMARY KEY (`FareID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `HawkAir`.`Airports`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Airports` (
  `Code` VARCHAR(3) NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `City` VARCHAR(45) NOT NULL,
  `State` VARCHAR(45) NULL,
  `Country` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `HawkAir`.`Route`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Route` (
  `RouteID` INT NOT NULL,
  `From` VARCHAR(3) NOT NULL,
  `To` VARCHAR(3) NOT NULL,
  `Duration` TIME NOT NULL,
  PRIMARY KEY (`RouteID`),
  INDEX `fk_Route_Airports1_idx` (`From` ASC) VISIBLE,
  INDEX `fk_Route_Airports2_idx` (`To` ASC) VISIBLE,
  CONSTRAINT `fk_Route_Airports1`
    FOREIGN KEY (`From`)
    REFERENCES `HawkAir`.`Airports` (`Code`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Route_Airports2`
    FOREIGN KEY (`To`)
    REFERENCES `HawkAir`.`Airports` (`Code`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `HawkAir`.`Flights`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Flights` (
  `FlightID` VARCHAR(6) NOT NULL,
  `AircraftID` VARCHAR(20) NOT NULL,
  `RouteID` INT NOT NULL,
  `ScheduleID` INT NOT NULL,
  `FareID` INT NOT NULL,
  `DepartTime` TIME NOT NULL,
  `FlightStatus` VARCHAR(20) NULL DEFAULT 'On Time',
  PRIMARY KEY (`FlightID`),
  INDEX `fk_Flights_Aircraft1_idx` (`AircraftID` ASC) VISIBLE,
  INDEX `fk_Flights_Schedule1_idx` (`ScheduleID` ASC) VISIBLE,
  INDEX `fk_Flights_Fares1_idx` (`FareID` ASC) VISIBLE,
  INDEX `fk_Flights_Route1_idx` (`RouteID` ASC) VISIBLE,
  CONSTRAINT `fk_Flights_Aircraft1`
    FOREIGN KEY (`AircraftID`)
    REFERENCES `HawkAir`.`Aircrafts` (`AircraftID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Flights_Schedule1`
    FOREIGN KEY (`ScheduleID`)
    REFERENCES `HawkAir`.`Schedule` (`ScheduleID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Flights_Fares1`
    FOREIGN KEY (`FareID`)
    REFERENCES `HawkAir`.`Fares` (`FareID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Flights_Route1`
    FOREIGN KEY (`RouteID`)
    REFERENCES `HawkAir`.`Route` (`RouteID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `HawkAir`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Bookings` (
  `BookingID` VARCHAR(6) NOT NULL,
  `UserID` INT NOT NULL,
  INDEX `fk_Booking_UserInformation1_idx` (`UserID` ASC) VISIBLE,
  PRIMARY KEY (`BookingID`),
  CONSTRAINT `fk_Booking_UserInformation1`
    FOREIGN KEY (`UserID`)
    REFERENCES `HawkAir`.`Users` (`UserID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `HawkAir`.`Payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Payments` (
  `UserID` INT NOT NULL,
  `CardNumber` VARCHAR(16) NOT NULL,
  `CardType` VARCHAR(10) NOT NULL,
  `ExpirationDateMonth` SMALLINT NOT NULL,
  `ExpirationDateYear` SMALLINT NOT NULL,
  `CVV` SMALLINT NOT NULL,
  `Name` VARCHAR(100) NOT NULL,
  INDEX `fk_Payment_Users1_idx` (`UserID` ASC) VISIBLE,
  PRIMARY KEY (`CardNumber`),
  CONSTRAINT `fk_Payment_Users1`
    FOREIGN KEY (`UserID`)
    REFERENCES `HawkAir`.`Users` (`UserID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `HawkAir`.`Admin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Admin` (
  `Username` VARCHAR(45) NOT NULL,
  `Password` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`Username`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `HawkAir`.`ContactUs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`ContactUs` (
  `Phone` VARCHAR(20) NOT NULL,
  `Email` VARCHAR(100) NOT NULL,
  `Company` VARCHAR(45) NOT NULL,
  `Street` VARCHAR(45) NOT NULL,
  `City` VARCHAR(45) NOT NULL,
  `State` VARCHAR(45) NOT NULL,
  `ZipCode` VARCHAR(45) NOT NULL,
  `Country` VARCHAR(45) NOT NULL)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `HawkAir`.`News`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`News` (
  `Headline` TEXT NOT NULL,
  `Date` DATE NOT NULL,
  `Picture` TEXT NOT NULL,
  `Content` TEXT NOT NULL)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `HawkAir`.`MultipleBookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`MultipleBookings` (
  `BookingID` VARCHAR(6) NOT NULL,
  `Passenger` VARCHAR(100) NOT NULL,
  `Class` VARCHAR(20) NOT NULL,
  `SeatNumber` VARCHAR(5) NOT NULL,
  `FlightID` VARCHAR(6) NOT NULL,
  `FlightDate` DATE NOT NULL,
  INDEX `fk_MultipleBookings_Bookings1_idx` (`BookingID` ASC) VISIBLE,
  CONSTRAINT `fk_MultipleBookings_Bookings1`
    FOREIGN KEY (`BookingID`)
    REFERENCES `HawkAir`.`Bookings` (`BookingID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,  
    CONSTRAINT `fk_MultipleBooking_Flights1`
    FOREIGN KEY (`FlightID`)
    REFERENCES `HawkAir`.`Flights` (`FlightID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `HawkAir`.`SecurityQuestion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`SecurityQuestion` (
  `SecurityQuestionID` INT NOT NULL AUTO_INCREMENT,
  `SecurityQuestion` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`SecurityQuestionID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `HawkAir`.`Login`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Login` (
  `Username` VARCHAR(45) NOT NULL,
  `Password` VARCHAR(64) NOT NULL,
  `UserID` INT NOT NULL,
  `Email` VARCHAR(100) NOT NULL,
  `SecurityQuestionID` INT NOT NULL,
  `SecurityAnswer` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Username`),
  INDEX `fk_Login_SecurityQuestion1_idx` (`SecurityQuestionID` ASC) VISIBLE,
  INDEX `fk_Login_Users1_idx` (`UserID` ASC) VISIBLE,
  CONSTRAINT `fk_Login_SecurityQuestion1`
    FOREIGN KEY (`SecurityQuestionID`)
    REFERENCES `HawkAir`.`SecurityQuestion` (`SecurityQuestionID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Login_Users1`
    FOREIGN KEY (`UserID`)
    REFERENCES `HawkAir`.`Users` (`UserID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `HawkAir`.`HawkAdvantage`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`HawkAdvantage` (
  `UserID` INT NOT NULL,
  `Miles` INT NOT NULL DEFAULT 0,
  INDEX `fk_HawkAdvantage_Users1_idx` (`UserID` ASC) VISIBLE,
  CONSTRAINT `fk_HawkAdvantage_Users1`
    FOREIGN KEY (`UserID`)
    REFERENCES `HawkAir`.`Users` (`UserID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Triggers
-- -----------------------------------------------------

CREATE TRIGGER  trigger_flights_delete
BEFORE DELETE ON schedule FOR EACH ROW 
    DELETE FROM schedule
    WHERE ScheduleID = OLD.ScheduleID;

CREATE TRIGGER  trigger_Multiplebookings_users_insert
AFTER INSERT ON Multiplebookings FOR EACH ROW 
    UPDATE Hawkadvantage set
	Hawkadvantage.miles = IF(new.class = 'First Class',
        Hawkadvantage.miles + floor((select PriceFirstClass from Fares where Fares.FareID = 
									(select FareID from Flights where Flights.FlightID = new.FlightID))/10),
        Hawkadvantage.miles + floor((select PriceEconomy from Fares where Fares.FareID = 
									(select FareID from Flights where Flights.FlightID = new.FlightID))/10))
    WHERE (select UserID from Bookings where Bookings.BookingID = NEW.BookingID) = Hawkadvantage.UserID;

CREATE TRIGGER  trigger_Multiplebookings_users_delete
BEFORE DELETE ON Multiplebookings FOR EACH ROW 
    UPDATE Hawkadvantage set
	Hawkadvantage.miles = IF(OLD.class = 'First Class',
        Hawkadvantage.miles - floor((select PriceFirstClass from Fares where Fares.FareID = 
									(select FareID from Flights where Flights.FlightID = old.FlightID))/10),
        Hawkadvantage.miles - floor((select PriceEconomy from Fares where Fares.FareID = 
									(select FareID from Flights where Flights.FlightID = old.FlightID))/10))
    WHERE (select UserID from Bookings where Bookings.BookingID = OLD.BookingID) = Hawkadvantage.UserID and
		   CURDATE() < old.FlightDate;


-- -----------------------------------------------------
-- Events
-- -----------------------------------------------------
CREATE EVENT  event_remove_bookings
ON SCHEDULE
	EVERY 1 DAY
    STARTS (CURDATE() + INTERVAL 1 DAY + INTERVAL 5 MINUTE)
    DO
    DELETE FROM bookings
    WHERE bookings.FlightDate < CURDATE();

-- -----------------------------------------------------
-- Insert Statements
-- -----------------------------------------------------
INSERT INTO `HawkAir`.`Address` VALUES
(NULL,'1087 Windy Ridge Road','Fort Wayne','46802','IN','United States'),
(NULL,'1345 Lewis Street','Bensenville','60106','IL','United States'),
(NULL,'900 Vesta Drive','Chicago','60631','IL','United States'),
(NULL,'3033 West Drive','Chicago','60661','IL','United States'),
(NULL,'680 Mutton Town Road','Centralia','98531','WA','United States');

INSERT INTO `HawkAir`.`Users` VALUES
(NULL,'','Roger','','McCubbin','','Male','1980-01-21',1,'260-579-8310'),
(NULL,'Ms.','Linda','','Knox','','Female','1970-10-12',2,'630-875-1041'),
(NULL,'','Jessica','','McCarthy','Jess','Female','1975-08-05',3,'773-727-5516'),
(NULL,'Mr.','Howard','William','Doublas','','Male','1976-06-06',4,'312-525-7519'),
(NULL,'','Amanda','','Lewis','','Female','1994-08-03',5,'360-623-1953');

INSERT INTO `HawkAir`.`SecurityQuestion` VALUES
(NULL,'What was your favorite sport in high school?'),
(NULL,'What is your pet''s name?'),
(NULL,'In what city were you born?'),
(NULL,'What was the color of your first car?'),
(NULL, 'What is your favorite team?');

INSERT INTO `HawkAir`.`Login` VALUES
('Quinnow','e45582512e2f8d730ce143a7c5021ef412b87ed7ea6eb5d32ffa64087bb3df69',1,'roger-mccubbin1946@yahoo.com',1,'Football'),
('Houghmed','75b1d1b804e4bb41b457f521508a01b870e1382370ef8f10a1f7442a13621007',2,'LindaJKnox@teleworm.us',2,'Simba'),
('Hatc1999','011bc4bea60b31e6181e5ff5e4036245b19d11de51f0f815e11e241d680b5bc1',3,'jessicamccarthy99@amazon.com',3,'Chicago'),
('Waseat','b3227450338443d6eb075389aa425ab21312178035b62996b842f43985f5e78e',4,'howdougl@gmail.com',4,'Red'),
('Crinsonast','6a8ea85ce30bbb416b31b1aaaf9ef67ac6b5373a199698d999827565736a8267',5,'ama-lewis@amazon.com',5,'Packers');

INSERT INTO `HawkAir`.`HawkAdvantage` VALUES
(1,0),
(2,0),
(3,0),
(4,0),
(5,0);

INSERT INTO `HawkAir`.`Airports` VALUES
('ORD','Chicago O''Hare International','Chicago','IL','United States'),
('LAX','Los Angeles International','Los Angeles','CA','United States'),
('JFK','John F Kennedy International','New York','NY','United States'),
('DEN','Denver International','Denver','CO','United States'),
('MIA','Miami International','Miami','FL','United States'),
('CID','Eastern Iowa Airport','Cedar Rapids','IA','United States');

INSERT INTO `HawkAir`.`Aircrafts` VALUES
('Airbus 319',96,8),
('Airbus 330',152,20),
('Boeing 737',126,16),
('Boeing 787',158,20),
('CRJ 700',48,8);

-- Flights for testing one way and multi-city flights
-- ORD -> LAX
-- ORD -> DEN, ORD -> DEN, ORD -> DEN
INSERT INTO `HawkAir`.`Route` VALUES
(1,'ORD','LAX','2:08'),
(2,'ORD','DEN','1:52'),
(3,'DEN','ORD','1:52');


INSERT INTO `HawkAir`.`Fares` VALUES
(NULL,350,650),
(NULL,160,240),
(NULL,170,250),
(NULL,150,280),
(NULL,195,270);


INSERT INTO `HawkAir`.`Schedule` VALUES
(1,1,1,1,1,1,1,1);

INSERT INTO `HawkAir`.`Flights` VALUES
('AA2470','Airbus 319',1,1,1,'18:00','On time'),
('AA4594','Airbus 330',2,1,2,'7:57','On time'),
('AA5144','Airbus 330',2,1,3,'14:57','On time'),
('AA8623','Airbus 330',2,1,4,'19:25','On time'),
('AA3287','Airbus 330',3,1,5,'12:30','On time');


/*
-- Flights for testing round trips
INSERT INTO `HawkAir`.`Flights` VALUES
-- CID -> ORD, ORD -> CID
('AA8901','Airbus 319','CID','ORD',1,'6:00','0:50','On time',130,230),
('AA2419','Airbus 319','ORD','CID',1,'8:20','0:50','On time',160,240),
-- CID -> ORD-> JFK, JFK -> ORD -> CID
('AA6846','Boeing 737','ORD','JFK',1,'8:45','2:40','On time',230,520),
('AA5572','Boeing 737','JFK','ORD',1,'12:50','2:40','On time',250,540),
('AA9912','Airbus 319','ORD','CID',1,'17:15','0:50','On time',145,255),
-- CID -> ORD -> JFK -> MIA, MIA -> JFK -> ORD -> CID
('AA6881','Boeing 787','JFK','MIA',1,'12:50','2:00','On time',340,780),
('AA1320','Boeing 787','MIA','JFK',1,'16:05','2:00','On time',355,660),
('AA2711','Boeing 737','JFK','ORD',1,'19:35','2:40','On time',310,490),
('AA8321','Airbus 319','ORD','CID',1,'22:20','0:50','On time',120,270);
*/


INSERT INTO `HawkAir`.`Bookings` VALUES
('ABCDEF',1),
('QWERTY',2),
('ASDFGH',3),
('ZXCVBN',3);

INSERT INTO `HawkAir`.`MultipleBookings` VALUES
('ABCDEF','Roger McCubbin','First Class',20,'AA2470','2020-05-24'),
('QWERTY','Linda Knox','First Class',10,'AA2470','2020-05-21'),
('ASDFGH','Jessica McCarthy','First Class',6,'AA8623','2020-05-19'),
('ZXCVBN','Jessica McCarthy','Economy',88,'AA3287','2020-05-31');

-- Login: admin
-- Password: password
INSERT INTO `HawkAir`.`Admin` VALUES
('admin','5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8');

INSERT INTO `HawkAir`.`News` VALUES
('May Vacation Sale','2020-04-17','/static/images/vacations.png','Save and earn up to 25\,000 bonus miles when you book your flight and hotel together! MileagePlus is your ticket to the world\, with the most ways to earn and use miles and the most award destinations of any U.S. airline loyalty program. Now all you need is more vacation days.'),
('Rent a Car with Budget','2020-04-03','/static/images/car.png','Save up to 35% off base rates and earn miles. Reserve a car today! No matter the destination\, enjoy a trip that delivers more savings. Save up to 30% off of Budget base rates and earn 1\,000 AAdvantage bonus miles when you rent for 4 or more days.'),
('Fly Nonstop to Poland','2020-03-25','/static/images/poland.png','New service to Krakow from Chicago O''Hare start May 7. Search and book your flights! Pack your bags and explore Europe! Take advantage of great fares and low exchange rates and save first on flights and again on hotels\, dining and shopping when you get there.'),
('New Flights to Latin America','2020-03-19','/static/images/latinamerica.png','From a remote beach getaway to modern\, bustling cities\, you''re bound to discover new and exciting places and ideas. Shop Main Cabin deals to Latin America and the Caribbean.'),
('Vacation Smarter','2020-03-06','/static/images/savings.png','Go beyond the flight. For a limited time\, SkyMiles Members save up to $350 on any Delta Vacations package worldwide. Plus\, earn bonus miles & use miles on the best getaways\, curated just for you. Terms apply.');

INSERT INTO `HawkAir`.`ContactUs` VALUES
('HawkAir','2 West Washington St.','Iowa City','IA','52242','United States','319-834-0276','hawkair2020@gmail.com');