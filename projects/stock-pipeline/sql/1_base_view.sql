DROP MATERIALIZED VIEW IF EXISTS base_view;
CREATE MATERIALIZED VIEW base_view AS

WITH base_view_daily_return AS (
    SELECT
        symbol,
        date,
        price,
        price / LAG(price) OVER (PARTITION BY symbol ORDER BY date) - 1 AS daily_return
    FROM stock_prices
)
SELECT
    symbol,
    date,
    price,
    daily_return
FROM base_view_daily_return;

REFRESH MATERIALIZED VIEW base_view;
