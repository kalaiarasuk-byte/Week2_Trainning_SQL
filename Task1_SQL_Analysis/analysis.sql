
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL
);

CREATE TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    amount NUMERIC(10,2) NOT NULL,
    ordered_at DATE NOT NULL
);


CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    attrs JSONB
);


INSERT INTO customers (id, name, city)
VALUES
(1, 'Arun', 'Chennai'),
(2, 'Priya', 'Mumbai'),
(3, 'Rahul', 'Chennai'),
(4, 'Divya', 'Bangalore');



INSERT INTO orders (id, customer_id, amount, ordered_at)
VALUES
(101, 1, 700, '2026-01-05'),
(102, 1, 600, '2026-02-10'),
(103, 2, 300, '2026-01-20'),
(104, 2, 900, '2026-02-15'),
(105, 3, 1200, '2026-01-25'),
(106, 2, 500, '2026-03-05'),
(107, 3, 400, '2026-02-20'),
(108, 1, 800, '2026-03-15'),
(109, 3, 600, '2026-03-10');




INSERT INTO products (id, name, attrs)
VALUES
(1, 'Laptop A', '{"brand":"Dell","ram":16}'),
(2, 'Laptop B', '{"brand":"HP","ram":8}');


SELECT
    c.id,
    c.name,
    SUM(o.amount) AS total_sales
FROM customers c
JOIN orders o
    ON c.id = o.customer_id
GROUP BY c.id, c.name
HAVING SUM(o.amount) > 1000
ORDER BY total_sales DESC;


SELECT
    c.id,
    c.name,
    c.city
FROM customers c
LEFT JOIN orders o
    ON c.id = o.customer_id
WHERE o.id IS NULL;


-- ==========================================
-- QUERY 3:
-- Top customer per city
-- CTE + ROW_NUMBER
-- ==========================================

WITH customer_sales AS (
    SELECT
        c.id,
        c.name,
        c.city,
        COALESCE(SUM(o.amount), 0) AS total_sales
    FROM customers c
    LEFT JOIN orders o
        ON c.id = o.customer_id
    GROUP BY c.id, c.name, c.city
),
city_ranking AS (
    SELECT
        id,
        name,
        city,
        total_sales,
        ROW_NUMBER() OVER (
            PARTITION BY city
            ORDER BY total_sales DESC, id
        ) AS city_rank
    FROM customer_sales
)
SELECT
    id,
    name,
    city,
    total_sales
FROM city_ranking
WHERE city_rank = 1
ORDER BY city;


SELECT
    id AS order_id,
    customer_id,
    amount,
    ordered_at,

    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY amount DESC
    ) AS amount_rank,

    LAG(amount) OVER (
        PARTITION BY customer_id
        ORDER BY ordered_at
    ) AS previous_order_amount

FROM orders
ORDER BY customer_id, ordered_at;

SELECT
    id,
    name,
    attrs,
    attrs ->> 'ram' AS ram
FROM products
WHERE attrs @> '{"brand": "Dell"}';