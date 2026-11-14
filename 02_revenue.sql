-- Q6: Top 5 states by number of orders
SELECT c.customer_state,
       COUNT(*) AS total_orders
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC
LIMIT 5;

-- Q7: Total revenue (GMV) from delivered orders, excluding freight
SELECT SUM(oi.price) AS total_revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';

-- Q8: Monthly revenue (GMV) from delivered orders, excluding freight
SELECT strftime('%Y-%m', o.order_purchase_timestamp) AS order_month,
       SUM(oi.price) AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY order_month
ORDER BY order_month;

-- Q9: Monthly orders, revenue, and AOV (delivered orders, excluding freight)
SELECT strftime('%Y-%m', o.order_purchase_timestamp) AS order_month,
       COUNT(DISTINCT o.order_id)                    AS total_orders,
       SUM(oi.price)                                 AS revenue,
       ROUND(SUM(oi.price) * 1.0 / COUNT(DISTINCT o.order_id), 2) AS aov
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY order_month
ORDER BY order_month;

-- Q10: Top 10 product categories by revenue (delivered orders, excluding freight)
SELECT t.product_category_name_english AS category,
       SUM(oi.price)                   AS revenue
FROM order_items oi
JOIN orders o   ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN product_category_name_translation t
     ON t.product_category_name = p.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY t.product_category_name_english
ORDER BY revenue DESC
LIMIT 10;

-- Q11: Top 10 sellers by revenue (delivered orders, excluding freight)
SELECT oi.seller_id,
       SUM(oi.price) AS revenue
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id
ORDER BY revenue DESC
LIMIT 10;

-- Q12: Categories with more than 1,000 distinct delivered orders
SELECT t.product_category_name_english AS category,
       COUNT(DISTINCT o.order_id)      AS total_orders,
       SUM(oi.price)                   AS revenue
FROM order_items oi
JOIN orders o   ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN product_category_name_translation t
     ON t.product_category_name = p.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY t.product_category_name_english
HAVING COUNT(DISTINCT o.order_id) > 1000
ORDER BY revenue DESC;



