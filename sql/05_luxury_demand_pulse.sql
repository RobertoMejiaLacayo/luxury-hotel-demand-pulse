CREATE OR REPLACE TABLE `luxury-hotel-marketing-radar.luxury_marketing.luxury_pulse_daily` AS


WITH calendar AS (
 -- Focus on the period where hotel data exists
 SELECT date
 FROM `luxury-hotel-marketing-radar.luxury_marketing.calendar`
 WHERE date BETWEEN DATE '2025-01-01' AND DATE '2025-10-31'
),


joined AS (
 SELECT
   c.date,
   f.usd_per_cad,
   f.fx_attractiveness_score,
   t.trends_intent_score,
   h.adr_index,
   h.availability_index,
   h.adr_cad_est,
   h.occupancy_pct_est
 FROM calendar c
 LEFT JOIN `luxury-hotel-marketing-radar.luxury_marketing.fx_score` f
   USING (date)
 LEFT JOIN `luxury-hotel-marketing-radar.luxury_marketing.trends_intent_score` t
   USING (date)
 LEFT JOIN `luxury-hotel-marketing-radar.luxury_marketing.hotel_signal` h
   USING (date)
),


features AS (
 SELECT
   *,
   -- Higher = tighter, more constrained supply
   100.0 - availability_index AS tightness_index
 FROM joined
),


pulse AS (
 SELECT
   date,
   usd_per_cad,
   fx_attractiveness_score,
   trends_intent_score,
   adr_index,
   availability_index,
   adr_cad_est,
   occupancy_pct_est,
   tightness_index,
   -- Weighted combination into a 0–100 Luxury Demand Pulse score
   ROUND(
     0.25 * fx_attractiveness_score +
     0.35 * trends_intent_score +
     0.25 * adr_index +
     0.15 * tightness_index,
     2
   ) AS luxury_demand_pulse
 FROM features
)


SELECT * FROM pulse
ORDER BY date;

