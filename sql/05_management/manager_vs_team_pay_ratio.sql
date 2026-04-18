-- ============================================================
-- Query: Manager vs Team Pay Ratio
-- Category: Management
-- Business Question: Are managers paid proportionally to their team?
-- Technique: Two CTEs, ratio calculation, NULLIF for safety
-- ============================================================

WITH manager_salary AS (
    SELECT 
        dm.dept_no,
        dm.emp_no AS mgr_emp_no,
        s.salary  AS mgr_salary
    FROM dept_manager dm
    JOIN salaries s ON dm.emp_no = s.emp_no
    WHERE dm.to_date = '9999-01-01'
      AND s.to_date  = '9999-01-01'
),
team_avg_salary AS (
    SELECT 
        de.dept_no,
        ROUND(AVG(s.salary), 0) AS avg_team_salary
    FROM dept_emp de
    JOIN salaries s ON de.emp_no = s.emp_no
    WHERE de.to_date = '9999-01-01'
      AND s.to_date  = '9999-01-01'
    GROUP BY de.dept_no
)
SELECT 
    d.dept_name,
    CONCAT(e.first_name, ' ', e.last_name) AS manager_name,
    ms.mgr_salary,
    ts.avg_team_salary,
    ROUND(ms.mgr_salary / NULLIF(ts.avg_team_salary, 0), 2) AS pay_ratio,
    CASE
        WHEN ms.mgr_salary / NULLIF(ts.avg_team_salary, 0) > 1.5
            THEN 'Above benchmark'
        WHEN ms.mgr_salary / NULLIF(ts.avg_team_salary, 0) BETWEEN 1.15 AND 1.5
            THEN 'Within benchmark'
        ELSE 'Below benchmark'
    END AS ratio_assessment
FROM manager_salary ms
JOIN team_avg_salary ts ON ms.dept_no = ts.dept_no
JOIN departments d      ON ms.dept_no = d.dept_no
JOIN employees e        ON ms.mgr_emp_no = e.emp_no
ORDER BY pay_ratio DESC;

-- Expected Output Columns: dept_name | manager_name | mgr_salary | avg_team_salary | pay_ratio | ratio_assessment
-- Power BI Visual: Scatter plot (team_avg_salary vs mgr_salary) with reference line at 1.3x
-- Industry benchmark: pay_ratio of 1.15 to 1.5 is considered healthy
