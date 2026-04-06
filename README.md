# E-commerce Delivery Performance Analysis

## Overview

This project analyzes e-commerce order and delivery performance using the Olist dataset. The goal was to clean raw transactional data, build a structured dataset, and explore key business metrics such as delivery time, order volume, and geographic performance.
The project demonstrates an end-to-end workflow including data cleaning, data modeling, and analytical querying.

## Data Pipeline

Raw Data -> Cleaning (Python) -> Feature Engineering -> Fact Table -> SQL Analysis


## Data Sources

The full Olist dataset from Kaggle is included in the `data/raw` folder. 
Not all tables were used in this analysis, but they are retained to reflect the complete source data and allow for future expansion.


## Tech Stack

- Python (Pandas)
- PostgreSQL
- SQL

## Data Preparation

Data was cleaned and transformed using Python notebooks:
- Removed inconsistencies and nulls
- Standardized column formats
- Created derived fields such as `delivery_days`

A final analytical table (`fct_orders`) was created, combining order and customer data to support analysis.

## Data Model

The core table used for analysis was fct_orders.
This design enables efficient aggregation and filtering for business-level metrics such as delivery performance and regional comparisons.


## Star Schema

```text
       dim_customers
+--------------------------+
| customer_unique_id (PK)  |
| customer_city            |
| customer_state           |
| customer_state_name      |
| customer_zip_code_prefix |
+------------+-------------+
             |
             | customer_unique_id
             |
             v
          fct_orders
+-------------------------------+
| order_id (PK)                 |
| customer_id                   |
| customer_unique_id (FK)       |
| order_status                  |
| order_purchase_timestamp      |
| order_approved_at             |
| order_delivered_carrier_date  |
| order_delivered_customer_date |
| order_estimated_delivery_date |
| delivery_days                 |
+-------------------------------+
```

The data model follows a star schema design with `fct_orders` as the central fact table and `dim_customers` as a supporting dimension. For analytical efficiency, selected customer attributes were denormalized into the fact table.

### fct_orders

The primary analytical table combining order and customer data, key fields include: 

- order_id (primary key)
- customer_id
- order_purchase_timestamp
- order_delivered_customer_date
- delivery_days (calculated using delivered orders only)
- customer_state

This table was designed to support aggregation and filtering for business analysis.

## Key Analyses

SQL queries were used to explore:

- Order volume trends over time
- Average delivery performance
- Geographic distribution of orders
- Delivery performance by region
- Relationship between order volume and delivery time

See `analysis.sql` for full queries.

## Key Insights

### 1. Geographic Delivery Disparity
High-volume regions (e.g., São Paulo) have significantly faster delivery times (~8 days), while low-volume regions can exceed 25 days.

### 2. Logistics Efficiency Scales with Demand
A correlation of approximately -0.59 indicates a moderate inverse relationship between order volume and delivery time, suggesting that higher demand regions benefit from more efficient logistics.

### 3. Delivery Time Trends
Delivery times show early volatility due to low initial order volume, then stabilize within a consistent range of approximately 10-14 days, based on monthly aggregation of average delivery_days.

## How to Run

1. Execute Python notebooks to generate cleaned datasets
2. Generate or use the cleaned final dataset (`fct_orders.csv`)
3. Import into PostgreSQL
4. Run queries from `analysis.sql`

## Future Improvements

- Build dbt models for transformations
- Add dashboards (Tableau / Power BI)
- Explore additional features such as payment data or product categories
