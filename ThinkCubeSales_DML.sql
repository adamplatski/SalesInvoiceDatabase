-- FileName: ThinkCubeSales_DML.sql
-- Description: Populate the ThinkCubeSales Database
-- 
-- Course: CST8215 - 301
-- Author: Adam Plater
-- Last Modified: 1 August 2020

-- CLEAR DEPENDANT TABLES -- 
DELETE FROM shipping_details;
DELETE FROM invoices_line;
DELETE FROM invoices;
DELETE FROM customers;

-- CLEAR PARENT TABLES --
DELETE FROM addresses;
DELETE FROM jobs;
DELETE FROM salespeople;
DELETE FROM products;
DELETE FROM sellers;
DELETE FROM shipping_providers;

-- CREATE SAMPLE DATA --

-- Add Address Data
INSERT INTO addresses ( address_id, address_description, address_street, address_city, address_prov, address_postcode, address_phone )
	VALUES 	( 1, 'SalesHop Inc', '987 Bank Street', 'Ottawa', 'ON', 'K9K9K9', '613-555-6668' ),
		( 2, 'SignStallers Corp', '456 Walkley Road', 'Ottawa', 'ON', 'K4D4D4', '613-555-8887' );

-- Add Seller Location Data
INSERT INTO sellers ( seller_id, seller_description, seller_address, seller_city, seller_prov, seller_postcode, seller_phone, seller_fax, seller_email ) 
	VALUES 	( 'THINKS', 'ThinkCube Soft Inc.', '544 SomeStreet', 'Ottawa', 'ON', 'K1Z1Z1', '613-555-1212', '613-555-1313', 'sales@thinkcube.fake' );

-- Add Shipping Provider(s) Data
INSERT INTO shipping_providers ( provider_id, provider_description )
	VALUES 	( 1, 'FedEX' );

-- Add Job(s) Data
INSERT INTO jobs ( job_id, job_description )
	VALUES 	(1, 'Project for SalesHop Inc and SignStallers Corp' );

-- Add Salesperson(s) Data
INSERT INTO salespeople ( sales_id, sales_fname, sales_lname )
	VALUES 	( 'JOEB', 'Joe', 'B' );

-- Add Product(s) Data
INSERT INTO products ( prod_id, prod_description, prod_price, prod_quantity )
	VALUES 	( 'SC10', 'SignCreator 10.0', 1250.00, 50 ),
		( 'MFF', 'Fabolous Fonts addon', 100.00, 50 ),
		( 'ME33', 'Big Roll Vinyl Stick Back 60"', 550.00, 10 );

-- Add Customer(s) Data
INSERT INTO customers ( cust_id, cust_fname, cust_lname, cust_email, cust_address_id, cust_balance )
	VALUES 	( 856523, 'John', 'Doe', 'johndoe@example.com', 1 , 0 ),
		( 887452, 'Jim', 'Bob', 'jimbob@example.com', 2, 0 );

-- Add Invoice(s) Data
INSERT INTO invoices ( invoice_number, invoice_date, invoice_seller_id, invoice_cust_id, invoice_sales_id, invoice_job_id, invoice_payment, "invoice_payment_DD", cust_shipping_id )
	VALUES 	( 523658, '20160623', 'THINKS', 856523, 'JOEB', 1, 30, '20160722', 887452 );

-- Add Invoice(s) Line Data
INSERT INTO invoices_line ( invoice_number, invoice_line, prod_id, line_quantity, line_discount )
	VALUES	( 523658, 1, 'SC10', 1, 0 ),
		( 523658, 2, 'MFF', 1, 0.5 ),
		( 523658, 3, 'ME33', 3, 0.1 );

-- Add Shipping Detail(s) Data
INSERT INTO shipping_details ( invoice_number, shipping_provider_id, ship_date, ship_arrival_date )
	VALUES 	( 523658, 1, '20160627', '20160629' );

-- eof: ThinkCubeSales_DML.sql