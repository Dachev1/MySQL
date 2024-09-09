-- from 1st to 5th task
USE minions;

CREATE TABLE minions (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(80),
    `age` INT
);

CREATE TABLE towns (
    `town_id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(80)
);

ALTER TABLE towns
RENAME COLUMN `town_id` TO `id`;

ALTER TABLE minions
    ADD COLUMN town_id INT;

ALTER TABLE minions
    ADD CONSTRAINT fk_town_id
        FOREIGN KEY (town_id) REFERENCES towns (id);
        
INSERT INTO towns (name)
VALUES ('Sofia'),
		('Plovdiv'),
        ('Varna');
        
INSERT INTO minions (name, age, town_id)
VALUES ('Kevin', 22, 1),
		('Bob', 15, 2),
        ('Steward', NULL, 3);
        
SELECT * FROM towns;
SELECT * FROM minions;  

TRUNCATE TABLE minions;

DROP TABLE minions;
DROP TABLE towns;

-- from 6th to 11th task

CREATE TABLE people (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(200) NOT NULL,
    `picture` BLOB,
    `height` DOUBLE(6 , 2 ),
    `weight` DOUBLE(6 , 2 ),
    `gender` CHAR(1) NOT NULL,
    `birthdate` DATE NOT NULL,
    `biography` TEXT
);

INSERT INTO people (name, picture, height, weight, gender, birthdate, biography)
VALUES ('Ivan', 'test', 1.99, 99.2, 'm', '2000-05-12','text'),
		('Alex', 'test', 1.50, 100.5, 'm', '2001-06-16', 'text'),
        ('Ivana', 'test', 2.00, 60.5, 'f', '2006-04-10','text'),
        ('Boris', 'test', 1.85, 89.2, 'm', '2003-12-12','text'),
        ('Dido', 'test', 2.00, 97.07, 'm', '2020-02-02','text');
        
SELECT * FROM people;

CREATE TABLE users(
`id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`username` VARCHAR(30) UNIQUE NOT NULL,
`password` VARCHAR(26) NOT NULL,
`profile_picture` BLOB,
`last_login_time` DATETIME,
`is_deleted` BOOL
);

INSERT INTO users (username, password, profile_picture, last_login_time, is_deleted)
VALUES ('dacheww', 'pass', 'pic', '9999-12-31 23:59:59', true),
		('sasho06', 'pass', 'pic', '9999-12-31 23:59:59', false),
        ('brttt213', 'pass', 'pic', '9999-12-31 23:59:59', false),
        ('ddDrago', 'pass', 'pic', '9999-12-31 23:59:59', false),
        ('Alex1', 'pass', 'pic', '9999-12-31 23:59:59', false);
        
SELECT * FROM users;

ALTER TABLE users
DROP PRIMARY KEY,
ADD PRIMARY KEY (id, username);

ALTER TABLE users
CHANGE last_login_time last_login_time DATETIME DEFAULT NOW();

ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users PRIMARY KEY (id),
ADD CONSTRAINT username UNIQUE (username);



-- 11. Movies Database
USE movies_db;

CREATE TABLE directors(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    director_name VARCHAR(50) NOT NULL,
    notes TEXT
);

INSERT INTO directors(director_name, notes) VALUES 
('Test1', 'text1'),
('Test2', 'text2'),
('Test3', 'text3'),
('Test4', 'text4'),
('Test5', 'text5');

CREATE TABLE genres(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL,
    notes TEXT
);

INSERT INTO genres(genre_name, notes) VALUES 
('Genre1', 'text1'),
('Genre2', 'text2'),
('Genre3', 'text3'),
('Genre4', 'text4'),
('Genre5', 'text5');

CREATE TABLE categories(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    notes TEXT
);

INSERT INTO categories(category_name, notes) VALUES 
('Cat1', 'text1'),
('Cat2', 'text2'),
('Cat3', 'text3'),
('Cat4', 'text4'),
('Cat5', 'text5');


CREATE TABLE movies(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    director_id INT, 
    copyright_year YEAR, 
    length VARCHAR(255), 
    genre_id INT, 
    category_id INT, 
    rating DOUBLE(6,2), 
    notes TEXT
);

