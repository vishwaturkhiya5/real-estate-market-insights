-- Real Estate Price Trend Analysis & Market Insights
-- SQLite setup file. Run this file before importing the CSV.

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS real_estate_raw;

-- The raw landing table intentionally stores every CSV field as TEXT.
-- Typed conversion is performed in data_cleaning.sql so malformed values can
-- be identified instead of being silently changed during import.
CREATE TABLE real_estate_raw (
    PERIOD_BEGIN TEXT,
    PERIOD_END TEXT,
    PERIOD_DURATION TEXT,
    REGION_TYPE TEXT,
    REGION_TYPE_ID TEXT,
    TABLE_ID TEXT,
    IS_SEASONALLY_ADJUSTED TEXT,
    REGION TEXT,
    CITY TEXT,
    STATE TEXT,
    STATE_CODE TEXT,
    PROPERTY_TYPE TEXT,
    PROPERTY_TYPE_ID TEXT,
    MEDIAN_SALE_PRICE TEXT,
    MEDIAN_SALE_PRICE_MOM TEXT,
    MEDIAN_SALE_PRICE_YOY TEXT,
    MEDIAN_LIST_PRICE TEXT,
    MEDIAN_LIST_PRICE_MOM TEXT,
    MEDIAN_LIST_PRICE_YOY TEXT,
    MEDIAN_PPSF TEXT,
    MEDIAN_PPSF_MOM TEXT,
    MEDIAN_PPSF_YOY TEXT,
    MEDIAN_LIST_PPSF TEXT,
    MEDIAN_LIST_PPSF_MOM TEXT,
    MEDIAN_LIST_PPSF_YOY TEXT,
    HOMES_SOLD TEXT,
    HOMES_SOLD_MOM TEXT,
    HOMES_SOLD_YOY TEXT,
    PENDING_SALES TEXT,
    PENDING_SALES_MOM TEXT,
    PENDING_SALES_YOY TEXT,
    NEW_LISTINGS TEXT,
    NEW_LISTINGS_MOM TEXT,
    NEW_LISTINGS_YOY TEXT,
    INVENTORY TEXT,
    INVENTORY_MOM TEXT,
    INVENTORY_YOY TEXT,
    MONTHS_OF_SUPPLY TEXT,
    MONTHS_OF_SUPPLY_MOM TEXT,
    MONTHS_OF_SUPPLY_YOY TEXT,
    MEDIAN_DOM TEXT,
    MEDIAN_DOM_MOM TEXT,
    MEDIAN_DOM_YOY TEXT,
    AVG_SALE_TO_LIST TEXT,
    AVG_SALE_TO_LIST_MOM TEXT,
    AVG_SALE_TO_LIST_YOY TEXT,
    SOLD_ABOVE_LIST TEXT,
    SOLD_ABOVE_LIST_MOM TEXT,
    SOLD_ABOVE_LIST_YOY TEXT,
    PRICE_DROPS TEXT,
    PRICE_DROPS_MOM TEXT,
    PRICE_DROPS_YOY TEXT,
    OFF_MARKET_IN_TWO_WEEKS TEXT,
    OFF_MARKET_IN_TWO_WEEKS_MOM TEXT,
    OFF_MARKET_IN_TWO_WEEKS_YOY TEXT,
    PARENT_METRO_REGION TEXT,
    PARENT_METRO_REGION_METRO_CODE TEXT,
    LAST_UPDATED TEXT
);

-- CSV import is a SQLite shell command, not SQL. After running this file,
-- open sqlite3 from the project root and execute these commands:
--   .mode csv
--   .import --skip 1 "data/City_tracker(2).csv" real_estate_raw
--   SELECT COUNT(*) FROM real_estate_raw;
-- Expected full-file row count: 1,048,575.

