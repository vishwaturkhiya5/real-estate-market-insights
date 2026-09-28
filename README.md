# Real Estate Price Trend Analysis & Market Insights

A portfolio-ready **SQL and Excel analytics project** analyzing monthly U.S. city-level housing-market data. The project focuses on price trends, sales activity, inventory, market supply, days on market, geographic performance, and property-type trends.

It includes a reproducible **SQLite analysis workflow, validated KPIs, Excel dashboard, and supporting documentation**.

---

## Project Overview

The complete dataset contains **1,048,575 rows and 58 columns**, covering monthly housing-market data from **January 2012 to May 2026**.

To maintain consistency with the original project period, the published analysis uses records through **31 October 2025**, resulting in **1,006,204 records**.

The analysis covers:

* Price and sales trends
* Inventory and months of supply
* Days on market
* Sale-to-list ratios
* State and city comparisons
* Property-type analysis
* Monthly and yearly trends
* Long-term and YoY growth

---

## Business Problem

Housing-market data can produce misleading results when city names repeat across states, market coverage changes over time, or overlapping property categories are added together.

This project creates a consistent analytical framework to measure **price direction, sales activity, inventory, supply, and market competitiveness** without double-counting or treating a city-weighted price as an official national median.

---

## Dataset

| Attribute              | Details                      |
| ---------------------- | ---------------------------- |
| Raw Records            | 1,048,575                    |
| Columns                | 58                           |
| Date Range             | Jan 2012 – May 2026          |
| Project Cutoff         | Oct 31, 2025                 |
| Records Through Cutoff | 1,006,204                    |
| City Names             | 15,860                       |
| City-State Markets     | 22,418                       |
| Geography              | 50 States + Washington, D.C. |

Property categories include:

* All Residential
* Single Family Residential
* Condo/Co-op
* Townhouse
* Multi-Family (2–4 Unit)

The stable analytical key is:

```text
TABLE_ID + PERIOD_BEGIN + PROPERTY_TYPE + IS_SEASONALLY_ADJUSTED
```

---

## Data Cleaning & Quality

The project includes a reproducible SQLite data-cleaning workflow.

Key checks include:

* Date and numeric field standardization
* Missing-value handling
* Duplicate-row validation
* Analytical-key validation
* Price quality checks
* Sale-to-list ratio validation
* Project-period filtering

Prices outside **$10,000–$5,000,000** and sale-to-list ratios outside **0.50–1.50** are flagged rather than automatically deleted.

For additive KPIs such as homes sold and inventory, **All Residential** is used to avoid double-counting property subtypes.

City rankings require a minimum of **20 current-month sales**.

---

## Key KPIs

| KPI              | Definition                               |
| ---------------- | ---------------------------------------- |
| Total Records    | Records through Oct 31, 2025             |
| Total Homes Sold | All Residential homes sold               |
| Weighted Price   | City median price weighted by homes sold |
| Long-Term Growth | Oct 2025 vs Jan 2012 common-market price |
| YoY Growth       | Oct 2025 vs Oct 2024                     |
| Median DOM       | Homes-sold-weighted median DOM           |
| Months of Supply | Inventory-weighted months of supply      |
| Sale-to-List     | Homes-sold-weighted valid ratio          |

The weighted price is an **analytical measure of city-level medians** and should not be interpreted as the official U.S. national median.

---

## Key Findings

* Common-market weighted price increased **168.83%** from January 2012 to October 2025.
* October 2025 price growth was **4.51% YoY**.
* Homes sold decreased **13.44% YoY**.
* Inventory decreased **11.71% YoY**.
* Months of supply increased **26.40% to 5.97 months**.
* Weighted median DOM increased **6.15% to 52.52 days**.
* California, Florida and Texas accounted for **29.10% of project-period sales**.
* Newport Beach, CA had the highest eligible October median at **$3.849M**.
* Johnstown, PA had the lowest eligible October median at **$58,500**.

---

## Excel Dashboard

The Excel dashboard contains:

* 10 KPI cards
* 12 charts
* State Analysis
* City Analysis
* Property Type Analysis
* Monthly Trends
* Pivot Analysis
* Data Dictionary
* Instructions

The dashboard uses a **navy, teal, white and light-grey** professional theme.

Power Query, PivotTables and the Excel Data Model can be used as the recommended refresh workflow for the full local dataset.

---

## SQL Analysis

SQLite is used for reproducible analysis and KPI validation.

The project demonstrates:

* `GROUP BY`
* `HAVING`
* `CASE WHEN`
* CTEs
* Subqueries
* `JOIN`
* Aggregations
* Date functions
* `LAG()`
* `RANK()`
* `DENSE_RANK()`
* Window functions
* 3- and 12-month moving averages
* YoY analysis

---

## Project Structure

```text
real-estate-market-insights/
│
├── README.md
├── data/
│   └── README.md
├── sql/
│   ├── create_database.sql
│   ├── data_cleaning.sql
│   ├── analysis_queries.sql
│   └── dashboard_views.sql
├── excel_dashboard/
│   └── Real_Estate_Market_Insights_Dashboard.xlsx
├── images/
│   └── dashboard_preview.png
├── documentation/
│   ├── data_dictionary.md
│   ├── data_profile.md
│   ├── insights.md
└── .gitignore
```

---

## Tech Stack

| Technology      | Purpose                          |
| --------------- | -------------------------------- |
| SQLite          | Data analysis and KPI validation |
| SQL             | Business analytics               |
| Microsoft Excel | Dashboard and visualization      |
| Power Query     | Data refresh                     |
| PivotTables     | Analytical summaries             |
| VS Code         | Project development              |
| Git             | Version control                  |
| GitHub          | Project hosting                  |

---

## Reproduce the Analysis

### Prerequisites

* SQLite
* Microsoft Excel
* VS Code

### Run SQL

```bash
sqlite3 real_estate_market.db
```

Then execute:

```sql
.read sql/create_database.sql
.read sql/data_cleaning.sql
.read sql/analysis_queries.sql
.read sql/dashboard_views.sql
```

Open the Excel dashboard:

```text
excel_dashboard/Real_Estate_Market_Insights_Dashboard.xlsx
```

---

## Key Takeaway

The project demonstrates how large-scale housing-market data can be transformed into reliable business insights through:

```text
Data Cleaning → SQL Analysis → KPI Validation → Business Insights → Excel Dashboard
```

It demonstrates practical skills in **SQL, SQLite, data cleaning, KPI development, time-series analysis, business analytics, and Excel dashboard development**.
