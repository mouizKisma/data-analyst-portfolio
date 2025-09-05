CREATE TABLE IF NOT EXISTS stock_prices (
        symbol VARCHAR(10) NOT NULL,
        date DATE NOT NULL,
        price FLOAT NOT NULL,
        volume BIGINT NOT NULL,
        PRIMARY KEY (symbol, date)
    );