-- -----------------------------------------------------
-- Schema HawkAir
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `HawkAir` ;
CREATE SCHEMA `HawkAir` DEFAULT CHARACTER SET utf8 ;
USE `HawkAir` ;

-- -----------------------------------------------------
-- Table `HawkAir`.`Users`
-- -----------------------------------------------------
CREATE TABLE `HawkAir`.`Users` (
    `UserID` INT NOT NULL AUTO_INCREMENT,
    `Title` VARCHAR(6) NOT NULL,
    `FirstName` VARCHAR(45) NOT NULL,
    `MiddleName` VARCHAR(45) NOT NULL,
    `LastName` VARCHAR(45) NOT NULL,
    `PreferredName` VARCHAR(45) NOT NULL,
    `Sex` VARCHAR(6) NOT NULL,
    `DOB` DATE NOT NULL,
    `Street` VARCHAR(100) NOT NULL,
    `City` VARCHAR(45) NOT NULL,
    `ZipCode` VARCHAR(10) NOT NULL,
    `State` VARCHAR(45) NULL,
    `Country` VARCHAR(45) NOT NULL,
    `Phone` VARCHAR(20) NOT NULL,
    `Email` VARCHAR(100) NOT NULL,
    `Username` VARCHAR(45) NOT NULL,
    `Password` VARCHAR(64) NOT NULL,
    `SecurityQuestion` VARCHAR(100) NOT NULL,
    `SecurityAnswer` VARCHAR(45) NOT NULL,
    `HawkAdvantage` TINYINT(1) NOT NULL DEFAULT 0,
    `Miles` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`UserID`))
ENGINE = InnoDB;

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
    `UserID` INT NOT NULL)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `HawkAir`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE `HawkAir`.`Bookings` (
    `BookingID` INT NOT NULL,
    `SeatNumber` VARCHAR(5) NULL,
    `Class` VARCHAR(20) NOT NULL,
    `UserID` INT NOT NULL,
    `FlightID` VARCHAR(6) NOT NULL)
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
    `FlightStatus` VARCHAR(20) NULL DEFAULT 'On Time',
    `PriceFirstClass` MEDIUMINT NOT NULL,
    `PriceEconomy` MEDIUMINT NOT NULL,
    `BookedFirstClassSeats` SMALLINT NULL DEFAULT 0,
    `BookedEconomySeats` SMALLINT NULL DEFAULT 0,
    PRIMARY KEY (`FlightID`))
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
    `FlightID` VARCHAR(6) NOT NULL)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `HawkAir`.`Airports`
