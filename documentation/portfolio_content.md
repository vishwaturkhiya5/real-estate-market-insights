# Portfolio content

## ATS-friendly resume bullets

- Analyzed 1.01M real-estate market records across 22,418 U.S. city-state markets covering all 50 states and Washington, D.C. using SQLite, with date, duplicate, missing-value and property-type overlap controls.
- Built an Excel market-insights dashboard tracking 7.11M All Residential home sales through October 2025 and measured 168.8% long-term price growth across 256 common markets, alongside 4.51% YoY growth in the October 2025 weighted price measure.

## GitHub repository description

SQLite and Excel analysis of 1M+ U.S. city-level housing records, with verified price, sales, inventory and market-competition insights through October 2025.

## LinkedIn project description

I completed a real-estate market analytics project using SQLite and Microsoft Excel. I worked with 1,048,575 monthly records covering 22,459 city-state markets in the complete source file and filtered the dashboard to data available through October 2025.

The main challenge was avoiding misleading totals. Property-type rows overlap, so I used only All Residential rows for total home sales. I also separated unique city names from unique city-state markets and used a fixed panel of 256 markets for the long-term price comparison.

The final dashboard tracks sales, weighted city-level price measures, YoY growth, inventory, months of supply, days on market, sale-to-list performance and market rankings. The verified project-period results include 7.11M homes sold, 168.8% long-term growth in the fixed market panel and 4.51% YoY price growth in October 2025.

## Interview questions and natural answers

### 1. Why did you use All Residential for total homes sold?

The file also contains single-family, condo, townhouse and multifamily rows. Those are components of All Residential, so adding every property type would count many sales twice. I filtered to All Residential whenever I calculated an additive total.

### 2. How did you calculate long-term price growth?

I first selected markets available in both January 2012 and October 2025. For each endpoint, I calculated `SUM(city median price × homes sold) / SUM(homes sold)`. The measure increased from about $204,668 to $550,217, which is 168.83%. I describe it as a weighted average of city-level medians, not a national median.

### 3. Why are there fewer unique cities than markets?

`CITY` contains only the city name, so cities with the same name in different states collapse together. `REGION` includes city and state, giving 22,418 markets through the cutoff compared with 15,860 unique city names in the full file.

### 4. How did you handle outliers and small markets?

I kept genuine values in the cleaned data and added flags for suspicious prices and ratios. For city rankings, I required at least 20 sales in the current month. That improves stability without hiding the underlying records.

### 5. Why did you reject the original 2.16% YoY figure?

I rebuilt the October comparison from the weighted monthly series. October 2025 was $512,102 and October 2024 was $490,014, which gives 4.51%. Since 2.16% did not match a documented comparable period, I did not use it.

## One-minute interview explanation

This project analyzes more than one million monthly U.S. city-level housing records using SQLite and Excel. I first profiled the complete dataset, converted the source dates and numeric fields, checked missing values and duplicates, and documented the monthly city-property grain. The most important data issue was property-type overlap, so I used All Residential rows for sales and inventory totals. I filtered the published analysis through October 2025, which produced 1.01 million records across 22,418 city-state markets and 7.11 million homes sold. For price trends, I used a homes-sold-weighted average of city median prices and clearly avoided calling it the official national median. A fixed panel of 256 markets increased 168.8% from January 2012 to October 2025, and the October 2025 weighted price was 4.51% higher year over year. I presented the results in a one-screen Excel dashboard with price, activity, inventory and competitiveness views.

## Calculation explanation for the two headline figures

**168.83% growth**

- Population: All Residential rows in 256 markets present at both endpoints.
- January 2012 weighted price: $204,668.22.
- October 2025 weighted price: $550,216.85.
- Formula: `($550,216.85 / $204,668.22) - 1 = 168.83%`.

**Homes sold**

- Full source through May 2026: `SUM(HOMES_SOLD)` on All Residential rows = 7,361,964.
- Project cutoff through October 2025: the same formula = 7,113,013.
- The resume uses 7.11M because the project period ends in October 2025.

