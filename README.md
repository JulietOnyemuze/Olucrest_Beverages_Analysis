# Olucrest Beverages — Revenue, Margin & Damage Analytics
## Project Summary
This project analyzes the operations of Olucrest Beverages, a fictional beverage distribution company modelled after a real-world business. The company distributes products from major FMCG brands including Coca-Cola, Chivita, Vitamilk, C-Way and Lucozade across 6 branches.
The dataset was simulated to reflect realistic FMCG distribution scenarios, cleaned entirely in SQL Server, and visualised in a 3-page Power BI dashboard. The goal was to identify where profitability was being lost across damage, margins, and seasonal demand, and translate those findings into actionable business decisions.
## Problem Statement
Beverage distributors operate on thin margins, and most of what eats into profit is invisible on a standard sales report. For Olucrest Beverages, the key business questions were:
* Which products are actually profitable versus just popular?
* How much money is being lost to damaged stock, and why is it happening?
* Are supplier promotions helping or hurting profitability?
* Are their branches performing equally or not?
* Are supplier promotions helping or hurting profitability?
## Data Source and Methodology
### Data Source
The dataset was fully simulated to reflect realistic Nigerian FMCG distribution operations. Business context was gathered from a real beverage distributor, and the data was intentionally generated with common real-world data quality issues to demonstrate end-to-end data cleaning skills.

