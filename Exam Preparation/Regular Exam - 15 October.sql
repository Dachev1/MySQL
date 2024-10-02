USE restaurant_db;

CREATE TABLE waiters
(
    id         INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    email      VARCHAR(50) NOT NULL,
    phone      VARCHAR(50),
    salary     DECIMAL(10, 2)
);

CREATE TABLE tables
(
    id       INT AUTO_INCREMENT PRIMARY KEY,
    floor    INT NOT NULL,
    reserved BOOLEAN,
    capacity INT NOT NULL
);

CREATE TABLE products
(
    id    INT AUTO_INCREMENT PRIMARY KEY,
    name  VARCHAR(30)    NOT NULL UNIQUE,
    type  VARCHAR(30)    NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE clients
(
    id         INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    birthdate  DATE        NOT NULL,
    card       VARCHAR(50),
    review     TEXT
);

CREATE TABLE orders
(
    id           INT AUTO_INCREMENT PRIMARY KEY,
    table_id     INT  NOT NULL,
    waiter_id    INT  NOT NULL,
    order_time   TIME NOT NULL,
    payed_status BOOLEAN,
    FOREIGN KEY (table_id) REFERENCES tables (id),
    FOREIGN KEY (waiter_id) REFERENCES waiters (id)
);

CREATE TABLE orders_products
(
    order_id   INT,
    product_id INT,
    FOREIGN KEY (order_id) REFERENCES orders (id),
    FOREIGN KEY (product_id) REFERENCES products (id)
);

CREATE TABLE orders_clients
(
    order_id  INT,
    client_id INT,
    FOREIGN KEY (order_id) REFERENCES orders (id),
    FOREIGN KEY (client_id) REFERENCES clients (id)
);

INSERT INTO products(name, type, price)
SELECT CONCAT(last_name, ' ', 'specialty'),
       'Cocktail',
       CEIL(salary * 0.01)
FROM waiters
WHERE id > 6;

UPDATE orders
SET table_id = table_id - 1
WHERE table_id BETWEEN 12 AND 23;

DELETE w
FROM waiters w
         LEFT JOIN orders o
                   on w.id = o.waiter_id
WHERE o.id IS NULL;

SELECT *
FROM clients
ORDER BY birthdate DESC, id DESC;

SELECT first_name, last_name, birthdate, review
FROM clients
WHERE card IS NULL
  AND YEAR(birthdate) BETWEEN 1978 AND 1993
ORDER BY last_name DESC, id
LIMIT 5;


SELECT CONCAT(last_name, first_name, LENGTH(first_name), 'Restaurant') AS username,
       REVERSE(SUBSTRING(email, 2, 12))                                AS password
FROM waiters
WHERE salary IS NOT NULL
ORDER BY password DESC;

SELECT id, name, COUNT(name) AS count
FROM products
         JOIN orders_products op on products.id = op.product_id
GROUP BY name
HAVING count >= 5
ORDER BY count DESC, name;

SELECT t.id,
       t.capacity,
       COUNT(oc.client_id) AS count_clients,
       CASE
           WHEN COUNT(oc.client_id) < t.capacity THEN 'Free seats'
           WHEN COUNT(oc.client_id) = t.capacity THEN 'Full'
           ELSE 'Extra seats'
           END             AS availability
FROM tables AS t
         JOIN orders AS o ON t.id = o.table_id
         JOIN orders_clients AS oc ON o.id = oc.order_id
WHERE t.floor = 1
GROUP BY t.id, t.capacity
ORDER BY t.id DESC;

CREATE FUNCTION udf_client_bill(full_name VARCHAR(50)) RETURNS DECIMAL(19, 2)
BEGIN
    RETURN (SELECT SUM(p.price) AS bill
            FROM clients c
                     JOIN orders_clients oc ON c.id = oc.client_id
                     JOIN orders o on oc.order_id = o.id
                     JOIN orders_products op ON o.id = op.order_id
                     JOIN products p on p.id = op.product_id
            WHERE (SELECT CONCAT(first_name, ' ', last_name) = full_name)
            GROUP BY c.id
    );
END;

CREATE PROCEDURE udp_happy_hour(product_type VARCHAR(50))
BEGIN
    UPDATE products p
    SET p.price = p.price * 0.80
    WHERE p.type = product_type AND p.price >= 10;
END;

