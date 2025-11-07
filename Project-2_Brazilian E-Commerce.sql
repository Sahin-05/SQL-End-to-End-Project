
---------- 2. PROJE: Brazilian E-Commerce Public Data Seti ile SQL Sorguları ve Analizler ----------


--1 : VERİ SETİNİN POSTGRESQL SUNUCUSUNA BAĞLANARAK ÇEKİLMESİ: 


/*DBeaver'da bulunan database içerisinde "Brassilian E-Commerce" database'i oluşturulmuş ve bu database seçilerek 
“Tables” bölümünde “Import Data” ile belirtilen 4 tablo import edilmiştir.*/

/*Import edilen tablolarda numeric data, NaN, null ve '' veri kontrolleri yapılmış ve gerekli veri tipi dönüşümleri
aşağıda belirtildiği şekilde gerçekleştirilmiştir.*/


-- customers tablosundaki zip_code sütununun veri tipinin "INTEGER" olarak değiştirilmesi:

SELECT *
FROM olist_customers_dataset ocd 

SELECT * 
FROM olist_customers_dataset ocd 
WHERE customer_zip_code_prefix !~ '^[0-9]+$';

UPDATE olist_customers_dataset ocd 
SET customer_zip_code_prefix = TRIM(BOTH ' ' FROM customer_zip_code_prefix); 

ALTER TABLE olist_customers_dataset 
ALTER COLUMN customer_zip_code_prefix TYPE INT USING (customer_zip_code_prefix::integer); 


/* orders tablosundaki order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, 
order_delivered_customer_date ve order_estimated_delivery_date sütunlarının veri tipinin "TIMESTAMP" olarak değiştirilmesi:*/

SELECT *
FROM olist_orders_dataset

ALTER TABLE olist_orders_dataset 
ALTER COLUMN order_purchase_timestamp TYPE TIMESTAMP USING (order_purchase_timestamp::TIMESTAMP);

--
UPDATE olist_orders_dataset
SET order_approved_at = NULL
WHERE order_approved_at IN ('', 'NaN', 'null');

ALTER TABLE olist_orders_dataset 
ALTER COLUMN order_approved_at TYPE TIMESTAMP USING (order_approved_at::TIMESTAMP);

--
UPDATE olist_orders_dataset
SET order_delivered_carrier_date = NULL
WHERE order_delivered_carrier_date IN ('', 'NaN', 'null');

ALTER TABLE olist_orders_dataset 
ALTER COLUMN order_delivered_carrier_date TYPE TIMESTAMP USING (order_delivered_carrier_date::TIMESTAMP);

--
UPDATE olist_orders_dataset
SET order_delivered_customer_date = NULL
WHERE order_delivered_customer_date IN ('', 'NaN', 'null');

ALTER TABLE olist_orders_dataset 
ALTER COLUMN order_delivered_customer_date TYPE TIMESTAMP USING (order_delivered_customer_date::TIMESTAMP);

--
UPDATE olist_orders_dataset
SET order_estimated_delivery_date = NULL
WHERE order_estimated_delivery_date IN ('', 'NaN', 'null');

ALTER TABLE olist_orders_dataset 
ALTER COLUMN order_estimated_delivery_date TYPE TIMESTAMP USING (order_estimated_delivery_date::TIMESTAMP);

/* order_items tablosundaki  order_item_id'nin INTEGER, 
price ve freight_value sütunlarının veri tipinin "REAL",
shipping_limit_date sütunun veri tipinin TIMESTAMP olarak değiştirilmesi:*/

SELECT *
FROM olist_order_items_dataset ooid 

UPDATE olist_order_items_dataset ooid
SET order_item_id = TRIM(BOTH ' ' FROM order_item_id), 
	price = TRIM(BOTH ' ' FROM price),
	freight_value = TRIM(BOTH ' ' FROM price);

ALTER TABLE olist_order_items_dataset
ALTER COLUMN order_item_id TYPE INTEGER USING (order_item_id::INTEGER); 

ALTER TABLE olist_order_items_dataset
ALTER COLUMN price TYPE REAL USING (price::REAL); 

ALTER TABLE olist_order_items_dataset
ALTER COLUMN freight_value TYPE REAL USING (freight_value::REAL);

ALTER TABLE olist_order_items_dataset 
ALTER COLUMN shipping_limit_date TYPE TIMESTAMP USING (shipping_limit_date::TIMESTAMP);

/* products tablosundaki  product_name_lenght, product_description_lenght ve product_photos_qty'nin INTEGER; 
product_weight_g, product_length_cm, product_height_cm ve product_width_cm'nin REAL veri tipine dönüştürülmesi. 
*/
--
SELECT *
FROM olist_products_dataset

