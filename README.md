______________________________________
# SQL End-to-End Proje Raporu
Ad Soyad: Şahin Cıplak
GitHub Reposu: Sahin-05/SQL-End-to-End-Project: SQL Project Files
Tableau Public Linki (Proje 2 için): 
https://public.tableau.com/app/profile/sahin.c./viz/Project2_Braziliane-commerce/Braziliane-commerce 
________________________________________
## Proje 1: E-Ticaret Veritabanı Oluşturma ve Yapılandırma
Bu projenin ilk aşamasında, bir e-ticaret sistemi için sıfırdan ilişkisel bir veritabanı tasarlanmış, tablolar oluşturulmuş ve örnek verilerle doldurulmuştur.

### 1. Veritabanı Tasarımı ve Şeması
Proje kapsamında tasarlanan veritabanı şeması (ER Diagram) aşağıdadır. Tasarımda e-ticaret sitesi için CREATE TABLE komutu ile customers, customers_address, products, categories, orders, order_address, orderitems ve payments olmak üzere toplam 8 adet tablo oluşturulmuştur. Ana tablolar ve aralarındaki ilişkiler (bire-çok, bire-bir) dikkate alınmış ve bu kapsamda aşağıdaki ilişkiler tesis edilmiştir:
- customers ile orders arasında bire çok ilişki (Bir müşteri birçok sipariş verebilir) 
- orders ile orderitems arasında bire çok ilişki (Bir sipariş içerisinde birden fazla ürün olabilir)
- products ile orderitems arasında bire çok ilişki (Bir ürün birçok siparişte yer alabilir.)
- products ile categories arasında bire çok ilişki (Her ürün yalnızca bir kategoriye aittir.)
- customers ile customers_address arasında bire çok ilişki (Bir müşteriye birden fazla adres tanımlanabilir.)
- customers ile order_address arasında bire çok ilişki (Bir müşteri birçok siparişte farklı adresler kullanabilir.)
- orders ile order_address arasında bire bir ilişki (Her siparişin bir teslimat adresi vardır.)
- orders ile payments arasında bire çok ilişki (Bir siparişin bir veya birden fazla ödeme kaydı olabilir.)
- customers ile payments arasında bire çok ilişki (Bir müşteri birçok ödeme işlemi yapabilir.)
- customers ile products arasında orderitems köprü tablosu üzerinden çoka çok ilişki (Müşteri birçok ürün satın alabilir, ürün birçok müşteri tarafından satın alınabilir.)

ERD: https://github.com/Sahin-05/SQL-End-to-End-Project/blob/main/ERD.png

Normalizasyon:
Veri tekrarını önlemek amacıyla tablolar 1NF ve 2NF kurallarına göre normalize edilmiştir.
1NF (First Normal Form): Her sütunda tek bir değer olması ve tekrar eden gruplar bulunmaması sağlanmıştır.
2NF (Second Normal Form): Her sütun anahtar sütunla tamamen ilişkili hale getirilmiştir. Özellikle "address" bilgileri "customers" ve "orders" tablosundan ayrılmış, "orderitems" bilgileri ayrı bir tablo halinde oluşturulmuş ve tablolar PK ve FK ile ilişkili hale getirilmiştir.

### 2. SQL Betikleri (Scripts)
Tüm veritabanı yapısını oluşturan ve örnek verileri ekleyen SQL betikleri aşağıdaki dosyada toplanmıştır.
•	Proje 1 SQL Dosyası: https://github.com/Sahin-05/SQL-End-to-End-Project/blob/main/Project-1_E-Commerce%20Database.sql 
Bu dosya aşağıdaki komutları içermektedir:
•	CREATE TABLE komutları (Tabloların ve veri tiplerinin oluşturulması) 
•	INSERT INTO komutları (Tabloların örnek verilerle doldurulması) 

### 3. Veri Doğrulama ve İlişki Kontrol Sorguları
Oluşturulan tabloların ve aralarındaki ilişkilerin doğruluğunu kontrol etmek için temel SELECT ve JOIN sorguları kullanılmıştır.

-- customers, customers_address, products, categories, orders, order_address, orderitems ve payments tablolarındaki verileri kontrol edilmiştir:

SELECT * FROM customers;
SELECT * FROM customers_address;
SELECT * FROM products;
SELECT * FROM categories;
SELECT * FROM orders;
SELECT * FROM order_address;
SELECT * FROM orderitems;
SELECT * FROM payments;

