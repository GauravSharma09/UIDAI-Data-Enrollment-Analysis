# UIDAI-Data-Enrollment-Analysis
UIDAI Aadhaar Enrolment Analytics dashboard analyzes nationwide enrolment trends by age group, time, and geography. It highlights child-dominated registrations, state-wise performance, seasonal surges, and operational load, enabling better capacity planning, resource allocation, and data-driven policy decisions.

📊 UIDAI Aadhaar Enrolment Analytics

A data-driven analytics project that explores Aadhaar enrolment patterns across India using SQL and Power BI. The project focuses on demographic trends, geographical distribution, operational load, and predictive insights to support better decision-making.

🚀 Project Overview

This project analyzes large-scale Aadhaar enrolment data by integrating:

📂 SQL-based data processing & advanced analytics
📊 Power BI interactive dashboard
🧠 Insight generation for planning & optimization

The goal is to help UIDAI improve enrolment capacity, identify risks, and optimize resource allocation.

🗂 Dataset & Data Processing
- Multiple CSV files merged into a single dataset using SQL
- Data cleaning performed:
- Standardized state names
- Removed invalid records (e.g., dummy values like 100000)
- Structured into a unified table enrollment_data

📌 Key Columns:
- enroll_date
- states, districts, pincode
- age_0_5, age_5_17, age_18_greater

📊 Dashboard Features

🔹 KPI Metrics
- Total Enrolments: 7M+ 
- Child Enrolment Ratio: 97%
- Operational Load Index
- Age-wise enrolment counts

🔹 Visual Analysis
- Enrolment trend over time
- Age group distribution
- Geographical mapping (state & district level)
- Queue-based and category-based insights

🧠 Key Insights

👶 Enrolments are heavily skewed towards 0–5 age group, indicating strong child registration initiatives
📅 Peak enrolments occur in later months, showing seasonal demand
🏙 High population states like Uttar Pradesh, Bihar, Maharashtra dominate enrolments
⚙️ Operational load varies significantly across regions, highlighting resource imbalance
📉 Some districts are underperforming, indicating accessibility gaps

🧮 SQL Analysis Highlights

The project includes 20+ analytical SQL queries covering:

🔹 Descriptive Analysis
Total enrolments
State & district-level aggregation
Age group distribution

🔹 Diagnostic Analysis
Underperforming districts
High-load pincodes
Anomaly detection (unusual spikes)

🔹 Predictive Indicators
Child dependency ratio
Transition pressure ratio
Enrollment momentum score

🔹 Advanced Metrics
Operational Load Index
Enrollment Efficiency Score
Volatility Index
Risk Zone Classification (Low / Medium / High)

📍 Use Cases
- Capacity planning for enrolment centers
- Risk identification in high-load regions
- Workforce and infrastructure optimization
- Policy making and demographic analysis
  
🛠 Tech Stack

SQL (PostgreSQL) – Data cleaning & analysis
Power BI – Dashboard & visualization
Excel/CSV – Raw dataset

📸 Dashboard Preview

<img width="1126" height="635" alt="Screenshot 2026-01-20 171133" src="https://github.com/user-attachments/assets/60075c95-8efb-4787-b59a-9e3ec5548eb9" />
<img width="1142" height="648" alt="Screenshot 2026-01-20 171206" src="https://github.com/user-attachments/assets/cc8d0809-33dd-4ba9-b0a7-d60124ac7ec9" />
<img width="1127" height="643" alt="Screenshot 2026-01-20 171216" src="https://github.com/user-attachments/assets/bf5fe4f4-c5ef-45ec-b976-f5522b1f1df5" />

👨‍💻 Author

Gaurav Sharma
