WITH start_station_count AS(
SELECT
  member_casual AS member_type,
  start_station_name,
  COUNT(ride_id) AS ride_count
  FROM `tribal-thought-284301.Cyclistic_clean_data.Cyclistic_clean_data_table`
  GROUP BY member_casual,start_station_name
),
end_station_count AS(
SELECT
  member_casual AS member_type,
  end_station_name,
  COUNT(ride_id) AS ride_count
  FROM `tribal-thought-284301.Cyclistic_clean_data.Cyclistic_clean_data_table`
  GROUP BY member_casual,end_station_name
),
start_station_rank AS (
SELECT *,
RANK() OVER(PARTITION BY member_type ORDER BY ride_count DESC) AS rnk
FROM start_station_count

),
end_station_rank AS (
SELECT *,
RANK() OVER(PARTITION BY member_type ORDER BY ride_count DESC) AS rnk
FROM end_station_count

)
SELECT 
"Start" AS station_type,
member_type,
start_station_name,
ride_count,
rnk
FROM start_station_rank
WHERE rnk <= 3
UNION ALL
SELECT 
"END" AS station_type,
member_type,
end_station_name,
ride_count,
rnk
FROM end_station_rank
WHERE rnk <= 3