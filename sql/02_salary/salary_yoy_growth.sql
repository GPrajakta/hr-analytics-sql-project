-- ============================================================
-- Query: Salary Growth Year-over-Year (YoY Trend)
-- Category: Salary Analytics
-- Business Question: Are salaries keeping up with the workforce?
-- Technique: CTE, LAG window function, YoY growth calculation
-- ============================================================

WITH yearly_avg AS (
    SELECT 
        YEAR(s.from_date)             AS salary_year,
        d.dept_name,
        ROUND(AVG(s.salary), 0)       AS avg_salary,
        COUNT(DISTINCT s.emp_no)      AS employee_count
    FROM salaries s
    JOIN dept_emp de ON s.emp_no = de.emp_no
    JOIN departments d ON de.dept_no = d.dept_no
    GROUP BY YEAR(s.from_date), d.dept_name
)
SELECT 
    salary_year,
    dept_name,
    avg_salary,
    employee_count,
    LAG(avg_salary) OVER (
        PARTITION BY dept_name ORDER BY salary_year
    ) AS prev_year_avg,
    ROUND(
        100.0 * (
            avg_salary
            - LAG(avg_salary) OVER (PARTITION BY dept_name ORDER BY salary_year)
        ) / NULLIF(
            LAG(avg_salary) OVER (PARTITION BY dept_name ORDER BY salary_year),
            0
        ),
        2
    ) AS yoy_growth_pct
FROM yearly_avg
ORDER BY dept_name, salary_year;

-- Expected Output Columns: salary_year | dept_name | avg_salary | employee_count | prev_year_avg | yoy_growth_pct
-- Power BI Visual: Line chart (salary_year on X-axis, yoy_growth_pct on Y-axis, one line per dept)
-- Business Insight: Negative or sub-2% growth = real-term pay erosion risk
