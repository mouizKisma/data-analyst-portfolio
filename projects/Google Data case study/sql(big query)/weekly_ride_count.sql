SELECT
  DATE_TRUNC(started_at, WEEK(MONDAY)) AS week_start,
  member_casual AS member_type,
  COUNT(*) as ride_count
FROM `tribal-thought-284301.Cyclistic_clean_data.Cyclistic_clean_data_table`
GROUP BY member_type, week_start
ORDER BY member_type, week_start DESC