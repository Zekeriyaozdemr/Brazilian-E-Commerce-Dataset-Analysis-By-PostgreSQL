------------------------------------------- CASE 1 : Order Analysis
-------------------------------------------------- Question 1
------------------------------------- Examine order distributions monthly

SELECT  
	to_char(order_approved_at,'YYYY-MM') AS Month,
	COUNT(order_id) AS Order_count
FROM 
	orders
WHERE 
	order_approved_at IS NOT NULL
GROUP BY 1
ORDER BY 1

---------------------------------------------------- Question 2
---------------------------- Examine order distributions in order status breakdown

SELECT  
	order_status,
	CAST (to_char(order_approved_at,'YYYY-MM') AS DATE) AS Month,
	COUNT(order_id) AS Order_Count
FROM 
	orders
WHERE 
	order_approved_at IS NOT NULL
GROUP BY 1,2
ORDER BY 2 

---------------------------------------------------------------------------------------------------------------
-- SELECT 
-- 	order_id, 
-- 	order_approved_at
-- FROM 
-- 	orders
-- WHERE 
-- 	order_approved_at IS NULL;
--------------------------------------------------- Question 3
--------------------------------- Examine order quantities by product category

SELECT  
	product_category_name_english AS Ürün_Kategorisi,
	CAST(order_approved_at AS DATE) AS Sipariş_Tarihi,
	COUNT(DISTINCT order_id) AS Siparis_Adeti
FROM 
	orders AS o
INNER JOIN 
	orderitems as oi USING(order_id)
INNER JOIN 
	products as p USING(product_id)
INNER JOIN 
	productcatname as pc USING(product_category_name)
WHERE 
	order_approved_at IS NOT NULL
GROUP BY 1,2
ORDER BY 2

--------------------------------- Check out the categories featured on special days
SELECT
	order_id,
	product_category_name_english AS ürün_adı,
	CAST(order_approved_at AS DATE),
	*
FROM 
	orders AS o
LEFT JOIN 
	orderitems as oi USING(order_id)
LEFT JOIN 
	products as p USING(product_id)
FULL JOIN 
	productcatname as pc USING(product_category_name)
WHERE order_approved_at < '01-01-2017' AND product_category_name_english = 'furniture_decor'


-------------------------------------------------- Question 4 (P1)
------------------------------- Examine the number of orders based on days of the week

SELECT  
	to_char(order_approved_at,'DAY') as Hafta_Günler,
	COUNT(DISTINCT order_id) as Siparis_Adeti
FROM 
	orders
WHERE 
	order_approved_at IS NOT NULL
GROUP BY 1
ORDER BY 1

-------------------------------------------------- Question 4 (P2)
------------------------------- Examine the number of orders based on days of the month

SELECT  
	to_char(order_approved_at,'DD') as Ay_Günler,
	COUNT(DISTINCT order_id) as Siparis_Adeti
FROM 
	orders
WHERE 
	order_approved_at IS NOT NULL
GROUP BY 1
ORDER BY 1

--------------------------------------------- CASE 2 : Customer Analysis
---------------------------------------------------- Question 1
-- In Which Cities Do Customers Shop More? Determine the city where the customer orders the most and make the analysis accordingly.
	
WITH tablo1 AS (	
	SELECT
		order_id,
		customer_unique_id,
		customer_city,
		COUNT(order_id) OVER (PARTITION BY customer_city,customer_unique_id) AS count_city
	FROM orders o
		INNER JOIN customers c USING(customer_id)
	ORDER BY customer_unique_id,customer_city
),
Tablo2 AS (	
	SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY customer_unique_id ORDER BY count_city DESC) AS sort
	FROM tablo1
)	
	SELECT
		customer_city,
		COUNT(DISTINCT customer_unique_id) AS Müşteri_Sayısı
	FROM tablo2
	WHERE sort=1
	GROUP BY 1
	ORDER BY 2 DESC
------------------------------- Customers who ordered from more than one city

WITH tablo1 AS (
SELECT customer_unique_id,
		customer_city,
		COUNT(customer_unique_id)
FROM customers
GROUP BY customer_unique_id,customer_city
HAVING COUNT(customer_unique_id) > 1 
ORDER BY customer_unique_id
)
        SELECT customer_unique_id,
		COUNT(customer_unique_id)
		FROM tablo1
		GROUP BY customer_unique_id
		HAVING COUNT(customer_unique_id) > 1 
	
------------------------------------- Confirmation of the query					
SELECT
		order_id,
		customer_unique_id,
		customer_city
	FROM 
		orders o
		LEFT JOIN customers c USING(customer_id)
		WHERE customer_unique_id = '738ffcf1-017b-584e-9d26-84b36e07469c'


----------------------------------------------- CASE 3 : Seller Analysis
----------------------------------------------------- Question 1
--------------------------- Top 5 sellers who deliver orders to customers in the fastest way
--------------------- Analysis was made based on customers whose average order quantity was over 30. 
	
