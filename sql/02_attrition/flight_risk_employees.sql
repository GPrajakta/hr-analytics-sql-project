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
        --------faster tenure calculation -------
        ROUND(
            EXTRACT(YEAR FROM AGE(CURRENT_DATE, e.hire_date)), 1
        ) AS tenure_years,
        COUNT(DISTINCT t.title) AS distinct_titles,
        s.salary AS current_salary
    FROM employees e
    ------------ only current salary (reduces rows early)-------------
    JOIN salaries s  
        ON e.emp_no = s.emp_no 
       AND s.to_date = '9999-01-01'
    --------------- keep titles (needed for promotion logic) --------------
    JOIN titles t    
        ON e.emp_no = t.emp_no
    GROUP BY 
        e.emp_no, e.first_name, e.last_name, 
        e.gender, e.hire_date, s.salary
)
SELECT 
    ep.emp_no,
    ep.first_name,
    ep.last_name,
    ep.gender,
    ep.tenure_years,
    ep.distinct_titles AS titles_held,
    ep.current_salary,
    d.dept_name,
    CASE
        WHEN ep.tenure_years >= 8 THEN 'HIGH RISK'
        WHEN ep.tenure_years >= 5 THEN 'MEDIUM RISK'
        WHEN ep.tenure_years >= 3 THEN 'LOW RISK'
    END AS flight_risk_level
FROM employee_profile ep
------------------ join department ONLY once here-------------
JOIN dept_emp de 
    ON ep.emp_no = de.emp_no 
   AND de.to_date = '9999-01-01'
JOIN departments d 
    ON de.dept_no = d.dept_no
---------filter early------------------------
WHERE ep.tenure_years >= 5
  AND ep.distinct_titles = 1
ORDER BY ep.tenure_years DESC;

-- Expected Output Columns: emp_no | first_name | last_name | gender | tenure_years | titles_held | current_salary | dept_name | flight_risk_level
-- Power BI Visual: Table with conditional formatting on flight_risk_level
-- Use as: HR intervention list for retention conversations
