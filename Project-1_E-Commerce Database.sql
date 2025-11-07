---------- 1. PROJE: VERİ TABANI OLUŞTURMA VE YAPILANDIRMA ----------


--1 : VERİ TABANI TASARIMI: 

/*E-ticaret sitesi için CREATE TABLE komutu ile customers, customers_address, products, categories, orders,
 order_address, orderitems ve payments olmak üzere toplam 8 adet tablo oluşturulmuştur.*/

--2 : NORMALİZASYON VE TABLOLARIN OPTİMİZE EDİLMESİ:

/* 1NF (First Normal Form): Her sütunda tek bir değer olması ve tekrar eden gruplar bulunmaması sağlanmıştır.
   2NF (Second Normal Form): Her sütun anahtar sütunla tamamen ilişkili hale getirilmiştir. Özellikle "address" bilgileri
   "customers" ve "orders" tablosundan ayrılmış, "orderitems" bilgileri ayrı bir tablo halinde oluşturulmuş ve tablolar PK ve FK ile
   ilişkili hale getirilmiştir.*/ 

--3: RELATIONAL (İLİŞKİSEL) TABLOLARIN OLUŞTURULMASI:

/* Tablolar arasında ilişkiler PK ve FK'lar aracılığı ile tesis edilmiş ve aşağıdaki ilişki türleri oluşturulmuştur:
 
 * customers ile orders arasında bire çok ilişki (Bir müşteri birçok sipariş verebilir) 
 * orders ile orderitems arasında bire çok ilişki (Bir sipariş içerisinde birden fazla ürün olabilir)
 * products ile orderitems arasında bire çok ilişki (Bir ürün birçok siparişte yer alabilir.)
 * products ile categories arasında bire çok ilişki (Her ürün yalnızca bir kategoriye aittir.)
 * customers ile customers_address arasında bire çok ilişki (Bir müşteriye birden fazla adres tanımlanabilir.)
 * customers ile order_address arasında bire çok ilişki (Bir müşteri birçok siparişte farklı adresler kullanabilir.)
 * orders ile order_address arasında bire bir ilişki (Her siparişin bir teslimat adresi vardır.)
 * orders ile payments arasında bire çok ilişki (Bir siparişin bir veya birden fazla ödeme kaydı olabilir.)
 * customers ile payments arasında bire çok ilişki (Bir müşteri birçok ödeme işlemi yapabilir.)
 * customers ile products arasında orderitems köprü tablosu üzerinden çoka çok ilişki (Müşteri birçok ürün satın alabilir, ürün birçok müşteri tarafından satın alınabilir.)
 * */

--4: VERİTABANI ŞEMASI VE TABLOLARIN OLUŞTURULMASI:

/* Tablolar uygun veri tipleri ile oluşturulmuş ve Pubic/Tables/Diagram sayfasında veritabanı şeması elde edilmiştir.*/

-- 5: VERİ TİPLERİNİN BELİRLENMESİ VE DOLDURULMASI:

/* Veri tipleri sütunlarda bulunan verilere uygun olarak belirlenmiş ve AI yardımı ile üretilen veriler INSERT INTO
 komutu ile tablolara girilmiştir.*/

CREATE TABLE customers (
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR (50) NOT NULL,
	last_name VARCHAR (50) NOT NULL,
	gender VARCHAR(6) CHECK (gender IN ('Male', 'Female')),
	email VARCHAR (50) UNIQUE,
	password_ VARCHAR (50),
	phone_num VARCHAR (15),
	created_date DATE DEFAULT CURRENT_DATE
	);

CREATE TABLE customers_address (
	id SERIAL PRIMARY KEY,
	customer_id INTEGER,
	country VARCHAR (50) NOT NULL,
	city VARCHAR (50) NOT NULL,
	town VARCHAR (50),
	district VARCHAR(50),
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
	);

CREATE TABLE products (
	Id SERIAL,
	product_code INTEGER PRIMARY KEY,
	product_name VARCHAR(100),
	unit_price REAL,
	stock_total INTEGER
	);

CREATE TABLE categories (
	category_id INTEGER PRIMARY KEY,
	product_code INTEGER,
	category_1 VARCHAR(50),
	category_2 VARCHAR(50),
	category_3 VARCHAR(50),
	FOREIGN KEY (product_code) REFERENCES products(product_code)
	);

CREATE TABLE orders (
	order_id SERIAL PRIMARY KEY,
	customer_id INTEGER,
	order_date DATE,
	cargo_type VARCHAR(50),
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
	);

CREATE TABLE order_address (
	id SERIAL PRIMARY KEY,
	customer_id INTEGER,
	order_id INTEGER,
	country VARCHAR (50) NOT NULL,
	city VARCHAR (50) NOT NULL,
	town VARCHAR (50) NOT NULL,
	district VARCHAR(50) NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
	FOREIGN KEY (order_id) REFERENCES orders(order_id)
	);

CREATE TABLE orderitems (
	id SERIAL PRIMARY KEY,
	order_id INTEGER,
	product_code INTEGER,
	quantity INTEGER,
	total_price REAL,
	FOREIGN KEY (order_id) REFERENCES orders(order_id),
	FOREIGN KEY (product_code) REFERENCES products(product_code)
	);

