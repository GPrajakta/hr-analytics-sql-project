-- ============================================================
-- Query: Average Time to First Promotion
-- Category: Tenure & Promotion
-- Business Question: How long before employees get their first title change?
-- Technique: CTE, MIN(from_date), DATEDIFF, GROUP BY dept
-- ============================================================

WITH first_promotion AS (
    SELECT 
        e.emp_no,
        e.hire_date,
        MIN(t.from_date)  AS first_promo_date
    FROM employees e
    JOIN titles t ON e.emp_no = t.emp_no
    WHERE t.from_date > e.hire_date    -- exclude the title assigned at hire
    GROUP BY e.emp_no, e.hire_date
)
SELECT 
    d.dept_name,
    ROUND(AVG(DATEDIFF(fp.first_promo_date, fp.hire_date) / 365.25), 1) AS avg_years_to_promo,
    MIN(ROUND(DATEDIFF(fp.first_promo_date, fp.hire_date) / 365.25, 1)) AS min_years,
    MAX(ROUND(DATEDIFF(fp.first_promo_date, fp.hire_date) / 365.25, 1)) AS max_years,
    COUNT(*)                                                             AS promoted_count
FROM first_promotion fp
JOIN dept_emp de ON fp.emp_no = de.emp_no AND de.to_date = '9999-01-01'
JOIN departments d ON de.dept_no = d.dept_no
GROUP BY d.dept_name
ORDER BY avg_years_to_promo ASC;

-- Expected Output Columns: dept_name | avg_years_to_promo | min_years | max_years | promoted_count
-- Power BI Visual: Horizontal bar chart sorted ascending — fastest promoting departments at top
