-- 1
DELIMITER $
CREATE PROCEDURE usp_get_employees_salary_above_35000() 
BEGIN
	SELECT first_name, last_name 
    FROM employees
    WHERE salary > 35000
    ORDER BY first_name, last_name, employee_id;
END $

DELIMITER ;
CALL usp_get_employees_salary_above_35000();

-- 2
DELIMITER $
CREATE PROCEDURE usp_get_employees_salary_above(min_salary DECIMAL(12, 4))
BEGIN
	SELECT first_name, last_name 
    FROM employees
    WHERE salary >= min_salary
    ORDER BY first_name, last_name, employee_id;
END $

-- 3
DELIMITER $
CREATE PROCEDURE usp_get_towns_starting_with(start_str VARCHAR(20))
BEGIN
	SELECT t.name AS town_name 
    FROM employees AS e
    JOIN addresses AS a ON e.address_id = a.address_id
    JOIN towns AS t ON a.town_id = t.town_id
    WHERE t.name LIKE CONCAT(start_str, '%')
    GROUP BY town_name
    ORDER BY town_name;
END $

DELIMITER ;
DROP PROCEDURE usp_get_towns_starting_with;
CALL usp_get_towns_starting_with('b');

-- 4
DELIMITER $
CREATE PROCEDURE usp_get_employees_from_town(town_name VARCHAR(20))
BEGIN
	SELECT first_name, last_name 
    FROM employees AS e
	JOIN addresses AS a ON e.address_id = a.address_id
    JOIN towns AS t ON a.town_id = t.town_id
    WHERE t.name = town_name
    ORDER BY first_name, last_name, employee_id;
END $

DELIMITER ;
CALL usp_get_employees_from_town('Sofia');

-- 5
DELIMITER $
CREATE FUNCTION ufn_get_salary_level(employee_salary DECIMAL(12,2)) RETURNS VARCHAR(10)
READS SQL DATA
BEGIN
	DECLARE result VARCHAR(10);
    
     CASE 
        WHEN employee_salary < 30000 THEN
            SET result := 'Low';
        WHEN employee_salary BETWEEN 30000 AND 50000 THEN
            SET result := 'Average';
        ELSE
            SET result := 'High';
    END CASE;
    
    RETURN result;
END $

DELIMITER ;
SELECT salary, ufn_get_salary_level(salary) FROM employees; 

-- 6
DELIMITER $
CREATE PROCEDURE usp_get_employees_by_salary_level(level_of_salary VARCHAR(10))
BEGIN
	SELECT first_name, last_name
    FROM employees
	WHERE ufn_get_salary_level(salary) = level_of_salary
    ORDER BY first_name DESC, last_name DESC;
END $

DELIMITER ;

-- 7
DELIMITER $
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50)) RETURNS TINYINT
DETERMINISTIC
BEGIN
	RETURN word REGEXP CONCAT('^[', set_of_letters, ']+$');
END $

-- 8
DELIMITER $
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN
	SELECT CONCAT(first_name, ' ',last_name) AS full_name
	FROM account_holders
	ORDER BY full_name, id;
END $

DELIMITER ;

-- 9
DELIMITER $
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(money DECIMAL(19,4))
BEGIN
	SELECT 
    ah.first_name, ah.last_name
FROM
    account_holders AS ah
        JOIN
    accounts AS a ON ah.id = a.account_holder_id
WHERE
    (SELECT 
            SUM(balance)
        FROM
            account_holders
                JOIN
				accounts ON account_holders.id = accounts.account_holder_id
            WHERE 
				accounts.account_holder_id = a.account_holder_id) > money
GROUP BY a.account_holder_id
ORDER BY ah.id;
END $

DELIMITER ;

DROP PROCEDURE usp_get_holders_with_balance_higher_than;
CALL usp_get_holders_with_balance_higher_than(7000);

-- 10
DELIMITER $
CREATE FUNCTION ufn_calculate_future_value(
sum DECIMAL(12, 4), 
yearly_interest_rate DOUBLE(12, 2),
number_of_years INT
) RETURNS DECIMAL(12, 4)
READS SQL DATA
BEGIN
    RETURN sum * POW((1 + yearly_interest_rate), number_of_years);
