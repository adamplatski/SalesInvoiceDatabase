-- FileName: ThinkCubeSales_DDL.sql
-- Description: Creation of the ThinkCubeSales Database, Creates Tables and Views.
-- Imported from pgModeler
-- Course: CST8215 - 301
-- Author: Adam Plater
-- Last Modified: 1 August 2020

-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.9.1
-- PostgreSQL version: 10.0
-- Project Site: pgmodeler.io
-- Model Author(s): Adam Plater-Zyberk, Andrew Smiley, Tim Beattie


-- Database creation must be done outside a multicommand file.
-- These commands were put in this file only as a convenience.
-- -- object: new_database | type: DATABASE --
-- -- DROP DATABASE IF EXISTS new_database;
-- CREATE DATABASE new_database;
-- -- ddl-end --
-- 

-- DROP VIEW Statements before dropping tables
DROP VIEW IF EXISTS Discount_V;
DROP VIEW IF EXISTS HST_V;
DROP VIEW IF EXISTS Subtotal_V;

-- object: public.products | type: TABLE --
DROP TABLE IF EXISTS public.products CASCADE;
CREATE TABLE public.products(
	prod_id char(5) NOT NULL,
	prod_description character varying(60) NOT NULL,
	prod_price numeric(7,2) NOT NULL,
	prod_quantity integer NOT NULL,
	CONSTRAINT products_pk PRIMARY KEY (prod_id)

);
-- ddl-end --
ALTER TABLE public.products OWNER TO postgres;
-- ddl-end --

-- object: public.invoices | type: TABLE --
DROP TABLE IF EXISTS public.invoices CASCADE;
CREATE TABLE public.invoices(
	invoice_number serial NOT NULL,
	invoice_date timestamp NOT NULL,
	invoice_seller_id char(6) NOT NULL,
	invoice_cust_id serial NOT NULL,
	invoice_sales_id char(4) NOT NULL,
	invoice_job_id serial,
	invoice_payment integer,
	"invoice_payment_DD" timestamp,
	cust_shipping_id serial,
	CONSTRAINT invoices_pk PRIMARY KEY (invoice_number)

);
-- ddl-end --
COMMENT ON COLUMN public.invoices.invoice_payment IS 'payment terms, measured in Days';
-- ddl-end --
COMMENT ON COLUMN public.invoices."invoice_payment_DD" IS 'Will have to add the number of days from invoice_date + invoice_payment';
-- ddl-end --
ALTER TABLE public.invoices OWNER TO postgres;
-- ddl-end --

-- object: public.invoices_line | type: TABLE --
DROP TABLE IF EXISTS public.invoices_line CASCADE;
CREATE TABLE public.invoices_line(
	invoice_number serial NOT NULL,
	invoice_line integer NOT NULL,
	prod_id char(5) NOT NULL,
	line_quantity integer,
	line_discount numeric(9,2),
	CONSTRAINT invoices_line_pk PRIMARY KEY (invoice_number,invoice_line)

);
-- ddl-end --
ALTER TABLE public.invoices_line OWNER TO postgres;
-- ddl-end --

-- object: public.addresses | type: TABLE --
DROP TABLE IF EXISTS public.addresses CASCADE;
CREATE TABLE public.addresses(
	address_id serial NOT NULL,
	address_street character varying(20) NOT NULL,
	address_city character varying(20) NOT NULL,
	address_prov char(2) NOT NULL,
	address_postcode char(6) NOT NULL,
	address_phone character varying(15) NOT NULL,
	address_description character varying(60),
	CONSTRAINT shipping_addresses_pk PRIMARY KEY (address_id)

);
-- ddl-end --
ALTER TABLE public.addresses OWNER TO postgres;
-- ddl-end --