| Table | Rows | Description
|-------|------|------------|
| sales_table | 798 | Sales transactions across all branches and products
| damage_table | 300 | Product damage records by branch, product and cause
| pricing_table | 144 | Monthly pricing per product with supplier promo data
| product_table | 12 | Product details including brand, category and incentive rates
| branches_table | 7 | Branch details including location and vehicle availability and storage capacity
### Data Cleaning & Validation (SQL)
18 issues were resolved across the 5 tables:
| Table | Issue Identified | Fix Applied
|-------|------------------|------------|
| branches_table | Mixed formats in has_vehicle (YES/Y/yes/NO/N/no) | Standardised to 'Yes' / 'No' using CASE
| branches_table | Text embedded in storage_capacity_cartons ('1200 cartons') | Stripped text, replaced empty values with column average, converted to INT
| branches_table | Missing location value for branch B3 | Filled with known value 'Aba'
| products_table | Inconsistent brand name formatting ('COCA-COLA', 'Coca Cola') | Standardised using CASE
| products_table | % symbol in incentive_rate_percent ('5%') | Stripped symbol, converted to DECIMAL
| products_table | 'units' text in units_per_carton ('12 units') | Stripped text, converted to INT
| products_table | Missing category value for product P2 | Filled with known value 'Carbonated'
| pricing_table | Inconsistent month names ('JAN', 'JANUARY', 'january') | Standardised to full name using CASE
| pricing_table | Mixed formats in supplier_promo (YES/Y/NO/N) | Standardised to 'Yes' / 'No' using CASE
| pricing_table | Empty strings in promo_buy_price_naira | Converted to NULL
| damage_table | Inconsistent damage_cause casing + typo ('SUPLIER') | Standardised and corrected using CASE
| damage_table | Currency symbol encoding error in damage_value_naira ('â‚¦2400') | Stripped symbol, converted to DECIMAL
| damage_table | Empty strings in damage_cause and units_damaged | Replaced with 'Unknown' and NULL respectively
| damage_table | Duplicate damage records | Removed using ROW_NUMBER() CTE
| sales_table | Five different date formats in one column | Standardised to YYYY-MM-DD using CONVERT, converted to DATE type
| sales_table | Simple duplicate records | Removed using ROW_NUMBER() CTE
| sales_table | Empty branch_id values | Replaced with 'B-Unknown'; matching row added to dim_branches
| sales_table | Empty units_sold values | Converted to 0
### Highlighted Queries
#### Query 1: Replacing a missing numeric value with the column average (branches_table)
Rather than deleting rows with missing storage_capacity_cartons values, empty strings were replaced with the average capacity across all other branches, preserving the row while making the value usable for analysis.
``` sql
SELECT
    TRIM(branch_id)     AS branch_id,
    TRIM(branch_name)   AS branch_name,
    TRIM(location)      AS location,
    TRIM(state)         AS state,
    CASE
        WHEN TRIM(has_vehicle) = 'yes' THEN 'Yes'
        ELSE TRIM(has_vehicle)
    END AS has_vehicle,
    CASE
        WHEN storage_capacity_cartons = '' THEN (
            SELECT AVG(CAST(storage_capacity_cartons AS FLOAT))
            FROM [cloutsaas].[dbo].branches_table_dirty
            WHERE storage_capacity_cartons != ''
        )
        ELSE CAST(storage_capacity_cartons AS FLOAT)
    END AS storage_capacity_cartons
INTO branches_table_clean
FROM [cloutsaas].[dbo].branches_table_dirty;
```
#### Query 2: Handling duplicate records in fact_sales
Duplicates were removed using a ROW_NUMBER() CTE, keeping only the first occurrence of each transaction.
``` sql
WITH duplicates AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY transaction_id
            ORDER BY transaction_id
        ) AS row_num
    FROM fact_sales_clean
)
DELETE FROM duplicates
WHERE row_num > 1;
```
*Full cleaning scripts for all 5 tables: [sql/data_cleaning.sql](https://github.com/JulietOnyemuze/Olucrest_Beverages_Analysis/tree/main/SQL%20scripts)*
## Key Insights and Visualization
### Overview
* Revenue is growing month on month (+2.6%) but profit margin is declining (-0.4%), the business is selling more but keeping less of each naira earned
* Dry season drives 60% of annual revenue
* Ikeja Hub is the top-performing branch; Aba Central generates the least revenue across all 6 branches
* Revenue peaked in March and declined steadily, November was the lowest month
### Loss & Operations
* ₦786.28K in damage losses represents **5.11% of total revenue,** a significant leak for a business operating on 12% margins
* Packaging defects are the leading damage cause, consistent with the real-world issue of Chivita cartons leaking
* Chivita Apple and Chivita Exotic account for the highest damage losses by product
* Onitsha Depot and Aba Central, both branches without delivery vehicles, record the highest damage losses. Relying on outside transport means less control over how stock is handled.
* Rainy season contributes 58.81% of all damage, proportional to its sales volume, meaning damage is a year-round structural problem, not just a seasonal one
### Pricing & Promo Intelligence
* In months where the supplier offers a discounted buy price, Olucrest's average profit per unit is ₦53.83, compared to just ₦27.10 in normal months. That is a ₦26.73 uplift per unit without changing anything about how the business operates
* Vitamilk Banana benefits most from promos (₦36.89 uplift per unit); Chivita Orange benefits least (₦1.23)
* Chivita Exotic has the highest supplier incentive rate at 20% but does not lead in sales, proving that in this market, customers buy based on brand familiarity, not incentive offers
* Products with the highest revenue are not always the most profitable. Chivita Orange is the top revenue product at ₦1.89M, but keeps only 10.3% as margin. Coke 1L generates less revenue but retains 17.5%.
## Recommendations
| Finding | What the business should do
|---------|----------------------------|
| Chivita packaging is the biggest source of damage loss | Reduce Chivita damage losses through better storage and handling practices. Since the packaging issues are outside direct control, Chivita products should be stored separately, handled more carefully during offloading, and checked immediately upon arrival to prevent leaking cartons from damaging nearby stock.
| Branches without vehicles record the most damage | Invest in delivery vehicles for Onitsha Depot and Aba Central, or find reliable dedicated logistics partners for those branches
| Supplier promo months nearly double profit margins | Build a closer relationship with suppliers to get advance notice of promotional windows, then stock up strategically during those periods
| Dry season drives 60% of revenue | Plan ahead, increase stock levels and staffing before Dry season begins to avoid running out of stock during the highest-demand period
| 24 transactions could not be linked to any branch | Introduce a simple point-of-sale logging system so every transaction is recorded against the correct branch, this data is currently invisible to management
| Product performance is being judged mainly by revenue, even though Chivita Orange generates high sales with very low margins | Evaluate products using both revenue and profit margin, not sales volume alone, to support more profitable pricing and procurement decisions
## Challenges & Lessons Learned
1. The Pricing table contained multiple price records per product per month, making a direct relationship with the Sales table unreliable. This created a many-to-many relationship that caused relationship issues in Power BI. To resolve this, the Sales table was rebuilt with buy price and sell price embedded directly into each transaction row, removing the dependency on the Pricing table.\
*Key lesson: when a lookup table starts behaving like a fact table, restructuring the data model is often better than forcing a relationship.*

2. The date column in Sales table contained multiple formats including DD-MM-YYYY, DD/MM/YYYY, YYYY/MM/DD, YYYY.MM.DD, and Mon DD YYYY, all within the same field. Because SQL date conversion is format-sensitive, each pattern required separate handling using pattern matching and targeted UPDATE statements before the column could be safely converted to a DATE datatype.\
*Key Lesson: Date fields are among the most fragile parts of any dataset. The full range of values should always be inspected before attempting datatype conversion.*