UPDATE olist_products_dataset
SET product_name_lenght = NULL
WHERE product_name_lenght IN ('', 'NaN', 'null');

ALTER TABLE olist_products_dataset
ALTER COLUMN product_name_lenght TYPE INTEGER USING (product_name_lenght::INTEGER);

--
UPDATE olist_products_dataset
SET product_description_lenght = NULL
WHERE product_description_lenght IN ('', 'NaN', 'null');

ALTER TABLE olist_products_dataset
ALTER COLUMN product_description_lenght TYPE INTEGER USING (product_description_lenght::INTEGER);
			 
--
UPDATE olist_products_dataset
SET product_photos_qty = NULL
WHERE product_photos_qty IN ('', 'NaN', 'null');

ALTER TABLE olist_products_dataset
ALTER COLUMN product_photos_qty TYPE INTEGER USING (product_photos_qty::INTEGER);
			 
--
UPDATE olist_products_dataset
SET product_weight_g = NULL
WHERE product_weight_g IN ('', 'NaN', 'null');

ALTER TABLE olist_products_dataset
ALTER COLUMN product_weight_g TYPE REAL USING (product_weight_g::REAL);

--
UPDATE olist_products_dataset
SET product_length_cm = NULL
WHERE product_length_cm IN ('', 'NaN', 'null');

ALTER TABLE olist_products_dataset
ALTER COLUMN product_length_cm TYPE REAL USING (product_length_cm::REAL);

--
UPDATE olist_products_dataset
SET product_height_cm = NULL
WHERE product_height_cm IN ('', 'NaN', 'null');

ALTER TABLE olist_products_dataset
ALTER COLUMN product_height_cm TYPE REAL USING (product_height_cm::REAL);

--
UPDATE olist_products_dataset
SET product_width_cm = NULL
WHERE product_width_cm IN ('', 'NaN', 'null');

ALTER TABLE olist_products_dataset
ALTER COLUMN product_width_cm TYPE REAL USING (product_width_cm::REAL);


SELECT *
FROM olist_customers_dataset ocd 
			 
SELECT *
FROM olist_orders_dataset ood 

SELECT *
FROM olist_order_items_dataset ooid			 
			 
SELECT *
FROM olist_products_dataset opd

--2: SQL SORGULARININ YAZILMASI VE ANALİZLER: 

-- 1.Soru: Olist’in aylık toplam gelirini hesaplayın.

SELECT 
	date_trunc('month', ood.order_purchase_timestamp) AS months,
	SUM(ooid.price + ooid.freight_value) AS monthly_total_revenue
FROM olist_order_items_dataset ooid
JOIN olist_orders_dataset ood
ON ooid.order_id = ood.order_id
WHERE ood.order_status = 'delivered'
GROUP BY date_trunc('month', ood.order_purchase_timestamp)
ORDER BY months;

Değerlendirme: Aylık gelirler 2016’dan 2018’e doğru giderek artmakta ve en çok gelir elde edilen aylar 2018’in Ocak-Mayıs aylarında yoğunlaşmaktadır.
	
-- 2.Soru: En çok satılan 10 ürün kategorisini bulun.  

SELECT 
	opd.product_category_name,
	COUNT(ooid.order_item_id) AS number_of_orders,
	SUM(ooid.price + ooid.freight_value) AS total_sales
FROM olist_order_items_dataset ooid
JOIN olist_orders_dataset ood
ON ooid.order_id = ood.order_id
JOIN olist_products_dataset opd
ON ooid.product_id = opd.product_id
WHERE ood.order_status = 'delivered'
GROUP BY opd.product_category_name
ORDER BY COUNT(ooid.order_item_id) DESC
LIMIT 10;

Değerlendirme: En çok satılan 10 ürün kategorisinden ilkinin “cama_mesa_banho”, sonuncusunun “automotivo” olduğu görülmektedir.
	
/* 3.Soru:   Müşterileri toplam harcamalarına göre segmentlere ayırın (>1000 BRL = Premium, 500-1000 
BRL = Regular, <500 BRL = Low) */

SELECT 
	ocd.customer_state,
	customer_unique_id,
	SUM(ooid.price + ooid.freight_value) AS total_spent,
	CASE
		WHEN SUM(ooid.price + ooid.freight_value) >= 1000 THEN 'Premium'
		WHEN SUM(ooid.price + ooid.freight_value) BETWEEN 500 AND 1000 THEN 'Regular'
		ELSE 'Low'
	END
	AS customer_segmentation
