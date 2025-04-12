SELECT 
    *
FROM
    unicorns;

-- renamed column names to shorter acronyms
alter table unicorns
rename column `Valuation (Billion USD)_November 2021` to valuation,
rename column `Select Investors` to investors,
rename column `Founded Year` to founded_year,
rename column `Revenue (Billion USD)` to revenue_BnUSD;

-- add a new PK column with values 
ALTER TABLE unicorns 
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY FIRST;


SELECT DISTINCT
    employees
FROM
    unicorns;

-- to remove spaces in employees column
UPDATE unicorns 
SET 
    employees = TRIM(employees);

set sql_safe_updates = 0;

-- to remove + sign in employees column
UPDATE unicorns 
SET 
    employees = REPLACE(employees, '+', '');

-- to remove , sign in employees column
UPDATE unicorns 
SET 
    employees = REPLACE(employees, ',', '');

-- to remove spaces in employees column
UPDATE unicorns 
SET 
    employees = REPLACE(employees, ' ', '');

-- change the format of employees column to integer
ALTER TABLE unicorns MODIFY COLUMN employees INT;

-- Q1. Top 5 Countries by Number of Unicorns
SELECT 
    country, COUNT(*) AS unicorn_count
FROM
    unicorns
GROUP BY country
ORDER BY unicorn_count DESC , country ASC
LIMIT 5;

-- Q2. Top 3 Sectors by Average Valuation:
SELECT 
    sector, valuation
FROM
    unicorns
ORDER BY sector ASC , valuation DESC
LIMIT 3;

-- Q3- Unicorns Founded After 2010
SELECT 
    *
FROM
    unicorns
WHERE
    founded_year > 2010
ORDER BY founded_year;

-- Q4. Total Valuation of Unicorns in the FinTech Sector
SELECT 
    company,
    country,
    valuation,
    sector,
    founded_year,
    revenue_BnUSD
FROM
    unicorns
WHERE
    sector = 'FinTech'
ORDER BY valuation DESC, founded_year DESC;

-- another way 
SELECT*FROM
    unicorns
WHERE
    sector = 'FinTech'
ORDER BY valuation DESC, founded_year DESC;

-- Q5. Most Common Investors

-- Step1 - Segreagte the names of investors in individual columns
SELECT 
    TRIM(IF(LOCATE(',', investors) > 0,
            SUBSTRING_INDEX(investors, ',', 1),
            investors)) AS investor1,
    TRIM(IF(LOCATE(',',
                    investors,
                    LOCATE(',', investors) + 1) > 0,
            SUBSTRING_INDEX(SUBSTRING_INDEX(investors, ',', 2),
                    ',',
                    - 1),
            NULL)) AS investor2,
    TRIM(IF(LOCATE(',',
                    investors,
                    LOCATE(',',
                            investors,
                            LOCATE(',', investors) + 1) + 1) > 0,
            SUBSTRING_INDEX(SUBSTRING_INDEX(investors, ',', 3),
                    ',',
                    - 1),
            NULL)) AS investor3
FROM
    unicorns;

-- Step2 - Find most common investors (or count the no. of times each investor invested) using cross join
SELECT 
    investor, COUNT(*) AS occurrence_count
FROM
    (SELECT 
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(investors, ',', n.n), ',', - 1)) AS investor
    FROM
        unicorns
    CROSS JOIN (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) n
    WHERE
        n.n <= 1 + LENGTH(investors) - LENGTH(REPLACE(investors, ',', ''))) AS investor_list
WHERE
    investor <> ''
GROUP BY investor
ORDER BY occurrence_count DESC , investor ASC;

-- another method using json table query (found this method through chatgpt only as I was trying to find out other ways to write the same query)
SELECT investor, COUNT(*) AS occurrence_count
FROM (
    SELECT TRIM(value) AS investor
    FROM unicorns,
         JSON_TABLE(
             CONCAT('["', REPLACE(investors, ',', '","'), '"]'),
             '$[*]' COLUMNS(value VARCHAR(255) PATH '$')
         ) AS split_investors
) AS investor_list
WHERE investor <> ''
GROUP BY investor
ORDER BY occurrence_count DESC, investor ASC;


-- CHALLENGES
-- 1. Identify Trends: Explore trends in the data, such as the growth of unicorns in specific sectors or countries.

-- by sector
SELECT 
    sector, founded_year, COUNT(*) AS unicorn_count
FROM
    unicorns
GROUP BY sector , founded_year
ORDER BY founded_year DESC , unicorn_count DESC;

-- by country
SELECT 
    country, founded_year, COUNT(*) AS unicorn_count
FROM
    unicorns
GROUP BY country , founded_year
ORDER BY founded_year DESC , unicorn_count DESC;


-- sector and country trend over decades
SELECT sector, country, FLOOR(founded_year/10)*10 AS decade, COUNT(*) AS unicorn_count
FROM unicorns
GROUP BY sector, country, decade
ORDER BY sector ASC, country ASC, decade DESC;


-- 2. Investor Analysis: Which investors have the most unicorns in their portfolio?
SELECT 
    investor, COUNT(*) AS unicorn_count
FROM
    (SELECT 
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(investors, ',', n.n), ',', - 1)) AS investor
    FROM
        unicorns
    CROSS JOIN (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) n
    WHERE
        n.n <= 1 + LENGTH(investors) - LENGTH(REPLACE(investors, ',', ''))) AS investor_list
WHERE
    investor <> ''
GROUP BY investor
ORDER BY unicorn_count DESC , investor ASC;

-- 3. Growth Analysis: Compare Valuations of Companies Founded in Different Decades

-- 1st way
SELECT 
    FLOOR(founded_year / 10) * 10 AS decade,
    COUNT(*) AS unicorn_count,
    AVG(valuation) AS avg_valuation,
    MAX(valuation) AS max_valuation,
    MIN(valuation) AS min_valuation,
    GROUP_CONCAT(DISTINCT country) AS country,
    GROUP_CONCAT(DISTINCT sector) AS sector,
    GROUP_CONCAT(DISTINCT employees) AS employees
FROM
    unicorns
GROUP BY decade
ORDER BY decade ASC;

-- 2nd way
SELECT 
    FLOOR(founded_year / 10) * 10 AS decade,
    country,
    sector,
    COUNT(*) AS unicorn_count,
    AVG(valuation) AS avg_valuation,
    MAX(valuation) AS max_valuation,
    MIN(valuation) AS min_valuation
FROM
    unicorns
GROUP BY decade , country , sector
ORDER BY decade ASC , country ASC , sector ASC;

-- end