-- object: public.customers | type: TABLE --
DROP TABLE IF EXISTS public.customers CASCADE;
CREATE TABLE public.customers(
	cust_id serial NOT NULL,
	cust_fname character varying(30),
	cust_lname character varying(30) NOT NULL,
	cust_email character varying(50) NOT NULL,
	cust_address_id serial NOT NULL,
	cust_balance numeric(9,2) NOT NULL DEFAULT 0,
	CONSTRAINT customers_pk PRIMARY KEY (cust_id)

);
-- ddl-end --
ALTER TABLE public.customers OWNER TO postgres;
-- ddl-end --

-- object: public.salespeople | type: TABLE --
DROP TABLE IF EXISTS public.salespeople CASCADE;
CREATE TABLE public.salespeople(
	sales_id char(4) NOT NULL,
	sales_fname character varying(30),
	sales_lname character varying(30) NOT NULL,
	CONSTRAINT salespeople_pk PRIMARY KEY (sales_id)

);
-- ddl-end --
ALTER TABLE public.salespeople OWNER TO postgres;
-- ddl-end --

-- object: public.shipping_providers | type: TABLE --
DROP TABLE IF EXISTS public.shipping_providers CASCADE;
CREATE TABLE public.shipping_providers(
	provider_id serial NOT NULL,
	provider_description character varying(100) NOT NULL,
	CONSTRAINT shipping_providers_pk PRIMARY KEY (provider_id)

);
-- ddl-end --
ALTER TABLE public.shipping_providers OWNER TO postgres;
-- ddl-end --

-- object: public.jobs | type: TABLE --
DROP TABLE IF EXISTS public.jobs CASCADE;
CREATE TABLE public.jobs(
	job_id serial NOT NULL,
	job_description character varying(10000),
	CONSTRAINT jobs_pk PRIMARY KEY (job_id)

);
-- ddl-end --
ALTER TABLE public.jobs OWNER TO postgres;
-- ddl-end --

-- object: public.sellers | type: TABLE --
DROP TABLE IF EXISTS public.sellers CASCADE;
CREATE TABLE public.sellers(
	seller_id char(6) NOT NULL,
	seller_description character varying(60) NOT NULL,
	seller_address character varying(20),
	seller_city character varying(20) NOT NULL,
	seller_prov char(2) NOT NULL,
	seller_postcode character(6) NOT NULL,
	seller_phone character varying(15) NOT NULL,
	seller_fax character varying(15),
	seller_email character varying(50) NOT NULL,
	CONSTRAINT sellers_pk PRIMARY KEY (seller_id)

);
-- ddl-end --
ALTER TABLE public.sellers OWNER TO postgres;
-- ddl-end --

-- object: public.shipping_details | type: TABLE --
DROP TABLE IF EXISTS public.shipping_details CASCADE;
CREATE TABLE public.shipping_details(
	invoice_number serial NOT NULL,
	shipping_provider_id serial NOT NULL,
	ship_date timestamp NOT NULL,
	ship_arrival_date timestamp NOT NULL,
	CONSTRAINT shipping_details_pk PRIMARY KEY (invoice_number)

);
-- ddl-end --
ALTER TABLE public.shipping_details OWNER TO postgres;
-- ddl-end --

