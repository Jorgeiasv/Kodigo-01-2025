-- 1. Data Definition Language (DDL)
-- Intermediate
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2),
    department_id INT
);

-- Advanced
ALTER TABLE employees
ADD CONSTRAINT chk_positive_salary CHECK (salary > 0);


-- 2. Data Manipulation Language (DML)
-- Intermediate
INSERT INTO employees (id, name, salary, department_id)
VALUES (1, 'Ana Lopez', 950.00, 2);

-- Advanced
UPDATE employees
SET salary = salary * 1.15
WHERE salary < (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = employees.department_id
);


-- 3. Data Control Language (DCL)
-- Intermediate
GRANT SELECT, INSERT ON employees TO sales_user;

-- Advanced
REVOKE UPDATE, DELETE ON employees FROM intern_user;


-- 4. Transaction Control Language (TCL)
-- Intermediate
BEGIN;
UPDATE employees
SET salary = salary + 200
WHERE id = 3;
COMMIT;

-- Advanced
BEGIN;
SAVEPOINT before_change;
UPDATE employees
SET salary = salary - 300
WHERE department_id = 2;
ROLLBACK TO before_change;
COMMIT;


-- 5. Core Clauses (ORDER BY, GROUP BY, JOIN, etc.)
-- Intermediate
SELECT name, salary
FROM employees
WHERE salary > 1000
ORDER BY salary DESC;

-- Advanced
SELECT d.name AS department, COUNT(e.id) AS employee_count
FROM employees e
JOIN departments d ON e.department_id = d.id
GROUP BY d.name
ORDER BY employee_count DESC;


-- 6. Aggregate Functions (AVG(), SUM(), COUNT(), MIN(), MAX())
-- Intermediate
SELECT AVG(salary) AS average_salary
FROM employees;

-- Advanced
SELECT department_id,
       MAX(salary) AS max_salary,
       MIN(salary) AS min_salary,
       COUNT(*) AS total_employees
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 2;
