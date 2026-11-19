-- Share of customers who placed more than one delivered order
WITH orders_per_customer AS (
    SELECT c.customer_unique_id,
           COUNT(DISTINCT o.order_id) AS num_orders
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT COUNT(*)                                        AS total_customers,
       SUM(CASE WHEN num_orders > 1 THEN 1 ELSE 0 END) AS repeat_customers,
       ROUND(SUM(CASE WHEN num_orders > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS repeat_pct
FROM orders_per_customer;

-- New customers per first-purchase month (their cohort)
WITH customer_orders AS (
    SELECT c.customer_unique_id,
           strftime('%Y-%m', o.order_purchase_timestamp) AS order_month
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
),
first_month AS (
    SELECT customer_unique_id,
           MIN(order_month) AS cohort_month
    FROM customer_orders
    GROUP BY customer_unique_id
)
SELECT cohort_month,
       COUNT(*) AS new_customers
FROM first_month
WHERE cohort_month >= '2017-01'
GROUP BY cohort_month
ORDER BY cohort_month;


-- Cohort retention: % of each cohort that ordered again N months after their first purchase
WITH customer_orders AS (
    SELECT c.customer_unique_id,
           strftime('%Y-%m', o.order_purchase_timestamp) AS order_month
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, order_month      -- one row per customer per month
),
first_month AS (
    SELECT customer_unique_id,
           MIN(order_month) AS cohort_month
    FROM customer_orders
    GROUP BY customer_unique_id
),
cohort_sizes AS (
    SELECT cohort_month,
           COUNT(*) AS cohort_size
    FROM first_month
    GROUP BY cohort_month
),
activity AS (
    SELECT f.cohort_month,
           co.customer_unique_id,
           (CAST(substr(co.order_month, 1, 4) AS INTEGER) * 12 + CAST(substr(co.order_month, 6, 2) AS INTEGER))
         - (CAST(substr(f.cohort_month, 1, 4) AS INTEGER) * 12 + CAST(substr(f.cohort_month, 6, 2) AS INTEGER))
           AS month_number
    FROM customer_orders co
    JOIN first_month f ON f.customer_unique_id = co.customer_unique_id
)
SELECT a.cohort_month,
       cs.cohort_size,
       a.month_number,
       COUNT(DISTINCT a.customer_unique_id) AS active_customers,
       ROUND(COUNT(DISTINCT a.customer_unique_id) * 100.0 / cs.cohort_size, 2) AS retention_pct
FROM activity a
JOIN cohort_sizes cs ON cs.cohort_month = a.cohort_month
WHERE a.cohort_month >= '2017-01'
  AND a.month_number <= 6
GROUP BY a.cohort_month, a.month_number
ORDER BY a.cohort_month, a.month_number;

-- Customers who ordered in 2 or more different months (stricter repeat definition)
WITH active_months AS (
    SELECT c.customer_unique_id,
           COUNT(DISTINCT strftime('%Y-%m', o.order_purchase_timestamp)) AS months_active
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT COUNT(*) AS total_customers,
       SUM(CASE WHEN months_active > 1 THEN 1 ELSE 0 END) AS returned_in_later_month,
       ROUND(SUM(CASE WHEN months_active > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS returned_pct
FROM active_months;