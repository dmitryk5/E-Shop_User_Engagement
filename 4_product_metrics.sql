-- =====================================================
-- 04. Product-Level Engagement & Intent Metrics
-- =====================================================
-- Objective:
-- Quantify product performance by combining view volume
-- with session-level purchase intent signals.
--
-- This table enables identification of:
-- * Products that attract attention but do not convert
-- * Products that generate disproportionate high intent
-- * Category-level differences in engagement quality
-- =====================================================


-- -----------------------------------------------------
-- Step 1: Build product-level metrics
-- -----------------------------------------------------
-- Each row represents a unique product.
-- Metrics reflect both popularity (views) and
-- quality of engagement (high-intent exposure).

CREATE TABLE product_metrics AS
SELECT
    e.unique_product_code,
    e.product_category,

    -- Overall visibility
    COUNT(*) AS total_views,

    -- Session reach
    COUNT(DISTINCT e.session_id) AS sessions_viewed,

    -- Pricing context
    ROUND(AVG(price), 2) AS avg_price,

    -- High-intent exposure
    SUM(
        CASE
            WHEN f.high_intent = 1 THEN 1
            ELSE 0
        END
    ) AS high_intent_views
FROM e_shop_base e
JOIN funnel_flags f
    ON e.session_id = f.session_id
GROUP BY
    e.unique_product_code,
    e.product_category
ORDER BY total_views DESC;


-- -----------------------------------------------------
-- Step 2: Validate product-level metrics
-- -----------------------------------------------------
-- Review aggregated product metrics to confirm
-- expected ranking and value ranges.

SELECT *
FROM product_metrics;
