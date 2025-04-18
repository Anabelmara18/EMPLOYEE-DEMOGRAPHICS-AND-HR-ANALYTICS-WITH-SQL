## Table of Contents

- [Overview](#overview)
- [Objectives](#objectives)
- [Tools Used](#tools-used)
- [Data Preparation](#data-preparation)
- [Techniques Used](#techniques-used)
- [Key Analysis & Queries](#key-analysis--queries)
- [Key Insights And Recommendation](#key-insights-&-recommendations)
- [Overall Recommendation](#Overall-Recommendations)
- [Author](#Author)
    



# EMPLOYEE-DEMOGRAPHICS-HR-ANALYTICS-WITH-SQL
A SQL-based analysis of employee data to uncover insights on workforce diversity, employment status, and compensation trends.

## Overview
This project simulates a real-world HR analytics solution by examining employee data to:

- Identify diversity patterns  
- Analyze employment trends  
- Investigate departmental dynamics  
- Evaluate compensation distribution  
- Assess performance & recruitment channels  

All analysis was done using **pure SQL** in **PostgreSQL**, emphasizing backend-driven insight generation.

---

## Objectives  

- Analyze gender and racial diversity across the company  
- Examine departmental distribution and employment status  
- Identify trends in terminations and promotions  
- Explore average pay rates by job title or department  
- Clean and prepare query-ready data by handling missing values and formatting issues

## Tools Used  

- **PostgreSQL** – for querying and analysis  
- **Excel** – for preprocessing and data cleaning  
- **GitHub** – for documentation and version control

##  Data Preparation
- Standardized column names  
- Resolved missing values  
- Created calculated columns (e.g., `age`, `days_employed`)  
- Split datasets into `EMPLOYEE`, `COMPENSATION`, and `PERFORMANCE` tables for clarity  


## Techniques Used

- **Data Cleaning:**  
  Cleaned and formatted the raw employee dataset in Excel by handling missing values, correcting date formats, and standardizing column names.

- **Database Setup:**  
  Created SQL tables and inserted cleaned data into PostgreSQL for analysis.

- **Exploratory Data Analysis (EDA) with SQL:**  
  - Analyzed gender and racial distribution across the workforce  
  - Examined departmental employee counts and structures  
  - Investigated employment status breakdown (active vs terminated)  
  - Explored compensation trends by job roles and departments

- **Insights & Recommendations:**  
  Interpreted SQL query results to derive actionable HR insights and support data-driven decision making.

## KEY ANALYSIS & QUERIES
*Demographics & Diversity*

### 🎯 Gender Distribution
```sql
SELECT Sex AS Gender, Count(*) AS Number_Of_Employee,
ROUND(Count(*)*100.0/(SELECT COUNT(*) FROM EMPLOYEE),2) || '%' AS Percentage
FROM EMPLOYEE
GROUP BY Gender;
```

**Data Output**  
| Gender | Total Employees | Percentage |
|--------|-----------------|------------|
| Female | 177             | 57.10%     |
| Male   | 133             | 42.90%     |

---

### 🌍 Race Distribution
```sql
SELECT race_desc AS Race, Count(*) AS Number_Of_Employee,
ROUND(Count(*)*100.0/(SELECT COUNT(*) FROM EMPLOYEE),2) || '%' AS Percentage
FROM EMPLOYEE
GROUP BY Race
ORDER BY Race DESC;
```

**Data Output**  
| Race                             | Total employees | Percentage |
|----------------------------------|-----------------|------------|
| White                            | 193             | 62.26%     |
| Black or African American        | 57              | 18.39%     |
| Asian                            | 34              | 10.97%     |
| Two or more races                | 18              | 5.81%      |
| American Indian or Alaska Native | 4               | 1.29%      |
| Hispanic                         | 4               | 1.29%      |

---

### 🛂 Citizenship Distribution
```sql
SELECT Citizen_desc AS Citizenship, Count(*) AS Number_Of_Employee,
 ROUND(Count(*)*100.0/(SELECT COUNT(*) FROM EMPLOYEE),2) || '%' AS Percentage
 FROM EMPLOYEE
GROUP BY Citizenship
ORDER BY Number_Of_Employee DESC;
```

**Data Output**  
| Citizenship         | Total Employees | Percentage |
|---------------------|-----------------|------------|
| US Citizen          | 294             | 94.84%     |
| Eligible NonCitizen | 12              | 3.87%      |
| Non-Citizen         | 4               | 1.29%      |

---

### 📊 Add and Calculate Employee Age
```sql
ALTER TABLE EMPLOYEE
ADD COLUMN Age INTEGER;

SELECT MAX(Date_Of_Termination)
FROM EMPLOYEE;

UPDATE EMPLOYEE
SET age = CASE
    WHEN employment_status = '%Terminated' THEN
        EXTRACT(YEAR FROM AGE(
            COALESCE(
                TO_DATE(Date_of_termination::TEXT || '-01-01', 'YYYY-MM-DD'),
                DATE '2016-06-16'
            ),
            DOB
        ))
    ELSE
        EXTRACT(YEAR FROM AGE(CURRENT_DATE, DOB))
END;
```

---

### 📈 Average Age Of Employees In Each Department
```sql
SELECT Department, ROUND(AVG(Age),2) AS Age
FROM EMPLOYEE
GROUP BY Department
ORDER BY Age DESC;
```

**Data Output**  
| Department           | Average Age |
|----------------------|-------------|
| Executive Office     | 70.00       |
| Production           | 46.23       |
| Sales                | 45.77       |
| IT/IS                | 44.88       |
| Software Engineering | 42.60       |
| Admin Offices        | 39.10       |


### 👥 Identify Top-Performing Managers by Recruitment Volume
```sql
SELECT Manager_name, COUNT(*) AS employee_number
FROM EMPLOYEE
GROUP BY Manager_name
ORDER BY employee_number DESC;
```

**Data Output**  
| Manager/Recruiter  | Employee |
|--------------------|----------|
| Kelley Spirea      | 22       |
| Michael Albert     | 22       |
| Elijiah Gray       | 22       |
| Kissy Sullivan     | 22       |
| Ketsia Liebig      | 21       |
| David Stanley      | 21       |
| Webster Butler     | 21       |
| Amy Dunn           | 21       |
| Brannon Miller     | 21       |
| Janet King         | 19       |
| Simon Roup         | 17       |
| John Smith         | 14       |
| Peter Monroe       | 14       |
| Lynn Daneault      | 13       |
| Alex Sweetwater    | 9        |
| Brian Champaigne   | 8        |
| Jennifer Zamora    | 7        |
| Brandon R. LeBlanc | 7        |
| Eric Dougall       | 4        |
| Debra Houlihan     | 3        |
| Board of Directors | 2        |

---

### ⏳ Average Tenure Before Termination
```sql
SELECT ROUND (AVG(days_employed)/365 ,2) AS AVG_Years
FROM COMPENSATION;
```

**Data Output**  
**3.55 Years** (equivalent to 1,296.08 Days)

---

### 🏢 Department by Recruitment Volume
```sql
SELECT Department, COUNT(*) AS employee_number
FROM EMPLOYEE
GROUP BY Department
ORDER BY employee_number DESC;
```

**Data Output**  
| Department           | Total Employees |
|----------------------|-----------------|
| Production           | 208             |
| IT/IS                | 50              |
| Sales                | 31              |
| Admin Offices        | 10              |
| Software Engineering | 10              |
| Executive Office     | 1               |


### ⭐ Average Performance Score by Department
```sql
SELECT EMPLOYEE.Department, ROUND(AVG(PERFORMANCE.Perf_scoreid), 2) AS Perf_num
FROM EMPLOYEE
LEFT JOIN PERFORMANCE ON EMPLOYEE.Employee_number = PERFORMANCE.Employee_number
GROUP BY EMPLOYEE.Department
ORDER BY Perf_num DESC;
```

**Data Output**  
| Department           | Performance Score |
|----------------------|-------------------|
| Admin Offices        | 3.90              |
| IT/IS                | 3.78              |
| Production           | 3.49              |
| Executive Office     | 3.00              |
| Sales                | 2.87              |
| Software Engineering | 2.60              |

---

### 🔄 Relationship Between Performance Score and Employee Source
```sql
SELECT Employee_source, 
       ROUND(AVG(perf_scoreid), 0) AS Performance_Score, 
       Performance_Score
FROM PERFORMANCE
GROUP BY Employee_source, Performance_Score
ORDER BY Performance_Score ASC;
```

**Data Output**
| Employee Source                        | Performance Score | Performance              |
|----------------------------------------|-------------------|--------------------------|
| Other                                  | 0                 | 90-day meets             |
| Pay Per Click - Google                 | 0                 | 90-day meets             |
| Search Engine - Google Bing Yahoo      | 0                 | 90-day meets             |
| Word of Mouth                          | 0                 | 90-day meets             |
| Social Networks - Facebook Twitter etc | 0                 | 90-day meets             |
| Diversity Job Fair                     | 0                 | 90-day meets             |
| Monster.com                            | 0                 | 90-day meets             |
| Billboard                              | 0                 | 90-day meets             |
| Vendor Referral                        | 0                 | 90-day meets             |
| Website Banner Ads                     | 0                 | 90-day meets             |
| Glassdoor                              | 0                 | 90-day meets             |
| Employee Referral                      | 0                 | 90-day meets             |
| Newspager/Magazine                     | 0                 | 90-day meets             |
| Professional Society                   | 1                 | PIP                      |
| Search Engine - Google Bing Yahoo      | 1                 | PIP                      |
| MBTA ads                               | 1                 | PIP                      |
| Diversity Job Fair                     | 1                 | PIP                      |
| Billboard                              | 1                 | PIP                      |
| Pay Per Click - Google                 | 1                 | PIP                      |
| Website Banner Ads                     | 1                 | PIP                      |
| Other                                  | 2                 | Needs Improvement        |
| Monster.com                            | 2                 | Needs Improvement        |
| Search Engine - Google Bing Yahoo      | 2                 | Needs Improvement        |
| Pay Per Click - Google                 | 2                 | Needs Improvement        |
| MBTA ads                               | 2                 | Needs Improvement        |
| Word of Mouth                          | 2                 | Needs Improvement        |
| Internet Search                        | 2                 | Needs Improvement        |
| Billboard                              | 2                 | Needs Improvement        |
| Glassdoor                              | 2                 | Needs Improvement        |
| Diversity Job Fair                     | 2                 | Needs Improvement        |
| Pay Per Click - Google                 | 3                 | Fully Meets              |
| Other                                  | 3                 | Fully Meets              |
| Billboard                              | 3                 | Fully Meets              |
| Search Engine - Google Bing Yahoo      | 3                 | Fully Meets              |
| Careerbuilder                          | 3                 | Fully Meets              |
| Word of Mouth                          | 3                 | Fully Meets              |
| On-line Web application                | 3                 | Fully Meets              |
| Diversity Job Fair                     | 3                 | Fully Meets              |
| Internet Search                        | 3                 | Fully Meets              |
| Website Banner Ads                     | 3                 | Fully Meets              |
| Information Session                    | 3                 | Fully Meets              |
| Company Intranet - Partner             | 3                 | Fully Meets              |
| Indeed                                 | 3                 | Fully Meets              |
| Employee Referral                      | 3                 | Fully Meets              |
| Newspager/Magazine                     | 3                 | Fully Meets              |
| Social Networks - Facebook Twitter etc | 3                 | Fully Meets              |
| Vendor Referral                        | 3                 | Fully Meets              |
| Professional Society                   | 3                 | Fully Meets              |
| Glassdoor                              | 3                 | Fully Meets              |
| MBTA ads                               | 3                 | Fully Meets              |
| Monster.com                            | 3                 | Fully Meets              |
| On-campus Recruiting                   | 3                 | Fully Meets              |
| On-campus Recruiting                   | 4                 | Exceeds                  |
| MBTA ads                               | 4                 | Exceeds                  |
| Pay Per Click - Google                 | 4                 | Exceeds                  |
| Monster.com                            | 4                 | Exceeds                  |
| Information Session                    | 4                 | Exceeds                  |
| Glassdoor                              | 4                 | Exceeds                  |
| Professional Society                   | 4                 | Exceeds                  |
| Billboard                              | 4                 | Exceeds                  |
| Other                                  | 4                 | Exceeds                  |
| Website Banner Ads                     | 4                 | Exceeds                  |
| Employee Referral                      | 4                 | Exceeds                  |
| Diversity Job Fair                     | 4                 | Exceeds                  |
| Social Networks - Facebook Twitter etc | 4                 | Exceeds                  |
| Search Engine - Google Bing Yahoo      | 4                 | Exceeds                  |
| Employee Referral                      | 5                 | Exceptional              |
| Billboard                              | 5                 | Exceptional              |
| Professional Society                   | 5                 | Exceptional              |
| MBTA ads                               | 5                 | Exceptional              |
| Diversity Job Fair                     | 5                 | Exceptional              |
| Glassdoor                              | 9                 | N/A- too early to review |
| Social Networks - Facebook Twitter etc | 9                 | N/A- too early to review |
| Monster.com                            | 9                 | N/A- too early to review |
| Employee Referral                      | 9                 | N/A- too early to review |
| Internet Search                        | 9                 | N/A- too early to review |
| Pay Per Click                          | 9                 | N/A- too early to review |
| Search Engine - Google Bing Yahoo      | 9                 | N/A- too early to review |
| Newspager/Magazine                     | 9                 | N/A- too early to review |
| Word of Mouth                          | 9                 | N/A- too early to review |
| Professional Society                   | 9                 | N/A- too early to review |
| Website Banner Ads                     | 9                 | N/A- too early to review |
| Pay Per Click - Google                 | 9                 | N/A- too early to review |
| Other                                  | 9                 | N/A- too early to review |
| Information Session                    | 9                 | N/A- too early to review |
| Billboard                              | 9                 | N/A- too early to review |
| On-campus Recruiting                   | 9                 | N/A- too early to review |
| Diversity Job Fair                     | 9                 | N/A- too early to review |
| Vendor Referral                        | 9                 | N/A- too early to review |


### 💰 Average Pay Rate by Department
```sql
SELECT EMPLOYEE.Department, ROUND(AVG(COMPENSATION.Pay_rate), 2) AS Payment 
FROM EMPLOYEE
LEFT JOIN COMPENSATION ON EMPLOYEE.employee_number = COMPENSATION.employee_number
GROUP BY EMPLOYEE.Department
ORDER BY Payment DESC;
```

**Data Output**  
| Department           | Payment Rate |
|----------------------|--------------|
| Executive Office     | 80.00        |
| Sales                | 55.52        |
| Software Engineering | 48.67        |
| IT/IS                | 45.79        |
| Admin Offices        | 31.90        |
| Production           | 23.09        |

---

### 📈 Are Employees with More Days Employed Paid Better?
```sql
SELECT 
  CASE 
    WHEN days_employed <= 365 THEN '0-1 year'
    WHEN days_employed <= 1095 THEN '1-3 years'
    WHEN days_employed <= 1825 THEN '3-5 years'
    WHEN days_employed <= 3650 THEN '5-10 years'
    ELSE '10+ years'
  END AS experience_range,
  COUNT(*) AS num_employees,
  ROUND(AVG(Pay_rate), 2) AS avg_salary
FROM COMPENSATION
GROUP BY experience_range
ORDER BY avg_salary DESC;
```

**Data Output**  
| Experience Range | Total Employees | Average Salary |
|------------------|-----------------|----------------|
| 10+ years        | 2               | 36.00          |
| 5-10 years       | 71              | 33.27          |
| 1-3 years        | 81              | 33.00          |
| 0-1 year         | 38              | 29.61          |
| 3-5 years        | 118             | 29.37          |

---

### 🧑‍💼 Top 5 Managers Who Oversee the Highest Paid Teams
```sql
SELECT EMPLOYEE.Positions, EMPLOYEE.Manager_name, ROUND(AVG(COMPENSATION.Pay_Rate), 2) AS Salary
FROM EMPLOYEE
LEFT JOIN COMPENSATION ON COMPENSATION.Employee_number = EMPLOYEE.Employee_number
GROUP BY EMPLOYEE.Positions, EMPLOYEE.Manager_name
ORDER BY Salary DESC
LIMIT 5;
```

**Data Output**  
| Positions/Teams      | Manager Name       | Pay Rate |
|----------------------|--------------------|----------|
| President & CEO      | Board of Directors | 80.00    |
| IT Director          | Jennifer Zamora    | 65.00    |
| CIO                  | Janet King         | 65.00    |
| IT Manager - Support | Jennifer Zamora    | 64.00    |
| BI Director          | Jennifer Zamora    | 63.50    |

### ❌ Termination Rate by Department
```sql
SELECT 
  department,
  COUNT(*) AS total_employees,
  COUNT(CASE WHEN employment_status ILIKE '%Terminated%' THEN 1 END) AS terminated_employees,
  ROUND(
    100.0 * COUNT(CASE WHEN employment_status ILIKE '%Terminated%' THEN 1 END) / COUNT(*), 
    2
  ) AS termination_rate_percent
FROM employee
GROUP BY department
ORDER BY termination_rate_percent DESC;
```

**Data Output**  
| Department           | Total Employees | Terminated Employees | Termination Rate (%) |
|----------------------|-----------------|----------------------|----------------------|
| Production           | 208             | 83                   | 39.90                |
| Software Engineering | 10              | 3                    | 30.00                |
| Admin Offices        | 10              | 2                    | 20.00                |
| IT/IS                | 50              | 10                   | 20.00                |
| Sales                | 31              | 4                    | 12.90                |
| Executive Office     | 1               | 0                    | 0.00                 |

---

### 🧭 Termination Rate by Recruitment Source
```sql
SELECT PERFORMANCE.Employee_source, 
       COUNT(*) AS total_employees,
       COUNT(CASE WHEN EMPLOYEE.employment_status ILIKE '%Terminated%' THEN 1 END) AS terminated_employees,
       ROUND(
         100.0 * COUNT(CASE WHEN EMPLOYEE.employment_status ILIKE '%Terminated%' THEN 1 END) / COUNT(*), 
         2
       ) AS termination_rate_percent
FROM employee
LEFT JOIN PERFORMANCE ON PERFORMANCE.Employee_number = EMPLOYEE.Employee_number
GROUP BY PERFORMANCE.Employee_source
ORDER BY termination_rate_percent DESC;
```

**Data Output**  
| Employee Source                        | Total Employees | Terminated Employees | Termination Rate (%) |
|----------------------------------------|-----------------|----------------------|-----------------------|
| Pay Per Click                          | 1               | 1                    | 100.00                |
| Company Intranet - Partner             | 1               | 1                    | 100.00                |
| On-line Web application                | 1               | 1                    | 100.00                |
| Social Networks - Facebook Twitter etc | 11              | 8                    | 72.73                 |
| Search Engine - Google Bing Yahoo      | 25              | 15                   | 60.00                 |
| Diversity Job Fair                     | 29              | 16                   | 55.17                 |
| Word of Mouth                          | 13              | 7                    | 53.85                 |
| Monster.com                            | 24              | 11                   | 45.83                 |
| Glassdoor                              | 14              | 6                    | 42.86                 |
| Other                                  | 9               | 3                    | 33.33                 |
| Internet Search                        | 6               | 2                    | 33.33                 |
| Billboard                              | 16              | 5                    | 31.25                 |
| Newspager/Magazine                     | 18              | 5                    | 27.78                 |
| Vendor Referral                        | 15              | 4                    | 26.67                 |
| Information Session                    | 4               | 1                    | 25.00                 |
| MBTA ads                               | 17              | 4                    | 23.53                 |
| Professional Society                   | 20              | 3                    | 15.00                 |
| Pay Per Click - Google                 | 21              | 3                    | 14.29                 |
| Employee Referral                      | 31              | 4                    | 12.90                 |
| On-campus Recruiting                   | 12              | 1                    | 8.33                  |
| Website Banner Ads                     | 13              | 1                    | 7.69                  |
| Careerbuilder                          | 1               | 0                    | 0.00                  |
| Indeed                                 | 8               | 0                    | 0.00                  |

---

### 📅 Termination Within One Year of Hire
```sql
SELECT ROUND(
  100.0 * COUNT(CASE 
                 WHEN employment_status ILIKE '%terminated%' 
                      AND Date_Of_Termination IS NOT NULL 
                      AND Date_Of_Termination - Date_Of_hire <= 365 
                 THEN 1 
               END) / COUNT(*), 
  2
) AS terminated_within_1_year_percent
FROM EMPLOYEE;
```

**Data Output**  
**10%** of employees were terminated within 1 year of being hired.

---

### 🏆 Top 10 Managers by Team Performance
```sql
SELECT Manager_name, Positions, ROUND(AVG(Perf_scoreid), 2) AS Score
FROM EMPLOYEE
LEFT JOIN PERFORMANCE ON PERFORMANCE.Employee_number = EMPLOYEE.Employee_number
WHERE Perf_scoreid <= 5
GROUP BY Manager_name, Positions
ORDER BY Score DESC
LIMIT 10;
```

**Data Output**  
| Manager Name        | Positions/Team           | Performance Score |
|---------------------|--------------------------|-------------------|
| Janet King          | CIO                      | 5.00              |
| Jennifer Zamora     | IT Director              | 5.00              |
| Janet King          | Director of Operations   | 4.00              |
| Jennifer Zamora     | IT Manager - Support     | 4.00              |
| Ketsia Liebig       | Production Technician II | 3.40              |
| Eric Dougall        | IT Support               | 3.25              |
| Kelley Spirea       | Production Technician II | 3.14              |
| Brannon Miller      | Production Technician I  | 3.07              |
| Brandon R. LeBlanc  | Accountant I             | 3.00              |
| Janet King          | Shared Services Manager  | 3.00              |


##  Key Insights & Recommendations

###  Diversity & Representation
- **Gender Balance:**  
  Female employees make up **57.1%** of the workforce, indicating strong female representation across departments.

- **Racial Composition:**  
  While **White employees (62.3%)** form the majority, other races like **Black or African American (18.4%)** and **Asian (11%)** contribute significantly—showing moderate racial diversity.

- **Citizenship Status:**  
  A dominant **94.8%** of the workforce are U.S. citizens. There’s room to diversify talent sources and explore global hiring options.

---

###  Age & Department Trends
- **Older Departments:**  
  Teams such as **Executive Office** and **Production** have higher average ages, reflecting leadership tenure and experience.

- **Younger Teams:**  
  Departments like **Software Engineering** and **Admin Offices** show younger workforce trends—ideal for talent development programs.

---

###  Turnover & Retention
- **High Turnover Areas:**  
  **Production (39.9%)** and **Software Engineering (30%)** have the highest termination rates. These teams may benefit from deeper retention strategies, satisfaction surveys, and workflow reviews.

- **Early Exits:**  
  **10%** of employees leave within their **first year** of hire. A structured onboarding experience, early-stage mentorship, and continuous engagement could help reduce early turnover.

---

###  Performance & Recruitment
- **Top Managers by Team Performance:**  
  Managers like **Jennifer Zamora** and **Janet King** consistently lead high-performing teams—highlighting their impact in IT and leadership roles.

- **Effective Hiring Sources:**  
  Recruitment through **employee referrals**, **on-campus recruiting**, and **professional societies** yielded higher performance scores. These sources are recommended for future scaling.

---

### Compensation & Growth
- **Tenure vs. Salary:**  
  Employees with **longer tenure (5–10+ years)** generally earn more. This suggests internal pay progression but should still be evaluated for equity.

- **Departmental Pay Disparity:**  
  Pay rates vary significantly across departments—highlighting the need for regular **compensation audits** to ensure fairness and competitiveness.

---

### Overall Recommendations
- Focus on **retention strategies** in high-turnover departments  
- Enhance **onboarding and mentoring** for new hires  
- Continue leveraging **referrals and university recruiting** for talent acquisition  
- Monitor and improve **pay equity** and performance review systems  
- Invest in **diversity and inclusion** efforts at all levels  


## Author

**Amarachi**  
_Data Analyst | SQL Enthusiast | Exploring HR and Business Insights through Data_

