-- Loading and merging the data fo 3 csv files of AADHAR ENROLLMENT DATASET by coping them into single one .
COPY api_data_aadhar_enrolment_0_500000 
FROM 'D:/data hackathon/api_data_aadhar_enrolment/api_data_aadhar_enrolment_0_500000.csv'
DELIMITER ','
CSV HEADER;

COPY api_data_aadhar_enrolment_0_500000 
FROM 'D:\data hackathon\api_data_aadhar_enrolment\api_data_aadhar_enrolment_500000_1000000.csv'
DELIMITER ','
CSV HEADER
ESCAPE '\';

COPY api_data_aadhar_enrolment_0_500000 
FROM 'D:\data hackathon\api_data_aadhar_enrolment\api_data_aadhar_enrolment_1000000_1006029.csv'
DELIMITER ','
CSV HEADER
ESCAPE '\';


-- CREATING TABLE
create table api_data_aadhar_enrolment_0_500000 (
	enroll_date date,
	states varchar(100),
	districts varchar(100),
	pincode int,
	age_0_5 int,
	age_5_17 int,
	age_18_greater int
);


-- RENAMING THE TABLE NAME TO "enrollment_data"
ALTER TABLE api_data_aadhar_enrolment_0_500000 RENAME TO enrollment_data;



-- SELECTING MERGED TABLE OF ALL 3 FILE INTO ONE 
SELECT * FROM enrollment_data;



-- CLEAN DISPLAY FORMAT OF ALL THE VALUES IN 'states' LIKE AS 'West Bengal'
UPDATE enrollment_data
SET states = INITCAP(states);



-- RENAMING " 'west bangal', 'westbengal' " TO 'West Bengal'
UPDATE enrollment_data
SET states = 'West Bengal'
WHERE LOWER(states) IN ('west bangal', 'westbengal');



-- RENAMING ALL MISSMATACHED COLUMNS
UPDATE enrollment_data
SET states = CASE
    WHEN states = 'Jammu And Kashmir' THEN 'Jammu & Kashmir'
	WHEN states = 'West  Bengal' THEN 'West Bengal'
    WHEN states = 'Dadra And Nagar Haveli' THEN 'Dadra & Nagar Haveli'
    WHEN states = 'Puducherry' THEN 'Pondicherry'
    WHEN states = 'Daman And Diu' THEN 'Daman & Diu'
	WHEN states = 'The Dadra And Nagar Haveli And Daman And Diu' THEN 'Dadra And Nagar Haveli And Daman And Diu'
    WHEN states = 'Andaman And Nicobar Islands' THEN 'Andaman & Nicobar Islands'
    ELSE states
END;



-- DELETING ALL ROWS WHERE STATES, DISTRICTS & PINCODE ARE 100000
DELETE FROM enrollment_data 
WHERE states = '100000' 
OR districts = '100000'
OR pincode = '100000';



-- COUNT OF ALL ROWS IN MERGED TABLE i.e. 1,500,000
SELECT COUNT(enroll_date) FROM enrollment_data;



-- [1. Overall Enrollment Load]  Calculates total enrollment across all age groups
-- Used to understand overall system load and scale requirement
SELECT SUM(age_0_5 + age_5_17 + age_18_greater) AS total_enrollments
FROM enrollment_data;



-- [2. State-wise Enrollment Pattern]  Aggregates total enrollments per state
-- Helps identify high-load and low-load states for regional planning
SELECT states, SUM(age_0_5 + age_5_17 + age_18_greater) AS total_enrollments FROM enrollment_data
GROUP BY states
ORDER BY total_enrollments DESC;



-- [3. District Concentration Hotspots]  Identifies districts with highest enrollment within states
-- Useful for micro-level infrastructure and staffing decisions
SELECT states, districts, SUM(age_0_5 + age_5_17 + age_18_greater) AS district_enrollments
FROM enrollment_data
GROUP BY states, districts
ORDER BY district_enrollments DESC;



-- [4. Age-wise Demand Distribution]  Breaks down enrollment by age groups
-- Helps understand demographic demand patterns
SELECT
    SUM(age_0_5) AS children_0_5,
    SUM(age_5_17) AS children_5_17,
    SUM(age_18_greater) AS adults_18_plus
