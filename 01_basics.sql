
-- Q1: How many orders does each status have? Sorted so the biggest comes first.
SELECT order_status,
       COUNT(*) AS total_orders
FROM orders
GROUP BY order_status 
ORDER BY total_orders DESC;

-- Q2: How many orders were delivered?
SELECT COUNT(*) AS delivered_orders
FROM orders
WHERE order_status = 'delivered';

-- Q3: How many distinct real customers are there?
SELECT COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers;

-- Q4: What are the earliest and latest purchase dates?
SELECT MIN(order_purchase_timestamp) AS earliest_purchase,
       MAX(order_purchase_timestamp) AS latest_purchase
FROM orders;

-- Q5a: How many orders have no delivered-to-customer date?
SELECT COUNT(*) AS missing_delivery_date
FROM orders
WHERE order_delivered_customer_date IS NULL;

-- Q5b: How many orders are not delivered?
SELECT COUNT(*) AS not_delivered
FROM orders
WHERE order_status <> 'delivered';

-- Q5c: Status vs. missing delivery date
SELECT order_status,
       COUNT(*) AS total_orders,
       SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS null_dates,
       SUM(CASE WHEN order_delivered_customer_date IS NOT NULL THEN 1 ELSE 0 END) AS has_date
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- ===== Data quality checks =====

-- Q6: Products with no category name (these are dropped by the inner join in category queries)
SELECT COUNT(*) FROM products WHERE product_category_name IS NULL;
-- Result: 610

-- Q7: Total products (to work out the percentage affected)
SELECT COUNT(*) FROM products;
-- Result: 32951