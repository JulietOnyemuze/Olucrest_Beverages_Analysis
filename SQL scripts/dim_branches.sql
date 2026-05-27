-- Step 1: Create clean working copy
SELECT *
INTO dim_branches_clean
FROM [cloutsaas].[dbo].dim_branch_RAW;

-- Step 2: Fix inconsistent state casing (e.g. 'lagos', 'LAGOS' → 'Lagos')
UPDATE dim_branches_clean
SET state =
    UPPER(LEFT(TRIM(state), 1)) +
    LOWER(SUBSTRING(TRIM(state), 2, LEN(TRIM(state))));

-- Step 3: Standardise has_vehicle column (YES/Y/yes → 'Yes', NO/N/no → 'No')
UPDATE dim_branches_clean
SET has_vehicle = CASE
    WHEN UPPER(has_vehicle) IN ('YES', 'Y') THEN 'Yes'
    WHEN UPPER(has_vehicle) IN ('NO', 'N')  THEN 'No'
END;

-- Step 4: Remove text 'cartons' from storage_capacity_cartons
--         e.g. '1200 cartons' → '1200'
UPDATE dim_branches_clean
SET storage_capacity_cartons =
    TRIM(REPLACE(storage_capacity_cartons, 'cartons', ''))

-- Step 5: Fix missing location value for branch B3
UPDATE dim_branches_clean
SET location = 'Aba'
WHERE branch_id = 'B3'
AND location = '';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_branches_clean';

-- Step 6: Convert storage_capacity_cartons from text to integer
ALTER TABLE dim_branches_clean
ALTER COLUMN storage_capacity_cartons INT;

-- Step 7: Add unknown member row to maintain referential integrity
--         (for transactions where branch could not be identified)
INSERT INTO [cloutsaas].[dbo].dim_branches_clean (branch_id, branch_name, location, state, has_vehicle, storage_capacity_cartons)
VALUES ('B-Unknown', 'Unknown Branch', 'Unknown', 'Unknown', 'Unknown', 0);

-- Final check
SELECT *
FROM [cloutsaas].[dbo].dim_branches_clean;