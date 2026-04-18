# Data Dictionary

## Business Rules & Definitions

### "Current" Employee
An employee whose `dept_emp.to_date = '9999-01-01'`. This is how the MySQL sample database marks active records with no end date.

```sql
-- Always use this filter for current-state queries
WHERE de.to_date = '9999-01-01'
```

### Tenure
Calculated as the number of years between `hire_date` and either `CURDATE()` (for active employees) or the `dept_emp.to_date` (for exits).

```sql
ROUND(DATEDIFF(CURDATE(), e.hire_date) / 365.25, 1) AS tenure_years
```

### Attrition
An employee is counted as "attrited" when their `dept_emp.to_date` is a real date (not `9999-01-01`), meaning they left or were transferred out of a department.

### Promotion
A promotion is defined as a new row in the `titles` table with a `from_date` after the employee's `hire_date`. The count of rows in `titles` per employee = number of titles held.

```sql
-- title_changes = 1 means the employee only ever had their original hire title (never promoted)
COUNT(t.title) AS title_changes
```

### Flight Risk
An employee is flagged as flight risk if ALL of the following are true:
- Tenure ≥ 5 years (`DATEDIFF` / 365.25 >= 5)
- Never promoted (`title_changes = 1`)
- Currently active (`to_date = '9999-01-01'`)

### Gender Pay Gap
Calculated as: `(male_avg_salary - female_avg_salary) / male_avg_salary * 100`

A positive result means males earn more. Calculated within each department to control for department-level salary differences.

### Pay Ratio (Manager vs Team)
`manager_salary / avg_team_salary`. A ratio of 1.2 means the manager earns 20% more than the average team member. Industry benchmark is typically 1.15–1.5.

---

## Salary Table — Understanding History

The `salaries` table stores every salary an employee ever had. To get the **current** salary, always filter `to_date = '9999-01-01'`. To get the **starting** salary, filter `from_date = hire_date`.

```sql
-- Current salary
WHERE s.to_date = '9999-01-01'

-- Salary at time of hire (new hire benchmark)
WHERE s.from_date = e.hire_date
```

---

## Departments Reference

| dept_no | dept_name |
|---------|-----------|
| d001 | Marketing |
| d002 | Finance |
| d003 | Human Resources |
| d004 | Production |
| d005 | Development |
| d006 | Quality Management |
| d007 | Sales |
| d008 | Research |
| d009 | Customer Service |