-- -----------------------------------------------------
CREATE TABLE `HawkAir`.`Airports` (
    `Code` VARCHAR(3) NOT NULL,
    `Name` VARCHAR(45) NOT NULL,
    `City` VARCHAR(45) NOT NULL,
    `State` VARCHAR(45) NULL,
    `Country` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`Code`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `HawkAir`.`Aircrafts`
-- -----------------------------------------------------
CREATE TABLE `HawkAir`.`Aircrafts` (
    `AircraftID` VARCHAR(20) NOT NULL,
    `TotalFirstClassSeats` SMALLINT NOT NULL,
    `TotalEconomySeats` SMALLINT NOT NULL,
    PRIMARY KEY (`AircraftID`))
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
CREATE TABLE `HawkAir`.`ContactUs` (
    `Phone` VARCHAR(20) NOT NULL,
    `Email` VARCHAR(100) NOT NULL)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Insert Statements
-- -----------------------------------------------------
INSERT INTO `HawkAir`.`Users` VALUES
(NULL,'','Roger','','McCubbin','','Male','1980-01-21','1087 Windy Ridge Road','Fort Wayne','46802','IN','United States','260-579-8310','roger-mccubbin1946@yahoo.com','Quinnow','roger12345','What was your favorite sport in high school?','Football',0,0),
(NULL,'Ms.','Linda','','Knox','','Female','1970-10-12','1345 Lewis Street','Bensenville','60106','IL','United States','630-875-1041','LindaJKnox@teleworm.us','Houghmed','ilovecats97','What is your pet''s name?','Simba',0,0),
(NULL,'','Jessica','','McCarthy','Jess','Female','1975-08-05','900 Vesta Drive','Chicago','60631','IL','United States','773-727-5516','jessicamccarthy99@amazon.com','Hatc1999','jessisthebest','In what city were you born?','Chicago',1,270),
(NULL,'Mr.','Howard','William','Doublas','','Male','1976-06-06','3033 West Drive','Chicago','60661','IL','United States','312-525-7519','howdougl@gmail.com','Waseat','howyoudoin1','What was the color of your first car?','Red',0,0),
(NULL,'','Amanda','','Lewis','','Female','1994-08-03','680 Mutton Town Road','Centralia','98531','WA','United States','360-623-1953','ama-lewis@amazon.com','Crinsonast','ccgroupsc94','What is your favorite team?','Packers',1,1300);

INSERT INTO `HawkAir`.`Flights` VALUES
('AA2470','Airbus 319','ORD','LAX','18:00','2:08','On time',650,350,0,0),
('AA5306','CRJ 700','ORD','DFW','11:22','2:02','On time',400,200,0,0),
('AA6846','Boeing 737','ORD','JFK','9:04','2:40','On time',520,230,0,0),
('AA4594','Airbus 319','ORD','DEN','7:57','1:52','On time',240,160,0,0),
('AA8737','Boeing 787','ORD','MIA','12:34','3:15','On time',370,250,0,0);

INSERT INTO `HawkAir`.`Airports` VALUES
('ORD','Chicago O''Hare International','Chicago','IL','United States'),
('LAX','Los Angeles International','Los Angeles','CA','United States'),
('JFK','John F Kennedy International','New York','NY','United States'),
('DFW','Dallas Fort Worth International','Dallas-Fort Worth','TX','United States'),
('DEN','Denver International','Denver','CO','United States'),
('MIA','Miami International','Miami','FL','United States');

INSERT INTO `HawkAir`.`Schedule` VALUES
(1,1,1,1,1,1,1,'AA2470'),
(1,1,1,1,1,1,1,'AA5306'),
(1,1,1,1,1,1,1,'AA6846'),
(1,1,1,1,1,1,1,'AA4594'),
(1,1,1,1,1,1,1,'AA8737');

INSERT INTO `HawkAir`.`Aircrafts` VALUES
('Airbus 319',8,96),
('Airbus 330',20,152),
('Boeing 737',16,126),
('Boeing 787',20,158),
('CRJ 700',8,48);

INSERT INTO `HawkAir`.`Admin` VALUES
('Admin', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8');

INSERT INTO `HawkAir`.`News` VALUES
('May Vacation Sale','2020-04-17','/static/images/vacations.png','Save and earn up to 25\,000 bonus miles when you book your flight and hotel together! MileagePlus is your ticket to the world\, with the most ways to earn and use miles and the most award destinations of any U.S. airline loyalty program. Now all you need is more vacation days.'),
('Rent a Car with Avis or Budget','2020-04-03','/static/images/car.png','Save up to 35% off base rates and earn miles. Reserve a car today! No matter the destination\, enjoy a trip that delivers more savings. Save up to 30% off of Budget base rates and earn 1\,000 AAdvantage bonus miles when you rent for 4 or more days. These miles are in addition to your base miles you receive when renting with Budget.'),
('Fly Nonstop to Poland','2020-03-25','/static/images/poland.png','New service to Krakow from Chicago O''Hare start May 7. Search and book your flights! Pack your bags and explore Europe! Take advantage of great fares and low exchange rates and save first on flights and again on hotels\, dining and shopping when you get there.'),
('New Flights to Latin America','2020-03-19','/static/images/latinamerica.png','From a remote beach getaway to modern\, bustling cities\, you''re bound to discover new and exciting places and ideas. Shop Main Cabin deals to Latin America and the Caribbean.'),
('Vacation Smarter','2020-03-06','static/images/savings.png','Go beyond the flight. For a limited time\, SkyMiles Members save up to $350 on any Delta Vacations package worldwide. Plus\, earn bonus miles & use miles on the best getaways\, curated just for you. Terms apply.');

INSERT INTO `HawkAir`.`ContactUs` VALUES
('319-834-0276', 'hawkair2020@gmail.com');
