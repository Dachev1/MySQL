-- 1
CREATE TABLE passports(
	passport_id INT AUTO_INCREMENT PRIMARY KEY,
    passport_number VARCHAR(255) UNIQUE
);

CREATE TABLE people(
	person_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255),
    salary DECIMAL(12,2),
    passport_id INT UNIQUE,
    CONSTRAINT fk_people_passports
	FOREIGN KEY (passport_id)
    REFERENCES passports(passport_id)
);

INSERT INTO passports(passport_id, passport_number)
VALUES (101, 'N34FG21B'),
	   (102, 'K65LO4R7'),
       (103, 'ZE657QP2');

INSERT INTO people(first_name, salary, passport_id)
VALUES ('Roberto', 43300.00, 102),
	   ('Tom', 56100.00, 103),
       ('Yana', 60200.00, 101);

-- 2
CREATE TABLE manufacturers(
	manufacturer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    established_on DATETIME
);

CREATE TABLE models(
	model_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    manufacturer_id INT,
    
    CONSTRAINT fk_models_manufacturers
	FOREIGN KEY (manufacturer_id)
    REFERENCES manufacturers(manufacturer_id)
);

INSERT INTO manufacturers(name, established_on)
VALUES ('BMW', '1916-03-01'),
	   ('Tesla', '2003-01-01'),
       ('Lada', '1966-05-01');
       
INSERT INTO models(model_id, name, manufacturer_id)
VALUES ('101', 'X1', 1),
	   ('102', 'i6', 1),
	   ('103', 'Model S', 2),
	   ('104', 'Model X', 2),
	   ('105', 'Model 3', 2),
	   ('106', 'Nova', 3);

SELECT * FROM manufacturers;
SELECT * FROM models;

-- 3
CREATE TABLE students(
	student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE exams(
	exam_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE students_exams(
	student_id INT NOT NULL,
	exam_id INT NOT NULL,
    
    CONSTRAINT pk_student_exam
    PRIMARY KEY (student_id, exam_id),
    
    CONSTRAINT fk_students_exams_students
    FOREIGN KEY (student_id)
    REFERENCES students(student_id),
    
    CONSTRAINT fk_students_exams_exams
    FOREIGN KEY (exam_id)
    REFERENCES exams(exam_id)
);

INSERT INTO students(name) VALUE ('Mila');
INSERT INTO students(name) VALUE ('Toni');
INSERT INTO students(name) VALUE ('Ron');

INSERT INTO exams(exam_id, name) VALUE (101, 'Spring MVC');
INSERT INTO exams(exam_id, name) VALUE (102, 'Neo4j');
INSERT INTO exams(exam_id, name) VALUE (103, 'Oracle 11g');

INSERT INTO students_exams(student_id, exam_id)
VALUES (1, 101),
	   (1, 102),
       (2, 101),
       (3, 103),
       (2, 102),
       (2, 103);

-- 4
CREATE TABLE teachers(
	teacher_id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50),
    manager_id INT
    

);

INSERT INTO teachers(teacher_id, name, manager_id)
VALUES (101, 'John', NULL),
	   (102, 'Maya', 106),
	   (103, 'Silvia', 106),
	   (104, 'Ted', 105),
	   (105, 'Mark', 101),
	   (106, 'Greta', 101);
       
ALTER TABLE teachers
ADD CONSTRAINT fk_teacher_manager
	FOREIGN KEY (manager_id)
    REFERENCES teachers(teacher_id);

-- 5
USE online_store_db;

CREATE TABLE item_types(
	item_type_id INT(11) AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE items(
	item_id INT(11) AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50),
    item_type_id INT(11),
    
    CONSTRAINT fk_items_item_types
    FOREIGN KEY (item_type_id)
    REFERENCES item_types(item_type_id)
);

CREATE TABLE cities(
	city_id INT(11) AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50)
);

CREATE TABLE customers(
	customer_id INT(11) AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50),
    birthday DATE,
    city_id INT(11),
    
    CONSTRAINT fk_customers_cities
    FOREIGN KEY (city_id)
    REFERENCES cities(city_id)
);

CREATE TABLE orders(
	order_id INT(11) AUTO_INCREMENT PRIMARY KEY,
    customer_id INT(11),
    
	CONSTRAINT fk_orders_customers
    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
);

CREATE TABLE order_items(
	order_id INT NOT NULL,
	item_id INT NOT NULL,
    
    CONSTRAINT pk_order_item
    PRIMARY KEY (order_id, item_id),
    
    CONSTRAINT fk_order_items_orders
    FOREIGN KEY (order_id)
    REFERENCES orders(order_id),
    
    CONSTRAINT fk_order_items_items
    FOREIGN KEY (item_id)
    REFERENCES items(item_id)
);

-- 6
USE university_db;

CREATE TABLE majors(
	major_id INT(11) AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE students(
	student_id INT(11) AUTO_INCREMENT PRIMARY KEY,
    student_number VARCHAR(12),
    student_name VARCHAR(50),
    major_id INT(11),
    
    CONSTRAINT fk_students_majors
	FOREIGN KEY (major_id)
    REFERENCES majors(major_id)
);

CREATE TABLE payments(
	payment_id INT(11) AUTO_INCREMENT PRIMARY KEY,
	payment_date DATE,
	payment_amount DECIMAL(8,2),
    student_id INT(11),
    
	CONSTRAINT fk_payments_students
	FOREIGN KEY (student_id)
    REFERENCES students(student_id)
);

CREATE TABLE subjects(
	subject_id INT(11) AUTO_INCREMENT PRIMARY KEY,
	subject_name VARCHAR(50)
);

CREATE TABLE agenda(
	student_id INT NOT NULL,
	subject_id INT NOT NULL,
    
    CONSTRAINT pk_student_subject
    PRIMARY KEY (student_id, subject_id),
    
    CONSTRAINT fk_agenda_students
    FOREIGN KEY (student_id)
    REFERENCES students(student_id),
    
    CONSTRAINT fk_agenda_subject
    FOREIGN KEY (subject_id)
    REFERENCES subjects(subject_id)
);

-- 9
SELECT 
	mountains.mountain_range,
    peaks.peak_name,
    peaks.elevation AS peak_elevation
FROM mountains
	JOIN peaks ON peaks.mountain_id = mountains.id
WHERE mountain_range = 'Rila'
ORDER BY peaks.elevation DESC;






