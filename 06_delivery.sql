-- Late delivery rate: delivered after the estimated delivery date
SELECT COUNT(*) AS delivered_orders,
       SUM(CASE WHEN date(order_delivered_customer_date) > date(order_estimated_delivery_date)
                THEN 1 ELSE 0 END) AS late_orders,
       ROUND(SUM(CASE WHEN date(order_delivered_customer_date) > date(order_estimated_delivery_date)
                      THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_pct
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;

-- Late rate and average days vs estimate by customer state (states with 500+ orders)
SELECT c.customer_state,
       COUNT(*) AS delivered_orders,
       ROUND(SUM(CASE WHEN date(o.order_delivered_customer_date) > date(o.order_estimated_delivery_date)
                      THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS late_pct,
       ROUND(AVG(julianday(date(o.order_delivered_customer_date))
               - julianday(date(o.order_estimated_delivery_date))), 1) AS avg_days_vs_estimate
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
HAVING COUNT(*) >= 500
ORDER BY late_pct DESC
LIMIT 10;

-- Average review score for on-time vs late deliveries
WITH delivery AS (
    SELECT order_id,
           CASE WHEN date(order_delivered_customer_date) > date(order_estimated_delivery_date)
                THEN 'late' ELSE 'on_time' END AS delivery_status
    FROM orders
    WHERE order_status = 'delivered'
      AND order_delivered_customer_date IS NOT NULL
)
SELECT d.delivery_status,
       COUNT(*) AS reviews,
       ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM delivery d
JOIN order_reviews r ON r.order_id = d.order_id
GROUP BY d.delivery_status;