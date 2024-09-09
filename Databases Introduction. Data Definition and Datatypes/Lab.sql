 CREATE TABLE `employees` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(50) NULL,
  `last_name` VARCHAR(50) NULL,
  PRIMARY KEY (`id`)
  );

CREATE TABLE `categories` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `products` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `category_id` INT,
    PRIMARY KEY (`id`)
);

INSERT INTO employees (first_name, last_name) 
VALUES 
("Alex", "Ivanov"),
("Pesho", "Petrov"),
("Bobi", "Atanasov");

ALTER TABLE employees
ADD middle_name VARCHAR(50) NOT NULL;

ALTER TABLE employees
MODIFY COLUMN middle_name VARCHAR(100);

SELECT * FROM employees;