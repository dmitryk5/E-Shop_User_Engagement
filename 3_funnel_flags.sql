-- =====================================================
-- 03. Funnel & Purchase Intent Classification
-- =====================================================
-- Objective:
-- Classify each session into funnel stages based on
-- engagement depth and inferred purchase intent.
--
-- Funnel Stages:
-- 1. Viewed Product  → Session contains at least one product view
-- 2. Deep Browser    → High engagement within a session
-- 3. High Intent     → Deep engagement combined with exposure
--                     to higher-priced products
--
-- This table forms the analytical backbone for
-- conversion metrics and dashboard KPIs.
-- =====================================================


-- -----------------------------------------------------
-- Step 1: Calculate dynamic price threshold
-- -----------------------------------------------------
-- Identify the 75th percentile of product prices to
-- define what constitutes a "high-priced" product.
-- Using a percentile-based threshold ensures robustness
-- across price distributions.

CREATE TABLE funnel_flags AS
WITH price_threshold AS (
    SELECT
        PERCENTILE_CONT(0.75)
        WITHIN GROUP (ORDER BY price) AS high_price_threshold
    FROM e_shop_base
)

-- -----------------------------------------------------
-- Step 2: Assign funnel stage flags at the session level
-- -----------------------------------------------------
-- Join the global price threshold to all sessions
-- and apply engagement-based classification rules.

SELECT
    sm.session_id,

    -- Funnel entry: any product interaction
    CASE
        WHEN sm.product_views >= 1 THEN 1
        ELSE 0
    END AS viewed_product,

    -- Deep browsing: sustained product exploration
    CASE
        WHEN sm.product_views >= 15 THEN 1
        ELSE 0
    END AS deep_browser,

    -- High purchase intent:
    -- High engagement combined with exposure to
    -- higher-priced products
    CASE
        WHEN sm.product_views >= 30
             AND sm.max_price_viewed >= pt.high_price_threshold
        THEN 1
        ELSE 0
    END AS high_intent
FROM session_metrics sm
CROSS JOIN price_threshold pt;


-- -----------------------------------------------------
-- Step 3: Validate high-intent sessions
-- -----------------------------------------------------
-- Inspect a sample of sessions classified as high intent
-- to ensure logic behaves as expected.

SELECT *
FROM funnel_flags
WHERE high_intent = 1
LIMIT 10;
