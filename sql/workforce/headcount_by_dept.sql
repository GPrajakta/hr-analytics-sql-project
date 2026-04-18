-- ============================================================
-- Query: Headcount by Department
-- Category: Workforce Overview
-- Business Question: Which departments are largest?
-- Technique: JOIN, GROUP BY, COUNT DISTINCT
-- ============================================================

SELECT 
    d.dept_name,
    COUNT(DISTINCT de.emp_no) AS headcount
FROM departments d
JOIN dept_emp de ON d.dept_no = de.dept_no
WHERE de.to_date = '9999-01-01'   -- current employees only
GROUP BY d.dept_name
ORDER BY headcount DESC;

-- Expected Output Columns: dept_name | headcount
-- Power BI Visual: Bar chart (dept_name vs headcount)
