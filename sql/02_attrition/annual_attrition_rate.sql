-- ============================================================
-- Query: Annual Attrition Rate by Department
-- Category: Attrition & Retention
-- Business Question: Which departments lose the most people each year?
-- Technique: CTEs, calculated rate, DATE_SUB
-- ============================================================

WITH dept_headcount AS (
    -- Current headcount per department (used as denominator)
    SELECT 
        de.dept_no,
        COUNT(DISTINCT de.emp_no) AS current_headcount
    FROM dept_emp de
    WHERE de.to_date = '9999-01-01'
    GROUP BY de.dept_no
),
annual_exits AS (
    -- Count of employees who left each department per year (last 5 years)
    SELECT 
        de.dept_no,
        YEAR(de.to_date) AS exit_year,
        COUNT(*) AS exits
    FROM dept_emp de
    WHERE de.to_date != '9999-01-01'
      AND de.to_date >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR)
    GROUP BY de.dept_no, YEAR(de.to_date)
)
SELECT 
    d.dept_name,
    ae.exit_year,
    ae.exits,
    dh.current_headcount,
    ROUND(100.0 * ae.exits / dh.current_headcount, 1) AS attrition_rate_pct
FROM annual_exits ae
JOIN dept_headcount dh ON ae.dept_no = dh.dept_no
JOIN departments d ON ae.dept_no = d.dept_no
ORDER BY ae.exit_year DESC, attrition_rate_pct DESC;

-- Expected Output Columns: dept_name | exit_year | exits | current_headcount | attrition_rate_pct
-- Power BI Visual: Line chart (attrition_rate_pct over exit_year, one line per dept)