-- object: invoice_seller_id | type: CONSTRAINT --
-- ALTER TABLE public.invoices DROP CONSTRAINT IF EXISTS invoice_seller_id CASCADE;
ALTER TABLE public.invoices ADD CONSTRAINT invoice_seller_id FOREIGN KEY (invoice_seller_id)
REFERENCES public.sellers (seller_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: invoice_cust_id | type: CONSTRAINT --
-- ALTER TABLE public.invoices DROP CONSTRAINT IF EXISTS invoice_cust_id CASCADE;
ALTER TABLE public.invoices ADD CONSTRAINT invoice_cust_id FOREIGN KEY (invoice_cust_id)
REFERENCES public.customers (cust_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: invoice_sales_id | type: CONSTRAINT --
-- ALTER TABLE public.invoices DROP CONSTRAINT IF EXISTS invoice_sales_id CASCADE;
ALTER TABLE public.invoices ADD CONSTRAINT invoice_sales_id FOREIGN KEY (invoice_sales_id)
REFERENCES public.salespeople (sales_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: invoice_job_id | type: CONSTRAINT --
-- ALTER TABLE public.invoices DROP CONSTRAINT IF EXISTS invoice_job_id CASCADE;
ALTER TABLE public.invoices ADD CONSTRAINT invoice_job_id FOREIGN KEY (invoice_job_id)
REFERENCES public.jobs (job_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: cust_shipping_id_fk | type: CONSTRAINT --
-- ALTER TABLE public.invoices DROP CONSTRAINT IF EXISTS cust_shipping_id_fk CASCADE;
ALTER TABLE public.invoices ADD CONSTRAINT cust_shipping_id_fk FOREIGN KEY (cust_shipping_id)
REFERENCES public.customers (cust_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: prod_id | type: CONSTRAINT --
-- ALTER TABLE public.invoices_line DROP CONSTRAINT IF EXISTS prod_id CASCADE;
ALTER TABLE public.invoices_line ADD CONSTRAINT prod_id FOREIGN KEY (prod_id)
REFERENCES public.products (prod_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: invoice_number | type: CONSTRAINT --
-- ALTER TABLE public.invoices_line DROP CONSTRAINT IF EXISTS invoice_number CASCADE;
ALTER TABLE public.invoices_line ADD CONSTRAINT invoice_number FOREIGN KEY (invoice_number)
REFERENCES public.invoices (invoice_number) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: cust_address_fk | type: CONSTRAINT --
-- ALTER TABLE public.customers DROP CONSTRAINT IF EXISTS cust_address_fk CASCADE;
ALTER TABLE public.customers ADD CONSTRAINT cust_address_fk FOREIGN KEY (cust_address_id)
REFERENCES public.addresses (address_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: ship_provider_id | type: CONSTRAINT --
-- ALTER TABLE public.shipping_details DROP CONSTRAINT IF EXISTS ship_provider_id CASCADE;
ALTER TABLE public.shipping_details ADD CONSTRAINT ship_provider_id FOREIGN KEY (shipping_provider_id)
REFERENCES public.shipping_providers (provider_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: invoice_fk | type: CONSTRAINT --
-- ALTER TABLE public.shipping_details DROP CONSTRAINT IF EXISTS invoice_fk CASCADE;
ALTER TABLE public.shipping_details ADD CONSTRAINT invoice_fk FOREIGN KEY (invoice_number)
REFERENCES public.invoices (invoice_number) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- Create VIEWS --

-- View that calculates the sum of the price reduced by discounted prices.
-- Calculated using implicit JOIN statements.
CREATE VIEW Discount_V AS
SELECT SUM( invoices_line.line_quantity * 
		( products.prod_price * invoices_line.line_discount )
	) AS total_discount
FROM	invoices, invoices_line, products
WHERE	invoices.invoice_number = 523658
AND	invoices_line.invoice_number = invoices.invoice_number
AND	products.prod_id = invoices_line.prod_id;

-- View that calculates the Subtotal of the invoice after all discounts.
-- Calculated using implicit JOIN statements.
CREATE VIEW Subtotal_V AS
SELECT SUM(
		(products.prod_price - (products.prod_price * invoices_line.line_discount)) 
		* invoices_line.line_quantity
	) AS subtotal
FROM	invoices, invoices_line, products
WHERE	invoices.invoice_number = 523658
AND	invoices_line.invoice_number = invoices.invoice_number
AND	products.prod_id = invoices_line.prod_id;

-- View that calculates the amount of tax that will be added to the total of the of the invoice.
-- Calculated using implicit JOIN statements.
CREATE VIEW HST_V AS
SELECT subtotal * 0.13 AS HST
FROM Subtotal_V;

-- eof: ThinkCubeSales_DDL.sql