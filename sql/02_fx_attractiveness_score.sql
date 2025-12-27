CREATE OR REPLACE TABLE `luxury-hotel-marketing-radar.luxury_marketing.fx_score` AS


WITH base AS (
 -- Calendar + raw FX (weekdays only)
 SELECT
   c.date,
   f.usd_per_cad
 FROM `luxury-hotel-marketing-radar.luxury_marketing.calendar` c
 LEFT JOIN `luxury-hotel-marketing-radar.luxury_marketing.fx_rates` f
   USING (date)
 WHERE c.date <= CURRENT_DATE()
),


ffilled AS (
 -- Forward-fill FX so weekends/holidays use the last known trading day
 SELECT
   date,
   LAST_VALUE(usd_per_cad IGNORE NULLS) OVER (
     ORDER BY date
     ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
   ) AS usd_per_cad_ff
 FROM base
),


metrics AS (
 -- Rolling stats on the forward-filled series
 SELECT
   date,
   usd_per_cad_ff,
   AVG(usd_per_cad_ff) OVER (
     ORDER BY date
     ROWS BETWEEN 90 PRECEDING AND CURRENT ROW
   ) AS rolling_mean_90,
   STDDEV(usd_per_cad_ff) OVER (
     ORDER BY date
     ROWS BETWEEN 90 PRECEDING AND CURRENT ROW
   ) AS rolling_std_90
 FROM ffilled
),


scored AS (
 SELECT
   date,
   usd_per_cad_ff AS usd_per_cad,
   rolling_mean_90,
   rolling_std_90,
   SAFE_DIVIDE(usd_per_cad_ff - rolling_mean_90, rolling_std_90) AS z_score
 FROM metrics
)


SELECT
 date,
 usd_per_cad,
 rolling_mean_90,
 rolling_std_90,
 z_score,
 GREATEST(0, LEAST(100, 50 + 10 * z_score)) AS fx_attractiveness_score
FROM scored
ORDER BY date;
