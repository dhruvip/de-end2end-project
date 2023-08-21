with datetime_cte AS (  
  SELECT DISTINCT
    created_at AS date_part
  FROM {{ source('staging','raw_order_line_item') }}
  WHERE created_at IS NOT NULL
)
SELECT
  date_part as datetime,
  EXTRACT(YEAR FROM date_part) AS year,
  EXTRACT(MONTH FROM date_part) AS month,
  EXTRACT(DAY FROM date_part) AS day,
  EXTRACT(HOUR FROM date_part) AS hour,
  EXTRACT(MINUTE FROM date_part) AS minute,
  EXTRACT(DAYOFWEEK FROM date_part) AS weekday
FROM datetime_cte