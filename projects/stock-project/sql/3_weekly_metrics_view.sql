DROP MATERIALIZED VIEW IF EXISTS weekly_metrics CASCADE;
CREATE MATERIALIZED VIEW weekly_metrics AS
SELECT
  symbol,
  DATE_TRUNC('week', date)::DATE AS week_start,
  (ARRAY_AGG(price ORDER BY date ASC))[1]  AS open_price,
  (ARRAY_AGG(price ORDER BY date DESC))[1] AS close_price,
  MAX(price)                               AS high_price,
  MIN(price)                               AS low_price,
  SUM(CASE WHEN daily_return > 0 THEN 1 ELSE 0 END) AS up_days,
  COUNT(*)                                 AS total_trading_days
FROM base_view
GROUP BY symbol, DATE_TRUNC('week', date)::DATE;

REFRESH MATERIALIZED VIEW weekly_metrics;
