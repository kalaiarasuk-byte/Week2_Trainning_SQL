

DROP TABLE IF EXISTS performance_orders;

CREATE TABLE performance_orders (
    id INT PRIMARY KEY,
    customer_id INT,
    amount NUMERIC(10,2),
    status VARCHAR(30)
);

INSERT INTO performance_orders
    (id, customer_id, amount, status)
SELECT
    generate_series(1, 200000),
    (generate_series(1, 200000) % 1000) + 1,
    (generate_series(1, 200000) % 5000) + 100,
    'completed';



SELECT COUNT(*)
FROM performance_orders;



EXPLAIN ANALYZE
SELECT *
FROM performance_orders
WHERE customer_id = 500;


CREATE INDEX idx_customer_id
ON performance_orders(customer_id);

EXPLAIN ANALYZE
SELECT *
FROM performance_orders
WHERE customer_id = 500;
