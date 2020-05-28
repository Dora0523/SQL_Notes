CREATE DATABASE company;
USE company;

/*************************************** EMPLOYEE */
CREATE TABLE employee (
emp_id INT PRIMARY KEY,
first_name VARCHAR(10),
last_name VARCHAR(10),
birth_date DATE,
sex VARCHAR(1),
salary INT,
super_id INT,
branch_id INT
);

SELECT *
FROM employee;



/**************************************** BRANCH */
CREATE TABLE branch (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR (40),
  mgr_id INT,
  mgr_start_date DATE,
  FOREIGN KEY (mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL  

);

SELECT *
FROM branch;



ALTER TABLE employee
ADD FOREIGN KEY (branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL; /*add branch_id as foreign key to EMPLOYEE table */

/******************************************* CLIENT */
CREATE TABLE client(
  client_id INT PRIMARY KEY,
  client_name VARCHAR(40),
  branch_id INT,
  FOREIGN KEY (branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
  );
  

  
SELECT *
FROM client;
  
/******************************************* WORKS_WITH */
CREATE TABLE works_with(
  emp_id INT,
  client_id INT,
  total_sales INT,
  PRIMARY KEY (emp_id, client_id),
  FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
  FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);



SELECT *
FROM works_with;
/****************************************** BRANCH_SUPPLIER */
CREATE TABLE branch_supplier (
  branch_id INT,
  supplier_name VARCHAR(40),
  supply_type VARCHAR(40),
  PRIMARY KEY(branch_id, supplier_name),
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE

);



SELECT *
FROM branch_supplier;

DROP TABLE branch_supplier;
/****************** insert info in order of branches ********************/

/* corporate branch */
INSERT INTO employee VALUES (100, 'David','Wallace','1967-11-17','M',250000,NULL, NULL);
INSERT INTO branch VALUES (1,'Corporate',100,'2006-02-09');
UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO employee VALUES (101,'Jan','Levinson','1961-05-11','F',110000,100,1);

/* scranton branch */
INSERT INTO employee VALUES (102, 'Michael','Scott','1964-03-15','M',75000,100,NULL);
INSERT INTO branch VALUES (2,'Scranton',102,'1992-04-06');
UPDATE employee
SET branch_id =2
WHERE emp_id = 102;

INSERT INTO employee VALUES (103, 'Angela','Martin','1971-06-25','F',63000,102,2);
INSERT INTO employee VALUES (104, 'Kelly','Kapoor','1980-02-05','F',55000,102,2);
INSERT INTO employee VALUES (105, 'Stanley','Hudson','1958-02-19','M',69000,102,2);

/* stamford branch */
INSERT INTO employee VALUES (106, 'Josh','Porter','1969-09-05','M',78000,NULL,NULL);
INSERT INTO branch VALUES (3,'Stamford',106,'1998-02-13');

INSERT INTO employee VALUES (107,'Andy','Bernard','1973-07-22','M',65000,106,3);
INSERT INTO employee VALUES (108,'Jim','Halpert','1978-10-01','M',71000,106,3);


/****************** insert other info ********************/

  INSERT INTO client VALUES (400,'Dunmore Highschool',2);
  INSERT INTO client VALUES (401,'Lackawana County',2);
  INSERT INTO client VALUES (402,'FedEx',3);
  INSERT INTO client VALUES (403, 'John Daly Law, LLC',3);
  INSERT INTO client VALUES (404,'Scranton Whitepages',2);
  INSERT INTO client VALUES (405,'times Newspaper',3);
  INSERT INTO client VALUES (406,'FedEx',2);

INSERT INTO works_with VALUES (105,400,55000);
INSERT INTO works_with VALUES (102,401,267000);
INSERT INTO works_with VALUES (108,402,22500);
INSERT INTO works_with VALUES (107,403,5000);
INSERT INTO works_with VALUES (108,403,12000);
INSERT INTO works_with VALUES (105,404,33000);
INSERT INTO works_with VALUES (107,405,26000);
INSERT INTO works_with VALUES (102,406,15000);
INSERT INTO works_with VALUES (105,406,130000);

INSERT INTO branch_supplier VALUES (2,'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES (2, 'Uni-ball','Writing Utensils');
INSERT INTO branch_supplier VALUES (3, 'Patriot Paper','Paper');
INSERT INTO branch_supplier VALUES (2,'J.T. Forms & Lables','Custom Forms');
INSERT INTO branch_supplier VALUES (3, 'Uni-ball','Writing Utensils');
INSERT INTO branch_supplier VALUES (3,'Hammer Mill','Papers');
INSERT INTO branch_supplier VALUES (3,'Stamford Lables','Custom Forms');




/*********************** BASIC SELECT QUIRIES *************************/

/*FIND ALL EMPLOYEES ORDERED BY SEX THEN NAME*/
SELECT*
FROM employee
ORDER BY sex, first_name, last_name;

/*FIND FORENAME AND SURNAME OF ALL EMPLOYEES*/
SELECT first_name AS forename, last_name AS surname
FROM employee;

/*FIND ALL DIFFERENT GENDERS*/
SELECT DISTINCT sex 
FROM employee;

/*********************** FUNCTIONS *************************/


/*FIND NUMBER OF FEMALE EMPLOYEES BORN AFTER 1970*/
SELECT COUNT(emp_id)
FROM employee
WHERE sex='F' AND birth_date>'1970-01-01';

/*FIND AVERAGE OF ALL MALE EMPLOYEE'S SALARIES*/
SELECT AVG(salary)
FROM employee
WHERE sex = 'M';

/*FIND THE SUM OF ALL EMPLOYEE SALARIES*/
SELECT SUM(salary)
FROM employee;

/*FIND HOW MANY MALES AND FEMALES*/
SELECT COUNT(sex), sex  /*return # and category*/
FROM employee
GROUP BY sex;/*group sex*/

/*FIND TOTAL SPENDS OF EACH CLIENT*/
SELECT SUM(total_sales), client_id /*sum up client sales*/
FROM works_with
GROUP BY client_id; /*group clients*/


/*********************** WILDCARDS *************************/
/*
% == any characters
_ == any one char
*/

/*FIND ANY CLIENTS IN LLC*/
SELECT *
FROM client
WHERE client_name LIKE '%LLC';  /*client_name end with 'LLC'*/

/*FIND ANY BRANCH SUPPLIERS IN LABEL BUSINESS*/
SELECT*
FROM branch_supplier
WHERE supplier_name LIKE '%lable%'; /*supplier_name with 'lable' occured anywhere*/

/*FIND ANY EMPLOYEE BORN IN OCTOBER*/
SELECT*
FROM employee
WHERE birth_date LIKE '____-10%'; 


/*********************** UNIONS *************************/
/*FIND LIST OF EMPLOYEE, CLIENT AND BRANCH NAMES*/
SELECT first_name
FROM employee
UNION
SELECT client_name
FROM client
UNION
SELECT branch_name
FROM branch;  /*return employee, client and branch name in one single col*/

/*FIND LIST OF ALL CLIENTS & BRANCH SUPPLIERS NAME*/
SELECT client_name, client.branch_id
FROM client
UNION
SELECT supplier_name, branch_supplier.branch_id
FROM branch_supplier;

/*FIND ALL MONEY SPENT OR EARNED BY COMPANY*/
SELECT salary
FROM employee
UNION
SELECT total_sales
FROM works_with;

/*********************** JOINTS *************************/
INSERT INTO branch VALUES(4,'Buffalo',Null,Null);


/*FIND ALL BRANCHESAND NAME OF BRANCH MANAGERS*/
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
JOIN branch
ON employee.emp_id = branch.mgr_id; /*join EMPLOYEE and BRANCH table together including all managers*/

SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
LEFT JOIN branch
ON employee.emp_id = branch.mgr_id; /*join EMPLOYEE and BRANCH table together including all employees*/

SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
RIGHT JOIN branch
ON employee.emp_id = branch.mgr_id; /*join EMPLOYEE and BRANCH table together including all branches*/


/*********************** NESTED QUIRIES *************************/


