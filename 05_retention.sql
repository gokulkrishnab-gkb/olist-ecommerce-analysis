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