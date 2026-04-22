-- ============================================================
-- Query: Workforce Age Distribution
-- Category: Workforce Overview
-- Business Question: What is the age profile of our workforce?
-- Technique: Subquery, TIMESTAMPDIFF, CASE WHEN bands
-- ============================================================

SELECT 
    age_band,
    gender,
    COUNT(*) AS employees
FROM (
    SELECT 
        e.emp_no,
        e.gender,
        CASE
            WHEN TIMESTAMPDIFF(YEAR, e.birth_date, CURDATE()) < 30 THEN 'Under 30'
            WHEN TIMESTAMPDIFF(YEAR, e.birth_date, CURDATE()) BETWEEN 30 AND 39 THEN '30-39'
            WHEN TIMESTAMPDIFF(YEAR, e.birth_date, CURDATE()) BETWEEN 40 AND 49 THEN '40-49'
            ELSE '50+'
        END AS age_band
    FROM employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE de.to_date = '9999-01-01'
) age_data
GROUP BY age_band, gender
ORDER BY age_band, gender;

-- Expected Output Columns: age_band | gender | employees
-- Power BI Visual: Clustered column chart (age_band vs employees, split by gender)
