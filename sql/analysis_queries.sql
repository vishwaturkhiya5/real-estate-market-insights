-- Analysis scope: all periods ending on or before 2025-10-31.
-- Unless a query explicitly compares property types, All Residential is used
-- for additive housing-market KPIs to prevent property-type double counting.

-- 1. Dataset profile and coverage.
SELECT COUNT(*) AS total_source_records FROM real_estate_raw;
SELECT COUNT(*) AS analysis_records FROM real_estate_clean WHERE PERIOD_END <= '2025-10-31';
SELECT MIN(PERIOD_BEGIN) AS first_period, MAX(PERIOD_END) AS last_period FROM real_estate_clean;
SELECT COUNT(DISTINCT CITY) AS unique_city_names FROM real_estate_clean;
SELECT COUNT(DISTINCT REGION) AS unique_city_state_markets FROM real_estate_clean WHERE PERIOD_END <= '2025-10-31';
SELECT COUNT(DISTINCT STATE_CODE) AS states_and_dc FROM real_estate_clean;
SELECT PROPERTY_TYPE, COUNT(*) AS records FROM real_estate_clean GROUP BY PROPERTY_TYPE ORDER BY records DESC;

-- 2. Missing values and exact business-key duplicates.
SELECT
 SUM(PERIOD_BEGIN IS NULL) AS missing_period,
 SUM(REGION IS NULL) AS missing_region,
 SUM(MEDIAN_SALE_PRICE IS NULL) AS missing_sale_price,
 SUM(HOMES_SOLD IS NULL) AS missing_homes_sold,
 SUM(INVENTORY IS NULL) AS missing_inventory,
 SUM(PRICE_DROPS IS NULL) AS missing_price_drops
FROM real_estate_clean;

SELECT PERIOD_BEGIN, TABLE_ID, PROPERTY_TYPE, IS_SEASONALLY_ADJUSTED, COUNT(*) AS duplicate_count
FROM real_estate_clean
GROUP BY PERIOD_BEGIN, TABLE_ID, PROPERTY_TYPE, IS_SEASONALLY_ADJUSTED
HAVING COUNT(*) > 1;

-- 3. Total homes sold. Do not sum property-type rows together.
SELECT SUM(HOMES_SOLD) AS total_homes_sold
FROM real_estate_clean
WHERE PROPERTY_TYPE = 'All Residential' AND PERIOD_END <= '2025-10-31';

-- 4. Monthly price and activity trend. The price is a homes-sold-weighted
-- average of city-level median prices, not the official U.S. national median.
WITH monthly AS (
 SELECT PERIOD_BEGIN,
        SUM(MEDIAN_SALE_PRICE * HOMES_SOLD) / NULLIF(SUM(HOMES_SOLD),0) AS weighted_city_median_price,
        SUM(HOMES_SOLD) AS homes_sold
 FROM real_estate_clean
 WHERE PROPERTY_TYPE='All Residential' AND PERIOD_END<='2025-10-31'
   AND MEDIAN_SALE_PRICE IS NOT NULL AND HOMES_SOLD>0
 GROUP BY PERIOD_BEGIN
)
SELECT *,
       weighted_city_median_price / NULLIF(LAG(weighted_city_median_price,1) OVER(ORDER BY PERIOD_BEGIN),0) - 1 AS price_mom,
       weighted_city_median_price / NULLIF(LAG(weighted_city_median_price,12) OVER(ORDER BY PERIOD_BEGIN),0) - 1 AS price_yoy
FROM monthly ORDER BY PERIOD_BEGIN;

-- 5. Homes sold by state and city.
SELECT STATE_CODE, SUM(HOMES_SOLD) AS homes_sold,
       RANK() OVER(ORDER BY SUM(HOMES_SOLD) DESC) AS sales_rank
FROM real_estate_clean
WHERE PROPERTY_TYPE='All Residential' AND PERIOD_END<='2025-10-31'
GROUP BY STATE_CODE ORDER BY sales_rank;

SELECT REGION, STATE_CODE, SUM(HOMES_SOLD) AS homes_sold,
       DENSE_RANK() OVER(PARTITION BY STATE_CODE ORDER BY SUM(HOMES_SOLD) DESC) AS rank_in_state
FROM real_estate_clean
WHERE PROPERTY_TYPE='All Residential' AND PERIOD_END<='2025-10-31'
GROUP BY REGION, STATE_CODE ORDER BY STATE_CODE, rank_in_state;

