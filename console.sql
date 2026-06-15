-- 1
CREATE TABLE products(
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    stock INT
);
-- 2
CREATE TABLE sales(
    sale_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    quantity INT
);

-- 3
CREATE OR REPLACE FUNCTION trigeer_before_insert_sale()
RETURNS TRIGGER
AS $$
DECLARE
    v_stock INT;
BEGIN
    SELECT p.stock INTO v_stock FROM products p WHERE p.product_id = NEW.product_id;
    IF NEW.quantity > v_stock THEN
        RAISE EXCEPTION 'Không đủ hàng tồn kho!';
    end if;
    RETURN NEW;
end;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER before_insert_sale BEFORE INSERT ON sales FOR EACH ROW
EXECUTE FUNCTION trigeer_before_insert_sale();

INSERT INTO products(name, stock) VALUES
      ('ao thun', 20),
      ('quan dui', 25),
      ('ban chai', 50);

INSERT INTO sales(product_id, quantity) VALUES (1, 50);
INSERT INTO sales(product_id, quantity) VALUES (2, 50);
INSERT INTO sales(product_id, quantity) VALUES (3, 150);
