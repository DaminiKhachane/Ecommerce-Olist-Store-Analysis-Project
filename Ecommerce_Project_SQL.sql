CREATE DATABASE ECOMMERCE;
USE ECOMMERCE;

-- KPI 1: Total Payment by Weekday/Weekend --
SELECT 
    CASE WHEN WEEKDAY(o.order_purchase_timestamp) IN (5, 6) THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    CONCAT(ROUND(SUM(p.payment_value) * 100 / (SELECT SUM(payment_value) FROM olist_order_payments_dataset), 2), '%') AS total_payment_percentage
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
GROUP BY day_type
ORDER BY SUM(p.payment_value) DESC;


-- KPI 2: Number of Orders with Review Score 5 and Payment Type as Credit Card --
SELECT 
   COUNT(*) AS total_orders,
   p.payment_type
FROM olist_order_reviews_dataset r
JOIN olist_order_payments_dataset p ON r.order_id = p.order_id
WHERE r.review_score = 5 AND p.payment_type = 'credit_card'
GROUP BY p.payment_type;

-- KPI 3: Average Delivery Days for 'pet_shop' Category --
SELECT 
    pr.product_category_name, 
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 2) AS average_delivery_days
FROM olist_products_dataset pr
JOIN olist_order_items_dataset oi ON pr.product_id = oi.product_id
JOIN olist_orders_dataset o ON oi.order_id = o.order_id
WHERE pr.product_category_name = 'pet_shop'
GROUP BY pr.product_category_name;

-- KPI 4: Average Price and Payment in Sao Paulo --
SELECT 
   s.seller_city,
   CONCAT(ROUND(AVG(oi.price) * 100 / (SELECT AVG(price) FROM olist_order_items_dataset), 2), '%') AS avg_price_percentage,
   CONCAT(ROUND(AVG(p.payment_value) * 100 / (SELECT AVG(payment_value) FROM olist_order_payments_dataset), 2), '%') AS avg_payment_percentage
FROM olist_sellers_dataset s
JOIN olist_order_items_dataset oi ON s.seller_id = oi.seller_id
JOIN olist_order_payments_dataset p ON oi.order_id = p.order_id
WHERE s.seller_city = 'Sao Paulo'
GROUP BY s.seller_city;


-- KPI 5: Average Shipping Days by Review Score --
SELECT 
    rev.review_score,
    ROUND(AVG(DATEDIFF(ord.order_delivered_customer_date, ord.order_purchase_timestamp)), 0) AS avg_shipping_days
FROM olist_orders_dataset AS ord
JOIN olist_order_reviews_dataset AS rev ON rev.order_id = ord.order_id
GROUP BY rev.review_score
ORDER BY rev.review_score;