FROM olist_customers_dataset ocd
JOIN olist_orders_dataset ood
ON ocd.customer_id = ood.customer_id
JOIN olist_order_items_dataset ooid
ON ooid.order_id = ood.order_id
WHERE ood.order_status = 'delivered'
GROUP BY ocd.customer_state, customer_unique_id; 

Değerlendirme: Müşterilerin yarıdan fazlası “Low”, sonra en fazla “Premium” ve en az da “Regular” segmentinde bulunmaktadır.
	
-- 4.Soru: Her ürün kategorisi için ortalama sipariş değerini (AOV) hesaplayın.

SELECT 
	CASE 
        WHEN opd.product_category_name IS NULL OR opd.product_category_name = '' THEN 'Unknown'
        ELSE opd.product_category_name
    END 
    AS product_category_name,
	ROUND(SUM(ooid.price + ooid.freight_value)::numeric/COUNT(DISTINCT ooid.order_id),2) AS average_order_value
FROM olist_order_items_dataset ooid
JOIN olist_orders_dataset ood
ON ooid.order_id = ood.order_id
JOIN olist_products_dataset opd
ON ooid.product_id = opd.product_id
WHERE ood.order_status = 'delivered'
GROUP BY opd.product_category_name
ORDER BY average_order_value DESC;

Değerlendirme: En yüksek ortalama sipariş değerine sahip ürün kategorisi “pcs”, en düşük değere sahip ürün “casa_conforto_2”. 
Ayrıca datasetinde kategorisi bilinmeyen (unknown) ürünlerin ortalama sipariş değeri 245.30’dur. 

-- 5.Soru: Tekrar alım yapan müşterilerin sayısını ve toplam satışlara katkısını (%) hesaplayın.  

WITH customer_summary 
AS ( 
	SELECT 
        ocd.customer_unique_id,
        COUNT(DISTINCT ood.order_id) AS order_count,
        SUM(ooid.price + ooid.freight_value) AS total_spent
 	FROM olist_customers_dataset ocd
 	JOIN olist_orders_dataset ood 
 	ON ocd.customer_id = ood.customer_id
 	JOIN olist_order_items_dataset ooid 
 	ON ood.order_id = ooid.order_id
 	WHERE ood.order_status = 'delivered'
 	GROUP BY ocd.customer_unique_id
 	)
SELECT 
    COUNT(*) FILTER (WHERE order_count > 1) AS repeat_customer_count,
    COUNT(*) AS total_customer_count,
    COUNT(*) FILTER (WHERE order_count > 1)::numeric / COUNT(*) * 100 AS repeat_customer_ratio_percent,
    SUM(total_spent) FILTER (WHERE order_count > 1)::numeric / SUM(total_spent) * 100 AS revenue_contribution_percent
FROM customer_summary;

Değerlendirme: 2801 müşteri (toplam müşterilerin yaklaşık % 3’ü) tekrar alım yapmış ve toplam satışlara katkısı yaklaşıl % 5,5 olmuştur. 
	
-- 6.Soru: En yüksek gelir getiren 10 eyaleti bulun. 

SELECT 
	ocd.customer_state,
	COUNT(DISTINCT ocd.customer_unique_id) AS total_customer,
	SUM(ooid.price + ooid.freight_value) AS total_sales
FROM olist_customers_dataset ocd
JOIN olist_orders_dataset ood
ON ocd.customer_id = ood.customer_id
JOIN olist_order_items_dataset ooid
ON ooid.order_id = ood.order_id
WHERE ood.order_status = 'delivered'
GROUP BY ocd.customer_state
ORDER BY total_sales DESC
LIMIT 10;

Değerlendirme: En yüksek gelir getiren 10 eyaletin birincisinin “SP”, onuncusunun “GO” olduğu görülmektedir.

-- 7.Soru: Kategori bazında ortalama teslimat süresini (gün cinsinden) hesaplayın.  

SELECT 
	CASE 
        WHEN opd.product_category_name IS NULL OR opd.product_category_name = '' THEN 'Unknown'
        ELSE opd.product_category_name
    END 
    AS product_category_name,
	ROUND(AVG(DATE_PART('day', ood.order_delivered_customer_date - ood.order_purchase_timestamp)::numeric),2) AS average_delivery_days
FROM olist_order_items_dataset ooid
JOIN olist_orders_dataset ood
ON ooid.order_id = ood.order_id
JOIN olist_products_dataset opd
ON ooid.product_id = opd.product_id
WHERE ood.order_status = 'delivered' AND ood.order_delivered_customer_date IS NOT NULL
GROUP BY opd.product_category_name;
ORDER BY average_delivery_days;

