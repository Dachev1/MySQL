CREATE DATABASE universities_db;
USE universities_db;

CREATE TABLE countries(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE cities(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(40) NOT NULL UNIQUE,
    population INT,
    country_id INT NOT NULL,
    
    CONSTRAINT fk_cities_countries
    FOREIGN KEY (country_id)
    REFERENCES countries(id)
);

CREATE TABLE universities(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(60) NOT NULL UNIQUE,
    address VARCHAR(80) NOT NULL UNIQUE,
    tuition_fee DECIMAL(19,2) NOT NULL,
    number_of_staff INT,
    city_id INT,
    
    CONSTRAINT fk_universities_cities
    FOREIGN KEY (city_id)
    REFERENCES cities(id)
);

CREATE TABLE students(
	id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(40) NOT NULL,
	last_name VARCHAR(40) NOT NULL,
    age INT,
    phone VARCHAR(20) NOT NULL UNIQUE,
	email VARCHAR(255) NOT NULL UNIQUE,
    is_graduated BOOLEAN NOT NULL,
    city_id INT,
    
    CONSTRAINT fk_students_cities
    FOREIGN KEY (city_id)
    REFERENCES cities(id)
);

CREATE TABLE courses(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(40) NOT NULL UNIQUE,
    duration_hours DECIMAL(19,2),
    start_date DATE,
	teacher_name VARCHAR(60) NOT NULL UNIQUE,
    description TEXT,
    university_id INT,
    
    CONSTRAINT fk_courses_universities
    FOREIGN KEY (university_id)
    REFERENCES universities(id)
);

CREATE TABLE students_courses(
    student_id INT,
    course_id INT,
	grade DECIMAL(19,2) NOT NULL,
    
    CONSTRAINT fk_students_courses_students
    FOREIGN KEY (student_id)
    REFERENCES students(id),
    
    CONSTRAINT fk_students_courses_courses
    FOREIGN KEY (course_id)
    REFERENCES courses(id)
);

INSERT INTO courses(name, duration_hours, start_date, teacher_name, description, university_id)
SELECT 
	CONCAT(teacher_name, ' course'),
    CHAR_LENGTH(name) / 10,
	DATE_ADD(start_date, INTERVAL + 5 DAY),
	REVERSE(teacher_name),
	CONCAT('Course ', teacher_name, REVERSE(description)),
	DAY(start_date)
FROM courses
WHERE id <= 5;

SELECT * FROM universities;
UPDATE universities
SET tuition_fee = tuition_fee + 300
WHERE id BETWEEN 5 AND 12;

DELETE FROM universities WHERE number_of_staff IS NULL;

SELECT id, name, population, country_id 
FROM cities
ORDER BY population DESC;

SELECT first_name, last_name, age, phone, email 
FROM students
WHERE age >= 21
ORDER BY first_name DESC, email, id
LIMIT 10;

SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS `full_name`,
    SUBSTRING(s.email, 2, 10) AS `username`,
    REVERSE(s.phone) AS `password`
FROM
    students AS s
        LEFT JOIN
    students_courses AS sc ON s.id = sc.student_id
WHERE
    sc.course_id IS NULL
ORDER BY `password` DESC;

SELECT 
	COUNT(*) as students_count, 	
	u.name AS university_name
FROM students_courses AS sc
	JOIN courses AS c ON sc.course_id = c.id
	JOIN universities AS u ON c.university_id = u.id
GROUP BY u.name
HAVING students_count >= 8
ORDER BY students_count DESC, university_name DESC;

SELECT  COUNT(*), course_id
FROM students AS s
	JOIN students_courses AS sc ON s.id = sc.student_id
GROUP BY course_id;

SELECT 
	u.name AS university_name,
    c.name AS city_name,
    u.address,
    CASE
		WHEN  u.tuition_fee < 800 THEN 'cheap'
		WHEN  u.tuition_fee < 1200 THEN 'normal'
		WHEN  u.tuition_fee < 2500 THEN 'high'
        ELSE 'expensive'
    END AS price_rank,
    u.tuition_fee
FROM universities AS u
	JOIN cities AS c ON u.city_id = c.id
ORDER BY u.tuition_fee;


DELIMITER $

CREATE FUNCTION udf_average_alumni_grade_by_course_name(course_name VARCHAR(60)) RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
	RETURN (SELECT AVG(sc.grade) 
    FROM students AS s
		JOIN students_courses AS sc ON s.id = sc.student_id
		JOIN courses AS c ON sc.course_id = c.id
    WHERE s.is_graduated = 1 AND c.name = course_name);    
END $

CREATE PROCEDURE udp_graduate_all_students_by_year(year_started INT)
BEGIN
	UPDATE students
    SET is_graduated = 1
    WHERE id IN (SELECT student_id
				FROM courses AS c
					JOIN students_courses AS sc ON c.id = sc.course_id
				WHERE YEAR(start_date) = year_started);
END $
