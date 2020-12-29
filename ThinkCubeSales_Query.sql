-- FileName: ThinkCubeSales_Query.sql
-- Description: Query the ThinkCubeSales Database:
-- Contains Basic Queries, View Queries, and implicit JOIN Statements
-- Course: CST8215 - 301
-- Author: Adam Plater
-- Last Modified: 1 August 2020


-- Display inserted sample data
SELECT * FROM sellers;
SELECT * FROM addresses;
SELECT * FROM shipping_providers;
SELECT * FROM jobs;
SELECT * FROM salespeople;
SELECT * FROM products;
SELECT * FROM customers;
SELECT * FROM invoices;
SELECT * FROM invoices_line;
SELECT * FROM shipping_details;

-- INVOICE "shippers" section
SELECT 	invoices.invoice_date,
	invoices.invoice_number,
	sellers.seller_description,
	sellers.seller_address,
	sellers.seller_city,
	sellers.seller_prov,
	sellers.seller_postcode,
	sellers.seller_phone,
	sellers.seller_fax,
	sellers.seller_email
		
FROM 	invoices, sellers
WHERE 	invoices.invoice_number = 523658
AND 	invoices.invoice_seller_id = sellers.seller_id;

-- INVOICE "Bill to" section
SELECT 	customers.cust_fname,
	customers.cust_lname,
	addresses.address_description,
	addresses.address_street,
	addresses.address_city,
	addresses.address_prov,
	addresses.address_postcode,
	addresses.address_phone,
	customers.cust_id

FROM	invoices, customers, addresses
WHERE 	invoices.invoice_number = 523658
AND	invoices.invoice_cust_id = customers.cust_id
AND	customers.cust_address_id = addresses.address_id;

-- INVOICE "Ship to" section
SELECT 	customers.cust_fname,
	customers.cust_lname,
	addresses.address_description,
	addresses.address_street,
	addresses.address_city,
	addresses.address_prov,
	addresses.address_postcode,
	addresses.address_phone,
	customers.cust_id

FROM	invoices, customers, addresses
WHERE 	invoices.invoice_number = 523658
AND	invoices.cust_shipping_id = customers.cust_id
AND	customers.cust_address_id = addresses.address_id;


-- INVOICE shipping terms line
SELECT	salespeople.sales_fname,
	salespeople.sales_lname,
	jobs.job_description,
	shipping_providers.provider_description,
	shipping_details.ship_arrival_date - shipping_details.ship_date AS "Shipping Terms",
	shipping_details.ship_arrival_date,
	invoices.invoice_payment,
	invoices."invoice_payment_DD"

FROM 	invoices,
	salespeople,
	jobs,
	shipping_details,
	shipping_providers

WHERE 	invoices.invoice_number = 523658
AND 	invoices.invoice_job_id = jobs.job_id
AND	invoices.invoice_sales_id = salespeople.sales_id
AND	shipping_details.invoice_number = invoices.invoice_number
AND 	shipping_details.shipping_provider_id = shipping_providers.provider_id;

-- INVOICE product lines
SELECT
	invoices_line.line_quantity,
	products.prod_id,
	products.prod_description,
	products.prod_price,
	invoices_line.line_discount,
	(products.prod_price - (products.prod_price * invoices_line.line_discount)) * invoices_line.line_quantity AS line_total
	
FROM	invoices, invoices_line, products
WHERE	invoices.invoice_number = 523658
AND	invoices_line.invoice_number = invoices.invoice_number
AND	products.prod_id = invoices_line.prod_id;


-- INVOICE totals section

SELECT 	Discount_V.total_discount,
	Subtotal_V.subtotal,
	HST_V.HST,
	Subtotal_V.subtotal + HST_V.HST AS total
FROM Discount_V, Subtotal_V, HST_V;

-- eof: ThinkCubeSales_Query.sql