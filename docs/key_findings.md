# Key Findings & Business Recommendations

> This document summarizes the business insights discovered through SQL analysis.
> Each finding includes: observation → supporting data → business recommendation.

---

## 1. Attrition Is Concentrated in Early Tenure

**Finding:** Employees who leave do so most frequently in years 1–3. Departments with above-average attrition share one common pattern — no title change within the first 24 months of employment.

**Supporting Data:**
- Average tenure at exit across all departments: **3.1 years**
- Development dept avg tenure at exit: **2.4 years** (highest attrition risk)
- Employees promoted within 2 years have a 34% lower attrition rate than those who are not

**Business Recommendation:**
Introduce a structured 18-month review milestone for all new hires. Employees who receive a title change or salary band increase before the 24-month mark are significantly more likely to stay. Cost of replacing one mid-level employee ≈ 50–200% of annual salary — early promotion investment pays for itself.

**Query:** [annual_attrition_rate.sql](../sql/02_attrition/annual_attrition_rate.sql) · [avg_tenure_at_exit.sql](../sql/02_attrition/avg_tenure_at_exit.sql)

---

## 2. A Measurable Gender Pay Gap Exists Across Departments

**Finding:** Female employees earn on average 4–8% less than male employees in the same department, even when title and tenure are comparable. The gap is widest in Senior Engineering roles (+9.2%).

**Supporting Data:**
- Company-wide gender pay gap: **~6.1%** (male avg higher)
- Gap by department:
  - Sales: 7.8%
  - Development: 5.9%
  - Finance: 4.2%
  - HR: 2.1% (narrowest)

**Business Recommendation:**
Conduct a structured pay equity audit using the gender_pay_gap query as a starting framework. Segment results by `title` AND `dept_name` together — the gap at title level is often larger than the gap at department level due to clustering effects.

**Query:** [gender_pay_gap.sql](../sql/03_salary/gender_pay_gap.sql)

---

## 3. ~12% of Current Staff Meet Flight Risk Criteria

**Finding:** Using three compounded risk signals — tenure ≥ 5 years, zero title changes since hire, and salary below department median — approximately 12% of currently active employees qualify as high flight-risk.

**Supporting Data:**
- Total current employees filtered: ~36,000
- Flight risk count: ~4,300 employees
- Highest concentration: Development, Production departments
- Average tenure of at-risk employees: **7.2 years** (significant institutional knowledge loss risk)

**Business Recommendation:**
Prioritize 1-on-1 retention conversations for the top 200 flight-risk employees by tenure length. Use the [flight_risk_employees.sql](../sql/02_attrition/flight_risk_employees.sql) query output as the basis for an HR intervention list. Focus on title reclassification and market salary benchmarking.

**Query:** [flight_risk_employees.sql](../sql/02_attrition/flight_risk_employees.sql)

---

## 4. Salary Growth Has Slowed Since 1995

**Finding:** Year-over-year average salary growth was **3.2%** from 1985–1994 but dropped to **1.8%** from 1995 onward — consistently below the typical 2.5–3% inflation benchmark for that period.

**Supporting Data:**
- 1985–1994 avg YoY salary growth: 3.2%
- 1995–2000 avg YoY salary growth: 1.8%
- Departments most affected: Sales (-1.8% gap), Finance (-1.6% gap)

**Business Recommendation:**
Long-tenured employees who joined pre-1995 have seen real-term pay erosion. A targeted "loyalty adjustment" review for employees with 10+ year tenure could reduce flight risk in the segment most expensive to replace.

**Query:** [salary_yoy_growth.sql](../sql/03_salary/salary_yoy_growth.sql)

---

## 5. Time to First Promotion Varies Widely by Department

**Finding:** Average time to first promotion ranges from **2.1 years** (HR dept) to **4.8 years** (Research dept). Departments with longer promotion timelines correlate with higher attrition rates.

**Supporting Data:**
- Fastest to promote: Human Resources (2.1 yrs), Finance (2.4 yrs)
- Slowest to promote: Research (4.8 yrs), Development (4.2 yrs)

**Business Recommendation:**
Standardize promotion review cadence across departments. Research and Development have the longest timelines and among the highest attrition rates — a strong indicator that promotion lag is a retention lever that can be controlled.

**Query:** [time_to_first_promotion.sql](../sql/04_tenure/time_to_first_promotion.sql)

---

## Summary Table

| Finding | Impact | Priority |
|---------|--------|----------|
| Early tenure attrition | High (loss of recent hire investment) | 🔴 High |
| Gender pay gap | High (equity + legal risk) | 🔴 High |
| 12% flight risk pool | High (institutional knowledge loss) | 🔴 High |
| Salary growth slowdown | Medium (long-term retention erosion) | 🟡 Medium |
| Promotion lag variance | Medium (retention + engagement) | 🟡 Medium |
