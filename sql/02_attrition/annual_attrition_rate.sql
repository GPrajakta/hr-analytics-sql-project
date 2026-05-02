-- ============================================================
-- Query: Annual Attrition Rate by Department
-- Category: Attrition & Retention
-- Business Question: Which departments lose the most people each year?
-- Technique: CTEs, calculated rate, DATE_SUB
-- ============================================================


   WITH dept_headcount AS (
    SELECT 
        dept_no,
        COUNT(DISTINCT emp_no) AS headcount
    FROM dept_emp
    WHERE to_date = '9999-01-01'
    GROUP BY dept_no
),
annual_exits AS (
    SELECT 
        dept_no,
        EXTRACT(YEAR FROM to_date) AS year,
        COUNT(DISTINCT emp_no) AS exits
    FROM dept_emp
    WHERE to_date <> '9999-01-01'
      AND to_date >= CURRENT_DATE - INTERVAL '5 years'
    GROUP BY dept_no, EXTRACT(YEAR FROM to_date)
)

SELECT 
    d.dept_name,
    ae.year,
    ae.exits,
    dh.headcount,
    ROUND(100.0 * ae.exits / dh.headcount, 1) AS attrition_rate
FROM annual_exits ae
JOIN dept_headcount dh 
    ON ae.dept_no = dh.dept_no
JOIN departments d 
    ON ae.dept_no = d.dept_no
ORDER BY ae.year DESC, attrition_rate DESC;
-- Expected Output Columns: dept_name | exit_year | exits | current_headcount | attrition_rate_pct
-- Power BI Visual: Line chart (attrition_rate_pct over exit_year, one line per dept)
