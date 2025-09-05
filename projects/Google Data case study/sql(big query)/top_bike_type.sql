WITH bike_type_count AS (
SELECT 
member_casual AS member_type,
rideable_type AS bike_type,
count(ride_id) AS ride_count
FROM tribal-thought-284301.Cyclistic_clean_data.Cyclistic_clean_data_table 
GROUP BY member_casual, rideable_type
),
bike_type_rank AS (
SELECT *,
RANK() OVER(PARTITION BY member_type ORDER BY ride_count DESC) AS rnk
FROM bike_type_count
)
SELECT
member_type,
bike_type
FROM bike_type_rank
WHERE rnk = 1