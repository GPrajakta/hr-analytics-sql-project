-- ============================================================
-- Query: Gender Distribution by Department
-- Category: Workforce Overview
-- Business Question: Is there a gender imbalance in any dept?
-- Technique: Window Function (SUM OVER PARTITION), ROUND
-- ============================================================

SELECT 
    d.dept_name,
    e.gender,
    COUNT(*) AS count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY d.dept_name),
        1
    ) AS pct
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE de.to_date = '9999-01-01'
GROUP BY d.dept_name, e.gender
ORDER BY d.dept_name, e.gender;

-- Expected Output Columns: dept_name | gender | count | pct
-- Power BI Visual: Stacked bar chart (dept_name vs pct, split by gender)
