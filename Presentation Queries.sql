use DMA_PJT;
-- --------------------------------------------------------------------------------------------------------------
-- Simple Query
-- Retrieve all product names and their actual prices.
SELECT product_name, actual_price FROM product_table;
-- ---------------------------------------------------------------------------------------------------------------
-- ---- Aggergate
-- Calculate the average rating for a each category.
SELECT category_id, AVG(rating) AS average_rating
FROM product_table
GROUP BY category_id;
-- ---------------------------------------------------------------------------------------------------------------
-- ---- Inner Join/Outer Join:
-- Retrieve product names along with their category names:
SELECT product_name, category_name
FROM product_table
INNER JOIN category_table ON product_table.category_id = category_table.category_id;
-- ----------------------------------------------------------------------------------------------------------------
-- ---- Nested Query:
-- Find products with a rating greater than the average rating:
SELECT product_name, rating
FROM product_table
WHERE rating > (SELECT AVG(rating) FROM product_table);
-- ------------------------------------------------------------------------------------------------------------------
-- ---- Correlated Query:
-- List users who have made a purchase and their total purchase amount:
SELECT user_id, user_name,
       (SELECT SUM(discounted_price) 
        FROM transaction_table 
        INNER JOIN product_table ON transaction_table.product_id = product_table.product_id
        WHERE transaction_table.user_id = user_table.user_id) AS total_purchase_amount
FROM user_table
WHERE EXISTS (SELECT 1 FROM transaction_table WHERE transaction_table.user_id = user_table.user_id);
-- ----------------------------------------------------------------------------------------------------------------------
-- ---- >=ALL/>ANY/Exists/Not Exists:
-- Retrieve products with a price greater than all products in a specific category:
SELECT product_name, actual_price
FROM product_table
WHERE actual_price > ALL (SELECT actual_price
                         FROM product_table
                         WHERE category_id = (SELECT category_id FROM category_table WHERE category_name = 'Electronics'));
-- --------------------------------------------------------------------------------------------------------------------------
-- ---- Set Operations (Union):
-- Get a list of all unique product categories and payment methods:
SELECT category_name FROM category_table
UNION
SELECT payment_method_name FROM payment_method_table;
-- --------------------------------------------------------------------------------------------------------------------------
-- ---- Subqueries in Select and From:
SELECT product_name, (SELECT COUNT(*) FROM review_table WHERE review_table.product_id = product_table.product_id) AS review_count
FROM product_table;
-- --------------------------------------------------------------------------------------------------------------------------
-- Left Join
-- Write a Query to Join all Tables:
SELECT 
    p.product_id,
    p.product_name,
    p.discounted_price,
    p.actual_price,
    p.discount_percentage,
    p.rating,
    p.rating_count,
    p.about_product,
    c.category_id,
    c.category_name,
    v.vendor_id,
    v.vendor_name,
    v.vendor_loc,
    u.user_id,
    u.user_name,
    u.user_gender,
    u.user_age,
    u.user_wishlist_count,
    r.review_id,
    r.review_title,
    r.review_content,
    r.review_date,
    pl.img_link,
    pl.product_link,
    t.transaction_id,
    t.purchase_date,
    pm.payment_method_id,
    pm.payment_method_name,
    ps.payment_status
FROM 
    product_table p
    JOIN category_table c ON p.category_id = c.category_id
    JOIN vendor_table v ON p.vendor_id = v.vendor_id
    JOIN user_table u ON p.id_user_bought = u.user_id
    LEFT JOIN review_table r ON p.product_id = r.product_id
    LEFT JOIN product_image_link_table pl ON p.product_id = pl.product_id
    LEFT JOIN transaction_table t ON p.product_id = t.product_id
    LEFT JOIN payment_method_table pm ON u.user_id = pm.user_id
    LEFT JOIN payment_status_table ps ON t.transaction_id = ps.transaction_id
    LEFT JOIN stockstatus_table ss ON p.product_id = ss.product_id;




