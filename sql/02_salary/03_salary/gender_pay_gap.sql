-- ============================================================
-- Query: Gender Pay Gap by Department
-- Category: Salary Analytics
-- Business Question: Is there a pay disparity between genders?
-- Technique: CTE, PIVOT with CASE WHEN, calculated gap percentage
-- ============================================================

WITH gender_salary AS (
    SELECT 
        d.dept_name,
        e.gender,
        ROUND(AVG(s.salary), 0) AS avg_salary
    FROM employees e
    JOIN salaries s  ON e.emp_no = s.emp_no  AND s.to_date  = '9999-01-01'
    JOIN dept_emp de ON e.emp_no = de.emp_no  AND de.to_date = '9999-01-01'
    JOIN departments d ON de.dept_no = d.dept_no
    GROUP BY d.dept_name, e.gender
)
SELECT 
    dept_name,
    MAX(CASE WHEN gender = 'M' THEN avg_salary END) AS male_avg_salary,
    MAX(CASE WHEN gender = 'F' THEN avg_salary END) AS female_avg_salary,
    MAX(CASE WHEN gender = 'M' THEN avg_salary END)
        - MAX(CASE WHEN gender = 'F' THEN avg_salary END) AS absolute_gap,
    ROUND(
        100.0 * (
            MAX(CASE WHEN gender = 'M' THEN avg_salary END)
            - MAX(CASE WHEN gender = 'F' THEN avg_salary END)
        ) / NULLIF(MAX(CASE WHEN gender = 'M' THEN avg_salary END), 0),
        1
    ) AS gap_pct
FROM gender_salary
GROUP BY dept_name
ORDER BY gap_pct DESC;

-- Expected Output Columns: dept_name | male_avg_salary | female_avg_salary | absolute_gap | gap_pct
-- Power BI Visual: Diverging bar chart centered at 0 (gap_pct)
-- Positive gap_pct = males earn more. Negative = females earn more.
-- Business Insight: Any dept above 5% warrants a pay equity audit
