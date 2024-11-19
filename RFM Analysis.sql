----------------------------------------- RFM ANALYSİS

WITH RFM AS (
	SELECT
    	o.order_id,
    	o.customer_id,
    	c.customer_unique_id,
    	o.order_status,
    	o.order_approved_at,
    	op.payment_value
	FROM
    	orders o
	LEFT JOIN
    	orderpayments op USING(order_id)
	LEFT JOIN
    	customers c USING(customer_id)
	WHERE
    	o.order_status <> 'canceled' 
		AND o.order_status <> 'unavailable' 
		AND o.order_approved_at IS NOT NULL 
		AND op.payment_value IS NOT NULL
	
), RFM_Table AS (
	SELECT
		DISTINCT customer_unique_id,
		'2018-09-04' - FIRST_VALUE(order_approved_at) 
		OVER(PARTITION BY customer_unique_id ORDER BY order_approved_at DESC)::date AS Recency,
		COUNT(order_id) OVER(PARTITION BY customer_unique_id) AS Frequency,
		SUM(payment_value) OVER(PARTITION BY customer_unique_id) AS Monetary
	FROM RFM
	
), max_rec_rank AS (
	SELECT
		DENSE_RANK() OVER (ORDER BY Recency)
	FROM RFM_Table
	ORDER BY 1 DESC
	LIMIT 1
	
), max_freq_rank AS (
	SELECT
		DENSE_RANK() OVER (ORDER BY Frequency)
	FROM RFM_Table
	ORDER BY 1 DESC
	LIMIT 1
	
), max_mon_rank AS (
	SELECT
		DENSE_RANK() OVER (ORDER BY Monetary)
	FROM RFM_Table
	ORDER BY 1 DESC
	LIMIT 1
	
), RFM_Skorları AS (
	SELECT
		*,
		ROUND(DENSE_RANK() OVER(ORDER BY Recency DESC)/
			  (SELECT * FROM max_rec_rank)::numeric*4)+1
			   AS Rec_Skor,
		ROUND(DENSE_RANK() OVER(ORDER BY Frequency)/
			  (SELECT * FROM max_freq_rank)::numeric*4)+1
			   AS Freq_Skor,
		ROUND(DENSE_RANK() OVER(ORDER BY Monetary)/
			  (SELECT * FROM max_mon_rank)::numeric*4)+1
			   AS Mon_Skor
	FROM RFM_Table
	ORDER BY Frequency DESC

), Seg_Table AS (
	SELECT
		*,
		ROUND((Mon_Skor+Freq_Skor)/2) AS Freq_Mon_Skor,
		CONCAT(Rec_Skor,Freq_Skor,Mon_Skor)::numeric AS RFM
	FROM RFM_Skorları
	ORDER BY Rec_Skor,Freq_Mon_Skor

), Seg_Customer AS (
	SELECT
		*,
	CASE
		WHEN (RFM>=111) AND (RFM<=155) THEN 'At Risk'
		WHEN (RFM>=211) AND (RFM<=255) THEN 'Hold and Improve'
		WHEN (RFM>=311) AND (RFM<=353) THEN 'Potential Loyalist'
		WHEN ((RFM>=354) AND (RFM<=454)) OR ((RFM>=511) AND (RFM<=535)) OR (RFM=541) THEN 'Loyal Customer'
		WHEN (RFM=455) OR ((RFM>=542) AND (RFM<=555)) THEN 'Champions'
		ELSE 'Other'
		END AS Customer_Segment
	FROM Seg_Table
)
	SELECT 
		Customer_Segment,
		SUM(Frequency) AS Sipariş_Sayısı,
		COUNT(DISTINCT customer_unique_id) AS Müşteri_Sayısı
	FROM Seg_Customer
	GROUP BY 1
	ORDER BY 3 DESC


-------------------------------------------- RFM ANALYSİS 2

WITH table1 AS (
	SELECT
		invoiceno,
		customerid,
		invoicedate,
		(quantity*unitprice) AS amount
	FROM RFM
	WHERE 
		quantity>0
		AND customerid IS NOT NULL

), table2 AS (
	SELECT
		DISTINCT customerid,
		'2011-12-10' - FIRST_VALUE(invoicedate) OVER(PARTITION BY customerid ORDER BY invoicedate DESC)::date AS Recency,
		COUNT(invoiceno) OVER(PARTITION BY customerid) AS Frequency,
		SUM(amount) OVER(PARTITION BY customerid) AS Monetary
	FROM table1
	
), max_rec_rank AS (
	SELECT
		DENSE_RANK() OVER (ORDER BY Recency)
	FROM Table2
	ORDER BY 1 DESC
	LIMIT 1
	
), max_freq_rank AS (
	SELECT
		DENSE_RANK() OVER (ORDER BY Frequency)
	FROM Table2
	ORDER BY 1 DESC
	LIMIT 1
	
), max_mon_rank AS (
	SELECT
		DENSE_RANK() OVER (ORDER BY Monetary)
	FROM Table2
	ORDER BY 1 DESC
	LIMIT 1
	
), RFM_Skorları AS (
	SELECT
		*,
		ROUND(DENSE_RANK() OVER(ORDER BY Recency DESC)/
			  (SELECT * FROM max_rec_rank)::numeric*4)+1
			   AS Rec_Skor,
		ROUND(DENSE_RANK() OVER(ORDER BY Frequency)/
			  (SELECT * FROM max_freq_rank)::numeric*4)+1
			   AS Freq_Skor,
		ROUND(DENSE_RANK() OVER(ORDER BY Monetary)/
			  (SELECT * FROM max_mon_rank)::numeric*4)+1
			   AS Mon_Skor
	FROM Table2
	ORDER BY Frequency DESC

), Seg_Table AS (
	SELECT
		*,
		ROUND((Mon_Skor+Freq_Skor)/2) AS Freq_Mon_Skor,
		CONCAT(Rec_Skor,Freq_Skor,Mon_Skor)::numeric AS RFM
	FROM RFM_Skorları
	ORDER BY Rec_Skor,Freq_Mon_Skor

), Seg_Customer AS (
	SELECT
		*,
	CASE
		WHEN (RFM>=111) AND (RFM<=155) THEN 'At Risk'
		WHEN (RFM>=211) AND (RFM<=255) THEN 'Hold and Improve'
		WHEN (RFM>=311) AND (RFM<=353) THEN 'Potential Loyalist'
		WHEN ((RFM>=354) AND (RFM<=454)) OR ((RFM>=511) AND (RFM<=535)) OR (RFM=541) THEN 'Loyal Customer'
		WHEN (RFM=455) OR ((RFM>=542) AND (RFM<=555)) THEN 'Champions'
		ELSE 'Other'
		END AS Customer_Segment
	FROM Seg_Table
)
	SELECT 
		Customer_Segment,
		SUM(Frequency) AS Sipariş_Sayısı,
		COUNT(customerid) AS Müşteri_Sayısı
	FROM Seg_Customer
	GROUP BY 1
	ORDER BY 3 DESC


