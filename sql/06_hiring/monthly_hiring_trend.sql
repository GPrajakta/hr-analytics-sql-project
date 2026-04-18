-- ============================================================
-- Query: Monthly Hiring Trend
-- Category: Hiring Trends
-- Business Question: When does the company hire the most?
-- Technique: Window Function (SUM OVER), YEAR/MONTH/MONTHNAME
-- ============================================================

SELECT 
    YEAR(hire_date)                                         AS hire_year,
    MONTH(hire_date)                                        AS hire_month,
    MONTHNAME(hire_date)                                    AS month_name,
    COUNT(*)                                                AS new_hires,
    SUM(COUNT(*)) OVER (
        PARTITION BY YEAR(hire_date)
        ORDER BY MONTH(hire_date)
    )                                                       AS ytd_cumulative_hires
FROM employees
GROUP BY YEAR(hire_date), MONTH(hire_date), MONTHNAME(hire_date)
ORDER BY hire_year, hire_month;

-- Expected Output Columns: hire_year | hire_month | month_name | new_hires | ytd_cumulative_hires
-- Power BI Visual: Line chart (month_name on X, new_hires on Y) with year as legend
-- Business Insight: Seasonal hiring peaks = when to prepare onboarding capacity
