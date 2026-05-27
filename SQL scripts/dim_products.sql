-- Step 1: Create clean working copy
SELECT *
INTO dim_products_clean
FROM [cloutsaas].[dbo].dim_product_RAW;

-- Step 2: Standardise brand names
UPDATE dim_products_clean
SET brand = CASE UPPER(TRIM(brand))
    WHEN 'COCA-COLA' THEN 'Coca-Cola'
    WHEN 'LUCOZADE'  THEN 'Lucozade'
    WHEN 'CHIVITA'   THEN 'Chivita'
    WHEN 'VITAMILK'  THEN 'Vitamilk'
    WHEN 'C-WAY'     THEN 'C-Way'
    ELSE TRIM(brand)
END;

-- Step 3: Remove % symbol from incentive_rate_percent e.g. '5%' → '5'
UPDATE dim_products_clean
SET incentive_rate_percent = REPLACE(incentive_rate_percent, '%', '');

-- Step 4: Remove 'units' text from units_per_carton
UPDATE dim_products_clean
SET units_per_carton =
    TRIM(REPLACE(units_per_carton, 'units', ''))

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products_clean';

-- Step 5: Convert columns to correct data types
ALTER TABLE dim_products_clean
ALTER COLUMN incentive_rate_percent DECIMAL (12,1);

ALTER TABLE dim_products_clean
ALTER COLUMN units_per_carton INT;

-- Step 6: Fill missing category value for product P2
UPDATE dim_products_clean
SET category = 'Carbonated'
WHERE product_id = 'P2'
AND category = '';

-- Final check
SELECT *
FROM [cloutsaas].[dbo].dim_products_clean;
