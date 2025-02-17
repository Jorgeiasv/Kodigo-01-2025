-- Eliminación de restricciones de claves foráneas antes de eliminar tablas
ALTER TABLE order_details DROP CONSTRAINT order_details_order_fk;
ALTER TABLE order_details DROP CONSTRAINT order_details_product_fk;
ALTER TABLE transactions DROP CONSTRAINT transactions_order_fk;
ALTER TABLE orders DROP CONSTRAINT orders_customer_fk;

-- Eliminación de índices antes de eliminar tablas
DROP INDEX idx_orders_customer;
DROP INDEX idx_order_details_product;
DROP INDEX idx_transactions_order;
DROP INDEX idx_orders_date;

-- Eliminación de las tablas en el orden correcto para evitar restricciones
DROP TABLE order_details CASCADE CONSTRAINTS PURGE;
DROP TABLE transactions CASCADE CONSTRAINTS PURGE;
DROP TABLE orders CASCADE CONSTRAINTS PURGE;
DROP TABLE products CASCADE CONSTRAINTS PURGE;
DROP TABLE customers CASCADE CONSTRAINTS PURGE;

COMMIT;
