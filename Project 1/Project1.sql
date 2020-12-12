#1 Enter a department name, and retrieve all the names and salaries of all employees who work in that department.
SELECT Fname, Minit, Lname, Salary
FROM EMPLOYEES AS E
WHERE E.Dept_num IN 
		(SELECT Dept_number
        FROM DEPARTMENT
        WHERE Name = 'HR');

#2.Enter an employee last name and first name and retrieve a list of projects names/hours per week that the employee works on.
SELECT DISTINCT P.Name, W.Hours
FROM PROJECT AS P, WORKS_ON AS W
WHERE (P.project_number, W.Hours) IN 
		(SELECT W.project_number, W.Hours
		FROM WORKS_ON AS W
        WHERE W.Ssn IN
			(SELECT E.Ssn
            FROM EMPLOYEES AS E
            WHERE Fname = 'Roy' AND Lname = 'Lewallen'));
        
#3 Enter a department name and retrieve the total of all employee salaries who work in the department.
SELECT Name AS Department_Name, SUM(Salary) AS Total_salary
FROM EMPLOYEES, DEPARTMENT
WHERE (Dept_num, Name) IN
	(SELECT Dept_number, Name
    FROM DEPARTMENT
    WHERE Name = 'Sales');
    
#4 For each department, retrieve the department name and the number (count) of employees who work in that department.
# Order the result by number of employees in descending order.
SELECT Name, COUNT(*) AS 'Total Employees' 
FROM DEPARTMENT
INNER JOIN EMPLOYEES
ON Dept_number = Dept_num
GROUP BY Dept_number, Name
ORDER BY COUNT(*) DESC;

#5 For each employee who is a supervisor, retrieve the employee first and last name and
# the number (count) of employees that are supervised. Order the result in descending order.
SELECT S.Fname, S.Lname, COUNT(*) AS 'Employees Supervised'
FROM EMPLOYEES AS E, EMPLOYEES AS S
WHERE E.SuperSSN = S.Ssn
GROUP BY S.Ssn
ORDER BY COUNT(*) DESC;


