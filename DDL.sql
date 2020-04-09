-- -----------------------------------------------------
-- Schema HawkAir
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `HawkAir`;
CREATE SCHEMA `HawkAir` DEFAULT CHARACTER SET utf8;
USE `HawkAir`;

-- -----------------------------------------------------
-- Table `HawkAir`.`Users`
-- -----------------------------------------------------
CREATE TABLE `HawkAir`.`Users` (
    `UserID` INT AUTO_INCREMENT,
    `Title` VARCHAR(3) NOT NULL,
    `FirstName` VARCHAR(45) NOT NULL,
    `MiddleName` VARCHAR(45) NOT NULL,
    `LastName` VARCHAR(45) NOT NULL,
    `PreferredName` VARCHAR(45) NOT NULL,
    `Sex` VARCHAR(6) NOT NULL,
    `DOB` DATE NOT NULL,
    `Street` VARCHAR(100) NOT NULL,
    `City` VARCHAR(45) NOT NULL,
    `ZipCode` VARCHAR(10) NOT NULL,
    `State` VARCHAR(45),
    `Country` VARCHAR(45) NOT NULL,
    `Phone` VARCHAR(20) NOT NULL,
    `Email` VARCHAR(100) NOT NULL,
    `Username` VARCHAR(45) NOT NULL,
    `Password` VARCHAR(64) NOT NULL,
    `SecurityQuestion` VARCHAR(100) NOT NULL,
    `SecurityAnswer` VARCHAR(45) NOT NULL,
    `HawkAdvantage` TINYINT(1) DEFAULT 1,
    `Miles` INT DEFAULT 0,
    PRIMARY KEY (`UserID`, `Email`, `Password`))
ENGINE = InnoDB AUTO_INCREMENT=100001;

