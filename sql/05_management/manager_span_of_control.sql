-- ============================================================
-- Query: Manager Span of Control
-- Category: Management
-- Business Question: How many direct reports does each manager have?
-- Technique: Multi-table JOIN, GROUP BY, AVG salary of team
-- ============================================================

SELECT 
    CONCAT(e.first_name, ' ', e.last_name)  AS manager_name,
    d.dept_name,
    COUNT(DISTINCT de.emp_no)               AS team_size,
    ROUND(AVG(s_team.salary), 0)            AS team_avg_salary,
    MIN(s_team.salary)                      AS team_min_salary,
    MAX(s_team.salary)                      AS team_max_salary
FROM dept_manager dm
JOIN employees e        ON dm.emp_no = e.emp_no
JOIN departments d      ON dm.dept_no = d.dept_no
JOIN dept_emp de        ON dm.dept_no = de.dept_no  AND de.to_date = '9999-01-01'
JOIN salaries s_team    ON de.emp_no = s_team.emp_no AND s_team.to_date = '9999-01-01'
WHERE dm.to_date = '9999-01-01'   -- current managers only
GROUP BY dm.emp_no, e.first_name, e.last_name, d.dept_name
ORDER BY team_size DESC;

-- Expected Output Columns: manager_name | dept_name | team_size | team_avg_salary | team_min_salary | team_max_salary
-- Power BI Visual: Table or KPI cards per manager + bar chart for team_size
-- Business Insight: Industry benchmark for span of control is 7-10 direct reports