WITH order_delivery AS (
    SELECT
        s.seller_id,
        o.order_id,
        o.order_status,
        o.order_purchase_timestamp AS siparis_olusturma,
        o.order_delivered_customer_date AS siparis_teslim,
		r.review_score AS Score,
		r.review_comment_message AS Yorum,
        o.order_delivered_customer_date - o.order_purchase_timestamp AS teslimsuresi
    FROM
        orders o
        INNER JOIN orderitems oi USING(order_id)
        INNER JOIN sellers s USING(seller_id)
		INNER JOIN orderreviews r USING(order_id)
    WHERE
        o.order_status = 'delivered'
)
SELECT
    seller_id,
    date_trunc('day',AVG(teslimsuresi)) AS avg_delivery_day,
    COUNT(order_id) AS order_count,
	ROUND(AVG(score),2) AS avg_score,
	COUNT(yorum) AS Sum_comment_count
FROM
    order_delivery
GROUP BY
    seller_id
HAVING
    COUNT(order_id) > 30
ORDER BY
	avg_delivery_day
LIMIT 5
---------------------------------------------------- Question 2
----------- Which Sellers Sell Products in More Categories? Do Sellers with Many Categories Have a High Number of Orders?
	
WITH Seller_Cat AS (
	SELECT 
		s.seller_id,
	CASE
       WHEN pc.product_category_name_english IS NULL THEN 'Unknown Category'
       ELSE pc.product_category_name_english
    END AS product_category_name,
		o.order_id
	FROM
		orders o
        INNER JOIN orderitems oi USING(order_id)
		INNER JOIN products p USING(product_id)
		FULL JOIN productcatname pc USING (product_category_name) 
        INNER JOIN sellers s USING(seller_id)
)
	SELECT
		Seller_id,
		COUNT(DISTINCT product_category_name) AS Category_Count,
		COUNT(order_id) AS Order_Count
	FROM
		Seller_Cat
	GROUP BY
		Seller_id
	ORDER BY
		2 DESC
---------------------------------------------- CASE 4 : Payment Analysis
----------------------------------------------------- Question 1
------------------- In Which Region Do Users With High Number of Installments When Making Payments Live Most?
	
WITH customer_payment AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        op.payment_type,
        op.payment_installments,
        c.customer_city,
        c.customer_state
    FROM
        orders o
    INNER JOIN 
		orderpayments op ON o.order_id = op.order_id AND op.payment_type = 'credit_card'
    LEFT JOIN 
		customers c USING(customer_id)
),  
avg_installment_count AS (
    SELECT  
        payment_type,
        COUNT(order_id) AS total_orders,
        AVG(payment_installments) AS average_installments
    FROM 
		orderpayments
    WHERE 
		payment_type = 'credit_card' AND payment_installments > 1
    GROUP BY 1
)
SELECT
    cp.customer_city,
    COUNT(DISTINCT cp.customer_unique_id) AS customer_count
FROM 
    customer_payment cp
INNER JOIN
    avg_installment_count ai ON cp.payment_type = ai.payment_type
WHERE 
	cp.payment_installments > ai.average_installments
GROUP BY
    cp.customer_city
ORDER BY 
    customer_count DESC;
	
---------------------------------------------------- Question 2
----------------- Calculate the Number of Successful Orders and Total Successful Payment Amount by Payment Type.

WITH pay_type AS (
	SELECT
		*
	FROM
		orders o
	INNER JOIN 
		orderpayments op USING(order_id)
	WHERE
		order_status = 'delivered'
)
SELECT
    payment_type,
    COUNT(order_id) AS Order_count,
    ROUND(SUM(payment_value)) || '$' AS SUM_Payment
FROM
    pay_type
GROUP BY
    payment_type
ORDER BY 2 DESC;
--------------------------------------------------- Question 3
-- Make Category Based Analysis of Orders Paid in Single Payment and Installments. In which categories is payment in installments used most?

WITH categorytable AS (	
	SELECT
		o.order_id,
		o.order_status,
		op.payment_type,
		op.payment_installments,
	CASE
		WHEN pc.product_category_name_english IS NULL THEN 'Unknown Category'
		ELSE pc.product_category_name_english
		END AS product_category_name
	FROM
			   orders 			o
	INNER JOIN orderpayments    op  	USING(order_id)
	INNER JOIN orderitems       oi      USING(order_id)
	INNER JOIN products 		p       USING(product_id)
	FULL JOIN productcatname 	pc 		USING(product_category_name)	
)
SELECT
	product_category_name,
	COUNT(order_id) AS Toplam_Order,
	COUNT(CASE WHEN payment_installments > 1 THEN order_id END) AS Taksitli,
    COUNT(CASE WHEN payment_installments = 1 THEN order_id END) AS Peşin,
	COUNT(CASE WHEN payment_type = 'credit_card' THEN order_id END ) AS Credit_Card,
	COUNT(CASE WHEN payment_type = 'boleto' THEN order_id END ) AS Boleto,
	COUNT(CASE WHEN payment_type = 'debit_card' THEN order_id END ) AS Debit_Card,
	COUNT(CASE WHEN payment_type = 'voucher' THEN order_id END ) AS Voucher
FROM
	categorytable
GROUP BY 1
ORDER BY 3 DESC;
-----------------------------------------------------------------------------------
