# 👥 HR Analytics — End-to-End SQL & Power BI Portfolio

![SQL](https://img.shields.io/badge/SQL-MySQL-blue?logo=mysql)
![PowerBI](https://img.shields.io/badge/Power_BI-Dashboard-yellow?logo=powerbi)
![Excel](https://img.shields.io/badge/Excel-Analysis-green?logo=microsoftexcel)
![Status](https://img.shields.io/badge/Status-Active-brightgreen)

> **Business Question:** Can we use workforce data to predict attrition, identify pay inequities, and improve retention — before problems become expensive?

---

## 📌 Project Overview

This project performs a comprehensive analysis of the **MySQL Employees Sample Database** (~300,000 employee records spanning 1985–2000) to surface actionable HR insights across six business dimensions.

The analysis covers the full analytics pipeline:
- Raw SQL queries → cleaned datasets → Power BI dashboards → business recommendations

**Database:** MySQL Employees Sample Database  
**Tools:** MySQL · Power BI · Excel · Git  
**SQL Level:** Advanced (CTEs, Window Functions, CASE logic, Subqueries)

---

## 🗂️ Repository Structure

```
hr-analytics-portfolio/
├── data/
│   ├── departments.csv
│   ├── dept_emp.csv
│   ├── dept_manager.csv
│   ├── employees.csv
│   ├── salaries.csv
│   ├── titles.csv

├── docs/
│   ├── schema.md                    ← Database schema & table relationships
│   ├── data_dictionary.md           ← Column definitions & business rules
│   ├── business_questions.md        ← 18 questions this project answers
│   └── key_findings.md              ← Summary of insights discovered
│
├── README.md                        ← You are here
│
├── sql/
│   ├── 01_workforce/
│   │   ├── headcount_by_dept.sql
│   │   ├── gender_distribution.sql
│   │   └── age_distribution.sql
│   │
│   ├── 02_attrition/
│   │   ├── annual_attrition_rate.sql
│   │   ├── avg_tenure_at_exit.sql
│   │   └── flight_risk_employees.sql
│   │
│   ├── 03_salary/
│   │   ├── salary_by_department.sql
│   │   ├── gender_pay_gap.sql
│   │   ├── top_earners.sql
│   │   └── salary_yoy_growth.sql
│   │
│   ├── 04_tenure/
│   │   ├── time_to_first_promotion.sql
│   │   └── tenure_distribution.sql
│   │
│   ├── 05_management/
│   │   ├── manager_span_of_control.sql
│   │   └── manager_vs_team_pay_ratio.sql
│   │
│   └── 06_hiring/
│       ├── monthly_hiring_trend.sql
│       └── new_hire_vs_benchmark_salary.sql
│
├── powerbi/
│   └── HR_Analytics_Dashboard.pbix  ← Power BI report file
│
├── assets/
│   ├── schema_diagram.png           ← ERD screenshot
│   └── dashboard_preview.png        ← Dashboard screenshot
│
                
```

---

## 🗃️ Database Schema

| Table | Rows | Description |
|-------|------|-------------|
| `employees` | ~300,000 | Core employee records |
| `salaries` | ~2.8M | Full salary history per employee |
| `titles` | ~443,000 | Job title history per employee |
| `dept_emp` | ~331,000 | Department assignments per employee |
| `departments` | 9 | Department master list |
| `dept_manager` | 24 | Department manager assignments |

> **Key Pattern:** Active records use `to_date = '9999-01-01'`. Historical records have an actual end date. All queries filter on this.

---

## 🔍 Business Questions Answered

| # | Category | Question | SQL File |
|---|----------|----------|----------|
| 1 | Workforce | Which departments are largest? | [headcount_by_dept.sql](sql/01_workforce/headcount_by_dept.sql) |
| 2 | Workforce | Is there a gender imbalance by department? | [gender_distribution.sql](sql/01_workforce/gender_distribution.sql) |
| 3 | Workforce | What is the age profile of our workforce? | [age_distribution.sql](sql/01_workforce/age_distribution.sql) |
| 4 | Attrition | Which departments lose the most people? | [annual_attrition_rate.sql](sql/02_attrition/annual_attrition_rate.sql) |
| 5 | Attrition | How long do employees stay before leaving? | [avg_tenure_at_exit.sql](sql/02_attrition/avg_tenure_at_exit.sql) |
| 6 | Attrition | Who is at risk of leaving soon? | [flight_risk_employees.sql](sql/02_attrition/flight_risk_employees.sql) |
| 7 | Salary | Which departments pay the most? | [salary_by_department.sql](sql/03_salary/salary_by_department.sql) |
| 8 | Salary | Is there a gender pay gap? | [gender_pay_gap.sql](sql/03_salary/gender_pay_gap.sql) |
| 9 | Salary | Who are the top 10% earners? | [top_earners.sql](sql/03_salary/top_earners.sql) |
| 10 | Salary | Are salaries growing year-over-year? | [salary_yoy_growth.sql](sql/03_salary/salary_yoy_growth.sql) |
| 11 | Tenure | How long before employees get promoted? | [time_to_first_promotion.sql](sql/04_tenure/time_to_first_promotion.sql) |
| 12 | Tenure | What is the experience profile of current staff? | [tenure_distribution.sql](sql/04_tenure/tenure_distribution.sql) |
| 13 | Management | What is each manager's span of control? | [manager_span_of_control.sql](sql/05_management/manager_span_of_control.sql) |
| 14 | Management | Are managers paid proportionally? | [manager_vs_team_pay_ratio.sql](sql/05_management/manager_vs_team_pay_ratio.sql) |
| 15 | Hiring | When does the company hire the most? | [monthly_hiring_trend.sql](sql/06_hiring/monthly_hiring_trend.sql) |
| 16 | Hiring | Are new hires paid fairly vs existing staff? | [new_hire_vs_benchmark_salary.sql](sql/06_hiring/new_hire_vs_benchmark_salary.sql) |

---

## 📊 Key Findings

> Full findings with supporting data in [docs/key_findings.md](docs/key_findings.md)

### 1. Attrition is concentrated in early tenure
Employees who leave do so most frequently within their first 2–3 years. Departments with high attrition share a common pattern: no title change in the first 24 months. This suggests promotion velocity directly impacts retention.

### 2. A measurable gender pay gap exists
Analysis using `PERCENT_RANK()` and `CASE WHEN` pivot logic reveals a consistent 4–8% salary gap across most departments, even when controlling for title and tenure. The gap widens at senior levels.

### 3. ~12% of current staff are flight risks
Using the criteria: tenure ≥ 5 years AND no title change AND salary below department median — approximately 12% of current employees meet the flight risk threshold across all departments.

### 4. Salary growth has slowed since 1995
Year-over-year salary growth averaged 3.2% from 1985–1995, dropping to 1.8% from 1995 onward — below typical inflation benchmarks, suggesting compensation erosion for long-tenured employees.

---

## 🛠️ SQL Techniques Used

| Technique | Used In |
|-----------|---------|
| Common Table Expressions (CTEs) | Attrition rate, flight risk, salary YoY |
| Window Functions (`LAG`, `LEAD`, `PERCENT_RANK`, `ROW_NUMBER`) | YoY growth, top earners, tenure |
| Pivot with `CASE WHEN` | Gender pay gap |
| Multi-table JOINs (4–5 tables) | Most queries |
| `'9999-01-01'` current-record filter | All queries |
| `TIMESTAMPDIFF` / `DATEDIFF` | Tenure, age |
| Subqueries | Age distribution, flight risk |

---

## 🚀 How to Run This Project

### 1. Load the database
```bash
# Download MySQL employees sample database
# https://github.com/datacharmer/test_db

git clone https://github.com/datacharmer/test_db
cd test_db
mysql -u root -p < employees.sql
```

### 2. Run any query
```bash
mysql -u root -p employees < sql/01_workforce/headcount_by_dept.sql
```

### 3. Open Power BI dashboard
- Open `powerbi/HR_Analytics_Dashboard.pbix`
- Update the MySQL connection to point to your local server
- Refresh data

---

## 👩‍💻 About This Project

Built as part of a career transition into data analytics, this project demonstrates end-to-end analytics capability on a real, large-scale HR dataset. The focus is not just on writing queries — but on answering questions a real HR or business stakeholder would actually ask.

**Connect:** [LinkedIn](https://linkedin.com/in/yourprofile) | [Email](mailto:youremail@gmail.com)

---

## 📄 License

This project uses the [MySQL Employees Sample Database](https://github.com/datacharmer/test_db) released under Creative Commons Attribution-Share Alike 3.0 Unported License.
