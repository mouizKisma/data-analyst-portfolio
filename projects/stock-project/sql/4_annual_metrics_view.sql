DROP MATERIALIZED VIEW IF EXISTS annual_metrics CASCADE;
CREATE MATERIALIZED VIEW annual_metrics AS
SELECT
  symbol,
  DATE_TRUNC('year', date)::DATE AS year_start,
  MAX(price)                                   AS high_price,
  MIN(price)                                   AS low_price,
  EXP(SUM(LN(1 + daily_return))) - 1          AS annual_return,
  STDDEV(daily_return) * SQRT(252)             AS annual_volatility
FROM base_view
GROUP BY symbol, DATE_TRUNC('year', date)::DATE;

REFRESH MATERIALIZED VIEW annual_metrics;