-- Tablolar arasındaki bire-bir, bire-çok ve çoka-çok ilişkileri kontrol edilmiştir: 

SELECT *
FROM customers c 
JOIN customers_address ca 
ON c.customer_id = ca.customer_id

SELECT *
FROM customers c 
JOIN orders o 
ON c.customer_id = o.customer_id 

SELECT *
FROM customers c 
JOIN payments p 
ON c.customer_id = p.customer_id 

SELECT *
FROM products p 
JOIN categories c 
ON p.product_code = c.product_code

SELECT *
FROM orders o 
JOIN order_address oa 
ON o.order_id = oa.order_id

SELECT *
FROM orders o
JOIN orderitems o2  
ON o.order_id = o2.order_id 

SELECT *
FROM orderitems o
JOIN products p  
ON o.product_code = p.product_code 

SELECT *
FROM orders o
JOIN payments p 
ON o.order_id = p.order_id

________________________________________

## Proje 2: Mevcut Veri Seti ile SQL Sorguları ve Analizler

Bu projenin ikinci aşamasında, "Brazilian E-Commerce Public Data" veri seti kullanılmıştır. Belirlenen 4 adet tablo (olist_orders_dataset.csv, olist_order_items_dataset.csv, olist_products_dataset.csv, olist_customers_dataset.csv) PostgreSQL veritabanına yüklenmiş, analiz sorguları çalıştırılmış ve sonuçlar görselleştirilmiştir.

### 1. Veri Yükleme Süreci
DBeaver'da bulunan database içerisinde "Brassilian E-Commerce" database'i oluşturulmuş ve bu database seçilerek “Tables” bölümünde “Import Data” ile belirtilen 4 tablo import edilmiştir. Import edilen tablolarda numeric data, NaN, null ve ' ' şeklindeki veri kontrolleri yapılmış ve gerekli veri tipi dönüşümleri gerçekleştirilmiştir.

### 2. SQL Sorguları ve Analizler (10 Sorgu)
Veri seti üzerinde iş analitiği, müşteri segmentasyonu ve ürün performansı gibi konulara odaklanan 10 adet SQL sorgusu hazırlanmıştır.
•	Proje 2 SQL Dosyası: https://github.com/Sahin-05/SQL-End-to-End-Project/blob/main/Brazilian%20E-Commerce.sql 

#### Soru 1: Olist'in aylık toplam gelirini hesaplayın. 

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

#### Soru 2: En çok satılan 10 ürün kategorisini bulun. 

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

#### Soru 3: Müşterileri toplam harcamalarına göre segmentlere ayırın (>1000 BRL = Premium, 500-1000 BRL = Regular, <500 BRL = Low)

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

#### Soru 4: Her ürün kategorisi için ortalama sipariş değerini (AOV) hesaplayın.

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

Değerlendirme: En yüksek ortalama sipariş değerine sahip ürün kategorisi “pcs”, en düşük değere sahip ürün “casa_conforto_2”. Ayrıca datasetinde kategorisi bilinmeyen (unknown) ürünlerin ortalama sipariş değeri 245.30’dur. 

#### Soru 5: Tekrar alım yapan müşterilerin sayısını ve toplam satışlara katkısını (%) hesaplayın.

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

#### Soru 6: En yüksek gelir getiren 10 eyaleti bulun.

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

#### Soru 7: Kategori bazında ortalama teslimat süresini (gün cinsinden) hesaplayın.

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
GROUP BY opd.product_category_name
ORDER BY average_delivery_days;

Değerlendirme: En hızlı teslim edilen ürün kategorisinin “artes_e_artesanato” (ortalama 5,29 gün), en uzun teslimat süresine sahip ürün kategorisinin “moveis_escritorio” (ortalama 20,39 gün) olduğu görülmektedir. 

#### Soru 8: En yüksek iade oranına sahip ürün kategorilerini bulun.

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
    		ROUND(COUNT(CASE WHEN ood.order_status IN ('canceled', 'unavailable') THEN 1 END)::numeric / COUNT(*) * 100, 2) 
    		AS returned_rate_percent
FROM olist_orders_dataset ood
JOIN olist_order_items_dataset ooid
ON ooid.order_id = ood.order_id
JOIN olist_products_dataset opd
ON ooid.product_id = opd.product_id
GROUP BY opd.product_category_name
ORDER BY returned_rate_percent DESC;