CREATE TABLE payments (
	Id SERIAL PRIMARY KEY,
	customer_id INTEGER,
	order_id INTEGER,
	payment_type VARCHAR(20),
	payment_status VARCHAR(20) CHECK (payment_status IN ('Approved', 'Denied')),
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
	FOREIGN KEY (order_id) REFERENCES orders(order_id)
	);

INSERT INTO customers (first_name, last_name, gender, email, password_, phone_num, created_date)
VALUES
('Ahmet', 'Yılmaz', 'Male', 'ahmet.yilmaz@example.com', 'Ahmet123', '05321234567', '2025-10-01'),
('Ayşe', 'Kara', 'Female', 'ayse.kara@example.com', 'Ayse456', '05339876543', '2025-10-02'),
('Mehmet', 'Demir', 'Male', 'mehmet.demir@example.com', 'Mehmet789', '05321112233', '2025-10-03'),
('Elif', 'Çetin', 'Female', 'elif.cetin@example.com', 'Elif2025', '05443332211', '2025-10-04'),
('Can', 'Aydın', 'Male', 'can.aydin@example.com', 'Can555', '05557778899', '2025-10-05'),
('Zeynep', 'Koç', 'Female', 'zeynep.koc@example.com', 'Zeynep789', '05061234567', '2025-10-06'),
('Emre', 'Şahin', 'Male', 'emre.sahin@example.com', 'Emre999', '05073456789', '2025-10-06'),
('Selin', 'Arslan', 'Female', 'selin.arslan@example.com', 'Selin111', '05345678901', '2025-10-06'),
('Kerem', 'Yalçın', 'Male', 'kerem.yalcin@example.com', 'Kerem321', '05498765432', '2025-10-06'),
('Naz', 'Öztürk', 'Female', 'naz.ozturk@example.com', 'Naz654', '05556789012', '2025-10-06');

INSERT INTO customers_address (customer_id, country, city, town, district)
VALUES
(1, 'Türkiye', 'İstanbul', 'Kadıköy', 'Fenerbahçe'),
(2, 'Türkiye', 'Ankara', 'Çankaya', 'Yıldızevler'),
(3, 'Türkiye', 'İzmir', 'Konak', 'Alsancak'),
(4, 'Türkiye', 'Bursa', 'Nilüfer', 'Görükle'),
(5, 'Türkiye', 'Antalya', 'Muratpaşa', 'Kızıltoprak'),
(6, 'Türkiye', 'Eskişehir', 'Odunpazarı', 'Vișnelik'),
(7, 'Türkiye', 'Samsun', 'Atakum', 'Körfez'),
(8, 'Türkiye', 'Trabzon', 'Ortahisar', 'Boztepe'),
(9, 'Türkiye', 'Gaziantep', 'Şahinbey', 'Karataş'),
(10, 'Türkiye', 'Konya', 'Selçuklu', 'Bosna Hersek');

INSERT INTO products (product_code, product_name, unit_price, stock_total)
VALUES
(1001, 'Dizüstü Bilgisayar', 28999.99, 15),
(1002, 'Masaüstü Bilgisayar', 24999.50, 10),
(1003, 'Akıllı Telefon', 18999.00, 25),
(1004, 'Tablet', 10999.90, 30),
(1005, 'Kablosuz Kulaklık', 2499.99, 50),
(1006, 'Bluetooth Hoparlör', 1799.00, 40),
(1007, 'Akıllı Saat', 5499.00, 20),
(1008, 'Oyun Konsolu', 23999.00, 12),
(1009, 'Klavye', 899.00, 70),
(1010, 'Mouse', 599.00, 80),
(1011, 'Monitör 27 inç', 7499.00, 18),
(1012, 'Harici Hard Disk 1TB', 1999.00, 25),
(1013, 'USB Bellek 64GB', 399.00, 100),
(1014, 'Yazıcı', 3499.00, 15),
(1015, 'Web Kamera', 1299.00, 30),
(1016, 'Router (Modem)', 1599.00, 20),
(1017, 'Ekran Kartı RTX 4070', 29999.00, 8),
(1018, 'RAM 16GB DDR5', 2999.00, 35),
(1019, 'SSD 1TB NVMe', 3999.00, 28),
(1020, 'Güç Kaynağı 750W', 1899.00, 22);

