DROP MATERIALIZED VIEW IF EXISTS daily_metrics CASCADE;
CREATE MATERIALIZED VIEW daily_metrics AS

WITH daily_return_with AS (
    SELECT
        symbol,
        date,
        price,
        daily_return
    FROM base_view
    WHERE daily_return IS NOT NULL
),
ma_7d_return_data AS (
    SELECT
        symbol,
        date,
        price,
        daily_return,
        AVG(daily_return) OVER (PARTITION BY symbol ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS ma_7d_return
    FROM daily_return_with
),

volatility_21d AS (
    SELECT
        symbol,
        date,
        price,
        daily_return,
        ma_7d_return,
        STDDEV(daily_return) OVER (PARTITION BY symbol ORDER BY date ROWS BETWEEN 20 PRECEDING AND CURRENT ROW) AS volatility_21d
    FROM ma_7d_return_data
)

SELECT
  symbol,
  date,
  price,
  daily_return,
  ma_7d_return,
  volatility_21d
FROM volatility_21d
;

REFRESH MATERIALIZED VIEW daily_metrics;