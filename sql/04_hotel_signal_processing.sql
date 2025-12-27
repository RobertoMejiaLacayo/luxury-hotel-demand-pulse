CREATE OR REPLACE TABLE `luxury-hotel-marketing-radar.luxury_marketing.hotel_signal` AS


WITH calendar AS (
 -- Only use the period where we have monthly ADR/occ data
 SELECT date
 FROM `luxury-hotel-marketing-radar.luxury_marketing.calendar`
 WHERE date BETWEEN DATE '2025-01-01' AND DATE '2025-10-31'
),


joined AS (
 -- Attach each date to its month’s ADR/occupancy benchmark
 SELECT
   c.date,
   CAST(m.adr_cad AS FLOAT64) AS adr_cad,          -- adr is INT → cast to FLOAT
   CAST(m.occupancy_pct AS FLOAT64) AS occupancy_pct
 FROM calendar c
 JOIN `luxury-hotel-marketing-radar.luxury_marketing.hotel_market_monthly` m
   ON DATE_TRUNC(c.date, MONTH) = m.month_start
),


daily_base AS (
 -- Weekend uplift on ADR & occupancy
 SELECT
   date,
   adr_cad,
   occupancy_pct,
   CASE
     WHEN FORMAT_DATE('%A', date) IN ('Friday', 'Saturday')
       THEN 1.10           -- +10% on weekends
     ELSE 1.00
   END AS weekend_factor
 FROM joined
),


daily_adjusted AS (
 -- Apply weekend uplift + small day-to-day noise
 SELECT
   date,
   adr_cad * weekend_factor * (1 + (RAND() - 0.5) * 0.10) AS adr_daily,
   GREATEST(
     0.0,
     LEAST(
       100.0,
       occupancy_pct * weekend_factor * (1 + (RAND() - 0.5) * 0.10)
     )
   ) AS occupancy_daily
 FROM daily_base
),


adr_scaled AS (
 -- Normalize ADR to 0–1 index across this Jan–Oct window
 SELECT
   date,
   adr_daily,
   occupancy_daily,
   SAFE_DIVIDE(
     adr_daily - MIN(adr_daily) OVER (),
     NULLIF(MAX(adr_daily) OVER () - MIN(adr_daily) OVER (), 0)
   ) AS adr_norm
 FROM daily_adjusted
)


SELECT
 date,
 ROUND(adr_norm * 100, 2) AS adr_index,
 ROUND(100.0 - occupancy_daily, 2) AS availability_index,
 ROUND(adr_daily, 2) AS adr_cad_est,
 ROUND(occupancy_daily, 2) AS occupancy_pct_est
FROM adr_scaled
ORDER BY date;
