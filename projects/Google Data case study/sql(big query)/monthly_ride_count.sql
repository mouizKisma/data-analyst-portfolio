SELECT
  member_casual AS member_type,
  month,
  COUNT(ride_id) AS ride_count
  FROM `tribal-thought-284301.Cyclistic_clean_data.Cyclistic_clean_data_table`
  GROUP BY member_casual,month
  ORDER BY member_casual,month DESC
