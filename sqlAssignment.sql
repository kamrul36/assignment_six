-- Active: 1698946828785@@127.0.0.1@3306

CREATE DATABASE shopDB DEFAULT CHARACTER SET = 'utf8mb4';

USE shopDB 

CREATE TABLE
    customers (
        id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
        name varchar(50) NOT NULL,
        email varchar(50) NOT NULL,
        mobile varchar(50) NOT NULL,
        location varchar(50) NOT NULL,
        created_at timestamp NOT NULL DEFAULT current_timestamp(),
        updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
    )

CREATE TABLE
    orders(
        id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
        customer_id BIGINT(20) UNSIGNED NOT NULL,
        order_date DATE,
        total_amount VARCHAR(50) NOT NULL,
        created_at timestamp NOT NULL DEFAULT current_timestamp(),
        updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
        FOREIGN KEY (`customer_id`) REFERENCES `customers`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE
    )

CREATE TABLE
    products (
        id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(50) NOT NULL,
        description TEXT DEFAULT NULL,
        price VARCHAR(50) NOT NULL
    );

CREATE TABLE
    categories (
        id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(50) NOT NULL,
        created_at timestamp NOT NULL DEFAULT current_timestamp(),
        updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
    );

CREATE TABLE
    order_Items (
        order_item_id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
        order_id BIGINT(20) UNSIGNED NOT NULL,
        product_id BIGINT(20) UNSIGNED NOT NULL,
        quantity INT,
        unit_price VARCHAR(50),
        FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
        FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
        created_at timestamp NOT NULL DEFAULT current_timestamp(),
        updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
    );

INSERT INTO
    customers (
        id,
        name,
        email,
        mobile,
        location
    )
VALUES (
        1,
        'John Doe',
        'john.doe@email.com',
        '987456',
        'New York'
    ), (
        2,
        'Alice Smith',
        'alice.smith@email.com',
        '987425',
        'Los Angeles'
    ), (
        3,
        'Bob Johnson',
        'bob.johnson@email.com',
        '987423',
        'Chicago'
    );

INSERT INTO
    products (id, name, description, price)
VALUES (
        1,
        'Product A',
        'Description of Product A',
        19.99
    ), (
        2,
        'Product B',
        'Description of Product B',
        29.99
    ), (
        3,
        'Product C',
        'Description of Product C',
        14.99
    );

INSERT INTO
    categories (id, name)
VALUES (1, 'Category X'), (2, 'Category Y'), (3, 'Category Z');

INSERT INTO
    orders (
        id,
        customer_id,
        order_date,
        total_amount
    )
VALUES (1, 1, '2023-11-01', 49.98), (2, 2, '2023-11-02', 59.98), (3, 3, '2023-11-03', 44.97);

INSERT INTO
    order_Items (
        order_item_id,
        order_id,
        product_id,
        quantity,
        unit_price
    )
VALUES (1, 1, 1, 2, 19.99), (2, 2, 2, 1, 29.99), (3, 3, 3, 3, 14.99);

SELECT
    c.id,
    c.name,
    c.email,
    c.mobile,
    c.location,
    COUNT(o.id) AS total_orders
from customers c
    LEFT JOIN orders o ON c.id = o.id
GROUP BY
    c.id,
    c.name,
    c.email,
    c.mobile,
    c.location
ORDER BY total_orders DESC;

SELECT
    p.name AS product_name,
    oi.quantity,
    oi.quantity * oi.unit_price AS total_amount
FROM order_Items oi
    INNER JOIN products p ON oi.product_id = p.id
ORDER BY oi.order_id ASC;

SELECT
    c.name AS category_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM order_Items AS oi
    INNER JOIN products p ON oi.product_id = p.id
    INNER JOIN categories c ON p.id = c.id
GROUP BY c.name
ORDER BY total_revenue DESC;

SELECT
    c.name AS customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_purchase_amount
FROM customers c
    LEFT JOIN orders o ON c.id = o.customer_id
    LEFT JOIN order_items oi ON o.id = oi.order_id
GROUP BY c.name
ORDER BY
    total_purchase_amount DESC
LIMIT 5;