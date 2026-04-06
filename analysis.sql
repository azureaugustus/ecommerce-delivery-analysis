-- ===============================================================================================
-- 1. Orders Over Time
-- ===============================================================================================

-- Goal: Understand growth in orders over time


SELECT
	DATE(order_purchase_timestamp) AS order_date,
	COUNT(*) AS orders
FROM fct_orders
GROUP BY 1
ORDER BY 1;

-- ===============================================================================================
-- 2. Average Delivery Time
-- ===============================================================================================

-- Goal: Establish baseline delivery performance


SELECT
	AVG(delivery_days) AS avg_delivery_days
FROM fct_orders;


-- ===============================================================================================
-- 3. Orders by State
-- ===============================================================================================

-- Goal: Identify geographic distribution of demand


SELECT 
	customer_state,
	COUNT(*) AS orders
FROM fct_orders
GROUP BY 1
ORDER BY 2 DESC;


-- ===============================================================================================
-- 4. Delivery Time by State
-- ===============================================================================================

-- Goal: Compare delivery perofrmance across regions


SELECT 
	customer_state,
	AVG(delivery_days) AS avg_delivery_days,
	DENSE_RANK() OVER(ORDER BY AVG(delivery_days) DESC) AS worst_rank
FROM fct_orders
GROUP BY 1;


-- ===============================================================================================
--5. Delivery Time over Time
-- ===============================================================================================

-- Goal: Identify trends in delivery performance


SELECT
	DATE_TRUNC('month', order_purchase_timestamp) AS month,
	AVG(delivery_days) AS avg_delivery_days,
	LAG(AVG(delivery_days)) OVER(ORDER BY DATE_TRUNC('month', order_purchase_timestamp)) AS prev_month,
	AVG(delivery_days) - LAG(AVG(delivery_days)) OVER(ORDER BY DATE_TRUNC('month', order_purchase_timestamp)) AS change
FROM fct_orders
GROUP BY 1
ORDER BY 1;


-- ===============================================================================================
-- 6. Volume vs Delivery Time
-- ===============================================================================================

-- Goal: Compare order volume and delivery performance by state


SELECT
	customer_state,
	COUNT(*) AS orders,
	AVG(delivery_days) AS avg_delivery_days
FROM fct_orders
GROUP BY 1
ORDER BY orders DESC;

-- ===============================================================================================
-- 7. Correlation Analysis
-- ===============================================================================================

-- Goal: Measure relationship between order volume and delivery

SELECT
	CORR(orders, avg_delivery_days)
FROM (
	SELECT
		customer_state,
		COUNT(*) AS orders,
		AVG(delivery_days) AS avg_delivery_days
	FROM fct_orders
	GROUP BY 1) sub;













