# Database Schema

## Entity Relationship Diagram

```
employees (emp_no PK)
    │
    ├──→ salaries    (emp_no FK) — salary history, to_date='9999-01-01' = current
    ├──→ titles      (emp_no FK) — job title history
    ├──→ dept_emp    (emp_no FK) — department assignments
    │        └──→ departments (dept_no FK)
    └──→ dept_manager (emp_no FK) — manager assignments
             └──→ departments (dept_no FK)
```

## Table Descriptions

### `employees`
The core table. One row per employee.

| Column | Type | Notes |
|--------|------|-------|
| `emp_no` | INT | Primary key |
| `birth_date` | DATE | Used to calculate age |
| `first_name` | VARCHAR | |
| `last_name` | VARCHAR | |
| `gender` | ENUM('M','F') | |
| `hire_date` | DATE | Used to calculate tenure |

### `salaries`
Full salary history. Employees may have multiple rows (one per raise).

| Column | Type | Notes |
|--------|------|-------|
| `emp_no` | INT | FK → employees |
| `salary` | INT | Annual salary |
| `from_date` | DATE | When this salary took effect |
| `to_date` | DATE | `9999-01-01` = currently active |

### `titles`
Full job title history. A title change = a new row.

| Column | Type | Notes |
|--------|------|-------|
| `emp_no` | INT | FK → employees |
| `title` | VARCHAR | e.g., 'Engineer', 'Senior Engineer', 'Manager' |
| `from_date` | DATE | |
| `to_date` | DATE | `9999-01-01` = current title |

### `dept_emp`
Maps employees to departments over time.

| Column | Type | Notes |
|--------|------|-------|
| `emp_no` | INT | FK → employees |
| `dept_no` | CHAR(4) | FK → departments |
| `from_date` | DATE | |
| `to_date` | DATE | `9999-01-01` = currently in this department |

### `departments`
Master list of 9 departments.

| Column | Type | Notes |
|--------|------|-------|
| `dept_no` | CHAR(4) | Primary key (e.g., 'd001') |
| `dept_name` | VARCHAR | e.g., 'Engineering', 'Sales', 'Finance' |

### `dept_manager`
Tracks which employee manages which department over time.

| Column | Type | Notes |
|--------|------|-------|
| `dept_no` | CHAR(4) | FK → departments |
| `emp_no` | INT | FK → employees |
| `from_date` | DATE | |
| `to_date` | DATE | `9999-01-01` = current manager |

---

## Key Design Pattern

> All historical tables use `to_date = '9999-01-01'` to mark the **currently active** record.

```sql
-- Always add this WHERE clause for current data:
WHERE to_date = '9999-01-01'

-- For historical queries, remove the filter and use YEAR(from_date)
```

## Common JOIN Chains

**Employee + Current Department + Department Name:**
```sql
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no AND de.to_date = '9999-01-01'
JOIN departments d ON de.dept_no = d.dept_no
```

**Employee + Current Salary + Current Title + Current Department:**
```sql
FROM employees e
JOIN salaries s      ON e.emp_no = s.emp_no      AND s.to_date  = '9999-01-01'
JOIN titles t        ON e.emp_no = t.emp_no       AND t.to_date  = '9999-01-01'
JOIN dept_emp de     ON e.emp_no = de.emp_no      AND de.to_date = '9999-01-01'
JOIN departments d   ON de.dept_no = d.dept_no
```
