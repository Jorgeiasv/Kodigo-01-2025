-- Creación de la tabla de clientes
CREATE TABLE customers (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    email VARCHAR2(150) UNIQUE NOT NULL,
    country VARCHAR2(50),
    created_at DATE DEFAULT SYSDATE
);

-- Creación de la tabla de productos
CREATE TABLE products (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    category VARCHAR2(50),
    price NUMBER(10,2) NOT NULL,
    stock NUMBER NOT NULL,
    created_at DATE DEFAULT SYSDATE
);

-- Creación de la tabla de órdenes
CREATE TABLE orders (
    id NUMBER PRIMARY KEY,
    customer_id NUMBER REFERENCES customers(id) ON DELETE CASCADE,
    total_amount NUMBER(10,2) NOT NULL,
    order_date DATE DEFAULT SYSDATE
);

-- Creación de la tabla de detalles de órdenes
CREATE TABLE order_details (
    id NUMBER PRIMARY KEY,
    order_id NUMBER REFERENCES orders(id) ON DELETE CASCADE,
    product_id NUMBER REFERENCES products(id) ON DELETE CASCADE,
    quantity NUMBER NOT NULL,
    price NUMBER(10,2) NOT NULL
);

-- Creación de la tabla de transacciones
CREATE TABLE transactions (
    id NUMBER PRIMARY KEY,
    order_id NUMBER REFERENCES orders(id) ON DELETE CASCADE,
    payment_method VARCHAR2(50) NOT NULL,
    status VARCHAR2(20) CHECK (status IN ('Pending', 'Completed', 'Failed')),
    created_at DATE DEFAULT SYSDATE
);

-- Creación de índices para mejorar el rendimiento
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_order_details_product ON order_details(product_id);
CREATE INDEX idx_transactions_order ON transactions(order_id);

-- Inserción de datos ficticios en customers (1,000,000 registros)
INSERT INTO customers (id, name, email, country, created_at)
SELECT LEVEL, 
       'Customer ' || LEVEL, 
       'customer' || LEVEL || '@example.com', 
       CASE MOD(LEVEL, 5) 
           WHEN 0 THEN 'USA'
           WHEN 1 THEN 'Canada'
           WHEN 2 THEN 'UK'
           WHEN 3 THEN 'Germany'
           ELSE 'France'
       END,
       SYSDATE - DBMS_RANDOM.VALUE(1, 365) 
FROM dual CONNECT BY LEVEL <= 1000000;

-- Inserción de datos ficticios en products (50,000 registros)
INSERT INTO products (id, name, category, price, stock, created_at)
SELECT LEVEL, 
       'Product ' || LEVEL, 
       CASE MOD(LEVEL, 4)
           WHEN 0 THEN 'Electronics'
           WHEN 1 THEN 'Clothing'
           WHEN 2 THEN 'Home and Kitchen'
           ELSE 'Sports'
       END,
       ROUND(DBMS_RANDOM.VALUE(5, 500), 2),
       TRUNC(DBMS_RANDOM.VALUE(10, 200)),
       SYSDATE - DBMS_RANDOM.VALUE(1, 730)
FROM dual CONNECT BY LEVEL <= 50000;

-- Generación de órdenes aleatorias (5,000,000 registros)
INSERT INTO orders (id, customer_id, total_amount, order_date)
SELECT LEVEL, 
       TRUNC(DBMS_RANDOM.VALUE(1, 1000000)), 
       ROUND(DBMS_RANDOM.VALUE(20, 2000), 2), 
       SYSDATE - DBMS_RANDOM.VALUE(1, 365)
FROM dual CONNECT BY LEVEL <= 5000000;

-- Generación de detalles de órdenes asegurando que order_id y product_id existen (10,000,000 registros)
INSERT INTO order_details (id, order_id, product_id, quantity, price)
SELECT LEVEL,
       (SELECT id FROM orders ORDER BY DBMS_RANDOM.VALUE FETCH FIRST 1 ROWS ONLY), 
       (SELECT id FROM products ORDER BY DBMS_RANDOM.VALUE FETCH FIRST 1 ROWS ONLY), 
       TRUNC(DBMS_RANDOM.VALUE(1, 10)), 
       ROUND(DBMS_RANDOM.VALUE(5, 500), 2)
FROM dual CONNECT BY LEVEL <= 10000000;

-- Generación de transacciones aleatorias (5,000,000 registros)
INSERT INTO transactions (id, order_id, payment_method, status, created_at)
SELECT LEVEL, 
       (SELECT id FROM orders ORDER BY DBMS_RANDOM.VALUE FETCH FIRST 1 ROWS ONLY), 
       CASE MOD(LEVEL, 3) 
           WHEN 0 THEN 'Credit Card'
           WHEN 1 THEN 'PayPal'
           ELSE 'Bank Transfer'
       END,
       CASE MOD(LEVEL, 3) 
           WHEN 0 THEN 'Completed'
           WHEN 1 THEN 'Pending'
           ELSE 'Failed'
       END,
       SYSDATE - DBMS_RANDOM.VALUE(1, 365)
FROM dual CONNECT BY LEVEL <= 5000000;

COMMIT;

-- Optimización recomendada
CREATE INDEX idx_orders_date ON orders(order_date);
