CREATE TABLE countries
(
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(30) NOT NULL UNIQUE,
    description TEXT,
    currency    VARCHAR(5)  NOT NULL
);

CREATE TABLE airplanes
(
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    model               VARCHAR(50)    NOT NULL UNIQUE,
    passengers_capacity INT            NOT NULL,
    tank_capacity       DECIMAL(19, 2) NOT NULL,
    cost                DECIMAL(19, 2) NOT NULL
);

CREATE TABLE passengers
(
    id         INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name  VARCHAR(30) NOT NULL,
    country_id INT         NOT NULL,

    CONSTRAINT fk_passengers_countries
        FOREIGN KEY (country_id)
            REFERENCES countries (id)
);

CREATE TABLE flights
(
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    flight_code         VARCHAR(30) NOT NULL UNIQUE,
    departure_country   INT         NOT NULL,
    destination_country INT         NOT NULL,
    airplane_id         INT         NOT NULL,
    has_delay           BOOLEAN,
    departure           DATETIME,

    FOREIGN KEY (departure_country) REFERENCES countries (id),
    FOREIGN KEY (destination_country) REFERENCES countries (id),
    FOREIGN KEY (airplane_id) REFERENCES airplanes (id)
);

CREATE TABLE flights_passengers
(
    flight_id    INT,
    passenger_id INT,

    FOREIGN KEY (flight_id) REFERENCES flights (id),
    FOREIGN KEY (passenger_id) REFERENCES passengers (id)
);

INSERT INTO airplanes(model, passengers_capacity, tank_capacity, cost)
SELECT CONCAT(REVERSE(first_name), '797'),
       CHAR_LENGTH(last_name) * 17,
       id * 790,
       CHAR_LENGTH(first_name) * 50.6
FROM passengers
WHERE id <= 5;

UPDATE flights AS f
    JOIN countries AS c on f.departure_country = c.id
SET f.airplane_id = f.airplane_id + 1
WHERE c.name = 'Armenia';

DELETE f
FROM flights f
         LEFT JOIN flights_passengers fp on f.id = fp.flight_id
WHERE fp.passenger_id IS NULL;

SELECT *
FROM airplanes
ORDER BY cost DESC, id DESC;

SELECT flight_code,
       departure_country,
       airplane_id,
       departure
FROM flights
WHERE YEAR(departure) = 2022
ORDER BY airplane_id, flight_code
LIMIT 20;

SELECT CONCAT(UPPER(LEFT(last_name, 2)), country_id) AS flight_code,
       CONCAT(first_name, ' ', last_name)            AS full_name,
       country_id
FROM passengers
         LEFT JOIN flights_passengers fp on passengers.id = fp.passenger_id
WHERE fp.flight_id IS NULL
ORDER BY country_id;

SELECT c.name,
       c.currency,
       COUNT(*) AS booked_tickets
FROM flights f
         JOIN countries c on f.destination_country = c.id
         JOIN flights_passengers fp on f.id = fp.flight_id
GROUP BY c.name
HAVING booked_tickets >= 20
ORDER BY booked_tickets DESC;

SELECT flight_code,
       departure,
       CASE
           WHEN TIME(departure) BETWEEN '05:00:00' AND '11:59:59' THEN 'Morning'
           WHEN TIME(departure) BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
           WHEN TIME(departure) BETWEEN '17:00:00' AND '20:59:59' THEN 'Evening'
           ELSE 'Night'
           END AS day_part
FROM flights
ORDER BY flight_code DESC;

CREATE FUNCTION udf_count_flights_from_country(country VARCHAR(50)) RETURNS VARCHAR(20)
BEGIN
    RETURN (SELECT COUNT(*)
            FROM countries c
                     JOIN flights f on c.id = f.departure_country
            WHERE c.name = country
            GROUP BY c.name);
END;

CREATE PROCEDURE udp_delay_flight(code VARCHAR(50))
BEGIN
    UPDATE flights
    SET departure = DATE_ADD(departure, INTERVAL 30 MINUTE),
        has_delay = 1
    WHERE flight_code = code;
END;






