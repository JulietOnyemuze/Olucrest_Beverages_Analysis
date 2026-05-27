-- Step 1: Create clean working copy
SELECT *
INTO dim_pricing_clean
FROM [cloutsaas].[dbo].dim_pricing_RAW;

-- Step 2: Standardise month names
UPDATE dim_pricing_clean
SET month = CASE UPPER(TRIM(month))
    WHEN 'JANUARY' THEN 'January'
    WHEN 'JAN'     THEN 'January'

    WHEN 'FEBRUARY' THEN 'February'
    WHEN 'FEB'      THEN 'February'

    WHEN 'MARCH' THEN 'March'
    WHEN 'MAR'   THEN 'March'

    WHEN 'APRIL' THEN 'April'
    WHEN 'APR'   THEN 'April'

    WHEN 'MAY' THEN 'May'

    WHEN 'JUNE' THEN 'June'
    WHEN 'JUN'  THEN 'June'

    WHEN 'JULY' THEN 'July'
    WHEN 'JUL'  THEN 'July'

    WHEN 'AUGUST' THEN 'August'
    WHEN 'AUG'    THEN 'August'

    WHEN 'SEPTEMBER' THEN 'September'
    WHEN 'SEP'       THEN 'September'

    WHEN 'OCTOBER' THEN 'October'
    WHEN 'OCT'     THEN 'October'

    WHEN 'NOVEMBER' THEN 'November'
    WHEN 'NOV'      THEN 'November'

    WHEN 'DECEMBER' THEN 'December'
    WHEN 'DEC'      THEN 'December'

    ELSE TRIM(month)
END;

-- Step 3: Standardise supplier_promo column
UPDATE dim_pricing_clean
SET supplier_promo = CASE
    WHEN UPPER(LTRIM(RTRIM(supplier_promo))) IN ('YES', 'Y') THEN 'Yes'
    WHEN UPPER(LTRIM(RTRIM(supplier_promo))) IN ('NO', 'N')  THEN 'No'
    ELSE supplier_promo
END;

-- Step 4: Replace empty promo_buy_price_naira with NULL
UPDATE dim_pricing_clean
SET promo_buy_price_naira =
    CASE
        WHEN promo_buy_price_naira = '' THEN NULL
        ELSE promo_buy_price_naira
    END;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_pricing_clean';

-- Step 5: Convert columns to correct data types
ALTER TABLE dim_pricing_clean
ALTER COLUMN month_number INT;

ALTER TABLE dim_pricing_clean
ALTER COLUMN year INT;

ALTER TABLE dim_pricing_clean
ALTER COLUMN our_buy_price_naira DECIMAL(10,2);

ALTER TABLE dim_pricing_clean
ALTER COLUMN promo_buy_price_naira DECIMAL(10,2);

ALTER TABLE dim_pricing_clean
ALTER COLUMN our_sell_price_naira DECIMAL(10,2);

ALTER TABLE dim_pricing_clean
ALTER COLUMN margin_naira DECIMAL(10,2);

-- Final check
SELECT *
FROM [cloutsaas].[dbo].dim_pricing_clean;