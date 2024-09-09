USE soft_uni_db;

CREATE TABLE towns(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

CREATE TABLE addresses(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    address_text VARCHAR(100),
    town_id INT
);

ALTER TABLE addresses
ADD FOREIGN KEY (town_id) REFERENCES towns(id);


CREATE TABLE departments (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

CREATE TABLE employees (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    middle_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    job_title VARCHAR(20),
    department_id INT,
    hire_date DATE,
    salary DOUBLE(6,2),
    address_id INT
);

ALTER TABLE employees
ADD CONSTRAINT fk_employees_deparments FOREIGN KEY (department_id) REFERENCES departments(id),
ADD FOREIGN KEY (address_id) REFERENCES addresses(id);

INSERT INTO towns(name) VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

INSERT INTO departments(name) VALUES
('Engineering'),
('Sales'), 
('Marketing'),
('Software Development'),
('Quality Assurance');

INSERT INTO employees(first_name, middle_name, last_name, job_title, department_id, hire_date, salary) VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013/02/01', 3500.00),
('Petar ', 'Petrov ', 'Petrov ', 'Senior Engineer', 1, '2004/03/02', 4000.00),
('Maria ', 'Petrova ', 'Ivanova', 'Intern', 5, '2016/08/28', 525.25),
('Georgi ', 'Terziev ', 'Ivanov', 'CEO', 2, '2007/12/09', 3000.00),
('Peter ', 'Pan ', 'Pan ', 'Intern', 3, '2016/08/28', 599.88);

SELECT * FROM towns;
SELECT * FROM departments;
SELECT * FROM employees;

SELECT * FROM towns ORDER BY name ASC;
SELECT * FROM departments ORDER BY name ASC;
SELECT * FROM employees ORDER BY salary DESC;

SELECT name FROM towns ORDER BY name ASC;
SELECT name FROM departments ORDER BY name ASC;

UPDATE employees 
SET salary = salary + (0.10 * salary);

SELECT salary FROM employees;

