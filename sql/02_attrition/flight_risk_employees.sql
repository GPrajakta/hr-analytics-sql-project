-- ============================================================
-- Query: Flight Risk Employees
-- Category: Attrition & Retention
-- Business Question: Who might be disengaged and leave soon?
-- Technique: CTE, multiple risk criteria, HAVING equivalent via WHERE
-- Risk Criteria: tenure >= 5 yrs AND never promoted AND still active
-- ============================================================

WITH employee_profile AS (
    SELECT 
        e.emp_no,
        e.first_name,
        e.last_name,
        e.gender,
        e.hire_date,
        ROUND(DATEDIFF(CURDATE(), e.hire_date) / 365.25, 1)  AS tenure_years,
        COUNT(DISTINCT t.title)                                AS distinct_titles,
        MAX(s.salary)                                          AS current_salary
    FROM employees e
    JOIN titles t    ON e.emp_no = t.emp_no
    JOIN salaries s  ON e.emp_no = s.emp_no AND s.to_date = '9999-01-01'
    JOIN dept_emp de ON e.emp_no = de.emp_no AND de.to_date = '9999-01-01'
    GROUP BY e.emp_no, e.first_name, e.last_name, e.gender, e.hire_date
)
SELECT 
    ep.emp_no,
    ep.first_name,
    ep.last_name,
    ep.gender,
    ep.tenure_years,
    ep.distinct_titles      AS titles_held,
    ep.current_salary,
    d.dept_name,
    -- Risk label based on how many criteria are met
    CASE
        WHEN ep.tenure_years >= 8 THEN 'HIGH RISK'
        WHEN ep.tenure_years >= 5 THEN 'MEDIUM RISK'
    END AS flight_risk_level
FROM employee_profile ep
JOIN dept_emp de ON ep.emp_no = de.emp_no AND de.to_date = '9999-01-01'
JOIN departments d ON de.dept_no = d.dept_no
WHERE ep.tenure_years >= 5
  AND ep.distinct_titles = 1    -- never promoted (only ever had 1 title)
ORDER BY ep.tenure_years DESC;

-- Expected Output Columns: emp_no | first_name | last_name | gender | tenure_years | titles_held | current_salary | dept_name | flight_risk_level
-- Power BI Visual: Table with conditional formatting on flight_risk_level
-- Use as: HR intervention list for retention conversations
