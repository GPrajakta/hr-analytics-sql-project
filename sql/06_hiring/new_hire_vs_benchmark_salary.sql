-- ============================================================
-- Query: New Hire Salary vs Existing Staff Benchmark
-- Category: Hiring Trends
-- Business Question: Are we paying new hires fairly vs tenured staff?
-- Technique: Two CTEs, salary at hire date, diff percentage
-- ============================================================

WITH new_hire_salaries AS (
    -- Starting salary = first salary record matching the hire date
    SELECT 
        e.emp_no,
        e.hire_date,
        de.dept_no,
        s.salary AS starting_salary
    FROM employees e
    JOIN salaries s  ON e.emp_no = s.emp_no AND s.from_date = e.hire_date
    JOIN dept_emp de ON e.emp_no = de.emp_no AND de.to_date = '9999-01-01'
    WHERE e.hire_date >= DATE_SUB(CURDATE(), INTERVAL 3 YEAR)
),
existing_staff_benchmark AS (
    -- Average current salary of all active employees per department
    SELECT 
        de.dept_no,
        ROUND(AVG(s.salary), 0) AS existing_avg_salary
    FROM salaries s
    JOIN dept_emp de ON s.emp_no = de.emp_no
    WHERE s.to_date  = '9999-01-01'
      AND de.to_date = '9999-01-01'
    GROUP BY de.dept_no
)
SELECT 
    d.dept_name,
    COUNT(nhs.emp_no)                       AS new_hires_last_3yrs,
    ROUND(AVG(nhs.starting_salary), 0)      AS avg_new_hire_salary,
    esb.existing_avg_salary,
    ROUND(
        100.0 * (AVG(nhs.starting_salary) - esb.existing_avg_salary)
        / NULLIF(esb.existing_avg_salary, 0),
        1
    )                                       AS diff_pct
FROM new_hire_salaries nhs
JOIN existing_staff_benchmark esb ON nhs.dept_no = esb.dept_no
JOIN departments d ON nhs.dept_no = d.dept_no
GROUP BY d.dept_name, esb.existing_avg_salary
ORDER BY diff_pct DESC;

-- Expected Output Columns: dept_name | new_hires_last_3yrs | avg_new_hire_salary | existing_avg_salary | diff_pct
-- Power BI Visual: Clustered bar chart comparing avg_new_hire_salary vs existing_avg_salary per dept
-- Positive diff_pct = new hires paid MORE than existing staff (compression risk for existing employees)
-- Negative diff_pct = new hires paid LESS (may signal unfair entry pay)