-- 6. Inventory, months of supply, days on market, sale-to-list, above-list,
-- and price-drop trends. Each rate uses a relevant exposure weight.
SELECT PERIOD_BEGIN,
       SUM(INVENTORY) AS inventory,
       SUM(MONTHS_OF_SUPPLY*INVENTORY)/NULLIF(SUM(INVENTORY),0) AS weighted_months_of_supply,
       SUM(MEDIAN_DOM*HOMES_SOLD)/NULLIF(SUM(HOMES_SOLD),0) AS weighted_median_dom,
       SUM(CASE WHEN AVG_SALE_TO_LIST BETWEEN 0.5 AND 1.5 THEN AVG_SALE_TO_LIST*HOMES_SOLD END)
          /NULLIF(SUM(CASE WHEN AVG_SALE_TO_LIST BETWEEN 0.5 AND 1.5 THEN HOMES_SOLD END),0) AS weighted_sale_to_list,
       SUM(SOLD_ABOVE_LIST*HOMES_SOLD)/NULLIF(SUM(HOMES_SOLD),0) AS weighted_sold_above_list,
       SUM(PRICE_DROPS*INVENTORY)/NULLIF(SUM(INVENTORY),0) AS weighted_price_drops
FROM real_estate_clean
WHERE PROPERTY_TYPE='All Residential' AND PERIOD_END<='2025-10-31'
GROUP BY PERIOD_BEGIN ORDER BY PERIOD_BEGIN;

-- 7. Highest and lowest priced current markets. A 20-sale minimum reduces
-- unstable rankings without deleting the underlying small-market records.
WITH eligible AS (
 SELECT REGION, CITY, STATE_CODE, MEDIAN_SALE_PRICE, HOMES_SOLD
 FROM real_estate_clean
 WHERE PROPERTY_TYPE='All Residential' AND PERIOD_BEGIN='2025-10-01'
   AND MEDIAN_SALE_PRICE IS NOT NULL AND HOMES_SOLD>=20
)
SELECT *, RANK() OVER(ORDER BY MEDIAN_SALE_PRICE DESC) AS high_price_rank,
          RANK() OVER(ORDER BY MEDIAN_SALE_PRICE ASC) AS affordability_rank
FROM eligible ORDER BY high_price_rank LIMIT 20;

-- 8. Fastest-growing current markets with a minimum sales safeguard.
SELECT REGION, STATE_CODE, MEDIAN_SALE_PRICE, MEDIAN_SALE_PRICE_YOY, HOMES_SOLD,
       DENSE_RANK() OVER(ORDER BY MEDIAN_SALE_PRICE_YOY DESC) AS growth_rank
FROM real_estate_clean
WHERE PROPERTY_TYPE='All Residential' AND PERIOD_BEGIN='2025-10-01'
  AND MEDIAN_SALE_PRICE_YOY IS NOT NULL AND HOMES_SOLD>=20
ORDER BY growth_rank LIMIT 20;

-- 9. State price and growth rankings at the current period.
WITH state_current AS (
 SELECT STATE_CODE, SUM(HOMES_SOLD) AS homes_sold,
        SUM(MEDIAN_SALE_PRICE*HOMES_SOLD)/NULLIF(SUM(HOMES_SOLD),0) AS weighted_price
 FROM real_estate_clean
 WHERE PROPERTY_TYPE='All Residential' AND PERIOD_BEGIN='2025-10-01' AND HOMES_SOLD>0
 GROUP BY STATE_CODE
), state_prior AS (
 SELECT STATE_CODE,
        SUM(MEDIAN_SALE_PRICE*HOMES_SOLD)/NULLIF(SUM(HOMES_SOLD),0) AS weighted_price
 FROM real_estate_clean
 WHERE PROPERTY_TYPE='All Residential' AND PERIOD_BEGIN='2024-10-01' AND HOMES_SOLD>0
 GROUP BY STATE_CODE
)
SELECT c.STATE_CODE,c.homes_sold,c.weighted_price,
       c.weighted_price/NULLIF(p.weighted_price,0)-1 AS price_yoy,
       RANK() OVER(ORDER BY c.weighted_price DESC) AS price_rank
FROM state_current c JOIN state_prior p USING(STATE_CODE)
WHERE c.homes_sold>=100 ORDER BY price_rank;

