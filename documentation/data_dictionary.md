# Data Dictionary

The raw SQLite landing table stores every field as text. `data_cleaning.sql` converts them to the analytical types below while preserving blanks as `NULL`.

| Column | Type | Meaning |
|---|---|---|
| PERIOD_BEGIN | Date | First day of monthly period |
| PERIOD_END | Date | Last day of monthly period |
| PERIOD_DURATION | Integer | Source-provided duration of the monthly period |
| REGION_TYPE | Text | Geographic level; `place` throughout |
| REGION_TYPE_ID | Integer | Source geography-type ID |
| TABLE_ID | Integer | Stable source market identifier |
| IS_SEASONALLY_ADJUSTED | Boolean | Seasonal-adjustment flag; false throughout |
| REGION | Text | City-state market label |
| CITY | Text | City name; not unique across states |
| STATE | Text | State name |
| STATE_CODE | Text | Two-letter code; includes DC |
| PROPERTY_TYPE | Text | All Residential or one of four overlapping subtypes |
| PROPERTY_TYPE_ID | Integer | Source property-type ID |
| MEDIAN_SALE_PRICE | Real | City-level median sale price |
| MEDIAN_SALE_PRICE_MOM | Real | Decimal month-over-month price change |
| MEDIAN_SALE_PRICE_YOY | Real | Decimal year-over-year price change |
| MEDIAN_LIST_PRICE | Real | City-level median list price |
| MEDIAN_LIST_PRICE_MOM | Real | Decimal MoM list-price change |
| MEDIAN_LIST_PRICE_YOY | Real | Decimal YoY list-price change |
| MEDIAN_PPSF | Real | Median sale price per square foot |
| MEDIAN_PPSF_MOM | Real | Decimal MoM PPSF change |
| MEDIAN_PPSF_YOY | Real | Decimal YoY PPSF change |
| MEDIAN_LIST_PPSF | Real | Median list price per square foot |
| MEDIAN_LIST_PPSF_MOM | Real | Decimal MoM list-PPSF change |
| MEDIAN_LIST_PPSF_YOY | Real | Decimal YoY list-PPSF change |
| HOMES_SOLD | Integer | Homes sold during the period |
| HOMES_SOLD_MOM | Real | Decimal MoM sales change |
| HOMES_SOLD_YOY | Real | Decimal YoY sales change |
| PENDING_SALES | Integer | Pending sales during the period |
| PENDING_SALES_MOM | Real | Decimal MoM pending-sales change |
| PENDING_SALES_YOY | Real | Decimal YoY pending-sales change |
| NEW_LISTINGS | Integer | New listings during the period |
| NEW_LISTINGS_MOM | Real | Decimal MoM new-listings change |
| NEW_LISTINGS_YOY | Real | Decimal YoY new-listings change |
| INVENTORY | Integer | Active inventory |
| INVENTORY_MOM | Real | Decimal MoM inventory change |
| INVENTORY_YOY | Real | Decimal YoY inventory change |
| MONTHS_OF_SUPPLY | Real | Months of housing supply |
| MONTHS_OF_SUPPLY_MOM | Real | Absolute or source-provided MoM supply change |
| MONTHS_OF_SUPPLY_YOY | Real | Absolute or source-provided YoY supply change |
| MEDIAN_DOM | Real | Median days on market |
| MEDIAN_DOM_MOM | Real | Source-provided MoM DOM change |
| MEDIAN_DOM_YOY | Real | Source-provided YoY DOM change |
| AVG_SALE_TO_LIST | Real | Average sale-to-list ratio |
| AVG_SALE_TO_LIST_MOM | Real | Decimal MoM ratio change |
| AVG_SALE_TO_LIST_YOY | Real | Decimal YoY ratio change |
| SOLD_ABOVE_LIST | Real | Share sold above list price |
| SOLD_ABOVE_LIST_MOM | Real | Decimal MoM change |
| SOLD_ABOVE_LIST_YOY | Real | Decimal YoY change |
| PRICE_DROPS | Real | Share of active listings with price drops |
| PRICE_DROPS_MOM | Real | Decimal MoM change |
| PRICE_DROPS_YOY | Real | Decimal YoY change |
| OFF_MARKET_IN_TWO_WEEKS | Real | Share going off market within two weeks |
| OFF_MARKET_IN_TWO_WEEKS_MOM | Real | Decimal MoM change |
| OFF_MARKET_IN_TWO_WEEKS_YOY | Real | Decimal YoY change |
| PARENT_METRO_REGION | Text | Parent metro label |
| PARENT_METRO_REGION_METRO_CODE | Integer | Parent metro code |
| LAST_UPDATED | Text/Timestamp | Source extract or update timestamp |

## KPI Formulas

- Weighted city-level sale price: `SUM(MEDIAN_SALE_PRICE × HOMES_SOLD) / SUM(HOMES_SOLD)`.
- Weighted days on market and sale-to-list ratio: use `HOMES_SOLD` as the weight.
- Weighted months of supply and price drops: use `INVENTORY` as the weight.
- YoY price growth: `(current comparable-period weighted price / prior-year comparable-period weighted price) - 1`, using the same geography and property-type population in both periods.
- Total homes sold: `SUM(HOMES_SOLD)` after filtering to `All Residential`.
