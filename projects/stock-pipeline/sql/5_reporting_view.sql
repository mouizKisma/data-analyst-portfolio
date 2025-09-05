DROP VIEW IF EXISTS powerbi_view;
CREATE VIEW powerbi_view AS
SELECT
    d.symbol,
    d.date,
    d.price,
    d.daily_return,
    d.ma_7d_return,
    d.volatility_21d,
    w.week_start,
    w.open_price,
    w.close_price,
    w.high_price AS weekly_high_price,
    w.low_price AS weekly_low_price,
    w.up_days AS weekly_up_days,
    w.total_trading_days AS weekly_total_trading_days,
    w.open_price AS weekly_open_price,
    w.close_price AS weekly_close_price,
    a.year_start,
    a.high_price AS annual_high_price,
    a.low_price AS annual_low_price,
    a.annual_return,
    a.annual_volatility

FROM daily_metrics d
JOIN weekly_metrics w ON d.symbol = w.symbol AND DATE_TRUNC('week', d.date)::DATE = w.week_start
JOIN annual_metrics a ON d.symbol = a.symbol AND DATE_TRUNC('year', d.date)::DATE = a.year_start;