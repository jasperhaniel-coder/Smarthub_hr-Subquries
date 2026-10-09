-- SmartHub Academy: SQL Assignment - Subqueries (Questions 1-20)
-- Create/connect to smarthub_hr and run the supplied script (1).docx employee setup first.

-- Q1. Employees earning more than the company-wide average salary.
SELECT emp_id, full_name, department, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC, full_name;

-- Q2. Employees in the same department as Chinedu Eze.
SELECT emp_id, full_name, department
FROM employees
WHERE department = (
    SELECT department
    FROM employees
    WHERE full_name = 'Chinedu Eze'
)
ORDER BY full_name;

-- Q3. Employee(s) with the highest salary; ties are retained.
SELECT emp_id, full_name, salary
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees)
ORDER BY full_name;

-- Q4. Employee(s) with the lowest salary; ties are retained.
SELECT emp_id, full_name, salary
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees)
ORDER BY full_name;

-- Q5. Employees earning below the company-wide average salary.
SELECT emp_id, full_name, department, salary
FROM employees
WHERE salary < (SELECT AVG(salary) FROM employees)
ORDER BY salary, full_name;

-- Q6. Employees paid more than the average salary in their own department.
SELECT e.emp_id, e.full_name, e.department, e.salary
FROM employees AS e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM employees AS e2
    WHERE e2.department = e.department
)
ORDER BY e.department, e.salary DESC;

-- Q7. Employees earning more than Grace Effiong.
SELECT emp_id, full_name, salary
FROM employees
WHERE salary > (
    SELECT salary
    FROM employees
    WHERE full_name = 'Grace Effiong'
)
ORDER BY salary DESC, full_name;

-- Q8. Employees whose salary is greater than every Sales department salary.
SELECT emp_id, full_name, department, salary
FROM employees
WHERE salary > ALL (
    SELECT salary
    FROM employees
    WHERE department = 'Sales'
)
ORDER BY salary DESC, full_name;

-- Q9. Employees whose salary is greater than at least one Engineering salary.
SELECT emp_id, full_name, department, salary
FROM employees
WHERE salary > ANY (
    SELECT salary
    FROM employees
    WHERE department = 'Engineering'
)
ORDER BY salary DESC, full_name;

-- Q10. Employees earning more than their own manager.
SELECT
    e.emp_id,
    e.full_name AS employee_name,
    e.salary AS employee_salary,
    m.full_name AS manager_name,
    m.salary AS manager_salary
FROM employees AS e
JOIN employees AS m ON m.emp_id = e.manager_id
WHERE e.salary > m.salary
ORDER BY e.full_name;

-- Q11. Employees who do not directly manage anyone.
SELECT e.emp_id, e.full_name, e.department, e.role
FROM employees AS e
WHERE NOT EXISTS (
    SELECT 1
    FROM employees AS report
    WHERE report.manager_id = e.emp_id
)
ORDER BY e.full_name;

-- Q12. Employees who manage at least one other employee.
SELECT e.emp_id, e.full_name, e.department, e.role
FROM employees AS e
WHERE EXISTS (
    SELECT 1
    FROM employees AS report
    WHERE report.manager_id = e.emp_id
)
ORDER BY e.full_name;

-- Q13. Employees hired before Kelechi Amadi.
SELECT emp_id, full_name, hire_date
FROM employees
WHERE hire_date < (
    SELECT hire_date
    FROM employees
    WHERE full_name = 'Kelechi Amadi'
)
ORDER BY hire_date, full_name;

-- Q14. Employees tied for the highest salary in their department.
SELECT e.emp_id, e.full_name, e.department, e.salary
FROM employees AS e
WHERE e.salary = (
    SELECT MAX(e2.salary)
    FROM employees AS e2
    WHERE e2.department = e.department
)
ORDER BY e.department, e.full_name;

-- Q15. Employees earning more than the average non-NULL bonus.
SELECT emp_id, full_name, salary, bonus
FROM employees
WHERE salary > (
    SELECT AVG(bonus)
    FROM employees
    WHERE bonus IS NOT NULL
)
ORDER BY salary DESC, full_name;

-- Q16. Departments whose average salary exceeds the company-wide average.
SELECT department, AVG(salary) AS department_average_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees)
ORDER BY department;

-- Q17. Employees earning more than the average Engineering salary.
SELECT emp_id, full_name, department, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department = 'Engineering'
)
ORDER BY salary DESC, full_name;

-- Q18. Employees within 200,000 of the highest company salary, including the top earner.
SELECT emp_id, full_name, salary
FROM employees
WHERE salary >= (SELECT MAX(salary) FROM employees) - 200000
ORDER BY salary DESC, full_name;

-- Q19. Derived-table example: Engineering staff earning above 500,000.
SELECT engineering_staff.emp_id,
       engineering_staff.full_name,
       engineering_staff.department,
       engineering_staff.role,
       engineering_staff.salary
FROM (
    SELECT emp_id, full_name, department, role, salary
    FROM employees
    WHERE department = 'Engineering'
) AS engineering_staff
WHERE engineering_staff.salary > 500000
ORDER BY engineering_staff.salary DESC, engineering_staff.full_name;

-- Q20. Employee(s) with the second-highest distinct salary; ties are retained.
SELECT emp_id, full_name, salary
FROM employees
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
    WHERE salary < (SELECT MAX(salary) FROM employees)
)
ORDER BY full_name;
