-- create user
CREATE USER ecom_app WITH ENCRYPTED PASSWORD '********';

-- Create the DB
CREATE DATABASE ecomm WITH
ENCODING = 'UTF8',
OWNER = ecom_app,
CONNECTION LIMIT = 1000;

-- grant accesses
GRANT ALL PRIVILEGES ON DATABASE ecom TO ecom_app;

-- Table contains manufacture details
CREATE TABLE manufacture (
	id varchar(32),
	name varchar(50) NOT NULL,
	address varchar(80) NOT NULL,
	city varchar(30) NOT NULL,
	created_at timestamp default timestamp,
	updated_at timestamp default timestamp,
	PRIMARY KEY (id)
);

-- trigger to capture the current timestamp in the col updated_at for any update
CREATE TRIGGER manufacture_moddatetime
    BEFORE UPDATE ON manufacture
    FOR EACH ROW
    EXECUTE PROCEDURE moddatetime (updated_at);

-- Table contians details of the items available in the ecomm system
CREATE TABLE item (
	id varchar(32),
	name varchar(50) NOT NULL,
	manufacture_id varchar(32),
	cost number(10,2) NOT NULL,
	wieght number(6,3) NOT NULL,
	created_at timestamp default timestamp,
	updated_at timestamp default timestamp,
	PRIMARY KEY (id),
	CONSTRAINT fk_manufacture FOREIGN KEY(manufacture_id) REFERENCES manufacture(id)
);

-- Index created on the manufacture_id as it will be used to join with the table manufacture
CREATE INDEX idx_item_manufacture_id 
ON item(manufacture_id);

-- trigger to capture the current timestamp in the col updated_at for any update
CREATE TRIGGER item_moddatetime
    BEFORE UPDATE ON item
    FOR EACH ROW
    EXECUTE PROCEDURE moddatetime (updated_at);

-- Table contians details of the members registered in the ecomm platform
CREATE TABLE membership (
	id varchar(32),
	first_name varchar(30),
	last_name varchar(30) NOT NULL,
	dob date NOT NULL,
	mobile varchar(15) NOT NULL,
	email varchar(60) NOT NULL,
	created_at timestamp default timestamp,
	updated_at timestamp default timestamp,
	PRIMARY KEY (id)
);

-- Index created on the email as it is unique for each customer so will be used in the sqls
CREATE INDEX idx_membership_email 
ON membership(email);

-- trigger to capture the current timestamp in the col updated_at for any update
CREATE TRIGGER membership_moddatetime
    BEFORE UPDATE ON membership
    FOR EACH ROW
    EXECUTE PROCEDURE moddatetime (updated_at);

-- Table captures the payment details
CREATE TABLE payment (
	id varchar(32),
	type varchar(30) NOT NULL,
	amount number(10,2) NOT NULL,
	payment_dt date NOT NULL,
	created_at timestamp default timestamp,
	updated_at timestamp default timestamp,
	PRIMARY KEY (id)
);

-- Index created on the payment_dt as it will be used a lot for analytics
CREATE INDEX idx_payment_payment_dt 
ON payment(payment_dt);

-- trigger to capture the current timestamp in the col updated_at for any update
CREATE TRIGGER payment_moddatetime
    BEFORE UPDATE ON payment
    FOR EACH ROW
    EXECUTE PROCEDURE moddatetime (updated_at);

-- Table captures the transaction details
CREATE TABLE transaction (
	id varchar(32),
	item_id varchar(32),
	quantity number(10) NOT NULL,
	payment_id varchar(32),
	created_at timestamp default timestamp,
	updated_at timestamp default timestamp,
	PRIMARY KEY (id),
	CONSTRAINT fk_payment FOREIGN KEY(payment_id) REFERENCES payment(id),
	CONSTRAINT fk_item FOREIGN KEY(item_id) REFERENCES item(id)
);

-- Index created on the payment_id as it will be used to join with the table payment
CREATE INDEX idx_transaction_payment_id 
ON transaction(payment_id);

-- Index created on the item_id as it will be used to join with the table item
CREATE INDEX idx_transaction_item_id 
ON transaction(item_id);

-- trigger to capture the current timestamp in the col updated_at for any update
CREATE TRIGGER transaction_moddatetime
    BEFORE UPDATE ON transaction
    FOR EACH ROW
    EXECUTE PROCEDURE moddatetime (updated_at);

-- Table captures the sales details
CREATE TABLE sales (
	id varchar(32),
	member_id varchar(32),
	transaction_id varchar(32),
	created_at timestamp default timestamp,
	updated_at timestamp default timestamp,
	PRIMARY KEY (id),
	CONSTRAINT fk_member FOREIGN KEY(member_id) REFERENCES member(id),
	CONSTRAINT fk_transaction FOREIGN KEY(transaction_id) REFERENCES transaction(id)
);

-- Index created on the transaction_id as it will be used to join with the table transaction
CREATE INDEX idx_sales_transaction_id 
ON sales(transaction_id);

-- Index created on the member_id as it will be used to join with the table membership
CREATE INDEX idx_sales_member_id 
ON sales(member_id);

-- trigger to capture the current timestamp in the col updated_at for any update
CREATE TRIGGER sales_moddatetime
    BEFORE UPDATE ON sales
    FOR EACH ROW
    EXECUTE PROCEDURE moddatetime (updated_at);