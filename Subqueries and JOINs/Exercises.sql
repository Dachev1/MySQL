-- 1
SELECT 
    e.employee_id, e.job_title, e.address_id, a.address_text
FROM
    employees AS e
        JOIN
    addresses AS a ON e.address_id = a.address_id
ORDER BY e.address_id
LIMIT 5;

-- 2
SELECT 
    e.first_name, e.last_name, t.name, a.address_text
FROM
    employees AS e
        JOIN
    addresses AS a ON e.address_id = a.address_id
        JOIN
    towns AS t ON a.town_id = t.town_id
ORDER BY e.first_name , e.last_name
LIMIT 5;

-- 3
SELECT 
    e.employee_id, e.first_name, e.last_name, d.name
FROM
    employees AS e
        JOIN
    departments AS d ON e.department_id = d.department_id
WHERE
    d.name = 'Sales'
ORDER BY e.employee_id DESC;

-- 4
SELECT 
    e.employee_id, e.first_name, e.salary, d.name
FROM
    employees AS e
        JOIN
    departments AS d ON e.department_id = d.department_id
WHERE
    salary > 15000
ORDER BY d.department_id DESC
LIMIT 5;

-- 5
SELECT 
    e.employee_id, e.first_name
FROM
    employees AS e
        LEFT JOIN
    employees_projects AS ep ON e.employee_id = ep.employee_id
WHERE
    ep.project_id IS NULL
ORDER BY e.employee_id DESC
LIMIT 3;

-- 6
SELECT 
    e.first_name, e.last_name, e.hire_date, d.name AS dept_name
FROM
    employees AS e
        JOIN
    departments AS d ON e.department_id = d.department_id
WHERE
    e.hire_date > 1999 - 01 - 01
        AND d.name IN ('Sales' , 'Finance')
ORDER BY e.hire_date;

-- 7
SELECT 
    e.employee_id, e.first_name, p.name AS project_name
FROM
    employees AS e
        JOIN
    employees_projects AS ep ON e.employee_id = ep.employee_id
        JOIN
    projects AS p ON ep.project_id = p.project_id
WHERE
    DATE(p.start_date) > 2002 - 08 - 13
        AND p.end_date IS NULL
ORDER BY e.first_name , p.name
LIMIT 5;

-- 8
SELECT 
    e.employee_id,
    e.first_name,
    CASE
        WHEN p.start_date >= '2005-01-01' THEN NULL
        ELSE p.name
    END AS project_name
FROM
    employees AS e
        JOIN
    employees_projects AS ep ON e.employee_id = ep.employee_id
        JOIN
    projects AS p ON ep.project_id = p.project_id
WHERE
    e.employee_id = 24
ORDER BY p.name;

-- 9
SELECT 
    employee_id,
    first_name,
    manager_id,
    CASE
        WHEN
            manager_id = 3
        THEN
            (SELECT 
                    first_name
                FROM
                    employees
                WHERE
                    employee_id = 3)
        WHEN
            manager_id = 7
        THEN
            (SELECT 
                    first_name
                FROM
                    employees
                WHERE
                    employee_id = 7)
    END AS manager_name
FROM
    employees
WHERE
    manager_id IN (3 , 7)
ORDER BY first_name;

-- 10
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    (SELECT 
            CONCAT(first_name, ' ', last_name)
        FROM
            employees
        WHERE
            e.manager_id = employee_id) AS manager_name,
    d.name AS department_name
FROM
    employees AS e
        JOIN
    departments AS d ON e.department_id = d.department_id
WHERE
    e.manager_id IS NOT NULL
ORDER BY e.employee_id
LIMIT 5;

-- 11
SELECT 
    MIN(avg_salary) AS lowest_avg_salary
FROM
    (SELECT 
        AVG(salary) AS avg_salary
    FROM
        employees
    GROUP BY department_id) AS dept_avg_salaries;

-- 12
SELECT 
    c.country_code, m.mountain_range, p.peak_name, p.elevation
FROM
    countries AS c
        JOIN
    mountains_countries AS mc ON c.country_code = mc.country_code
        JOIN
    mountains AS m ON mc.mountain_id = m.id
        JOIN
    peaks AS p ON m.id = p.mountain_id
WHERE
    c.country_code = 'BG'
        AND p.elevation > 2835
ORDER BY p.elevation DESC;

-- 13
SELECT 
    c.country_code, COUNT(m.mountain_range) AS mountain_range
FROM
    countries AS c
        JOIN
    mountains_countries AS mc ON c.country_code = mc.country_code
        JOIN
    mountains AS m ON mc.mountain_id = m.id
WHERE
    c.country_code IN ('BG' , 'RU', 'US')
GROUP BY c.country_code
ORDER BY mountain_range DESC;

-- 14
SELECT 
    c.country_name, r.river_name
FROM
    countries AS c
        LEFT JOIN
    countries_rivers AS cr ON c.country_code = cr.country_code
        LEFT JOIN
    rivers r ON cr.river_id = r.id
WHERE
    c.continent_code = 'AF'
ORDER BY c.country_name
LIMIT 5;

-- 15
	SELECT 
    c.continent_code,
    c.currency_code,
    COUNT(*) AS currency_usage
FROM
    countries AS c
GROUP BY c.continent_code , c.currency_code
HAVING currency_usage > 1
    AND currency_usage = (SELECT 
        COUNT(*) AS max_usage
    FROM
        countries
    WHERE
        continent_code = c.continent_code
    GROUP BY continent_code , currency_code
    ORDER BY max_usage DESC
    LIMIT 1)
ORDER BY c.continent_code , c.currency_code;

-- 16
SELECT 
    COUNT(c.country_code) AS country_count
FROM
    countries c
        LEFT JOIN
    mountains_countries mc ON c.country_code = mc.country_code
WHERE
    mc.mountain_id IS NULL;

-- 17
SELECT 
    c.country_name,
    COALESCE(MAX(p.elevation), NULL) AS highest_peak_elevation,
    COALESCE(MAX(r.length), NULL) AS longest_river_length
FROM
    countries AS c
        LEFT JOIN
    mountains_countries AS mc ON c.country_code = mc.country_code
        LEFT JOIN
    peaks AS p ON mc.mountain_id = p.mountain_id
        LEFT JOIN
    countries_rivers AS cr ON c.country_code = cr.country_code
        LEFT JOIN
    rivers AS r ON cr.river_id = r.id
GROUP BY c.country_name
ORDER BY highest_peak_elevation DESC , longest_river_length DESC , c.country_name ASC
LIMIT 5;