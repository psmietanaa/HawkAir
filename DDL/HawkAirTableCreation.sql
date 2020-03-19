-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema HawkAir
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema HawkAir
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `HawkAir` DEFAULT CHARACTER SET utf8 ;
USE `HawkAir` ;

-- -----------------------------------------------------
-- Table `HawkAir`.`Users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Users` (
  `UserID` INT NOT NULL AUTO_INCREMENT,
  `Title` VARCHAR(6) NULL,
  `FirstName` VARCHAR(45) NOT NULL,
  `MiddleName` VARCHAR(45) NULL,
  `LastName` VARCHAR(45) NOT NULL,
  `PreferredName` VARCHAR(45) NULL,
  `Sex` VARCHAR(10) NOT NULL,
  `DOB` DATE NOT NULL,
  `Street` VARCHAR(100) NOT NULL,
  `City` VARCHAR(45) NOT NULL,
  `ZipCode` VARCHAR(10) NOT NULL,
  `State` VARCHAR(45) NULL,
  `Country` VARCHAR(45) NOT NULL,
  `Phone` VARCHAR(20) NOT NULL,
  `Email` VARCHAR(100) NOT NULL,
  `Username` VARCHAR(45) NOT NULL,
  `Password` VARCHAR(128) NOT NULL,
  `SecurityQuestion` VARCHAR(100) NOT NULL,
  `SecurityAnswer` VARCHAR(45) NOT NULL,
  `HawkAdvantage` TINYINT NOT NULL DEFAULT 0,
  `Miles` INT NOT NULL DEFAULT 0,
  constraint `sex_constraint` check(sex in ("Male","Female")),
  PRIMARY KEY (`UserID`),
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC) VISIBLE,
  UNIQUE INDEX `Username_UNIQUE` (`Username` ASC) VISIBLE)
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
-- Table `HawkAir`.`Aircrafts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Aircrafts` (
  `AircraftID` VARCHAR(20) NOT NULL,
  `TotalFirstClassSeats` SMALLINT NOT NULL,
  `TotalEconomySeats` SMALLINT NOT NULL,
  PRIMARY KEY (`AircraftID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `HawkAir`.`Flights`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Flights` (
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
  PRIMARY KEY (`FlightID`),
  INDEX `fk_Flights_Airports1_idx` (`To` ASC) VISIBLE,
  INDEX `fk_Flights_Airports2_idx` (`From` ASC) VISIBLE,
  INDEX `fk_Flights_Aircraft1_idx` (`AircraftID` ASC) VISIBLE,
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
-- Table `HawkAir`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Bookings` (
  `BookingID` INT NOT NULL,
  `SeatNumber` VARCHAR(5) NULL,
  `Class` VARCHAR(20) NOT NULL,
  `UserID` INT NOT NULL,
  `FlightID` VARCHAR(6) NOT NULL,
  INDEX `fk_Booking_UserInformation1_idx` (`UserID` ASC) VISIBLE,
  INDEX `fk_Booking_Flights1_idx` (`FlightID` ASC) VISIBLE,
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
-- Table `HawkAir`.`Payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Payments` (
  `CardNumber` VARCHAR(16) NOT NULL,
  `CardType` VARCHAR(10) NOT NULL,
  `ExpirationDateMonth` SMALLINT NOT NULL,
  `ExpirationDateYear` SMALLINT NOT NULL,
  `CVV` SMALLINT NOT NULL,
  `Name` VARCHAR(100) NOT NULL,
  `UserID` INT NOT NULL,
  PRIMARY KEY (`CardNumber`),
  INDEX `fk_Payment_Users1_idx` (`UserID` ASC) VISIBLE,
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
  `Password` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`Username`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `HawkAir`.`ContactUs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`ContactUs` (
  `Phone` VARCHAR(20) NOT NULL,
  `Email` VARCHAR(100) NOT NULL)
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
-- Table `HawkAir`.`Schedule`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HawkAir`.`Schedule` (
  `Monday` TINYINT NOT NULL,
  `Tuesday` TINYINT NOT NULL,
  `Wednesday` TINYINT NOT NULL,
  `Thursday` TINYINT NOT NULL,
  `Friday` TINYINT NOT NULL,
  `Saturday` TINYINT NOT NULL,
  `Sunday` TINYINT NOT NULL,
  `FlightID` VARCHAR(6) NOT NULL,
  INDEX `fk_Schedule_Flights1_idx` (`FlightID` ASC) VISIBLE,
  CONSTRAINT `fk_Schedule_Flights1`
    FOREIGN KEY (`FlightID`)
    REFERENCES `HawkAir`.`Flights` (`FlightID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;