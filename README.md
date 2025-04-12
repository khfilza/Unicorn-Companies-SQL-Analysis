**SQL Project: Analyzing Unicorn Companies**

**Project Overview**

This project involves analyzing a dataset of unicorn companies—privately held startups valued at over $1 billion as of November 2021. Using SQL, I performed data cleaning, transformation, and analysis to uncover trends in valuations, sectors, countries, and investor influence.

**Key Features**
🔹 Data Cleaning & Transformation
* Renamed columns for better readability.
* Modified the employees column by removing +, ,, and spaces, then converted it to INT.
* Added an auto-incrementing id column as the primary key.

🔹 SQL Analysis & Insights
* Identified top countries with the most unicorns.
* Analyzed highest-valued sectors.
* Explored unicorns founded after 2010.
* Calculated total valuation in FinTech.
* Extracted and analyzed most common investors (using advanced SQL techniques like CROSS JOIN and JSON_TABLE).

🔹 Trend & Growth Analysis
* Compared valuations across different decades.
* Studied sector-wise and country-wise trends over time.
* Investigated investor portfolios to find key players.

**Dataset Structure**
The dataset includes:
Company: Name of the unicorn company
Country: Headquarters location
Sector: Industry (e.g., FinTech, AI, Aerospace)
Valuation (Billion USD): Company valuation
Founded Year: Year of establishment
Select Investors: Key investors (comma-separated)
Revenue (Billion USD): Annual revenue
Employees: Workforce size

**SQL Techniques Used**
🔹 Data Manipulation:
ALTER TABLE, UPDATE, TRIM, REPLACE, MODIFY COLUMN  

🔹 Advanced Queries:
SUBSTRING_INDEX, CROSS JOIN, JSON_TABLE, GROUP_CONCAT  

🔹 Aggregations & Filtering:
GROUP BY, COUNT, AVG, MAX, MIN, ORDER BY, WHERE  

🔹 Trend Analysis:
FLOOR(founded_year/10)*10 AS decade  -- Grouping by decades  

**Key Findings**
🌍 Top Countries: The US, China, and UK dominate in unicorn count.
💡 Top Sectors: FinTech, AI, and E-commerce have the highest valuations.
📈 Growth Trends: Companies founded post-2010 show rapid growth.
💰 Investor Influence: Sequoia Capital and Andreessen Horowitz are top investors.

**Challenges & Solutions**
🔎 Investor Analysis:
* Split comma-separated investor lists into individual values using SUBSTRING_INDEX and CROSS JOIN.
* Applied JSON_TABLE for an alternative approach.

📊 Decade-wise Comparison:
* Used FLOOR(founded_year/10)*10 to group companies by founding decades.

**Credits**
This project was completed as part of the requirement of Data Analytics bootcamp with atomcamp.
