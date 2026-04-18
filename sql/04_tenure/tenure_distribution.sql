-- ============================================================
-- Query: Tenure Distribution Bands (Current Staff)
-- Category: Tenure & Promotion
-- Business Question: How much experience does our workforce have?
-- Technique: Subquery, CASE WHEN bands, GROUP BY dept + band
-- ============================================================

SELECT 
    d.dept_name,
    tenure_band,
    COUNT(*)                                                   AS employees,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY d.dept_name),
        1
    ) AS pct_of_dept
FROM (
    SELECT 
        de.emp_no,
        de.dept_no,
        CASE
            WHEN DATEDIFF(CURDATE(), e.hire_date) / 365.25 < 2  THEN '0-2 yrs'
            WHEN DATEDIFF(CURDATE(), e.hire_date) / 365.25 < 5  THEN '2-5 yrs'
            WHEN DATEDIFF(CURDATE(), e.hire_date) / 365.25 < 10 THEN '5-10 yrs'
            ELSE '10+ yrs'
        END AS tenure_band
    FROM employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE de.to_date = '9999-01-01'
) banded
JOIN departments d ON banded.dept_no = d.dept_no
GROUP BY d.dept_name, tenure_band
ORDER BY d.dept_name, tenure_band;

-- Expected Output Columns: dept_name | tenure_band | employees | pct_of_dept
-- Power BI Visual: 100% stacked bar chart (dept on Y, pct_of_dept split by tenure_band)
