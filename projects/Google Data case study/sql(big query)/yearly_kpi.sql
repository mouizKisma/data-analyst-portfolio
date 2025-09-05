WITH monthly_counts AS (
  SELECT 
  member_casual AS member_type,
  month,
  COUNT(ride_id) AS ride_count
  FROM `tribal-thought-284301.Cyclistic_clean_data.Cyclistic_clean_data_table` 
  GROUP BY member_casual,month

),
peak_months AS(
  SELECT
  member_type,
  month AS peak_month,
  RANK() OVER (PARTITION BY member_type ORDER BY ride_count DESC) AS rnk
  FROM monthly_counts
),

yearly_aggregation AS (
  SELECT 
  member_casual AS member_type, 
  COUNT(ride_id) AS ride_count,
  ROUND(AVG(ride_duration_min),1) as avg_ride_duration,
  ROUND(SUM(ride_duration_min)/60,1) as total_hourly_yearly_ridetime
  FROM `tribal-thought-284301.Cyclistic_clean_data.Cyclistic_clean_data_table` t
  GROUP BY member_casual


)

SELECT 
ya.member_type, 
ya.ride_count,
ya.avg_ride_duration,
ya.total_hourly_yearly_ridetime,
pm.peak_month
FROM yearly_aggregation ya
LEFT JOIN peak_months pm 
ON ya.member_type = pm.member_type
WHERE rnk = 1