Değerlendirme: “pc_gamer” ütün kategorisi toplam 9 siparişte 1 olmak üzere % 11,11 oranı ile en yüksek iade oranına sahiptir. İade sayıları açısından değerlendirildiğinde en fazla geri iade edilen ürün “esperto_lazer” (51 kez)’dir. 14 kez geri iade edilen ürünlerin ürün kategorileri bilinmemektedir (unknown).

#### Soru 9: En yüksek satış yapan 10 satıcıyı ve kategorilerini bulun.

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

Değerlendirme: En yüksek satış değerine sahip ürün kategorisi “relegios_presentes”, en düşük değere sahip kategori “ferramentas_jardim”. Ancak, en yüksek satış sayısına sahip ürün kategorisinin de “ferramentas_jardim” olduğu görülmektedir. Bu açıdan bakıldığında “ferramentas_jardim” kategorisindeki ürünlerin diğer ürünlere göre uygun fiyatlı olduğu sonucuna varılabilir. 

#### Soru 10: Hafta içi ve hafta sonu sipariş sayılarını ve gelirlerini karşılaştırın. 

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

Değerlendirme: Ürünlerin yaklaşık %75’nin hafta içi sipariş verildiği görülmektedir. Hafta içi sipariş verilen ürünlerin toplam geliri hafta sonu verilenlerin 3 katından fazladır. Bununla birlikte, ortalama sipariş değerinin (teslim edilen her bir  sipariş için ortalama fiyat) hafta sonu siparişleri için çok az bir farkla yüksek olduğu görülmektedir.  

### 3. Veri Dışa Aktarma (Export)
Analiz sorgularından Soru 1, Soru 3 ve Soru 6'nın  çıktıları, görselleştirme araçlarında kullanılmak üzere PostgreSQL'den dışa aktarılmıştır.
•	Dışa Aktarılan Veri Klasörü: https://github.com/Sahin-05/SQL-End-to-End-Project/tree/main/Extracted%20Data 
o	aylik_gelir.csv (Soru 1) 
o	musteri_segmentleri.csv (Soru 3) 
o	en_yuksek_gelirli_eyaletler.csv (Soru 6) 

### 4. Sonuçların Görselleştirilmesi ve Raporlama (Tableau)
Dışa aktarılan 3 adet veri tablosu kullanılarak Tableau üzerinde bir dashboard oluşturulmuş ve Tableau Public platformuna yüklenmiştir.

Tableau Public Dashboard Linki:
https://public.tableau.com/app/profile/sahin.c./viz/Project2_Braziliane-commerce/Braziliane-commerce 

### 5. Proje Dosyaları (GitHub)
Bu proje için kullanılan tüm dosyalar (SQL betikleri, dışa aktarılan veriler ve Tableau dosyası ) bu GitHub reposunda mevcuttur.

## Proje 3: DuckDB Kütüphanesi üzerinden SQL Kullanımına Yönelik Capstone Proje
Proje: Veri Temizleme ve İstatistiksel Analiz ile Veri Seti Hazırlama (DuckDB Kullanarak SQL Sorguları) 
Veri Seti: Synthetic Car Sales Dataset Over Million Records

### 1. Veri Setinin İndirilmesi ve Yüklenmesi: 
• Synthetic Car Sales Dataset veri seti Kaggle'dan https://www.kaggle.com/datasets/jayavarman/synthetic-car-sales-dataset-over-million-records adresinden indirilmiştir. 
• DuckDB ile CSV dosyası yüklenmiş ve veri seti bir DuckDB veritabanı içinde kullanılabilir hale getirilmiştir. 

### 2. Veri İncelemesi ve İlk SQL Sorgusu:
• Veri kümesi yapısını inceleme: DuckDB üzerinden DESCRIBE komutu ile veri kümesinin yapısı, feature adları ve veri türleri kontrol edilmiştir. 
• İlk SQL sorgusu yazılarak ve SELECT komutu kullanılarak ilk 5 satır görülmüş, sütunlar ve veri türleri hakkında genel bir bilgi edinilmiştir. 

