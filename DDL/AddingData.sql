-- -----------------------------------------------------
-- Adding data to aircrafts table
-- -----------------------------------------------------
LOAD DATA INFILE 'C:/Users/Jacob/IdeaProjects/CS4400/DDL/aircrafts.csv' 
INTO TABLE aircrafts 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- -----------------------------------------------------
-- Adding data to airports table
-- -----------------------------------------------------
LOAD DATA INFILE 'C:/Users/Jacob/IdeaProjects/CS4400/DDL/airports.csv' 
INTO TABLE airports
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- -----------------------------------------------------
-- Adding Data to flights table
-- -----------------------------------------------------
LOAD DATA INFILE 'C:/Users/Jacob/IdeaProjects/CS4400/DDL/flights.csv' 
INTO TABLE flights 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- -----------------------------------------------------
-- Adding data to schedule table
-- -----------------------------------------------------
LOAD DATA INFILE 'C:/Users/Jacob/IdeaProjects/CS4400/DDL/schedule.csv' 
INTO TABLE schedule 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- -----------------------------------------------------
-- Adding data to users table
-- -----------------------------------------------------
LOAD DATA INFILE 'C:/Users/Jacob/IdeaProjects/CS4400/DDL/users.csv' 
INTO TABLE users 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(`Title`,`FirstName`,`MiddleName`,`LastName`,`PreferredName`,`Sex`,`DOB`,`Street`,
`City`,`ZipCode`,`State`,`Country`,`Phone`,`Email`,`Username`,`Password`,
`SecurityQuestion`,`SecurityAnswer`,`HawkAdvantage`,`Miles`);

-- -----------------------------------------------------
-- Adding data to news table
-- -----------------------------------------------------
LOAD DATA INFILE 'C:/Users/Jacob/IdeaProjects/CS4400/DDL/news1.txt' 
INTO TABLE news
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;