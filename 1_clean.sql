-- =====================================================
-- 01. Data Cleaning & Standardization
-- =====================================================
-- Objective:
-- Prepare a clean, human-readable base table for downstream
-- funnel, product, and geographic analysis.
--
-- Key goals:
-- 1. Normalize date fields into a single event_date
-- 2. Rename columns for clarity and consistency
-- 3. Decode categorical ID fields into descriptive values
-- 4. Create a stable base table for all future analysis
-- =====================================================


-- -----------------------------------------------------
-- Step 1: Inspect raw dataset
-- -----------------------------------------------------
-- Initial review to understand column structure, data types,
-- and potential cleaning requirements.

SELECT *
FROM e_shop_clothing;


-- -----------------------------------------------------
-- Step 2: Create cleaned base table
-- -----------------------------------------------------
-- Transform year/month/day into a proper DATE field.
-- Rename columns to snake_case and business-friendly names.
-- Preserve original values where appropriate for traceability.

CREATE TABLE e_shop_base AS
SELECT
    make_date(year, month, day) AS event_date,
    "order" AS order_id,
    country::text AS country,
    "session ID" AS session_id,
    "page 1 (main category)"::text AS product_category,
    "page 2 (clothing model)" AS unique_product_code,
    colour::text AS color,
    location::text AS image_location,
    "model photography"::text AS model_photography,
    price,
    "price 2"::text AS is_above_category_avg_price,
    page AS page_number
FROM e_shop_clothing;


-- -----------------------------------------------------
-- Step 3: Validate newly created base table
-- -----------------------------------------------------
-- Quick sanity check to confirm transformations were applied
-- correctly and data is populated as expected.

SELECT *
FROM e_shop_base;


-- -----------------------------------------------------
-- Step 4: Decode country identifiers
-- -----------------------------------------------------
-- Convert numeric country codes into readable country names
-- to support geographic analysis and visualization.

UPDATE e_shop_base
SET country = CASE country
    WHEN '1'  THEN 'Australia'
    WHEN '2'  THEN 'Austria'
    WHEN '3'  THEN 'Belgium'
    WHEN '4'  THEN 'British Virgin Islands'
    WHEN '5'  THEN 'Cayman Islands'
    WHEN '6'  THEN 'Christmas Island'
    WHEN '7'  THEN 'Croatia'
    WHEN '8'  THEN 'Cyprus'
    WHEN '9'  THEN 'Czech Republic'
    WHEN '10' THEN 'Denmark'
    WHEN '11' THEN 'Estonia'
    WHEN '12' THEN 'Unidentified'
    WHEN '13' THEN 'Faroe Islands'
    WHEN '14' THEN 'Finland'
    WHEN '15' THEN 'France'
    WHEN '16' THEN 'Germany'
    WHEN '17' THEN 'Greece'
    WHEN '18' THEN 'Hungary'
    WHEN '19' THEN 'Iceland'
    WHEN '20' THEN 'India'
    WHEN '21' THEN 'Ireland'
    WHEN '22' THEN 'Italy'
    WHEN '23' THEN 'Latvia'
    WHEN '24' THEN 'Lithuania'
    WHEN '25' THEN 'Luxembourg'
    WHEN '26' THEN 'Mexico'
    WHEN '27' THEN 'Netherlands'
    WHEN '28' THEN 'Norway'
    WHEN '29' THEN 'Poland'
    WHEN '30' THEN 'Portugal'
    WHEN '31' THEN 'Romania'
    WHEN '32' THEN 'Russia'
    WHEN '33' THEN 'San Marino'
    WHEN '34' THEN 'Slovakia'
    WHEN '35' THEN 'Slovenia'
    WHEN '36' THEN 'Spain'
    WHEN '37' THEN 'Sweden'
    WHEN '38' THEN 'Switzerland'
    WHEN '39' THEN 'Ukraine'
    WHEN '40' THEN 'United Arab Emirates'
    WHEN '41' THEN 'United Kingdom'
    WHEN '42' THEN 'USA'
    WHEN '43' THEN 'biz (.biz)'
    WHEN '44' THEN 'com (.com)'
    WHEN '45' THEN 'int (.int)'
    WHEN '46' THEN 'net (.net)'
    WHEN '47' THEN 'org (.org)'
END;


-- -----------------------------------------------------
-- Step 5: Decode product categories
-- -----------------------------------------------------
-- Translate numeric product category codes into
-- business-meaningful labels.

UPDATE e_shop_base
SET product_category = CASE product_category
    WHEN '1' THEN 'trousers'
    WHEN '2' THEN 'skirts'
    WHEN '3' THEN 'blouses'
    WHEN '4' THEN 'sale'
END;


-- -----------------------------------------------------
-- Step 6: Decode product color values
-- -----------------------------------------------------
-- Replace numeric color identifiers with descriptive names
-- to support product-level and aesthetic analysis.

UPDATE e_shop_base
SET color = CASE color
    WHEN '1'  THEN 'beige'
    WHEN '2'  THEN 'black'
    WHEN '3'  THEN 'blue'
    WHEN '4'  THEN 'brown'
    WHEN '5'  THEN 'burgundy'
    WHEN '6'  THEN 'gray'
    WHEN '7'  THEN 'green'
    WHEN '8'  THEN 'navy blue'
    WHEN '9'  THEN 'various'
    WHEN '10' THEN 'olive'
    WHEN '11' THEN 'pink'
    WHEN '12' THEN 'red'
    WHEN '13' THEN 'violet'
    WHEN '14' THEN 'white'
END;


-- -----------------------------------------------------
-- Step 7: Decode image placement on page
-- -----------------------------------------------------
-- Convert image location codes into human-readable
-- positional descriptors.

UPDATE e_shop_base
SET image_location = CASE image_location
    WHEN '1' THEN 'top left'
    WHEN '2' THEN 'top middle'
    WHEN '3' THEN 'top right'
    WHEN '4' THEN 'bottom left'
    WHEN '5' THEN 'bottom middle'
    WHEN '6' THEN 'bottom right'
END;


-- -----------------------------------------------------
-- Step 8: Decode model photography orientation
-- -----------------------------------------------------
-- Identify whether the product image shows the model
-- facing forward or in profile.

UPDATE e_shop_base
SET model_photography = CASE model_photography
    WHEN '1' THEN 'en face'
    WHEN '2' THEN 'profile'
END;


-- -----------------------------------------------------
-- Step 9: Decode relative price indicator
-- -----------------------------------------------------
-- Translate binary pricing indicator into Yes / No
-- for easier interpretability in analysis and dashboards.

UPDATE e_shop_base
SET is_above_category_avg_price = CASE is_above_category_avg_price
    WHEN '1' THEN 'Yes'
    WHEN '2' THEN 'No'
END;


-- -----------------------------------------------------
-- Step 10: Final validation
-- -----------------------------------------------------
-- Confirm that cleaned and decoded fields appear as expected
-- before using this table in downstream analysis.

SELECT *
FROM e_shop_base
LIMIT 10;