### 3. Veri Temizliği ve Düzenlenmesi: 
• Eksik veri tespiti: COUNT(*), WHERE, IS NULL gibi SQL sorguları ile eksik veya NULL değerler kontrol edilmiş ve eksik değer olmadığı görülmüştür. 
• Hatalı ve tutarsız veri tespiti: SELECT * FROM table WHERE Year < 1900 OR Year > 2025 OR Price < 0 OR Mileage < 0 şeklindeki bir SQL sorgusu ile mantıksız veriler sorgulanmış, bulunmadığı tespit edilmiştir. 
• Veri temizliği işlemleri: 
o NULL değerlerini doldurma: Null değerde veri bulunmamakla birlikte, bulunması durumunda UPDATE komutu ile ortalama ve en sık tekrar eden verilerle nasıl doldurulacağı örnek SQL sorguları ile gösterilmiştir. 
o Gereksiz sütunların silinmesi: ALTER TABLE, DROP COLUMN komutları ile “First Name”, Last Name” ve “Address” sütunları düşürülmüştür. 
o Veri türü dönüşümü: “Year” sütununun veri tipi BIGINT’ten DATE veri tipine dönüştürülmüştür. 

### 4. Temel İstatistiksel Analizler:
• Temel istatistiksel ölçümler: SQL sorguları ile ortalama, medyan, maksimum, minimum gibi temel istatistiksel ölçümler yapmıştır. Bu kapsamda; AVG(Price), MAX(Price), MIN(Price), median_price, median_mileage, AX(Year), MIN(Year), En_Eski_Aracın_Yaşı ve En_Yeni_Aracın_Yaşı görülmüştür.
• Gruplama ve kategorik analiz: Markaya göre ortalama, maximum ve minimum araç fiyatları; Modele göre ortalama, maximum ve minimum araç fiyatları; Color ve Condition durumlarına göre ortalama araç fiyatları, Ülkelere göre ortalama, maximum ve minimum araç fiyatları görülmüştür.

### 5. Zaman Serisi ve Trend Analizleri:
• Zaman Serisi ve Trend Analizi: Veri setinde “satış tarihi” veya benzeri bir zaman verisi bulunmadığından, araçların “üretim yılı” sütunu zaman serisi analizlerinde kullanılmıştır.  EXTRACT(YEAR FROM Year) ve GROUP BY Year komutları yardımıyla; 
- Üretim yıllarına göre satılan araç sayısı durumu (Çıkarım: Özellikle 2020-12 yılları arasında üretilen araçların ortalama fiyatının diğer yıllara göre yüksek olduğu görülmektedir.), 
- Üretim yıllarına göre satılan araç sayısı durumu (Çıkarım: Üretim yıllarına göre satılan araç sayısı durumunun birbirine yakın olduğu görülmektedir.),
- Araçların üretim yıllarına göre toplam satış toplamlarının dağılımı (Çıkarım: Araçların yıllara göre satış toplamlarının dağılımının 1,7e+09 etrafında yoğunlaştığı görülmektedir.),
- Araçların üretim yıllarına göre ortalama kilometre (mileage) değişimi (Çıkarım: Ortalama kilometre değişimlerinin 2018-2020 yıllarında en yüksek, 2021-2023 yılları arasında en düşük seviyede olduğu görülmektedir.),
- Araçların üretim yıllarına ve “Condition” (örn. Yeni / İkinci El) durumuna göre en çok satılan 20 araç (Çıkarım: 2001, 2002,2003, 2011, 2015 ve 2020 yılı üretimli araçlarda iki farklı, diğerlerinde tek "condition"a sahip araçların çoğunlukla satıldığı görülmektedir.),
- Araçların üretim yıllarına göre en çok araç satılan 20 ülke (Çıkarım: 2011 yılı üretimi araçların üç; 2001, 2005 ve 2015 yılı üretimi araçların iki, diğer yıl üretim araçların tek bir ülkede en fazla satıldığı görülmektedir.),
- Üretim yıllarına göre en çok satılan ilk 3 marka araç (Çıkarım: Son 10 yılda Nissan, Subaru, Toyota, Volkswagen, Chevrolet, Chrysler ve Hyundai marka araçların daha fazla satıldığı) analizleri yapılmıştır.

### 6. Veriyi Görselleştirme için SQL Sonuçlarını Çıkartma 
• SQL yöntemleri ile yapılan zaman serisi ve trend analizi ile elde edilen DuckDB analiz sonuçları Pandas DataFrame’e aktarılmış, Matplotlib veya Seaborn kütüphaneleri kullanılarak çeşitli grafiklerle görselleştirilmiş ve çıkarımlar eklenmiştir. 

### 7. Sonuçların Raporlanması ve Proje Sunumu:
• Proje sonunda elde edilen SQL sorguları ve analiz sonuçları Jupyter Notebook üzerinden oluşturulmuş ve aşağıda linki belirtilen GitHub reposunda yayınlanmıştır. 
Sahin-05/SQL-End-to-End-Project: SQL Project Files

