-- ============================================================
-- Query: Top 10% Earners — Who Are They?
-- Category: Salary Analytics
-- Business Question: Profile of highest-paid employees
-- Technique: Window Function (PERCENT_RANK), 5-table JOIN
-- ============================================================

WITH salary_ranked AS (
    SELECT 
        e.emp_no,
        e.first_name,
        e.last_name,
        e.gender,
        s.salary,
        t.title,
        d.dept_name,
        PERCENT_RANK() OVER (ORDER BY s.salary)             AS company_pct_rank,
        PERCENT_RANK() OVER (
            PARTITION BY d.dept_name ORDER BY s.salary
        )                                                    AS dept_pct_rank
    FROM employees e
    JOIN salaries s  ON e.emp_no = s.emp_no  AND s.to_date  = '9999-01-01'
    JOIN titles t    ON e.emp_no = t.emp_no   AND t.to_date  = '9999-01-01'
    JOIN dept_emp de ON e.emp_no = de.emp_no  AND de.to_date = '9999-01-01'
    JOIN departments d ON de.dept_no = d.dept_no
)
SELECT 
    emp_no,
    first_name,
    last_name,
    gender,
    salary,
    title,
    dept_name,
    ROUND(company_pct_rank * 100, 1) AS company_percentile,
    ROUND(dept_pct_rank * 100, 1)    AS dept_percentile
FROM salary_ranked
WHERE company_pct_rank >= 0.90
ORDER BY salary DESC;

-- Expected Output Columns: emp_no | first_name | last_name | gender | salary | title | dept_name | company_percentile | dept_percentile
-- Power BI Visual: Table with salary formatted as currency + conditional color on gender
