INSERT INTO stock_prices (symbol, date, price, volume)
SELECT symbol, date, price, volume
FROM temp_stock_prices
ON CONFLICT (symbol, date) 
DO UPDATE SET
    price = EXCLUDED.price,
    volume = EXCLUDED.volume;