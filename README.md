# SupplyChainIQ
## Intelligent Supply Chain Analytics & Optimization Platform

An end-to-end supply chain analytics project that transforms raw operational data into actionable business insights using Python, SQL, Excel, and Power BI.

SupplyChainIQ analyzes sales performance, delivery efficiency, shipping operations, product categories, and customer behavior to identify operational challenges and support data-driven decision-making.

---

## Project Overview

Supply chain operations involve multiple interconnected activities, including order processing, shipping, delivery, and inventory management. Analyzing these activities helps businesses identify inefficiencies and improve operational performance.

SupplyChainIQ uses the DataCo Smart Supply Chain dataset to perform data cleaning, exploratory data analysis, SQL-based business analysis, spreadsheet analysis, and interactive dashboard development.

## Objectives

- Analyze overall supply chain and sales performance.
- Identify delivery inefficiencies and shipping risks.
- Evaluate shipping-mode performance.
- Analyze product-category and customer-segment contribution.
- Identify regional delivery challenges.
- Generate actionable business recommendations.

## Technology Stack

| Area | Technologies |
|---|---|
| Programming | Python |
| Data Analysis | Pandas, NumPy |
| Data Visualization | Matplotlib, Seaborn |
| Database | PostgreSQL |
| Querying | SQL |
| Spreadsheet Analysis | Excel |
| Business Intelligence | Power BI, DAX |
| Development Tools | Jupyter Notebook, VS Code, Git, GitHub |

## Dataset

**DataCo Smart Supply Chain Dataset**

Source: [Kaggle – DataCo Smart Supply Chain for Big Data Analysis](https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis)

Dataset overview:
- Original records: 180,519
- Original columns: 53
- Cleaned records: 180,519
- Cleaned columns: 50
- Unique orders: 65,752
- Unique customers: 20,652
- Order-item-level records: 180,519
- Order date range: January 2015 – January 2018

The dataset contains order, sales, customer, product, shipping, and delivery information.

## Project Workflow

1. **Data Audit and Cleaning**
   - Inspected dataset structure and data quality.
   - Examined missing values and duplicate records.
   - Removed unnecessary and redundant columns.
   - Created additional date and shipping-delay features.

2. **Exploratory Data Analysis**
   - Analyzed sales and order distributions.
   - Examined product-category performance.
   - Investigated delivery status and shipping delays.
   - Evaluated customer and regional patterns.

3. **SQL Business Analysis**
   - Imported cleaned data into PostgreSQL.
   - Developed SQL queries to answer business questions.
   - Analyzed sales, orders, customers, delivery performance, and shipping modes.

4. **Excel Analysis**
   - Developed KPI summaries and formula-based analysis.
   - Created category and shipping analysis sheets.
   - Built charts to communicate business findings.

5. **Power BI Dashboard**
   - Created an interactive report with three analytical pages.
   - Developed DAX measures for key performance indicators.
   - Designed visualizations for executive, logistics, product, and customer analysis.

6. **Business Recommendations**
   - Converted analytical findings into recommendations for delivery performance, logistics, inventory planning, and customer retention.

## Key Business Metrics

| KPI | Result |
|---|---:|
| Total Sales | 36.78 Million |
| Total Orders | 65,752 |
| Total Customers | 20,652 |
| Total Order Items | 180,519 |
| Average Sales per Item | 203.77 |
| Late Delivery Items | 98,977 |
| Late Delivery Rate | 54.83% |

*Currency is not specified in the source dataset. Sales values are presented in the dataset's original units.*

## Key Analytical Findings

### Shipping Performance

| Shipping Mode | Late Delivery Risk | Average Delay (Days) |
|---|---:|---:|
| First Class | 95.32% | 1.00 |
| Second Class | 76.63% | 1.99 |
| Same Day | 45.74% | 0.48 |
| Standard Class | 38.07% | Approximately 0.00 |

- First Class has the highest late-delivery risk.
- Second Class has the highest average shipping delay.
- Standard Class has the lowest late-delivery risk among the four shipping modes.
- Overall, 54.83% of order items are marked as late delivery.

### Additional Analysis