-- -----------------------------------------------------
-- Table `HawkAir`.`Payments`
-- -----------------------------------------------------
CREATE TABLE `HawkAir`.`Payments` (
    `CardNumber` VARCHAR(16) NOT NULL,
    `CardType` VARCHAR(10) NOT NULL,
    `ExpirationDateMonth` SMALLINT NOT NULL,
    `ExpirationDateYear` SMALLINT NOT NULL,
    `CVV` SMALLINT NOT NULL,
    `Name` VARCHAR(100) NOT NULL,
    `UserID` INT NOT NULL,
	CONSTRAINT `fk_Payment_Users1`
        FOREIGN KEY (`UserID`)
        REFERENCES `HawkAir`.`Users` (`UserID`)
        ON DELETE CASCADE
        ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `HawkAir`.`Airports`
-- -----------------------------------------------------
CREATE TABLE `HawkAir`.`Airports` (
    `Code` VARCHAR(3) NOT NULL,
    `Name` VARCHAR(45) NOT NULL,
    `City` VARCHAR(45) NOT NULL,
    `State` VARCHAR(45),
    `Country` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`Code`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `HawkAir`.`Aircrafts`
-- -----------------------------------------------------
CREATE TABLE `HawkAir`.`Aircrafts` (
    `AircraftID` VARCHAR(20) NOT NULL,
    `TotalEconomySeats` SMALLINT NOT NULL,
    `TotalFirstClassSeats` SMALLINT NOT NULL,
    PRIMARY KEY (`AircraftID`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `HawkAir`.`Flights`
-- -----------------------------------------------------
CREATE TABLE `HawkAir`.`Flights` (
    `FlightID` VARCHAR(6) NOT NULL,
    `AircraftID` VARCHAR(20) NOT NULL,
    `From` VARCHAR(3) NOT NULL,
    `To` VARCHAR(3) NOT NULL,
    `DepartTime` TIME NOT NULL,
    `Duration` TIME NOT NULL,
    `FlightStatus` VARCHAR(20) DEFAULT 'On Time',
    `PriceEconomy` MEDIUMINT NOT NULL,
    `PriceFirstClass` MEDIUMINT NOT NULL,
    PRIMARY KEY (`FlightID`),
    CONSTRAINT `fk_Flights_Airports1`
        FOREIGN KEY (`To`)
        REFERENCES `HawkAir`.`Airports` (`Code`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `fk_Flights_Airports2`
        FOREIGN KEY (`From`)
        REFERENCES `HawkAir`.`Airports` (`Code`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `fk_Flights_Aircraft1`
        FOREIGN KEY (`AircraftID`)
        REFERENCES `HawkAir`.`Aircrafts` (`AircraftID`)
        ON DELETE CASCADE
        ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `HawkAir`.`Schedule`
-- -----------------------------------------------------
CREATE TABLE `HawkAir`.`Schedule` (
    `Monday` TINYINT(1) NOT NULL,
    `Tuesday` TINYINT(1) NOT NULL,
    `Wednesday` TINYINT(1) NOT NULL,
    `Thursday` TINYINT(1) NOT NULL,
    `Friday` TINYINT(1) NOT NULL,
    `Saturday` TINYINT(1) NOT NULL,
    `Sunday` TINYINT(1) NOT NULL,
    `FlightID` VARCHAR(6) NOT NULL,
	CONSTRAINT `fk_Schedule_Flights1`
        FOREIGN KEY (`FlightID`)
        REFERENCES `HawkAir`.`Flights` (`FlightID`)
        ON DELETE CASCADE
        ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `HawkAir`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE `HawkAir`.`Bookings` (
    `BookingID` VARCHAR(6) NOT NULL,
    `Passenger` VARCHAR(100) NOT NULL,
    `FlightDate` DATE NOT NULL,
    `Class` VARCHAR(20) NOT NULL,
    `SeatNumber` VARCHAR(5),
    `UserID` INT NOT NULL,
    `FlightID` VARCHAR(6) NOT NULL,
    CONSTRAINT `fk_Booking_UserInformation1`
        FOREIGN KEY (`UserID`)
        REFERENCES `HawkAir`.`Users` (`UserID`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `fk_Booking_Flights1`
        FOREIGN KEY (`FlightID`)
        REFERENCES `HawkAir`.`Flights` (`FlightID`)
        ON DELETE CASCADE
        ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `HawkAir`.`Admin`
-- -----------------------------------------------------
CREATE TABLE `HawkAir`.`Admin` (
    `Username` VARCHAR(45) NOT NULL,
    `Password` VARCHAR(64) NOT NULL,
    PRIMARY KEY (`Username`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `HawkAir`.`News`
-- -----------------------------------------------------
CREATE TABLE `HawkAir`.`News` (
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
    `Street` VARCHAR(100) NOT NULL,
    `City` VARCHAR(45) NOT NULL,
    `State` VARCHAR(45) NOT NULL,
    `ZipCode` VARCHAR(10) NOT NULL,
    `Country` VARCHAR(45) NOT NULL,
    `Phone` VARCHAR(20) NOT NULL,
    `Email` VARCHAR(100) NOT NULL)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Triggers
-- -----------------------------------------------------

CREATE TRIGGER  trigger_schedule_delete
BEFORE DELETE ON schedule FOR EACH ROW 
    DELETE FROM flights
    WHERE FlightID = OLD.FlightID;

CREATE TRIGGER  trigger_booking_users_insert
AFTER INSERT ON bookings FOR EACH ROW 
    UPDATE users,flights set
	users.miles = IF(new.class = 'First Class',
        users.miles + floor(flights.PriceFirstClass/10),
        users.miles + floor(flights.PriceEconomy/10))
    WHERE NEW.UserID = users.UserID and NEW.FlightID = flights.FlightID;

CREATE TRIGGER  trigger_booking_users_delete
BEFORE DELETE ON bookings FOR EACH ROW 
    UPDATE users,flights set
	users.miles = IF(OLD.class = 'First Class',
        users.miles - floor(flights.PriceFirstClass/10),
        users.miles - floor(flights.PriceEconomy/10))
    WHERE OLD.UserID = users.UserID and OLD.FlightID = flights.FlightID and CURDATE() < OLD.FlightDate;

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
INSERT INTO `HawkAir`.`Users` VALUES
(NULL,'','Roger','','McCubbin','','Male','1980-01-21','1087 Windy Ridge Road','Fort Wayne','46802','IN','United States','260-579-8310','roger-mccubbin1946@yahoo.com','Quinnow','e45582512e2f8d730ce143a7c5021ef412b87ed7ea6eb5d32ffa64087bb3df69','What was your favorite sport in high school?','Football',1,0),
(NULL,'Ms.','Linda','','Knox','','Female','1970-10-12','1345 Lewis Street','Bensenville','60106','IL','United States','630-875-1041','LindaJKnox@teleworm.us','Houghmed','75b1d1b804e4bb41b457f521508a01b870e1382370ef8f10a1f7442a13621007','What is your pet''s name?','Simba',1,0),
(NULL,'','Jessica','','McCarthy','Jess','Female','1975-08-05','900 Vesta Drive','Chicago','60631','IL','United States','773-727-5516','jessicamccarthy99@amazon.com','Hatc1999','011bc4bea60b31e6181e5ff5e4036245b19d11de51f0f815e11e241d680b5bc1','In what city were you born?','Chicago',1,0),
(NULL,'Mr.','Howard','William','Doublas','','Male','1976-06-06','3033 West Drive','Chicago','60661','IL','United States','312-525-7519','howdougl@gmail.com','Waseat','b3227450338443d6eb075389aa425ab21312178035b62996b842f43985f5e78e','What was the color of your first car?','Red',1,0),
(NULL,'','Amanda','','Lewis','','Female','1994-08-03','680 Mutton Town Road','Centralia','98531','WA','United States','360-623-1953','ama-lewis@amazon.com','Crinsonast','6a8ea85ce30bbb416b31b1aaaf9ef67ac6b5373a199698d999827565736a8267','What is your favorite team?','Packers',1,0);

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
INSERT INTO `HawkAir`.`Flights` VALUES
('AA2470','Airbus 319','ORD','LAX',1,'18:00','2:08','On time',350,650),
('AA4594','Airbus 330','ORD','DEN',1,'7:57','1:52','On time',160,240),
('AA5144','Airbus 330','ORD','DEN',1,'14:57','1:52','On time',170,250),
('AA8623','Airbus 330','ORD','DEN',1,'19:25','1:52','On time',150,280),
('AA3287','Airbus 330','DEN','ORD',1,'12:30','1:52','On time',195,270);

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

INSERT INTO `HawkAir`.`Schedule` VALUES
(1,1,1,1,1,1,1,1);

INSERT INTO `HawkAir`.`Bookings` VALUES
('ABCDEF','Roger McCubbin','2020-03-24','First Class',NULL,100001,'AA2470'),
('QWERTY','Linda Knox','2020-03-21','First Class',NULL,100002,'AA2470'),
('ASDFGH','Jessica McCarthy','2020-03-19','First Class',NULL,100003,'AA8901'),
('ZXCVBN','Jessica McCarthy','2020-03-31','Economy',NULL,100003,'AA2419');

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