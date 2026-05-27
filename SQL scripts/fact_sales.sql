-- Step 1: Create clean working copy
SELECT *
INTO fact_sales_clean
FROM [cloutsaas].[dbo].fact_sales_RAW;

-- Step 2: Standardise mixed date formats to YYYY-MM-DD
--         Format 1: DD-MM-YYYY (e.g. '15-03-2024')
UPDATE fact_sales_clean
SET date = CONVERT(VARCHAR(10), CONVERT(DATE, date, 105), 23)
WHERE date LIKE '__-__-____';

--         Format 2: DD/MM/YYYY (e.g. '14/06/2024')
UPDATE fact_sales_clean
SET DATE = CONVERT(VARCHAR(10), CONVERT(DATE, date, 103), 23)
WHERE date LIKE '__/__/____';

--         Format 3: YYYY/MM/DD (e.g. '2024/07/22')
UPDATE fact_sales_clean
SET DATE = REPLACE (DATE, '/', '-')
WHERE DATE LIKE '____/__/__';

--         Format 4: YYYY.MM.DD (e.g. '2024.01.30')
UPDATE fact_sales_clean
SET DATE = REPLACE (DATE, '.', '-')
WHERE DATE LIKE '____.__.__';

--         Format 5: Mon DD YYYY (e.g. 'Oct 9 2024')
UPDATE fact_sales_clean
SET date = CONVERT(VARCHAR(10), CONVERT(DATE, date, 107), 23)
WHERE date LIKE '___ __ ____' 
   OR date LIKE '___ _ ____';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales_clean';

-- Step 3: Convert date column to DATE data type
ALTER TABLE fact_sales_clean
ALTER COLUMN date DATE;

-- Step 4: Identify all duplicate transaction IDs
SELECT *
FROM fact_sales_clean
WHERE transaction_id IN (
    SELECT transaction_id
    FROM fact_sales_clean
    GROUP BY transaction_id
    HAVING COUNT(*) > 1
)
ORDER BY transaction_id;

-- Step 5: Delete conflicting duplicates
DELETE FROM fact_sales_clean
WHERE transaction_id IN ('T350', 'T704');

-- Step 6: Remove remaining simple duplicates (keep first occurrence only)
WITH duplicates AS (
SELECT *,
        ROW_NUMBER() OVER(
            PARTITION BY transaction_id
            ORDER BY transaction_id)
                AS row_num
            FROM fact_sales_clean)
DELETE FROM duplicates
WHERE row_num > 1;

-- Step 7: Replace empty branch_id with 'B-Unknown'
--         (transactions where branch could not be identified)
UPDATE fact_sales_clean
SET branch_id = 'B-Unknown'
WHERE branch_id = '';

-- Step 8: Replace empty units_sold with NULL
UPDATE fact_sales_clean
SET units_sold = '0'
WHERE TRIM(units_sold) = '';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales_clean';

-- Step 9: Convert columns to correct data types
ALTER TABLE fact_sales_clean
ALTER COLUMN units_sold DECIMAL(10,0);

ALTER TABLE fact_sales_clean
ALTER COLUMN units_sold INT;

ALTER TABLE fact_sales_clean
ALTER COLUMN unit_buy_price_naira DECIMAL(10,2);

ALTER TABLE fact_sales_clean
ALTER COLUMN unit_sell_price_naira DECIMAL(10,2);

ALTER TABLE fact_sales_clean
ALTER COLUMN total_revenue_naira DECIMAL(10,2);

-- Final check
SELECT *
FROM [cloutsaas].[dbo].fact_sales_FINAL2;
