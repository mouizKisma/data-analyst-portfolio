DROP TABLE IF EXISTS temp_stock_prices;
CREATE TEMP TABLE temp_stock_prices (
    symbol VARCHAR(10),
    date DATE,
    price FLOAT,
    volume BIGINT
);