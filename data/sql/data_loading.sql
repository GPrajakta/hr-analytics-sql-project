-- ====================================
-- LOAD EMPLOYEES
-- ====================================
\copy employees(emp_no, birth_date, first_name, last_name, gender, hire_date)
FROM 'D:/sql_database/employees/employees.csv'
DELIMITER ','
CSV HEADER;

-- ====================================
-- LOAD DEPARTMENTS
-- ====================================
\copy departments(dept_no, dept_name)
FROM 'D:/sql_database/employees/departments.csv'
DELIMITER ','
CSV HEADER;

-- ====================================
-- LOAD DEPT_EMP
-- ====================================
\copy dept_emp(emp_no, dept_no, from_date, to_date)
FROM 'D:/sql_database/employees/dept_emp.csv'
DELIMITER ','
CSV HEADER;

-- ====================================
-- LOAD DEPT_MANAGER
-- ====================================
\copy dept_manager(emp_no, dept_no, from_date, to_date)
FROM 'D:/sql_database/employees/dept_manager.csv'
DELIMITER ','
CSV HEADER;

-- ====================================
-- LOAD SALARIES
-- ====================================
\copy salaries(emp_no, salary, from_date, to_date)
FROM 'D:/sql_database/employees/salaries.csv'
DELIMITER ','
CSV HEADER;

-- ====================================
-- LOAD TITLES
-- ====================================
\copy titles(emp_no, title, from_date, to_date)
FROM 'D:/sql_database/employees/titles.csv'
DELIMITER ','
CSV HEADER;
