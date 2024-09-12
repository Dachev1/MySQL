-- 1
CREATE TABLE mountains(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL 
); 

CREATE TABLE peaks(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    mountain_id INT NOT NULL,
    CONSTRAINT fk_mountains_peaks
    FOREIGN KEY (mountain_id)
    REFERENCES mountains(id)
); 

-- 2
SELECT
	vehicles.driver_id,
    vehicles.vehicle_type,
    CONCAT(campers.first_name, ' ', campers.last_name) AS driver_name
FROM vehicles
	JOIN campers ON campers.id = vehicles.driver_id;

-- 3
SELECT 
    routes.starting_point AS route_starting_point,
    routes.end_point AS route_ending_point,
    routes.leader_id,
	CONCAT(campers.first_name, ' ', campers.last_name) AS leader_name
FROM routes
	JOIN campers ON campers.id = routes.leader_id;

-- 4
DROP TABLE mountains;
DROP TABLE peaks;

CREATE TABLE mountains(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
); 

CREATE TABLE peaks(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    mountain_id INT NOT NULL,
    CONSTRAINT fk_mountains_peaks
    FOREIGN KEY (mountain_id)
    REFERENCES mountains(id)
	ON DELETE CASCADE
); 

-- Insert to test
INSERT INTO mountains(name) VALUE('Rila');
INSERT INTO mountains(name) VALUE('Stara Planina');

INSERT INTO peaks(name, mountain_id) VALUE('Musala', 1);
INSERT INTO peaks(name, mountain_id) VALUE('Musala2', 1);
INSERT INTO peaks(name, mountain_id) VALUE('Musala3', 1);
INSERT INTO peaks(name, mountain_id) VALUE('Botev', 2);

SELECT * FROM peaks;

DELETE FROM mountains WHERE id = 1;

-- 5
CREATE DATABASE project_management_db;
USE project_management_db;

CREATE TABLE employees(
	id INT(11) AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    project_id INT(11)
);

CREATE TABLE clients(
	id INT(11) AUTO_INCREMENT PRIMARY KEY,
    client_name VARCHAR(100)
);

CREATE TABLE projects(
id INT(11) AUTO_INCREMENT PRIMARY KEY,
client_id INT(11),
project_lead_id INT(11),

CONSTRAINT fk_projects_client_id_clients_id
FOREIGN KEY (client_id) 
REFERENCES clients(id),

CONSTRAINT fk_projects_project_lead_id_employees_id
FOREIGN KEY (project_lead_id) 
REFERENCES employees(id)
);

ALTER TABLE employees
ADD 
	CONSTRAINT fk_employees_project_id_projects_id
	FOREIGN KEY (project_id) 
	REFERENCES projects(id);

