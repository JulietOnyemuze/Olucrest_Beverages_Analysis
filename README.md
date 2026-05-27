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




## Key Insights and Visualization
* Revenue reached ₦15.39M but net profit was only ₦1.16M 
* Packaging defects are the leading damage cause, a supplier issue, not a staff issue
* Branches without delivery vehicles record the highest damage losses
* Promo months yield ₦53.83 avg margin per unit vs ₦27.10 on non-promo months
* Chivita Exotic has the highest incentive rate (20%) but does not lead in sales volume, brand familiarity outweighs incentives in this market
* High-revenue products are not always the most profitable, Chivita products show the widest revenue-to-margin gap
* Dry season drives 60.15% of total annual revenue
## Recommendations




