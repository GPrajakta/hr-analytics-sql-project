-- ============================================================
-- Query: Average Tenure at Exit
-- Category: Attrition & Retention
-- Business Question: How long do employees stay before leaving?
-- Technique: DATEDIFF, AVG, JOIN
-- ============================================================

SELECT 
    d.dept_name,
    ROUND(AVG(DATEDIFF(de.to_date, e.hire_date) / 365.25), 1) AS avg_tenure_years,
    MIN(ROUND(DATEDIFF(de.to_date, e.hire_date) / 365.25, 1)) AS min_tenure_years,
    MAX(ROUND(DATEDIFF(de.to_date, e.hire_date) / 365.25, 1)) AS max_tenure_years,
    COUNT(*) AS total_exits
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE de.to_date != '9999-01-01'   -- only employees who have left
GROUP BY d.dept_name
ORDER BY avg_tenure_years ASC;

-- Expected Output Columns: dept_name | avg_tenure_years | min_tenure_years | max_tenure_years | total_exits
-- Power BI Visual: Horizontal bar chart sorted by avg_tenure_years ascending
-- Business Insight: Departments with lowest avg tenure need early engagement programs
