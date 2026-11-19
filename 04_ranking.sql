-- Top 3 product categories by revenue in each year (delivered orders, excluding freight)
WITH category_year AS (
    SELECT strftime('%Y', o.order_purchase_timestamp) AS order_year,
           t.product_category_name_english           AS category,
           SUM(oi.price)                             AS revenue
    FROM order_items oi
    JOIN orders o   ON o.order_id = oi.order_id
    JOIN products p ON p.product_id = oi.product_id
    JOIN product_category_name_translation t
         ON t.product_category_name = p.product_category_name
    WHERE o.order_status = 'delivered'
      AND strftime('%Y', o.order_purchase_timestamp) IN ('2017', '2018')
    GROUP BY order_year, category
),
ranked AS (
    SELECT order_year,
           category,
           revenue,
           RANK() OVER (PARTITION BY order_year ORDER BY revenue DESC) AS rnk
    FROM category_year
)
SELECT order_year,
       rnk,
       category,
       ROUND(revenue, 2) AS revenue
FROM ranked
WHERE rnk <= 3
ORDER BY order_year, rnk;

-- Top 3 sellers in each of the top 5 categories (delivered orders, excluding freight)
WITH seller_category AS (
    SELECT t.product_category_name_english AS category,
           oi.seller_id,
           SUM(oi.price)                   AS revenue
    FROM order_items oi
    JOIN orders o   ON o.order_id = oi.order_id
    JOIN products p ON p.product_id = oi.product_id
    JOIN product_category_name_translation t
         ON t.product_category_name = p.product_category_name
    WHERE o.order_status = 'delivered'
    GROUP BY category, oi.seller_id
),
top_categories AS (
    SELECT category
    FROM seller_category
    GROUP BY category
    ORDER BY SUM(revenue) DESC
    LIMIT 5
),
ranked AS (
    SELECT category,
           seller_id,
           revenue,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY revenue DESC) AS row_num,
           ROUND(revenue * 100.0 / SUM(revenue) OVER (PARTITION BY category), 1) AS pct_of_category
    FROM seller_category
    WHERE category IN (SELECT category FROM top_categories)
)
SELECT category,
       row_num,
       seller_id,
       ROUND(revenue, 2) AS revenue,
       pct_of_category
FROM ranked
WHERE row_num <= 3
ORDER BY category, row_num;

-- ===== Findings =====

-- Q1: Did the top 3 categories change between 2017 and 2018?
-- The same 3 categories (health_beauty, watches_gifts, bed_bath_table) lead in both years,
-- but the order changed. health_beauty moved from 3rd to 1st (+60% revenue),
-- watches_gifts grew about 45%, and bed_bath_table stalled at about +8.5%.
-- Note: 2018 data covers only Jan to Aug, so these growth figures are conservative.

-- Q2: How concentrated are the top sellers?
-- watches_gifts relies on its top 3 sellers for about 47% of category revenue,
-- which is a supply risk. bed_bath_table depends on 2 sellers (about 31%).
-- health_beauty, computers_accessories and sports_leisure are spread across many sellers.