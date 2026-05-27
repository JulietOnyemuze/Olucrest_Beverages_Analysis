# Olucrest Beverages — Revenue, Margin & Damage Analytics
## Project Summary
This project analyses the operations of Olucrest Beverages, a fictional Nigerian beverage distribution company modelled after a real-world business. The company distributes products from major FMCG brands including Coca-Cola, Chivita, Vitamilk, C-Way and Lucozade across 6 branches in Nigeria.
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
14 issues were resolved across the 5 tables:
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
| sales_table | Conflicting duplicate records (T350, T704 — same ID, different dates) | Both rows deleted; correct record could not be determined
| sales_table | Simple duplicate records | Removed using ROW_NUMBER() CTE
| sales_table | Empty branch_id values | Replaced with 'B-Unknown'; matching row added to dim_branches
| sales_table | Empty units_sold values | Converted to 0


## Key Insights and Visualization
* Revenue reached ₦15.39M but net profit was only ₦1.16M 
* Packaging defects are the leading damage cause, a supplier issue, not a staff issue
* Branches without delivery vehicles record the highest damage losses
* Promo months yield ₦53.83 avg margin per unit vs ₦27.10 on non-promo months
* Chivita Exotic has the highest incentive rate (20%) but does not lead in sales volume, brand familiarity outweighs incentives in this market
* High-revenue products are not always the most profitable, Chivita products show the widest revenue-to-margin gap
* Dry season drives 60.15% of total annual revenue
## Recommendations




