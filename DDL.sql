-- -----------------------------------------------------
-- Schema HawkAir
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `HawkAir`;
CREATE SCHEMA IF NOT EXISTS `HawkAir` DEFAULT CHARACTER SET utf8;
USE `HawkAir`;

SET autocommit = OFF;

-- -----------------------------------------------------
-- Table `HawkAir`.`Titles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Titles` (
    `TitleID` INT NOT NULL,
    `Title` VARCHAR(3) NOT NULL,
    PRIMARY KEY (`TitleID`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `HawkAir`.`SecurityQuestions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`SecurityQuestions` (
    `SecurityQuestionID` INT NOT NULL AUTO_INCREMENT,
    `SecurityQuestion` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`SecurityQuestionID`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `HawkAir`.`Users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Users` (
    `UserID` INT NOT NULL AUTO_INCREMENT,
    `TitleID` INT NOT NULL,
    `FirstName` VARCHAR(45) NOT NULL,
    `MiddleName` VARCHAR(45) NULL,
    `LastName` VARCHAR(45) NOT NULL,
    `PreferredName` VARCHAR(45) NULL,
    `Sex` VARCHAR(6) NOT NULL,
    `DOB` DATE NOT NULL,
    `Phone` VARCHAR(20) NOT NULL,
    `Email` VARCHAR(100) NOT NULL,
    `Username` VARCHAR(45) NOT NULL,
    `Password` VARCHAR(64) NOT NULL,
    `SecurityQuestionID` INT NOT NULL,
    `SecurityAnswer` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`UserID`),
    INDEX `fk_Users_Titles1_idx` (`TitleID` ASC) VISIBLE,
    INDEX `fk_Users_SecurityQuestions1_idx` (`SecurityQuestionID` ASC) VISIBLE,
    CONSTRAINT `fk_Users_Titles1`
        FOREIGN KEY (`TitleID`)
        REFERENCES `HawkAir`.`Titles` (`TitleID`)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT `fk_Users_SecurityQuestions1`
        FOREIGN KEY (`SecurityQuestionID`)
        REFERENCES `HawkAir`.`SecurityQuestions` (`SecurityQuestionID`)
        ON DELETE RESTRICT
        ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 100001;

-- -----------------------------------------------------
-- Table `HawkAir`.`Addresses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Addresses` (
    `UserID` INT NOT NULL,
    `Street` VARCHAR(100) NOT NULL,
    `City` VARCHAR(45) NOT NULL,
    `ZipCode` VARCHAR(10) NOT NULL,
    `State` VARCHAR(45) NULL,
    `Country` VARCHAR(45) NOT NULL,
    INDEX `fk_Addresses_Users1_idx` (`UserID` ASC) VISIBLE,
    CONSTRAINT `fk_Addresses_Users1`
        FOREIGN KEY (`UserID`)
        REFERENCES `HawkAir`.`Users` (`UserID`)
        ON DELETE CASCADE
        ON UPDATE CASCADE)
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
-- Table `HawkAir`.`Aircrafts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Aircrafts` (
    `AircraftID` VARCHAR(20) NOT NULL,
    `EconomySeats` SMALLINT NOT NULL,
    `FirstClassSeats` SMALLINT NOT NULL,
    PRIMARY KEY (`AircraftID`))
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
-- Table `HawkAir`.`Schedules`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Schedules` (
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
-- Table `HawkAir`.`Routes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Routes` (
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
        REFERENCES `HawkAir`.`Schedules` (`ScheduleID`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `fk_Flights_Fares1`
        FOREIGN KEY (`FareID`)
        REFERENCES `HawkAir`.`Fares` (`FareID`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `fk_Flights_Route1`
        FOREIGN KEY (`RouteID`)
        REFERENCES `HawkAir`.`Routes` (`RouteID`)
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
        ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `HawkAir`.`MultipleBookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`MultipleBookings` (
    `BookingID` VARCHAR(6) NOT NULL,
    `FlightID` VARCHAR(6) NOT NULL,
    `FlightDate` DATE NOT NULL,
    `Passenger` VARCHAR(100) NOT NULL,
    `Class` VARCHAR(20) NOT NULL,
    `SeatNumber` VARCHAR(5) NOT NULL,
    INDEX `fk_MultipleBookings_Bookings1_idx` (`BookingID` ASC) VISIBLE,
    INDEX `fk_MultipleBookings_Flights1_idx` (`FlightID` ASC) VISIBLE,
    CONSTRAINT `fk_MultipleBookings_Bookings1`
        FOREIGN KEY (`BookingID`)
        REFERENCES `HawkAir`.`Bookings` (`BookingID`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `fk_MultipleBookings_Flights1`
        FOREIGN KEY (`FlightID`)
        REFERENCES `HawkAir`.`Flights` (`FlightID`)
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
-- Table `HawkAir`.`News`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`News` (
    `Headline` TEXT NOT NULL,
    `Date` DATE NOT NULL,
    `Picture` TEXT NOT NULL,
    `Content` TEXT NOT NULL)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `HawkAir`.`ContactUs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`ContactUs` (
    `Company` VARCHAR(45) NOT NULL,
    `Street` VARCHAR(45) NOT NULL,
    `City` VARCHAR(45) NOT NULL,
    `State` VARCHAR(45) NOT NULL,
    `ZipCode` VARCHAR(45) NOT NULL,
    `Country` VARCHAR(45) NOT NULL,
    `Phone` VARCHAR(20) NOT NULL,
    `Email` VARCHAR(100) NOT NULL)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Triggers
-- -----------------------------------------------------
CREATE TRIGGER trigger_multiplebookings_users_insert
AFTER INSERT ON multiplebookings FOR EACH ROW
    UPDATE hawkadvantage SET
	hawkadvantage.miles = IF(NEW.class = 'First Class',
        hawkadvantage.miles + floor((SELECT PriceFirstClass FROM fares WHERE fares.FareID = 
									(SELECT FareID FROM flights WHERE flights.FlightID = NEW.FlightID))/10),
        Hawkadvantage.miles + floor((SELECT PriceEconomy FROM fares WHERE fares.FareID = 
									(SELECT FareID FROM flights WHERE flights.FlightID = NEW.FlightID))/10))
    WHERE (SELECT UserID FROM bookings WHERE bookings.BookingID = NEW.BookingID) = hawkadvantage.UserID;

CREATE TRIGGER trigger_multiplebookings_users_delete
BEFORE DELETE ON multiplebookings FOR EACH ROW
    UPDATE hawkadvantage SET
	hawkadvantage.miles = IF(OLD.class = 'First Class',
        hawkadvantage.miles - floor((SELECT PriceFirstClass FROM fares WHERE fares.FareID = 
									(SELECT FareID FROM flights WHERE flights.FlightID = OLD.FlightID))/10),
        hawkadvantage.miles - floor((SELECT PriceEconomy FROM fares WHERE fares.FareID = 
									(SELECT FareID FROM flights WHERE flights.FlightID = OLD.FlightID))/10))
    WHERE (SELECT UserID FROM bookings WHERE bookings.BookingID = OLD.BookingID) = hawkadvantage.UserID AND CURDATE() < OLD.FlightDate;

-- -----------------------------------------------------
-- Events
-- -----------------------------------------------------
CREATE EVENT  event_remove_bookings
ON SCHEDULE EVERY 1 DAY
    STARTS (CURDATE() + INTERVAL 1 DAY + INTERVAL 5 MINUTE)
    DO
    DELETE FROM bookings
    WHERE bookings.FlightDate < CURDATE();

-- -----------------------------------------------------
-- Insert Statements
-- -----------------------------------------------------
INSERT INTO `HawkAir`.`Titles` VALUES
(1,''),
(2,'Mr'),
(3,'Ms'),
(4,'Mrs'),
(5,'Mx');

INSERT INTO `HawkAir`.`SecurityQuestions` VALUES
(1,'What was your favorite sport in high school?'),
(2,'What is your pet''s name?'),
(3,'In what city were you born?'),
(4,'What was the color of your first car?'),
(5, 'What is your favorite team?');

INSERT INTO `HawkAir`.`Users` VALUES
(100001,1,'Roger','','McCubbin','','Male','1980-01-21','260-579-8310','roger-mccubbin1946@yahoo.com','Quinnow','e45582512e2f8d730ce143a7c5021ef412b87ed7ea6eb5d32ffa64087bb3df69',1,'Football'),
(100002,3,'Linda','','Knox','','Female','1970-10-12','630-875-1041','LindaJKnox@teleworm.us','Houghmed','75b1d1b804e4bb41b457f521508a01b870e1382370ef8f10a1f7442a13621007',2,'Simba'),
(100003,1,'Jessica','','McCarthy','Jess','Female','1975-08-05','773-727-5516','jessicamccarthy99@amazon.com','Hatc1999','011bc4bea60b31e6181e5ff5e4036245b19d11de51f0f815e11e241d680b5bc1',3,'Chicago'),
(100004,2,'Howard','William','Doublas','','Male','1976-06-06','312-525-7519','howdougl@gmail.com','Waseat','b3227450338443d6eb075389aa425ab21312178035b62996b842f43985f5e78e',3,'Red'),
(100005,1,'Amanda','','Lewis','','Female','1994-08-03','360-623-1953','ama-lewis@amazon.com','Crinsonast','6a8ea85ce30bbb416b31b1aaaf9ef67ac6b5373a199698d999827565736a8267',5,'Packers');

INSERT INTO `HawkAir`.`Addresses` VALUES
(100001,'1087 Windy Ridge Road','Fort Wayne','46802','IN','United States'),
(100002,'1345 Lewis Street','Bensenville','60106','IL','United States'),
(100003,'900 Vesta Drive','Chicago','60631','IL','United States'),
(100004,'3033 West Drive','Chicago','60661','IL','United States'),
(100005,'680 Mutton Town Road','Centralia','98531','WA','United States');

INSERT INTO `HawkAir`.`HawkAdvantage` VALUES
(100001,0),
(100002,0),
(100003,0),
(100004,0),
(100005,0);

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

INSERT INTO `HawkAir`.`Schedules` VALUES
(1,1,1,1,1,1,1,1),
(2,1,1,1,1,1,0,0),
(3,1,0,1,0,1,1,1),
(4,1,0,1,0,1,0,0);

INSERT INTO `HawkAir`.`Fares` VALUES
(1,350,650),
(2,160,240),
(3,170,250),
(4,150,280),
(5,195,270),
(6,130,230),
(7,160,240),
(8,230,520),
(9,250,540),
(10,145,255),
(11,340,780),
(12,355,660),
(13,310,490),
(14,120,270);

-- Flights for testing one way and multi-city flights
-- ORD -> LAX
-- ORD -> DEN, ORD -> DEN, ORD -> DEN
-- DEN -> ORD
INSERT INTO `HawkAir`.`Routes` VALUES
(1,'ORD','LAX','2:08'),
(2,'ORD','DEN','1:52'),
(3,'DEN','ORD','1:52');

INSERT INTO `HawkAir`.`Flights` VALUES
('AA2470','Airbus 319',1,1,1,'18:00','On time'),
('AA4594','Airbus 330',2,1,2,'7:57','On time'),
('AA5144','Airbus 330',2,1,3,'14:57','On time'),
('AA8623','Airbus 330',2,1,4,'19:25','On time'),
('AA3287','Airbus 330',3,1,5,'12:30','On time');

-- Flights for testing round trips
INSERT INTO `HawkAir`.`Routes` VALUES
(4,'CID','ORD','0:50'),
(5,'ORD','CID','0:50'),
(6,'ORD','JFK','2:40'),
(7,'JFK','ORD','2:40'),
(8,'JFK','MIA','2:00'),
(9,'MIA','JFK','2:00');

INSERT INTO `HawkAir`.`Flights` VALUES
-- CID -> ORD, ORD -> CID
('AA8901','Airbus 319',4,1,6,'6:00','On time'),
('AA2419','Airbus 319',5,1,7,'8:20','On time'),
-- CID -> ORD-> JFK, JFK -> ORD -> CID
('AA6846','Boeing 737',6,1,8,'8:45','On time'),
('AA5572','Boeing 737',7,1,9,'12:50','On time'),
('AA9912','Airbus 319',5,1,10,'17:15','On time'),
-- CID -> ORD -> JFK -> MIA, MIA -> JFK -> ORD -> CID
('AA6881','Boeing 787',8,1,11,'12:50','On time'),
('AA1320','Boeing 787',9,1,12,'16:05','On time'),
('AA2711','Boeing 737',7,1,13,'19:35','On time'),
('AA8321','Airbus 319',5,1,14,'22:20','On time');

INSERT INTO `HawkAir`.`Bookings` VALUES
('ABCDEF',100001),
('QWERTY',100002),
('ASDFGH',100003),
('ZXCVBN',100003);

INSERT INTO `HawkAir`.`MultipleBookings` VALUES
('ABCDEF','AA2470','2020-05-24','Roger McCubbin','First Class','5A'),
('QWERTY','AA2470','2020-05-21','Linda Knox','First Class','10A'),
('ASDFGH','AA8623','2020-05-19','Jessica McCarthy','First Class','15A'),
('ZXCVBN','AA3287','2020-05-31','Jessica McCarthy','Economy','20A');

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