
SELECT COUNT(*) AS "Total Customers" FROM `Car_Rental`.`customer`;
SELECT COUNT(*) AS "Total Rate" FROM `Car_Rental`.`rate`;
SELECT COUNT(*) AS "Total Rentals" FROM `Car_Rental`.`rental`;
SELECT COUNT(*) AS "Total Vehicles" FROM `Car_Rental`.`vehicle`;

#Q1 Insert yourself as a New Customer. Do not provide the CustomerID in your query
INSERT INTO `Car_Rental`.`customer` (Name,Phone)
VALUES ("S Arya","(994) 057-1967");

#Q2 Update your phone number to (837) 721-8965
UPDATE `Car_Rental`.`customer`
SET Phone = "(837) 721-8965"
WHERE Phone = "(994) 057-1967";

#Q3 Increase only daily rates for luxury vehicles by 5%
UPDATE `Car_Rental`.`rate`
SET Daily = 1.05*Daily
WHERE Category = 1;

#Q4a Insert a new luxury van with the following info: Honda Odyssey 2019, vehicle id: 5FNRL6H58KB133711
INSERT INTO `Car_Rental`.`vehicle`
VALUES("5FNRL6H58KB133711","Honda Odyssey",2019,6,1);

#Q4b 
INSERT INTO `Car_Rental`.`rate`
VALUES(5,1,900,150),
(6,1,800,135);

#Q5 Return all Compact(1) & Luxury(1) vehicles that were available for rent from 
#June 01, 2019 until June 20, 2019. List VechicleID as VIN, Description, year, and 
#how many days have been rented so far. You need to change the weeks into days. [15 points]
SELECT V.VehicleID AS 'VIN', V.Description, V.Year, SUM(R.RentalType*R.Qty) AS "Days Rented"
FROM `Car_Rental`.`vehicle` AS V, `Car_Rental`.`rental` AS R
WHERE (V.VehicleID, R.Qty, R.RentalType) IN
	(SELECT DISTINCT VehicleID,Qty, RentalType
	FROM `Car_Rental`.`rental`
	WHERE (ReturnDate NOT BETWEEN '2019-06-01' AND '2019-06-20')
	  AND (StartDate NOT BETWEEN'2019-06-01' AND '2019-06-20')
      AND StartDate < '2019-06-20')
AND V.Type = 1 AND V.Category = 1
GROUP BY V.VehicleID;



#Q6 Return a list with the remaining balance for the customer with the id ‘221’. 
#List customer name, and the balance. [3 points]
SELECT C.Name, SUM(TotalAmount) AS "Balance"
FROM Car_Rental.customer AS C, Car_Rental.rental AS R
WHERE (C.CustID, TotalAmount, PaymentDate) IN 
	(SELECT CustID, TotalAmount, PaymentDate
	FROM Car_Rental.rental 
	WHERE CustID = 221 AND PaymentDate IS NOT NULL);

#Q7 Create a report that will return all vehicles. List the VehicleID as VIN, Description, Year, 
#Type, Category, and Weekly and Daily rates. For the vehicle Type and Category, you need to use 
#the SQL Case statement to substitute the numbers with text. Order your results based on Category 
#(first Luxury and then Basic) and Type based on the Type number, not the text. [4 points]
SELECT VehicleID AS "VIN",
	Description,
    Year,
    CASE WHEN V.Type  = 1 THEN 'Compact'
        WHEN V.Type  = 2 THEN 'Medium'
		WHEN V.Type  = 3 THEN 'Large'
        WHEN V.Type = 4 THEN 'SUV'
		WHEN V.Type  = 5 THEN 'Truck'
        WHEN V.Type = 6 THEN 'VAN'
	END AS Type,
    CASE WHEN V.Category = 0 THEN 'Basic'
		WHEN V.Category = 1 THEN 'Luxury'
	END AS Category,
    R.Daily,
    R.Weekly
FROM Car_Rental.vehicle AS V, Car_Rental.rate AS R
WHERE V.Type = R.Type AND V.Category = R.Category
ORDER BY V.Category DESC,
V.Type DESC;

#Q8 What is the total of money that customers paid to us until today? [2 points]
SELECT SUM(TotalAmount) AS "Total Money"
FROM Car_Rental.rental
WHERE ReturnDate <= curdate();