INSERT INTO categories (category_id, category_1, category_2, category_3, product_code)
VALUES
(1,  'Bilgisayar', 'Dizüstü Bilgisayar', 'Oyun Laptopu', 1001),
(2,  'Bilgisayar', 'Masaüstü Bilgisayar', 'Ofis Tipi', 1002),
(3,  'Telefon & Aksesuar', 'Akıllı Telefon', 'Android', 1003),
(4,  'Tablet & Aksesuar', 'Tablet', '10 inç Ekran', 1004),
(5,  'Ses Sistemleri', 'Kulaklık', 'Kablosuz', 1005),
(6,  'Ses Sistemleri', 'Hoparlör', 'Bluetooth', 1006),
(7,  'Giyilebilir Teknoloji', 'Akıllı Saat', 'Spor Serisi', 1007),
(8,  'Oyun & Eğlence', 'Konsol', 'PlayStation', 1008),
(9,  'Bilgisayar Aksesuarları', 'Klavye', 'Mekanik', 1009),
(10, 'Bilgisayar Aksesuarları', 'Mouse', 'Kablosuz', 1010),
(11, 'Ekranlar', 'Monitör', '27 inç LED', 1011),
(12, 'Depolama', 'Harici Disk', '1TB', 1012),
(13, 'Depolama', 'USB Bellek', '64GB', 1013),
(14, 'Ofis Ekipmanları', 'Yazıcı', 'Lazer Yazıcı', 1014),
(15, 'Görüntü & Ses', 'Web Kamera', 'Full HD', 1015),
(16, 'Ağ Ürünleri', 'Router', 'Çift Bant', 1016),
(17, 'Bilgisayar Parçaları', 'Ekran Kartı', 'RTX Serisi', 1017),
(18, 'Bilgisayar Parçaları', 'RAM', 'DDR5 16GB', 1018),
(19, 'Bilgisayar Parçaları', 'SSD', '1TB NVMe', 1019),
(20, 'Bilgisayar Parçaları', 'Güç Kaynağı', '750W', 1020);

INSERT INTO orders (customer_id, order_date, cargo_type)
VALUES
    (1, '2025-09-15', 'Standart'),
    (3, '2025-09-17', 'Hızlı Teslimat'),
    (5, '2025-09-18', 'Kargo Sigortalı'),
    (2, '2025-09-20', 'Standart'),
    (7, '2025-09-22', 'Ekspres'),
    (4, '2025-09-25', 'Standart'),
    (9, '2025-09-27', 'Kırılabilir Ürün');

INSERT INTO order_address (customer_id, order_id, country, city, town, district)
VALUES
    (1, 1, 'Türkiye', 'İstanbul', 'Kadıköy', 'Moda'),
    (3, 2, 'Türkiye', 'Ankara', 'Çankaya', 'Kızılay'),
    (5, 3, 'Türkiye', 'İzmir', 'Karşıyaka', 'Bostanlı'),
    (2, 4, 'Türkiye', 'Bursa', 'Nilüfer', 'Görükle'),
    (7, 5, 'Türkiye', 'Antalya', 'Muratpaşa', 'Lara'),
    (4, 6, 'Türkiye', 'Konya', 'Selçuklu', 'Bosna Hersek'),
    (9, 7, 'Türkiye', 'Trabzon', 'Ortahisar', 'Boztepe');

INSERT INTO orderitems (order_id, product_code, quantity, total_price)
VALUES
-- Sipariş 1 (customer_id = 1)
(1, 1001, 2, 2 * 59.99),
(1, 1005, 1, 1 * 89.50),

-- Sipariş 2 (customer_id = 3)
(2, 1003, 3, 3 * 25.75),
(2, 1010, 2, 2 * 45.00),

-- Sipariş 3 (customer_id = 5)
(3, 1008, 1, 1 * 120.00),
(3, 1015, 2, 2 * 35.25),

-- Sipariş 4 (customer_id = 2)
(4, 1002, 5, 5 * 12.99),
(4, 1018, 1, 1 * 99.90),

-- Sipariş 5 (customer_id = 7)
(5, 1006, 2, 2 * 75.50),
(5, 1012, 3, 3 * 22.00),

-- Sipariş 6 (customer_id = 4)
(6, 1011, 1, 1 * 250.00),
(6, 1017, 4, 4 * 40.75),

-- Sipariş 7 (customer_id = 9)
(7, 1009, 2, 2 * 15.99),
(7, 1019, 1, 1 * 110.00);

INSERT INTO payments (customer_id, order_id, payment_type, payment_status)
VALUES
-- Sipariş 1 (Ahmet Yılmaz)
(1, 1, 'Credit Card', 'Approved'),

-- Sipariş 2 (Mehmet Demir)
(3, 2, 'Bank Transfer', 'Approved'),

-- Sipariş 3 (Can Aydın)
(5, 3, 'Cash', 'Denied'),

-- Sipariş 4 (Ayşe Kara)
(2, 4, 'Credit Card', 'Approved'),

-- Sipariş 5 (Emre Şahin)
(7, 5, 'Credit Card', 'Approved'),

-- Sipariş 6 (Elif Çetin)
(4, 6, 'Bank Transfer', 'Denied'),

-- Sipariş 7 (Kerem Yalçın)
(9, 7, 'Cash', 'Approved');


-- 6: VERİTABANI VE TABLOLARIN DOĞRULAMASI:

SELECT *
FROM customers

SELECT *
FROM customers_address

SELECT *
FROM products

SELECT *
FROM categories

SELECT *
FROM orders

SELECT *
FROM order_address

SELECT *
FROM orderitems

SELECT *
FROM payments


-- 7: VERİTABANI İLİŞKİLERİNİN DOĞRULUĞUNU KONTROL ETME:

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
