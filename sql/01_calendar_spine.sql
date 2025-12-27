CREATE OR REPLACE TABLE `luxury-hotel-marketing-radar.luxury_marketing.calendar`
AS
WITH
 dates AS (
   SELECT DATE '2023-01-01' + INTERVAL n DAY AS date
   FROM UNNEST(GENERATE_ARRAY(0, 1460)) AS n  -- ~4 years of dates
 )
SELECT
 date,
 EXTRACT(YEAR FROM date) AS year,
 EXTRACT(MONTH FROM date) AS month,
 EXTRACT(DAY FROM date) AS day,
 FORMAT_DATE('%A', date) AS day_of_week,
 FORMAT_DATE('%A', date) IN ('Saturday', 'Sunday') AS is_weekend,
 EXTRACT(QUARTER FROM date) AS quarter
FROM `dates`
ORDER BY date;
