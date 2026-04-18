-- ============================================================
-- Query: Average Salary by Department (Current)
-- Category: Salary Analytics
-- Business Question: Which departments pay the most?
-- Technique: AVG, MIN, MAX, multi-table JOIN
-- ============================================================

SELECT 
    d.dept_name,
    ROUND(AVG(s.salary), 0) AS avg_salary,
    ROUND(MIN(s.salary), 0) AS min_salary,
    ROUND(MAX(s.salary), 0) AS max_salary,
    ROUND(MAX(s.salary) - MIN(s.salary), 0) AS pay_range,
    COUNT(DISTINCT s.emp_no) AS employee_count
FROM salaries s
JOIN dept_emp de ON s.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE s.to_date = '9999-01-01'
  AND de.to_date = '9999-01-01'
GROUP BY d.dept_name
ORDER BY avg_salary DESC;

-- Expected Output Columns: dept_name | avg_salary | min_salary | max_salary | pay_range | employee_count
-- Power BI Visual: Bar chart sorted by avg_salary, with error bars showing min/max range
