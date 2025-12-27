CREATE OR REPLACE TABLE `luxury-hotel-marketing-radar.luxury_marketing.trends_intent_score` AS

WITH base AS (
  -- Raw trends data (weekly per keyword)
  SELECT
    date,
    search_term,
    interest
  FROM `luxury-hotel-marketing-radar.luxury_marketing.google_trends`
  WHERE interest IS NOT NULL
),

max_per_kw AS (
  -- Peak score per keyword (for normalization)
  SELECT
    search_term,
    MAX(interest) AS max_interest
  FROM base
  GROUP BY search_term
),

normalized AS (
  -- Normalize each keyword to 0–1
  SELECT
    b.date,
    b.search_term,
    SAFE_DIVIDE(b.interest, m.max_interest) AS normalized_interest
  FROM base b
  JOIN max_per_kw m USING(search_term)
),

weekly_intent AS (
  -- Aggregate all keywords into a single weekly score (0–1)
  SELECT
    date,
    AVG(normalized_interest) AS weekly_intent_raw
  FROM normalized
  GROUP BY date
),

calendar AS (
  -- Your date spine (full calendar, includes future dates)
  SELECT date
  FROM `luxury-hotel-marketing-radar.luxury_marketing.calendar`
),

expanded AS (
  -- Forward-fill weekly value across daily calendar
  SELECT
    c.date,
    LAST_VALUE(w.weekly_intent_raw IGNORE NULLS)
      OVER (
        ORDER BY c.date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
      ) AS intent_raw
  FROM calendar c
  LEFT JOIN weekly_intent w
    ON w.date = c.date
),

final AS (
  SELECT
    date,
    -- Convert 0–1 raw score to 0–100 scale, round to 2 decimals
    ROUND(intent_raw * 100, 2) AS trends_intent_score
  FROM expanded
  -- Forward-fill only up to today
  WHERE date <= CURRENT_DATE()
)

SELECT * FROM final ORDER BY date;
