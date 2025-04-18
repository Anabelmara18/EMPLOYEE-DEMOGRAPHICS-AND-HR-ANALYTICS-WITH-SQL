--CREATING TABLES FOR MY DATA
CREATE TABLE EMPLOYEE (
Employee_Number INT Primary KEY,
Employee_Name VARCHAR(50),
Sex VARCHAR(10),
DOB DATE,
Race_Desc VARCHAR(70),
Hispanic_Latino VARCHAR(20),
Citizen_Desc VARCHAR(70),
Marital_Desc VARCHAR(20),
Date_Of_Hire DATE,
Date_Of_Termination DATE,
Employment_Status VARCHAR(50),
Department VARCHAR(50),
Positions  VARCHAR(70),
Manager_Name  VARCHAR(50)
);

CREATE TABLE COMPENSATION(
Rows_Number INT PRIMARY KEY,
Employee_Number INT REFERENCES EMPLOYEE,
Pay_Rate DECIMAL(10,2),
Days_Employed INT
);

CREATE TABLE PERFORMANCE(
Rowp_Number INT PRIMARY KEY,
Employee_Number INT REFERENCES EMPLOYEE,
Performance_Score VARCHAR(50),
Perf_ScoreID INT,
Employee_Source VARCHAR(50)
);

SELECT *
FROM Performance;

--TO REMOVE THE "," INBETWEEN THE NAMES
UPDATE EMPLOYEE
SET employee_name = REPLACE(employee_name, ',', '');

-- Gender Distribution
SELECT Sex AS Gender, Count(*) AS Number_Of_Employee,
 ROUND(Count(*)*100.0/(SELECT COUNT(*) FROM EMPLOYEE),2) || '%' AS Percentage
 FROM EMPLOYEE
GROUP BY Gender;

--Race Distribution
SELECT race_desc AS Race, Count(*) AS Number_Of_Employee,
 ROUND(Count(*)*100.0/(SELECT COUNT(*) FROM EMPLOYEE),2) || '%' AS Percentage
 FROM EMPLOYEE
GROUP BY Race
ORDER BY Number_Of_Employee DESC;

--Citizenship Distribution
SELECT Citizen_desc AS Citizenship, Count(*) AS Number_Of_Employee,
 ROUND(Count(*)*100.0/(SELECT COUNT(*) FROM EMPLOYEE),2) || '%' AS Percentage
 FROM EMPLOYEE
GROUP BY Citizenship
ORDER BY Number_Of_Employee DESC;

--ADDING THE AGE COLUMN BECAUSE IT IS MISSING IN THE DATASET
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



--Average Age Of Employees In Each Department
SELECT Department, ROUND(AVG(Age),2) AS Age
FROM EMPLOYEE
GROUP BY Department
ORDER BY Age DESC;

SELECT *
FROM PERFORMANCE;
--Identify top-performing managers in terms of recruitment volume;

SELECT Manager_name, COUNT(*) employee_number
FROM EMPLOYEE
GROUP BY Manager_name
ORDER BY employee_number DESC;

--Average time(years) employee stay before termination
SELECT ROUND (AVG(days_employed) ,2) AS AVG_Years
FROM COMPENSATION;

--Department by recruitment volume
SELECT Department, count(*) employee_number
FROM EMPLOYEE
GROUP BY Department
ORDER BY Employee_number DESC;

--Average Performance Score By Department
SELECT EMPLOYEE.Department, ROUND(AVG(PERFORMANCE.Perf_scoreid) ,2) AS Perf_num
FROM EMPLOYEE
LEFT JOIN PERFORMANCE ON EMPLOYEE.Employee_number = PERFORMANCE.Employee_number
GROUP BY EMPLOYEE.Department
ORDER BY Perf_num DESC;

--Relationship between performance score and employee source
SELECT Employee_source, ROUND(AVG(perf_scoreid) ,0) AS Performance_Sco, Performance_Score
FROM PERFORMANCE
GROUP BY Employee_source,Performance_Score
ORDER BY Performance_Sco ASC;

--Avg payrate by department
SELECT EMPLOYEE.Department, ROUND(AVG(COMPENSATION.Pay_rate) ,2) AS Payment 
FROM EMPLOYEE
LEFT JOIN COMPENSATION ON EMPLOYEE.employee_number = COMPENSATION.employee_number
GROUP BY Employee.Department
ORDER BY Payment DESC;

--Work duration vs pay rate
SELECT Pay_rate, ROUND(AVG(days_employed) ,2) AS Employment_Duration
FROM PERFORMANCE
LEFT JOIN COMPENSATION ON PERFORMANCE.Employee_number = COMPENSATION.Employee_number
GROUP BY Pay_rate
ORDER BY Employment_Duration DESC;

--	Are employees with more Days Employed paid better?
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

SELECT MAX(days_employed) FROM COMPENSATION;

--Which managers oversee the higest paid teams
SELECT EMPLOYEE.Positions, EMPLOYEE.Manager_name, ROUND(Avg(COMPENSATION.Pay_Rate),2) AS SALARY
FROM EMPLOYEE
LEFT JOIN COMPENSATION ON COMPENSATION.Employee_number = EMPLOYEE.Employee_number
GROUP BY EMPLOYEE.Positions, EMPLOYEE.Manager_name
ORDER BY SALARY DESC
LIMIT 5;

--Termination Rate By Department
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

--Recruitment source with highest number of termination
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


SELECT*
FROM EMPLOYEE

--PERCENTAGE OF EMPLOYEES WHO WERE TERMINATED IN ONE YEAR OF HIRE
SELECT 
  ROUND(
    100.0 * COUNT(CASE 
                   WHEN employment_status ILIKE '%terminated%' 
                        AND Date_Of_Termination IS NOT NULL 
                        AND Date_Of_Termination - Date_Of_hire <= 365 
                   THEN 1 
                 END) / COUNT(*), 
    2
  ) AS terminated_within_1_year_percent
FROM EMPLOYEE;

--Ranked list of managers because by the performance of their team
SELECT Manager_name, Positions, ROUND(AVG(Perf_scoreid) ,2) AS SCORE
FROM EMPLOYEE
LEFT JOIN PERFORMANCE ON PERFORMANCE.Employee_number = EMPLOYEE.Employee_number
WHERE Perf_scoreid <= '5'
GROUP BY MANAGER_NAME, Positions
ORDER BY SCORE DESC
LIMIT 10;