END $

DELIMITER ;
SELECT ufn_calculate_future_value(1000, 0.5, 5);

-- 11
DELIMITER $
CREATE PROCEDURE usp_calculate_future_value_for_account(id INT, interest_rate DOUBLE(12, 4))
BEGIN
    DECLARE years INT;
	SET years := 5;
    
    SELECT 
		a.id,
		ah.first_name,
		ah.last_name,
        a.balance AS current_balance,
        ufn_calculate_future_value(a.balance, interest_rate, years) AS balance_in_5_years
    FROM account_holders AS ah
		JOIN accounts AS a ON ah.id = a.account_holder_id
    WHERE a.id = id;
END $

DELIMITER ;
CALL usp_calculate_future_value_for_account(1, 0.1);

-- 12
DELIMITER $
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DOUBLE(12,4))
BEGIN
	START TRANSACTION;
    IF (SELECT COUNT(*)
		FROM account_holders AS ah
			JOIN accounts AS a ON ah.id = a.account_holder_id
		WHERE a.id = account_id OR money_amount < 0) <> 1 THEN ROLLBACK;
     ELSE
		UPDATE accounts
        SET balance = balance + money_amount
        WHERE id = account_id;
        COMMIT;
     END IF;   
END $

DELIMITER ;

CALL usp_deposit_money(1, 10);

-- 13
DELIMITER $
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DOUBLE(12,4))
BEGIN
 DECLARE current_balance DECIMAL(12, 4);
	START TRANSACTION;
    IF ((SELECT COUNT(*) FROM accounts WHERE id = account_id) <> 1 OR 
    (SELECT balance FROM accounts WHERE id = account_id) < money_amount OR 
    money_amount <0)
THEN ROLLBACK;
     ELSE
		UPDATE accounts
        SET balance = balance - money_amount
        WHERE id = account_id;
        COMMIT;
     END IF;   
END $

-- 14
DELIMITER $
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DOUBLE(19,4)) 
BEGIN
		START TRANSACTION;
		IF ((SELECT COUNT(*) FROM accounts WHERE id = from_account_id) <> 1 OR
		(SELECT COUNT(*) FROM accounts WHERE id = to_account_id) <> 1 OR
		((SELECT balance FROM accounts WHERE id = from_account_id) < amount) OR 
		amount <= 0 OR
		from_account_id = to_account_id) THEN ROLLBACK;
	ELSE 
		UPDATE accounts SET balance = balance - amount WHERE id = from_account_id;
		UPDATE accounts SET balance = balance + amount WHERE id = to_account_id;
		COMMIT;
	END IF;
END $

DELIMITER ;

SELECT 	a.id, 
	ah.id AS account_holder_id, 
	a.balance
FROM account_holders AS ah 
JOIN accounts AS a ON ah.id = a.account_holder_id 
WHERE a.id IN (1, 2);

CALL usp_transfer_money(5, 2, 14);

-- 15
CREATE TABLE logs(
	log_id INT AUTO_INCREMENT PRIMARY KEY, 
    account_id INT, 
    old_sum DECIMAL(12,4), 
    new_sum DECIMAL (12,4),
    
	CONSTRAINT fk_logs_accounts
    FOREIGN KEY (account_id) 
    REFERENCES accounts(id)
);

CREATE TRIGGER trigger_transaction
AFTER UPDATE
ON accounts
FOR EACH ROW
INSERT INTO logs(account_id, old_sum, new_sum)
VALUES(old.id, old.balance, new.balance);

-- 16
CREATE TABLE notification_emails(
	id INT AUTO_INCREMENT PRIMARY KEY, 
	recipient INT, 
	subject VARCHAR(255), 
    body VARCHAR(255)
);

CREATE TRIGGER trigger_add_log
AFTER INSERT
ON logs
FOR EACH ROW
INSERT INTO notification_emails(recipient, subject, body)
VALUES(
new.account_id, 
CONCAT('Balance change for account: ', new.account_id), 
CONCAT('On ', DATE_FORMAT(NOW(), '%b %d %Y at %h:%i:%s'),' your balance was changed from ' , ROUND(new.old_sum, 0), ' to ', ROUND(new.new_sum, 0))
);