#Q9a Create a report for the J. Brown customer with all vehicles he rented. List the description, 
#year, type, and category. Also, calculate the unit price for every rental, the total duration mention 
#if it is on weeks or days, the total amount, and if there is any payment. Similarly, as in Question 7,
# you need to change the numeric values to the corresponding text. Order the results by the StartDate.

SELECT DISTINCT V.VehicleID, Description, Year,
	CASE WHEN V.Type  = 1 THEN 'Compact'
        WHEN V.Type  = 2 THEN 'Medium'
		WHEN V.Type  = 3 THEN 'Large'
        WHEN V.Type = 4 THEN 'SUV'
		WHEN V.Type  = 5 THEN 'Truck'
        WHEN V.Type = 6 THEN 'VAN'
	END AS Type,
    CASE WHEN V.Category = 0 THEN 'Basic'
		WHEN V.Category = 1 THEN 'Luxury'
	END AS Category,
    Qty*RentalType AS 'Duration Days',
    CASE WHEN RentalType = 1 THEN 105*Qty 
		 WHEN RentalType = 7 THEN 600*Qty
	END AS Unit_Price,
    TotalAmount,
    CASE WHEN RentalType = 1 THEN 105*Qty - TotalAmount
		 WHEN RentalType = 7 THEN 600*Qty - TotalAmount
	END AS Payment,
    StartDate
FROM Car_Rental.vehicle AS V, Car_Rental.rental, Car_Rental.rate 
WHERE (V.VehicleID,StartDate) IN
	(SELECT VehicleID, StartDate
	FROM Car_Rental.rental
	WHERE CustID IN 
		(SELECT CustID
		FROM Car_Rental.customer
		WHERE Name = "J. Brown"))
ORDER BY StartDate ASC;


#Question 9-b: For the same customer return the current balance.
SELECT SUM(CASE WHEN RentalType = 1 THEN 105*Qty 
				WHEN RentalType = 7 THEN 600*Qty
	       END) AS "Total Purchases",
	   SUM(TotalAmount) AS "Total Paid",
       SUM(CASE WHEN RentalType = 1 THEN 105*Qty - TotalAmount
				WHEN RentalType = 7 THEN 600*Qty - TotalAmount
			END) AS Balance
FROM Car_Rental.rental
WHERE CustID IN
	(SELECT CustID 
	FROM Car_Rental.customer
	WHERE Name = "J. Brown");

#Q10 Retrieve all weekly rentals for the vechicleID ‘19VDE1F3XEE414842’ that are not paid yet. List the 
#Customer Name, the start and return date, and the amount. [3 points]
SELECT DISTINCT Name, StartDate, ReturnDate, TotalAmount
FROM Car_Rental.customer AS C, Car_Rental.rental AS R
WHERE (C.CustID, StartDate, ReturnDate, TotalAmount) IN 
	(SELECT CustID, StartDate, ReturnDate, TotalAmount
	FROM Car_Rental.rental
	WHERE VehicleID = "19VDE1F3XEE414842" AND RentalType = 7 AND PaymentDate IS NOT NULL);

#Q11 Return all customers that they never rent a vehicle. [3 points]
SELECT Name
FROM Car_Rental.customer
WHERE CustID NOT IN 
	(SELECT CustID
    FROM Car_Rental.rental);

#Q12 Return all rentals that the customer paid on the StartDate. List Customer Name, Vehicle Description,
# StartDate, ReturnDate, and TotalAmount. Order by Customer Name. [3 points]
SELECT DISTINCT Name, StartDate, ReturnDate, TotalAmount,Description
FROM Car_Rental.customer AS C, Car_Rental.rental AS R, Car_Rental.vehicle AS V
WHERE (Name, StartDate, ReturnDate, TotalAmount,V.VehicleID) IN 
	(SELECT Name, StartDate, ReturnDate, TotalAmount,VehicleID
	FROM Car_Rental.customer AS C, Car_Rental.rental AS R
	WHERE (C.CustID, StartDate, ReturnDate, TotalAmount,VehicleID) IN 
		(SELECT CustID, StartDate, ReturnDate, TotalAmount, VehicleID 
		FROM Car_Rental.rental
		WHERE StartDate = PaymentDate))
ORDER BY C.Name;

SELECT COUNT(*)
FROM Car_Rental.rental
NATURAL JOIN Car_Rental.vehicle;