Değerlendirme: En hızlı teslim edilen ürün kategorisinin “artes_e_artesanato” (ortalama 5,29 gün), 
en uzun teslimat süresine sahip ürün kategorisinin “moveis_escritorio” (ortalama 20,39 gün) olduğu görülmektedir. 

-- 8. Soru: En yüksek iade oranına sahip ürün kategorilerini bulun.

SELECT 
	CASE 
        WHEN opd.product_category_name IS NULL OR opd.product_category_name = '' THEN 'Unknown'
        ELSE opd.product_category_name
    END 
    AS product_category_name,
    COUNT(*) AS total_orders,
    COUNT(
    	CASE 
        	WHEN ood.order_status IN ('canceled', 'unavailable') THEN 1 
    	END) AS returned_orders,
    ROUND(
    	COUNT(
    		CASE WHEN ood.order_status IN ('canceled', 'unavailable') THEN 1 END)::numeric / COUNT(*) * 100, 2) 
    		AS returned_rate_percent
FROM olist_orders_dataset ood
JOIN olist_order_items_dataset ooid
ON ooid.order_id = ood.order_id
JOIN olist_products_dataset opd
ON ooid.product_id = opd.product_id
GROUP BY opd.product_category_name
ORDER BY returned_rate_percent DESC;

Değerlendirme: “pc_gamer” ütün kategorisi toplam 9 siparişte 1 olmak üzere % 11,11 oranı ile en yüksek iade oranına sahiptir. 
İade sayıları açısından değerlendirildiğinde en fazla geri iade edilen ürün “esperto_lazer” (51 kez)’dir. 
14 kez geri iade edilen ürünlerin ürün kategorileri bilinmemektedir (unknown).

-- 9. Soru: En yüksek satış yapan 10 satıcıyı ve kategorilerini bulun.  

SELECT 
	ooid.seller_id,
	CASE 
        WHEN opd.product_category_name IS NULL OR opd.product_category_name = '' THEN 'Unknown'
        ELSE opd.product_category_name
    END 
    AS product_category_name,
	COUNT(ooid.order_id) AS total_number_of_sales,
	SUM(ooid.price + ooid.freight_value) AS total_sales
FROM olist_order_items_dataset ooid
JOIN olist_orders_dataset ood
ON ooid.order_id = ood.order_id
JOIN olist_products_dataset opd
ON ooid.product_id = opd.product_id
WHERE ood.order_status = 'delivered'
GROUP BY ooid.seller_id, opd.product_category_name
ORDER BY total_sales DESC
LIMIT 10;

Değerlendirme: En yüksek satış değerine sahip ürün kategorisi “relegios_presentes”, en düşük değere sahip kategori “ferramentas_jardim”. 
Ancak, en yüksek satış sayısına sahip ürün kategorisinin de “ferramentas_jardim” olduğu görülmektedir. 
Bu açıdan bakıldığında “ferramentas_jardim” kategorisindeki ürünlerin diğer ürünlere göre uygun fiyatlı olduğu sonucuna varılabilir.
	
-- 10.Soru: Hafta içi ve hafta sonu sipariş sayılarını ve gelirlerini karşılaştırın.

SELECT 
    CASE 
        WHEN EXTRACT(DOW FROM ood.order_purchase_timestamp) IN (0, 6) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(DISTINCT ood.order_id) AS total_orders,
    SUM(ooid.price + ooid.freight_value) AS total_revenue,
    ROUND(AVG(ooid.price + ooid.freight_value)::numeric, 2) AS avg_order_value
FROM olist_orders_dataset ood
JOIN olist_order_items_dataset ooid
ON ood.order_id = ooid.order_id
WHERE ood.order_status = 'delivered'
GROUP BY day_type
ORDER BY day_type;

Değerlendirme: Ürünlerin yaklaşık %75’nin hafta içi sipariş verildiği görülmektedir. Hafta içi sipariş verilen ürünlerin toplam geliri hafta sonu verilenlerin 3 katından fazladır. 
Bununla birlikte, ortalama sipariş değerinin (teslim edilen her bir  sipariş için ortalama fiyat) hafta sonu siparişleri için çok az bir farkla yüksek olduğu görülmektedir.  

-- 3: POSTGRESQL’DEN VERİ EXPORT ETME (DIŞA AKTARMA)

/* 1, 3 ve 6'ncı sorgularda elde edilen analiz sonuçları csv formatında dışa aktarılmıştır.*/

-- 4: SONUÇLARIN GÖRSELLEŞTİRİLMESİ VE RAPORLAMA 

/* Dışa aktarılan tablolar Tableau programında görselleştirilmiştir.*/






