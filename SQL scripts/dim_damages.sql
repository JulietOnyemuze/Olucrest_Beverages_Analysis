-- Step 1: Create clean working copy
SELECT *
INTO fact_damages_clean
FROM [cloutsaas].[dbo].fact_damage_RAW;

-- Step 2: Standardise damage_cause values and fix typo
UPDATE fact_damages_clean
SET damage_cause = CASE
    WHEN UPPER(LTRIM(RTRIM(damage_cause))) IN ('PACKAGING DEFECT')                  THEN 'Packaging Defect'
    WHEN UPPER(LTRIM(RTRIM(damage_cause))) IN ('SUPPLIER', 'SUPLIER')               THEN 'Supplier'
    WHEN UPPER(LTRIM(RTRIM(damage_cause))) IN ('STAFF HANDLING')                    THEN 'Staff Handling'
    WHEN UPPER(LTRIM(RTRIM(damage_cause))) IN ('TRANSIT', 'IN TRANSIT')             THEN 'Transit'
    WHEN UPPER(LTRIM(RTRIM(damage_cause))) IN ('UNKNOWN')                           THEN 'Unknown'
    WHEN UPPER(LTRIM(RTRIM(damage_cause))) IN ('')                                  THEN 'Unknown'
    ELSE damage_cause
END;

-- Step 3: Remove currency symbol from damage_value_naira
--         (encoding issue caused ₦ to appear as 'â‚¦')
UPDATE fact_damages_clean
SET damage_value_naira = TRIM(REPLACE(damage_value_naira, 'â‚¦', ''));

-- Step 4: Replace empty units_damaged with NULL
UPDATE fact_damages_clean
SET units_damaged = CASE
    WHEN units_damaged = '' THEN NULL
    ELSE units_damaged
    END;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_damages_clean';

-- Step 5: Convert columns to correct data types
ALTER TABLE fact_damages_clean
ALTER COLUMN damage_value_naira DECIMAL(10,2);

ALTER TABLE fact_damages_clean
ALTER COLUMN date DATE;

ALTER TABLE fact_damages_clean
ALTER COLUMN units_damaged DECIMAL (10,0);

ALTER TABLE fact_damages_clean
ALTER COLUMN units_damaged INT;

-- Step 6: Identify duplicate damage records
SELECT *
FROM [cloutsaas].[dbo].fact_damages_clean
WHERE damage_id IN (
    SELECT damage_id
    FROM [cloutsaas].[dbo].fact_damages_clean
    GROUP BY damage_id
    HAVING COUNT(*) > 1
)
ORDER BY damage_id;

-- Step 7: Remove duplicate records (keep first occurrence only)
WITH duplicates AS(
SELECT *, ROW_NUMBER() OVER(
    PARTITION BY damage_id
    ORDER BY damage_id
    ) AS row_num
    FROM [cloutsaas].[dbo].fact_damages_clean)
DELETE FROM duplicates
WHERE row_num > 1;

-- Final check
SELECT *
FROM [cloutsaas].[dbo].fact_damages_clean;