FROM enrollment_data;



-- [5. Child Dependency Ratio (Predictive Indicator]  Calculates ratio of child enrollments to adult enrollments per state
-- Acts as an early indicator of future enrollment pressure
SELECT
    states,
    ROUND(
        SUM(age_0_5 + age_5_17)::DECIMAL 
        / NULLIF(SUM(age_18_greater), 0),
        2
    ) AS child_dependency_ratio
FROM enrollment_data
GROUP BY states
ORDER BY child_dependency_ratio DESC;



-- [6. Daily Enrollment Trend (Time-Series Analysis)]  Tracks daily enrollment volume over time
-- Used to identify seasonal patterns and growth trends
SELECT
    enroll_date,
    SUM(age_0_5 + age_5_17 + age_18_greater) AS daily_enrollments
FROM enrollment_data
GROUP BY enroll_date
ORDER BY enroll_date;



-- [7. Anomaly Detection (Unusual Spikes)]  Detects records where enrollment is significantly higher than average
-- Useful for identifying anomalies, data errors, or sudden surges
SELECT
    enroll_date,
    states,
    districts,
    (age_0_5 + age_5_17 + age_18_greater) AS total_enrollment
FROM enrollment_data
WHERE (age_0_5 + age_5_17 + age_18_greater) >
      (
        SELECT AVG(age_0_5 + age_5_17 + age_18_greater) * 2
        FROM enrollment_data
      )
ORDER BY total_enrollment DESC;



-- [8. Pincode-level Operational Load]  Aggregates enrollment at pincode level
-- Helps identify overloaded service areas
SELECT
    pincode,
    SUM(age_0_5 + age_5_17 + age_18_greater) AS pincode_load
FROM enrollment_data
GROUP BY pincode
ORDER BY pincode_load DESC;



-- [9. Day-on-Day Enrollment Growth]  Calculates daily growth or decline in enrollment
-- Useful for monitoring momentum and sudden changes
SELECT
    enroll_date,
    SUM(age_0_5 + age_5_17 + age_18_greater) -
    LAG(SUM(age_0_5 + age_5_17 + age_18_greater))
    OVER (ORDER BY enroll_date) AS daily_growth
FROM enrollment_data
GROUP BY enroll_date
ORDER BY enroll_date;



-- [10. Operational Load Index (Weighted Metric)]  Computes a weighted operational load score per state
-- Assigns higher weight to children due to higher processing effort
SELECT
    states,
    ROUND(
        SUM(age_0_5 * 1.2 + age_5_17 * 1.0 + age_18_greater * 0.8),
        2
    ) AS operational_load_index
FROM enrollment_data
GROUP BY states
ORDER BY operational_load_index DESC;



-- [11. Enrollment Volatility Index]  Measures fluctuation in enrollment using standard deviation
-- High volatility indicates operational instability
SELECT
    states,
    ROUND(
        STDDEV(age_0_5 + age_5_17 + age_18_greater),
        2
    ) AS enrollment_volatility
FROM enrollment_data
GROUP BY states
ORDER BY enrollment_volatility DESC;



-- [12. Enrollment Efficiency Score]  Calculates average enrollment handled per district in a state
-- Higher value indicates better operational efficiency
SELECT
    states,
    ROUND(
        SUM(age_0_5 + age_5_17 + age_18_greater) 
        / COUNT(DISTINCT districts),
        2
    ) AS enrollment_efficiency
FROM enrollment_data
GROUP BY states
ORDER BY enrollment_efficiency DESC;



-- [13. Underperforming Districts]  Identifies districts performing below their state average enrollment
-- Helps locate hidden gaps and underserved areas
WITH state_avg AS (
    SELECT
        states,
        AVG(age_0_5 + age_5_17 + age_18_greater) AS avg_enroll
    FROM enrollment_data
    GROUP BY states
)
SELECT
    e.states,
    e.districts,
    SUM(e.age_0_5 + e.age_5_17 + e.age_18_greater) AS district_enroll
FROM enrollment_data e
JOIN state_avg s ON e.states = s.states
GROUP BY e.states, e.districts, s.avg_enroll
HAVING SUM(e.age_0_5 + e.age_5_17 + e.age_18_greater) < s.avg_enroll
ORDER BY district_enroll;



-- [14. Adult Saturation Index]  Calculates proportion of adult enrollments in total enrollment
-- Indicates system maturity level
SELECT
    states,
    ROUND(
        SUM(age_18_greater)::DECIMAL 
        / NULLIF(SUM(age_0_5 + age_5_17 + age_18_greater),0),
        2
    ) AS adult_saturation_index
FROM enrollment_data
GROUP BY states
ORDER BY adult_saturation_index DESC;



-- [15. Child-to-Teen Transition Pressure]  Estimates future enrollment pressure as children age into next group
-- Used for medium-term demand forecasting
SELECT
    states,
    ROUND(
        SUM(age_0_5)::DECIMAL / NULLIF(SUM(age_5_17),0),
        2
    ) AS transition_pressure_ratio
FROM enrollment_data
GROUP BY states
ORDER BY transition_pressure_ratio DESC;



-- [16. Weekday-wise Load Distribution]  Analyzes enrollment variation across days of the week
-- Useful for workforce and schedule optimization
SELECT
    EXTRACT(DOW FROM enroll_date) AS day_of_week,
    ROUND(
        AVG(age_0_5 + age_5_17 + age_18_greater),
        2
    ) AS avg_daily_load
FROM enrollment_data
GROUP BY day_of_week
ORDER BY day_of_week;



-- [17. Peak Pressure Days]  Identifies top days with highest enrollment load
-- Helps prepare for surge handling and emergency planning
SELECT
    enroll_date,
    SUM(age_0_5 + age_5_17 + age_18_greater) AS peak_load
FROM enrollment_data
GROUP BY enroll_date
ORDER BY peak_load DESC
LIMIT 5;



-- [18. Long-Tail (Neglected) Districts]  Finds districts falling in bottom 10% of enrollments
-- Useful for equity-driven policy interventions
WITH district_totals AS (
    SELECT
        districts,
        SUM(age_0_5 + age_5_17 + age_18_greater) AS total_enroll
    FROM enrollment_data
    GROUP BY districts
)
SELECT *
FROM district_totals
WHERE total_enroll <
      (SELECT PERCENTILE_CONT(0.10)
       WITHIN GROUP (ORDER BY total_enroll)
       FROM district_totals)
ORDER BY total_enroll;



-- [19. Enrollment Momentum Score]  Measures growth velocity instead of absolute growth
-- Sudden increase indicates need for proactive scaling
SELECT
    enroll_date,
    ROUND(
        (SUM(age_0_5 + age_5_17 + age_18_greater) -
         LAG(SUM(age_0_5 + age_5_17 + age_18_greater))
         OVER (ORDER BY enroll_date))
        /
        NULLIF(LAG(SUM(age_0_5 + age_5_17 + age_18_greater))
        OVER (ORDER BY enroll_date),0),
        2
    ) AS momentum_score
FROM enrollment_data
GROUP BY enroll_date
ORDER BY enroll_date;



-- [20. Composite Risk Zone Classification]  Classifies states into LOW, MEDIUM, and HIGH risk zones
-- Combines average load and volatility for decision-making
WITH metrics AS (
    SELECT
        states,
        AVG(age_0_5 + age_5_17 + age_18_greater) AS avg_load,
        STDDEV(age_0_5 + age_5_17 + age_18_greater) AS volatility
    FROM enrollment_data
    GROUP BY states
)
SELECT
    states,
    avg_load,
    volatility,
    CASE
        WHEN avg_load > (SELECT AVG(avg_load) FROM metrics)
         AND volatility > (SELECT AVG(volatility) FROM metrics)
        THEN 'HIGH RISK'
        WHEN avg_load > (SELECT AVG(avg_load) FROM metrics)
        THEN 'MEDIUM RISK'
        ELSE 'LOW RISK'
    END AS risk_category
FROM metrics
ORDER BY risk_category;