INSERT INTO 
movies (title, director_id, copyright_year, length, genre_id, category_id, rating, notes) 
VALUES 
('Title1', '2', '1999', '180', '5', '3', '5.00', 'notes1'),
('Title2', '3', '1998', '180', '6', '4', '5.50', 'notes2'),
('Title3', '4', '1998', '180', '6', '4', '5.50', 'notes3'),
('Title4', '5', '1998', '180', '6', '4', '5.50', 'notes4'),
('Title5', '6', '1998', '180', '6', '4', '5.50', 'notes5');



-- 12. Car Rental Database
USE car_rental_db;

CREATE TABLE categories(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(50) NOT NULL,
    daily_rate DOUBLE(6,2),
    weekly_rate DOUBLE(6,2),
    monthly_rate DOUBLE(6,2),
    weekend_rate DOUBLE(6,2)
);

INSERT INTO categories (category, daily_rate, weekly_rate, monthly_rate, weekend_rate) VALUES
('category1', '3.0', '5.0', '7.22', '1.00'),
('category2', '1.0', '15.0', '9.22', '12.00'),
('category3', '5.0', '2.0', '7.55', '9.00');

CREATE TABLE cars(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    plate_number VARCHAR(50) NOT NULL,
    make VARCHAR(50),
    model VARCHAR(50),
    car_year YEAR,
    category_id INT,
    doors INT,
    picture BLOB,
    car_condition VARCHAR(50),
    available BOOL
);

INSERT INTO cars (plate_number, make, model, car_year, category_id, doors, picture, car_condition, available) VALUES
('X6168MA', 'VW', 'GOLF', '2010', '3', '4', 'coolPicture', 'used', true),
('X2790MA', 'TOYOTA', 'LAND CRUISER', NULL, '2', '2', 'coolPicture', 'used', true),
('PB7575XX', 'AUDI', 'A^', '2018', '8', '4', 'coolPicture', 'new', true);

CREATE TABLE employees(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    title VARCHAR(50),
    notes TEXT
);

INSERT INTO employees (first_name, last_name, title, notes) VALUES
('Ivan', 'Dachev', 'title1', 'info'),
('Kiro', 'KAl', 'title2', 'info'),
('Kris', 'Kei', 'title3', 'info');

CREATE TABLE customers(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    driver_licence_number VARCHAR(50) NOT NULL,
    full_name VARCHAR(50) NOT NULL,
    address VARCHAR(50),
    city VARCHAR(50),
    zip_code INT,
    notes TEXT
);

INSERT INTO customers (driver_licence_number, full_name, address, city, zip_code, notes) VALUES
('15132485124', 'full_name1', 'adress1', 'Haskovo', '6300', 'note1'),
('11111', 'full_name2', 'adress2', 'Sofia', '1112', 'note2'),
('222222', 'full_name3', 'adress3', 'Varna', '2221', 'note3');

CREATE TABLE rental_orders(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    customer_id INT,
    car_id INT,
    car_condition VARCHAR(50),
    tank_level VARCHAR(50),
    kilometrage_start INT,
    kilometrage_end INT,
    total_kilometrage INT,
    start_date DATETIME,
    end_date DATETIME, 
    total_days INT,
    rate_applied DOUBLE(6,2),
    tax_rate DOUBLE(6,2),
    order_status BOOL,
    notes TEXT
);

INSERT INTO rental_orders 
(employee_id,
 customer_id, 
 car_id, 
 car_condition, 
 tank_level, 
 kilometrage_start, 
 kilometrage_end, 
 total_kilometrage, 
 start_date, 
 end_date, 
 total_days, 
 rate_applied, 
 tax_rate, 
 order_status, 
 notes) 
VALUES
(11, 2, 3, 'new','full', 100, 250, 150, '2005-1-31 12:00:00', '2005-2-13 12:50:00', '11', 6.2, 5.00, true, 'notes'),
(22, 2, 3, 'new','full', 100, 250, 150, '2005-1-31 12:00:00', '2005-2-13 12:50:00', '11', 6.2, 5.00, true, 'notes'),
(33, 2, 3, 'new','full', 100, 250, 150, '2005-1-31 12:00:00', '2005-2-13 12:50:00', '11', 6.2, 5.00, true, 'notes');


