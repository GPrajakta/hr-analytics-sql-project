
-- Primary Keys
ALTER TABLE employees
ADD CONSTRAINT pk_employees PRIMARY KEY (emp_no);

ALTER TABLE departments
ADD CONSTRAINT pk_departments PRIMARY KEY (dept_no);

ALTER TABLE dept_emp
ADD CONSTRAINT pk_dept_emp PRIMARY KEY (emp_no, dept_no);

-- Foreign Keys
ALTER TABLE dept_emp
ADD CONSTRAINT fk_dept_emp_employee
FOREIGN KEY (emp_no) REFERENCES employees(emp_no);

ALTER TABLE dept_emp
ADD CONSTRAINT fk_dept_emp_department
FOREIGN KEY (dept_no) REFERENCES departments(dept_no);

-- Check Constraints
ALTER TABLE employees
ADD CONSTRAINT chk_gender CHECK (gender IN ('M','F'));

ALTER TABLE salaries
ADD CONSTRAINT chk_salary CHECK (salary > 0);

-- NOT NULL
ALTER TABLE employees
ALTER COLUMN first_name SET NOT NULL;

