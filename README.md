# EMPLOYEE-DEMOGRAPHICS-HR-ANALYTICS-WITH-SQL
A SQL-based analysis of employee data to uncover insights on workforce diversity, employment status, and compensation trends.

## Overview  
This project explores a company's employee dataset to uncover insights related to workforce diversity, employment status, compensation trends, and overall workforce composition. Using SQL, I performed detailed analysis on gender and racial distribution, department sizes, termination rates, and average pay by job roles.

It simulates a real-world HR analytics dashboard, empowering stakeholders to better understand employee demographics, identify gaps, and make data-driven decisions.

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

## QUERIES
*Demographics & Diversity*

**Gender Distribution**

SELECT Sex AS Gender, Count(*) AS Number_Of_Employee,
ROUND(Count(*)*100.0/(SELECT COUNT(*) FROM EMPLOYEE),2) || '%' AS Percentage
FROM EMPLOYEE
GROUP BY Gender;

**Data Output**
| Gender | Total Employees | Percentage |
|--------|-----------------|------------|
| Female | 177             | 57.10%     |
| Male   | 133             | 42.90%     |

**Race Distribution**

SELECT race_desc AS Race, Count(*) AS Number_Of_Employee,
ROUND(Count(*)*100.0/(SELECT COUNT(*) FROM EMPLOYEE),2) || '%' AS Percentage
FROM EMPLOYEE
GROUP BY Race
ORDER BY Race DESC;

**Data Output**
| Race                             | Total employees    | Percentage |
|----------------------------------|--------------------|------------|
| White                            | 193                | 62.26%     |
| Black or African American        | 57                 | 18.39%     |
| Asian                            | 34                 | 10.97%     |
| Two or more races                | 18                 | 5.81%      |
| American Indian or Alaska Native | 4                  | 1.29%      |
| Hispanic                         | 4                  | 1.29%      |

**Citizenship*

SELECT Citizen_desc AS Citizenship, Count(*) AS Number_Of_Employee,
 ROUND(Count(*)*100.0/(SELECT COUNT(*) FROM EMPLOYEE),2) || '%' AS Percentage
 FROM EMPLOYEE
GROUP BY Citizenship
ORDER BY Number_Of_Employee DESC;

**Data Output**
| Citizenship         | Total Employees | Percentage |
|---------------------|-----------------|------------|
| US Citizen          | 294             | 94.84%     |
| Eligible NonCitizen | 12              | 3.87%      |
| Non-Citizen         | 4               | 1.29%      |

**Average Age Of Employee In each department**
*ADDING THE AGE COLUMN BECAUSE IT IS MISSING IN THE DATASET*

ALTER TABLE EMPLOYEE
ADD COLUMN Age INTEGER;

SELECT MAX(Date_Of_Termination)
FROM EMPLOYEE;

UPDATE EMPLOYEE
SET age = CASE
    WHEN employment_status = '%Terminated' THEN
        EXTRACT(YEAR FROM AGE(
            -- Use actual termination year if available, else use 2016-06-16
            COALESCE(
                TO_DATE(Date_of_termination::TEXT || '-01-01', 'YYYY-MM-DD'),
                DATE '2016-06-16'
            ),
            DOB
        ))
    ELSE
        EXTRACT(YEAR FROM AGE(CURRENT_DATE, DOB))
END;

*Average Age Of Employees In Each Department*

SELECT Department, ROUND(AVG(Age),2) AS Age
FROM EMPLOYEE
GROUP BY Department
ORDER BY Age DESC;

**Data Output**
| Department           | Average Age |
|----------------------|-------------|
| Executive Office     | 70.00       |
| Production           | 46.23       |
| Sales                | 45.77       |
| IT/IS                | 44.88       |
| Software Engineering | 42.60       |
| Admin Offices        | 39.10       |
