# Dataset inspection and claim validation

## Complete-file profile

| Check | Verified result |
|---|---:|
| Rows | 1,048,575 |
| Columns | 58 |
| Date range | 1 Jan 2012–31 May 2026 |
| Analysis cutoff | 31 Oct 2025 |
| Records through cutoff | 1,006,204 |
| Unique `CITY` values | 15,860 |
| Unique city-state `REGION` values through cutoff | 22,418 |
| Unique city-state `REGION` values in full file | 22,459 |
| State codes | 51: all 50 states plus D.C. |
| Exact duplicate rows | 0 |
| Duplicate analytical keys | 0 using `TABLE_ID + PERIOD_BEGIN + PROPERTY_TYPE + seasonal flag` |

All rows are monthly (`PERIOD_DURATION = 30`), `REGION_TYPE = place`, and not seasonally adjusted. The source contains five property types: All Residential, Single Family Residential, Condo/Co-op, Townhouse, and Multi-Family (2–4 Unit).

## Dataset grain

One row represents one monthly city/place market, property type and seasonal-adjustment status. `TABLE_ID` is the stable market identifier. `REGION` is the city-state label, while `CITY` alone is not unique because the same city name can occur in several states.

The correct analytical key is:

`TABLE_ID + PERIOD_BEGIN + PROPERTY_TYPE + IS_SEASONALLY_ADJUSTED`

Grouping only by region text creates 1,625 apparent extra rows even though the complete file has no exact duplicate records. This is why the cleaning script uses `TABLE_ID` in its duplicate check.

## Missing values

The identity fields, dates, geography, property type and IDs are complete. Important metric null counts are:

| Field | Missing | Field | Missing |
|---|---:|---|---:|
| MEDIAN_SALE_PRICE | 1,215 | HOMES_SOLD | 1,141 |
| MEDIAN_SALE_PRICE_MOM | 200,461 | MEDIAN_SALE_PRICE_YOY | 217,788 |
| MEDIAN_LIST_PRICE | 174,152 | MEDIAN_LIST_PRICE_YOY | 333,287 |
| MEDIAN_PPSF | 13,891 | MEDIAN_LIST_PPSF | 178,102 |
| PENDING_SALES | 114,361 | NEW_LISTINGS | 177,846 |
| INVENTORY | 84,053 | MONTHS_OF_SUPPLY | 70,209 |
| MEDIAN_DOM | 11,117 | AVG_SALE_TO_LIST | 36,394 |
| SOLD_ABOVE_LIST | 6,892 | PRICE_DROPS | 473,479 |
| OFF_MARKET_IN_TWO_WEEKS | 92,309 | PRICE_DROPS_YOY | 613,651 |

Blank percentage fields are retained as `NULL`; they are not converted to zero. MoM and YoY nulls are expected when a market lacks a comparable earlier period.

## Numerical quality checks

- No non-numeric text values were identified in the numeric columns.
- Sale prices range from $1 to $65,000,000. There are 2,029 records below $10,000 and 978 above $5,000,000.
- There are 408 sale-to-list ratios outside the practical 0.50–1.50 range.
- Genuine outliers remain in the cleaned table. `data_quality_flags` marks them for review.
- Market rankings require at least 20 homes sold in October 2025 to reduce small-sample volatility.



