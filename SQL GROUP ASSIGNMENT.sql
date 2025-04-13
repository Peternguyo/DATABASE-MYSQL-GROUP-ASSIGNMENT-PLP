-- Step 1: Create Database
 CREATE DATABASE IF NOT EXISTS bookstore;
USE bookstore;

-- Step 2: Define Schema & Create Tables

-- Country Table
CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);
-- Address Status Table
CREATE TABLE address_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);
-- Book Language Table
CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100)
);
-- Publisher Table
CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150),
    website VARCHAR(200)
);

-- Shipping Method Table
CREATE TABLE shipping_method (
    method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(100),
    cost DECIMAL(10, 2)
);

-- Order Status Table
CREATE TABLE order_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50)
);

-- Address Table
CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);


-- Customer Table
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);



-- Customer Address Table
CREATE TABLE customer_address (
    customer_id INT,
    address_id INT,
    status_id INT,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (status_id) REFERENCES address_status(status_id)
);

-- Book Table
CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    isbn VARCHAR(20) UNIQUE,
    publication_year INT,
    price DECIMAL(10, 2),
    publisher_id INT,
    language_id INT,
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id),
    FOREIGN KEY (language_id) REFERENCES book_language(language_id)
);

-- Author Table
CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100)
);

-- Book Author Table (Many-to-Many)
CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);



-- Customer Order Table
CREATE TABLE cust_order (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    shipping_method_id INT,
    status_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(method_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);

-- Order Line Table
CREATE TABLE order_line (
    order_id INT,
    book_id INT,
    quantity INT,
    price_each DECIMAL(10, 2),
    PRIMARY KEY (order_id, book_id),
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- Order History Table
CREATE TABLE order_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    status_id INT,
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);

-- Step 3: Populate Tables with sample Data

-- Countries
INSERT INTO country (name) VALUES ('Kenya'), ('USA'), ('UK');

-- Address Status
INSERT INTO address_status (status_name) VALUES ('current'), ('old'), ('billing');


-- Book Languages
INSERT INTO book_language (name) VALUES ('English'), ('Swahili'), ('French');

-- Publishers
INSERT INTO publisher (name, website) VALUES 
('Oxford Press', 'https://oxford.com'), 
('Penguin Books', 'https://penguin.com'),
('East African Publishers', 'https://eap.com');

-- Shipping Methods
INSERT INTO shipping_method (method_name, cost) VALUES 
('Standard', 200.00), 
('Express', 500.00), 
('Overnight', 1000.00);

-- Order Status
INSERT INTO order_status (status_name) VALUES ('pending'), ('shipped'), ('delivered');


-- Addresses
INSERT INTO address (street, city, state, postal_code, country_id) VALUES 
('123 Moi Ave', 'Nairobi', 'Nairobi', '00100', 1),
('456 Kenyatta Rd', 'Mombasa', 'Coast', '80100', 1),
('789 Safari St', 'Kisumu', 'Nyanza', '40100', 1);

-- Customers
INSERT INTO customer (first_name, last_name, email, phone) VALUES 
('Alice', 'Kamau', 'alice@example.com', '0712345678'),
('Brian', 'Otieno', 'brian@example.com', '0723456789'),
('Carol', 'Mwangi', 'carol@example.com', '0734567890');

-- Customer Addresses
INSERT INTO customer_address VALUES 
(1, 1, 1), 
(2, 2, 1), 
(3, 3, 2);

-- Authors
INSERT INTO author (first_name, last_name) VALUES 
('Ngugi', 'wa Thiong\'o'), 
('Chimamanda', 'Adichie'), 
('George', 'Orwell');

-- Books
INSERT INTO book (title, isbn, publication_year, price, publisher_id, language_id) VALUES 
('The River Between', '9780141187033', 1965, 900.00, 3, 1),
('1984', '9780451524935', 1949, 750.00, 2, 1),
('Half of a Yellow Sun', '9780007200283', 2006, 1050.00, 1, 1);


-- Book Authors
INSERT INTO book_author VALUES 
(1, 1), 
(2, 3), 
(3, 2);

-- Orders
INSERT INTO cust_order (customer_id, shipping_method_id, status_id) VALUES 
(1, 1, 1), 
(2, 2, 2), 
(3, 3, 3);


-- Order Lines
INSERT INTO order_line VALUES 
(1, 1, 2, 900.00), 
(2, 2, 1, 750.00), 
(3, 3, 1, 1050.00);


-- Order History
INSERT INTO order_history (order_id, status_id) VALUES 
(1, 1), 
(2, 2), 
(3, 3);

-- Step 4: Create Users and Roles

-- Admin User (Full Access)
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'Admin@123';
GRANT ALL PRIVILEGES ON bookstore.* TO 'admin_user'@'localhost';


-- Read-only User
CREATE USER 'readonly_user'@'localhost' IDENTIFIED BY 'ReadOnly@123';
GRANT SELECT ON bookstore.* TO 'readonly_user'@'localhost';

-- Order Manager (Limited Permissions)
CREATE USER 'order_manager'@'localhost' IDENTIFIED BY 'Order@123';
GRANT SELECT, INSERT, UPDATE ON cust_order TO 'order_manager'@'localhost';
GRANT SELECT, INSERT, UPDATE ON order_line TO 'order_manager'@'localhost';
GRANT SELECT, INSERT ON order_history TO 'order_manager'@'localhost';

-- Step 5: Test Queries (Data Retrieval)
-- Get all books with their authors and publishers
SELECT b.title, a.first_name, a.last_name, p.name AS publisher
FROM book b
JOIN book_author ba ON b.book_id = ba.book_id
JOIN author a ON ba.author_id = a.author_id
JOIN publisher p ON b.publisher_id = p.publisher_id;


-- Get all customers with their current addresses
SELECT c.first_name, c.last_name, a.street, a.city
FROM customer c
JOIN customer_address ca ON c.customer_id = ca.customer_id
JOIN address a ON ca.address_id = a.address_id
JOIN address_status s ON ca.status_id = s.status_id
WHERE s.status_name = 'current';

-- Get orders with total value
SELECT o.order_id, c.first_name, SUM(ol.quantity * ol.price_each) AS total_price
FROM cust_order o
JOIN customer c ON o.customer_id = c.customer_id
JOIN order_line ol ON o.order_id = ol.order_id
GROUP BY o.order_id;



















