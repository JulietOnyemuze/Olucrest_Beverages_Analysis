# Olucrest_Beverages_Analysis
## Project Overview
This project analyses the sales performance, profit margins, and operational damage losses of Olucrest Beverages, a fictional Nigerian beverage distribution company modelled after a real-world business. The company distributes products from major FMCG brands including Coca-Cola, Chivita, Vitamilk, C-Way, and Lucozade across 6 branches in Nigeria.
The dataset was fully simulated, cleaned, and validated before being modelled and visualised in a 3-page Power BI dashboard designed to support management decision-making.
### Tools Used:
* SQL Server - Data cleaning and validation
* Power BI Desktop - Data modelling, DAX measures & dashboard design
The goal of this project was to....
## Problem Statement
* No visibility into which products are actually profitable vs just high in revenue
* Demand that shifts heavily by season, making poor stock planning expensive
* Branch performance varying significantly with no clear understanding of what is driving the gap
* Pricing competitiveness, when suppliers run promotional pricing to other distributors, Olucrest risks losing customers to competitors selling at lower prices, with no way to monitor or respond to market price shifts
* Stock getting damaged in transit, by staff, or due to poor packaging, with no way to recover that loss
## Data Source and Methodology
I created the data myself using....
### Dataset Design
Five tables were designed to mirror a real distribution company's data structure:
| Table | Description
|-------|------------|
| sales_table | Sales transactions across all branches and products
| damage_table | Product damage records by branch, product and cause
| pricing_table | Monthly pricing per product with supplier promo data
| product_table | Product reference data; brand, category, packaging, incentive rates
| branches_table | Branch reference data; location, vehicle availability, storage capacity
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




