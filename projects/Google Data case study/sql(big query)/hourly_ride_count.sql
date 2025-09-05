SELECT
  member_casual AS member_type,
  hour_of_day,
  COUNT(ride_id) AS ride_count
  FROM `tribal-thought-284301.Cyclistic_clean_data.Cyclistic_clean_data_table`
  GROUP BY member_casual,hour_of_day
  ORDER BY member_casual,hour_of_day DESC