-- 10. Rolling 3-month and 12-month price averages plus comparable YoY.
WITH monthly AS (
 SELECT PERIOD_BEGIN,
        SUM(MEDIAN_SALE_PRICE*HOMES_SOLD)/NULLIF(SUM(HOMES_SOLD),0) AS weighted_price
 FROM real_estate_clean
 WHERE PROPERTY_TYPE='All Residential' AND PERIOD_END<='2025-10-31' AND HOMES_SOLD>0
 GROUP BY PERIOD_BEGIN
), rolling AS (
 SELECT *,
   AVG(weighted_price) OVER(ORDER BY PERIOD_BEGIN ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_3m,
   AVG(weighted_price) OVER(ORDER BY PERIOD_BEGIN ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS rolling_12m,
   LAG(weighted_price,12) OVER(ORDER BY PERIOD_BEGIN) AS prior_year_price
 FROM monthly
)
SELECT *, weighted_price/NULLIF(prior_year_price,0)-1 AS price_yoy FROM rolling ORDER BY PERIOD_BEGIN;

-- 11. Long-term common-market growth. Requiring the same TABLE_ID in both
-- endpoints controls changing city coverage. Only 256 markets meet this exact
-- endpoint test. Formula: SUM(city median price * homes sold) / SUM(homes sold).
WITH common_markets AS (
 SELECT TABLE_ID
 FROM real_estate_clean
 WHERE PROPERTY_TYPE='All Residential' AND PERIOD_BEGIN IN ('2012-01-01','2025-10-01')
 GROUP BY TABLE_ID HAVING COUNT(DISTINCT PERIOD_BEGIN)=2
), endpoint AS (
 SELECT PERIOD_BEGIN,
        SUM(MEDIAN_SALE_PRICE*HOMES_SOLD)/SUM(HOMES_SOLD) AS weighted_price,
        COUNT(*) AS market_count
 FROM real_estate_clean JOIN common_markets USING(TABLE_ID)
 WHERE PROPERTY_TYPE='All Residential' AND PERIOD_BEGIN IN ('2012-01-01','2025-10-01') AND HOMES_SOLD>0
 GROUP BY PERIOD_BEGIN
)
SELECT MAX(CASE WHEN PERIOD_BEGIN='2012-01-01' THEN weighted_price END) AS start_price,
       MAX(CASE WHEN PERIOD_BEGIN='2025-10-01' THEN weighted_price END) AS end_price,
       MAX(CASE WHEN PERIOD_BEGIN='2025-10-01' THEN weighted_price END)
       /NULLIF(MAX(CASE WHEN PERIOD_BEGIN='2012-01-01' THEN weighted_price END),0)-1 AS long_term_growth,
       MIN(market_count) AS common_markets
FROM endpoint;

-- 12. Market activity and affordability segmentation.
WITH current_market AS (
 SELECT REGION,STATE_CODE,MEDIAN_SALE_PRICE,HOMES_SOLD,INVENTORY,MONTHS_OF_SUPPLY,MEDIAN_DOM,AVG_SALE_TO_LIST
 FROM real_estate_clean
 WHERE PROPERTY_TYPE='All Residential' AND PERIOD_BEGIN='2025-10-01' AND HOMES_SOLD>=20
)
SELECT *,
 CASE WHEN MEDIAN_SALE_PRICE<250000 THEN 'More affordable'
      WHEN MEDIAN_SALE_PRICE<500000 THEN 'Mid-priced'
      WHEN MEDIAN_SALE_PRICE<1000000 THEN 'High-priced'
      ELSE 'Luxury' END AS affordability_segment,
 CASE WHEN MONTHS_OF_SUPPLY<3 AND AVG_SALE_TO_LIST>=1 THEN 'Highly competitive'
      WHEN MONTHS_OF_SUPPLY<5 THEN 'Competitive / balanced'
      ELSE 'Buyer-friendly inventory' END AS activity_segment
FROM current_market ORDER BY MEDIAN_SALE_PRICE DESC;

-- 13. Property-type comparison. These categories overlap All Residential,
-- so their homes-sold values must never be added to the All Residential total.
SELECT PROPERTY_TYPE,SUM(HOMES_SOLD) AS homes_sold,
       SUM(MEDIAN_SALE_PRICE*HOMES_SOLD)/NULLIF(SUM(HOMES_SOLD),0) AS weighted_city_median_price
FROM real_estate_clean WHERE PERIOD_END<='2025-10-31' AND HOMES_SOLD>0
GROUP BY PROPERTY_TYPE ORDER BY homes_sold DESC;

