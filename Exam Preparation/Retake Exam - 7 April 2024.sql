CREATE TABLE cities(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE cars(
	id INT AUTO_INCREMENT PRIMARY KEY,
    brand VARCHAR(20) NOT NULL,
    model VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE instructors(
	id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL UNIQUE,
    has_a_license_from DATE NOT NULL
);

CREATE TABLE driving_schools(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(40) NOT NULL UNIQUE,
    night_time_driving BOOLEAN NOT NULL,
    average_lesson_price DECIMAL(10,2),
    car_id INT NOT NULL,
    city_id INT NOT NULL,
    
    CONSTRAINT fk_driving_schools_cars
    FOREIGN KEY (car_id)
    REFERENCES cars(id),
    
    CONSTRAINT fk_driving_schools_cities
    FOREIGN KEY (city_id)
    REFERENCES cities(id)
);

CREATE TABLE students(
	id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL UNIQUE,
    age INT,
    phone_number VARCHAR(20) UNIQUE
);

CREATE TABLE instructors_driving_schools(
	instructor_id INT,
    driving_school_id INT NOT NULL,
    FOREIGN KEY (instructor_id) REFERENCES instructors(id),
    FOREIGN KEY (driving_school_id) REFERENCES driving_schools(id)
);

CREATE TABLE instructors_students(
	instructor_id INT NOT NULL,
    student_id INT NOT NULL,
    FOREIGN KEY (instructor_id) REFERENCES instructors(id),
    FOREIGN KEY (student_id) REFERENCES students(id)
);

INSERT INTO students(first_name, last_name, age, phone_number)
SELECT
	LOWER(REVERSE(first_name)),
	LOWER(REVERSE(last_name)),
    age + LEFT(phone_number, 1),
    CONCAT('1+', phone_number)
FROM students
WHERE age < 20;

UPDATE driving_schools AS ds
JOIN cities AS c ON ds.city_id = c.id
SET ds.average_lesson_price = ds.average_lesson_price + 30
WHERE c.name = 'London';

DELETE FROM driving_schools
WHERE night_time_driving = false;

SELECT 
	CONCAT(first_name, ' ', last_name) AS `full_name`,
    age
FROM students
WHERE first_name LIKE '%a%'
AND age = (SELECT MIN(age) FROM students WHERE first_name LIKE '%a%')
ORDER BY id;

SELECT 
	ds.id,
    ds.name,
    c.brand
FROM driving_schools AS ds
JOIN cars AS c ON ds.car_id = c.id
LEFT JOIN instructors_driving_schools AS ids ON ds.id = ids.driving_school_id
WHERE ids.instructor_id IS NULL
ORDER BY brand, ds.id
LIMIT 5;

SELECT 
	i.first_name,
    i.last_name,
    COUNT(*) AS students_count,
	c.name
FROM driving_schools AS ds
JOIN cities AS c ON ds.city_id = c.id
JOIN instructors_driving_schools AS ids ON ds.id = ids.driving_school_id
JOIN instructors AS i ON ids.instructor_id = i.id
JOIN instructors_students AS insts ON i.id = insts.instructor_id
GROUP BY insts.instructor_id, c.name
HAVING students_count > 1
ORDER BY students_count DESC, i.first_name;

SELECT 
	c.name,
    COUNT(*) AS instructors_count
FROM driving_schools AS ds
JOIN cities AS c ON ds.city_id = c.id
JOIN instructors_driving_schools AS ids ON ds.id = ids.driving_school_id
GROUP BY c.name
HAVING instructors_count > 0
ORDER BY instructors_count DESC;

SELECT
	CONCAT(first_name, ' ',last_name) AS full_name,
    CASE
		WHEN YEAR(has_a_license_from) < 1990 THEN 'Specialist'
		WHEN YEAR(has_a_license_from) < 2000 THEN 'Advanced'
		WHEN YEAR(has_a_license_from) < 2008 THEN 'Experienced'
		WHEN YEAR(has_a_license_from) < 2015 THEN 'Qualified'
		WHEN YEAR(has_a_license_from) < 2020 THEN 'Provisional'
        ELSE 'Trainee'
    END AS level 
FROM instructors
ORDER BY YEAR(has_a_license_from), first_name;

DELIMITER $

CREATE FUNCTION udf_average_lesson_price_by_city (name VARCHAR(40)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	RETURN (SELECT AVG(ds.average_lesson_price)
	FROM driving_schools AS ds
	JOIN cities AS c ON ds.city_id = c.id
	WHERE c.name = name);
END $

CREATE PROCEDURE udp_find_school_by_car(brand VARCHAR(20))
BEGIN
	SELECT 
		ds.name,
		ds.average_lesson_price
	FROM driving_schools AS ds
	JOIN cars AS c ON ds.car_id = c.id
	WHERE c.brand = brand
	ORDER BY ds.average_lesson_price DESC;
END $








