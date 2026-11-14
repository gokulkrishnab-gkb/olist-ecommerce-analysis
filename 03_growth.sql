-- Month-over-month revenue growth (delivered orders, excluding freight)
-- Version A: all months, including the unreliable early ones

WITH monthly AS (
    SELECT strftime('%Y-%m', o.order_purchase_timestamp) AS order_month,
        SUM(oi.price) AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY order_month
),
with_prev AS (
    SELECT order_month,
        revenue,
        LAG(revenue) OVER (ORDER BY order_month) AS prev_revenue
    FROM monthly
)

SELECT order_month,
    ROUND(revenue,2) AS revenue,
    ROUND(prev_revenue,2) AS prev_revenue,
    ROUND((revenue-prev_revenue)*100.0 / prev_revenue, 1) AS mom_growth_pct
FROM with_prev
ORDER BY order_month;


-- Version B: from 2017-01 onwards (early 2016 months are too sparse to be meaningful)
-- Note: LAG uses the previous ROW, not the previous calendar month.
-- November 2016 has no data, so LAG for 2016-12 pulls October's value, and the early
-- 2016 months have tiny revenue, so their growth percentages (e.g. 2017-01 vs 2016-12)
-- are meaningless. Version B therefore starts at 2017-01.

WITH monthly AS (
    SELECT strftime('%Y-%m', o.order_purchase_timestamp) AS order_month,
           SUM(oi.price) AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
      AND strftime('%Y-%m', o.order_purchase_timestamp) >= '2017-01'
    GROUP BY order_month
),
with_prev AS (
    SELECT order_month,
           revenue,
           LAG(revenue) OVER (ORDER BY order_month) AS prev_revenue
    FROM monthly
)
SELECT order_month,
       ROUND(revenue, 2) AS revenue,
       ROUND(prev_revenue, 2) AS prev_revenue,
       ROUND((revenue - prev_revenue) * 100.0 / prev_revenue, 1) AS mom_growth_pct
FROM with_prev
ORDER BY order_month;


-- Running total of monthly revenue from 2017-01 (delivered orders, excluding freight)
WITH monthly AS (
    SELECT strftime('%Y-%m', o.order_purchase_timestamp) AS order_month,
           SUM(oi.price) AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
      AND strftime('%Y-%m', o.order_purchase_timestamp) >= '2017-01'
    GROUP BY order_month
)
SELECT order_month,
       ROUND(revenue, 2) AS revenue,
       ROUND(SUM(revenue) OVER (ORDER BY order_month), 2) AS running_total
FROM monthly
ORDER BY order_month;

-- Year-over-year revenue growth (2018 vs the same month in 2017)

WITH monthly AS (
    SELECT strftime('%Y-%m', o.order_purchase_timestamp) AS order_month,
           SUM(oi.price) AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
      AND strftime('%Y-%m', o.order_purchase_timestamp) >= '2017-01'
    GROUP BY order_month
),
with_last_year AS (
    SELECT order_month,
           revenue,
           LAG(revenue,12) OVER (ORDER BY order_month) AS revenue_last_year
    FROM monthly
)
SELECT order_month,
       ROUND(revenue, 2) AS revenue,
       ROUND(revenue_last_year, 2) AS revenue_last_year,
       ROUND((revenue - revenue_last_year) * 100.0 / revenue_last_year, 1) AS yoy_growth_pct
FROM with_last_year
ORDER BY order_month;

