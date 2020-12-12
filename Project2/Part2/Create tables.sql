CREATE TABLE `Car_Rental`.`customer`(
	`CustID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(45) NOT NULL,
    `Phone` VARCHAR(14) NOT NULL,
    PRIMARY KEY(`CustID`));

CREATE TABLE `Car_Rental`.`rental`(
	`CustID` INT UNSIGNED NOT NULL,
    `VehicleID` VARCHAR(45) NOT NULL,
    `StartDate` DATE NOT NULL,
    `OrderDate` DATE NOT NULL,
    `RentalType` INT UNSIGNED NOT NULL,
    `Qty` INT UNSIGNED NOT NULL,
    `ReturnDate` DATE NOT NULL,
    `TotalAmount` FLOAT NOT NULL,
    `PaymentDue` DATE,
    PRIMARY KEY(`CustID`,`VehicleID`));
  
CREATE TABLE `Car_Rental`.`vehicle`(
	`VehicleID` VARCHAR(45) NOT NULL ,
    `Description` VARCHAR(45) NOT NULL,
    `Year` INT NOT NULL,
    `Type` INT NOT NULL,
    `Category` INT NOT NULL,
    PRIMARY KEY(`VehicleID`));
    
CREATE TABLE `Car_Rental`.`rate`(
	`Type` INT NOT NULL ,
    `Category` INT NOT NULL,
    `Weekly` FLOAT NOT NULL,
    `Daily` FLOAT NOT NULL);

    