- Product-category sales contribution.
- Customer-segment sales contribution.
- Top 10 customers by sales.
- Monthly and annual sales trends.
- Regional late-delivery performance.
- Delivery-status distribution.

## Power BI Dashboard

The Power BI report contains three analytical pages:

### 1. Executive Overview
- Total Sales
- Total Orders
- Total Customers
- Late Delivery Percentage
- Annual Sales Trend
- Top 10 Product Categories by Sales
- Shipping Mode Performance

### 2. Delivery & Logistics
- Delivery Status Distribution
- Late Delivery Rate by Order Region
- Delivery Status Breakdown by Shipping Mode
- Late Delivery Risk by Shipping Mode
- Average Shipping Delay by Shipping Mode

### 3. Product & Customer Insights
- Sales Contribution by Product Category
- Sales Contribution by Customer Segment
- Monthly Sales Trend
- Product Category Ranking Over Time
- Top 10 Customers by Sales

**Dashboard file:** `SupplyChainIQ_Dashboard.pbix`

## Business Recommendations

The analysis supports several operational recommendations:

- Investigate the exceptionally high late-delivery risk associated with First Class shipping.
- Review warehouse processing and carrier handoffs for Second Class shipping.
- Monitor delivery performance across high-risk regions.
- Use monthly sales trends and category contribution to support inventory planning.
- Monitor fulfillment reliability for high-value customers.

Detailed recommendations are available in [`reports/BUSINESS_RECOMMENDATIONS.md`](reports/BUSINESS_RECOMMENDATIONS.md).

## Repository Structure

```text
SupplyChainIQ/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── notebooks/
│   ├── 01_Data_Audit_and_Profiling.ipynb
│   └── 02_EDA_and_Business_Insights.ipynb
│
├── sql/
│   └── 01_business_analysis.sql
│
├── scripts/
│   ├── inspect_dataset.py
│   ├── import_to_postgres.py
│   ├── run_sql.py
│   ├── test_db_connection.py
│   └── verify_database.py
│
├── excel/
│   └── SupplyChainIQ_Analysis.xlsx
│
├── reports/
│   └── BUSINESS_RECOMMENDATIONS.md
│
├── SupplyChainIQ_Dashboard.pbix
├── README.md
└── .gitignore
```

## How to Run

### 1. Clone the repository

```bash
git clone https://github.com/GayatriChaudhari791/SupplyChainIQ.git
cd SupplyChainIQ
```

### 2. Create and activate a virtual environment

```bash
python -m venv .venv
```

Windows PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
```

### 3. Install dependencies

```bash
pip install pandas numpy matplotlib seaborn jupyter openpyxl sqlalchemy psycopg2-binary
```

### 4. Prepare the dataset

Download the DataCo Smart Supply Chain dataset from Kaggle and place the source CSV in the appropriate raw-data directory.

Run the data inspection and cleaning notebooks in the `notebooks/` directory.

### 5. PostgreSQL analysis

Configure your local PostgreSQL connection, import the cleaned dataset, and execute the SQL analysis scripts in the `sql/` directory.

### 6. Explore the dashboard

Open `SupplyChainIQ_Dashboard.pbix` using Microsoft Power BI Desktop.

*Note: The raw dataset and local database credentials are not included in the repository. Configure your own local data paths and database connection.*

## Limitations

- The dataset represents historical operations from 2015 to January 2018.
- The analysis describes historical patterns and does not establish current supply chain performance.
- Late-delivery risk is an existing dataset indicator, not a predictive model developed in this project.
- Demand forecasting, stockout prediction, and automated optimization are not implemented in the current version.

## Future Enhancements

- Develop demand forecasting models.
- Build predictive models for stockout and delivery risks.
- Explore inventory optimization techniques.
- Develop an API for serving analytical results.
- Explore Generative AI for natural-language supply chain insights.

## Project Status

**Core analytics and dashboard development completed.**

Python EDA, PostgreSQL business analysis, Excel analysis, Power BI reporting, and business recommendations are included in the current project.

---

**Author:** Gayatri Chaudhari

**GitHub Repository:** [SupplyChainIQ](https://github.com/GayatriChaudhari791/SupplyChainIQ)