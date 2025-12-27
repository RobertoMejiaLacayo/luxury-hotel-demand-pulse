# Vancouver Luxury Hotel Demand Pulse

## Overview

The Vancouver Luxury Hotel Demand Pulse is an end-to-end analytics project that models daily demand conditions for luxury hotels in Vancouver using a composite index built from multiple external and internal signals.

The project answers a practical business question:

> *“Given currency conditions, search intent, pricing pressure, and room availability, how strong is luxury hotel demand in Vancouver today?”*

This type of signal is useful for:
- Revenue management teams
- Marketing and growth teams
- Strategy and forecasting roles
- Analysts working with external + internal data sources

The output is a daily demand index (0–100), visualized in Looker Studio and backed by automated pipelines in Google Cloud Platform.

---

## Key Outputs

- **Luxury Demand Pulse (0–100)**  
  A normalized daily index summarizing demand conditions.

- **Component-Level Signals**
  - FX Attractiveness Score (USD → CAD)
  - Search Intent Score (Google Trends)
  - Room Scarcity / Availability Index
  - Pricing Pressure (ADR-based)

- **Executive Dashboard (Looker Studio)**
  - Last 30-day rolling demand average
  - Demand trends over time
  - Component breakdowns
  - Top demand days

---

## Data Sources

This project intentionally blends heterogeneous data sources, simulating real-world analytics work:

### External Signals
- **Foreign Exchange (USD → CAD)**  
  Daily FX rates ingested via a scheduled Cloud Run service.

- **Search Intent (Google Trends)**  
  Weekly search interest for luxury hotel–related keywords (e.g. *“Vancouver luxury hotel”*, *“Fairmont Pacific Rim”*), ingested via `pytrends`.

### Internal / Proxy Signals
- **Hotel Pricing (ADR)**  
  Monthly Average Daily Rate data used to model pricing pressure.

- **Room Availability / Occupancy**  
  Daily availability estimates used to construct a scarcity index.

> Note: Where full historical data is unavailable, proxy data is used intentionally and documented. This reflects realistic constraints analysts face in production environments.

---

## Architecture (High-Level)
Cloud Run (Python)
- FX daily ingestion
- Google Trends ingestion
- Scheduled via Cloud Scheduler
↓
BigQuery (Analytics Layer)
- Calendar spine
- Normalized component indices
- Daily luxury demand pulse
↓
Looker Studio
- Executive scorecard and table
- Trend visualizations

---

## Demand Pulse Methodology (Simplified)

1. **Calendar spine** ensures a complete daily timeline.
2. Each signal is:
   - Cleaned
   - Forward-filled where appropriate
   - Normalized to a 0–100 scale
3. Signals are combined into a composite index:
   - FX Attractiveness
   - Search Intent
   - Room Scarcity
   - Pricing Pressure
4. Final output:
   - `luxury_demand_pulse` (daily score)
   - `Pulse Tier` (Low / Medium / High / Very High)

---

## What This Project Demonstrates

This project shows real-world and messy data conditions, where signals are incomplete, noisy, and need to be engineered into coherent business metrics:

- End-to-end data pipeline design (Raw external data → automated ingestion → structured BigQuery tables → engineered features → final analytics-ready dataset)
- Cloud-native analytics (GCP, BigQuery, Cloud Run)  
- External API ingestion & automation (Automated daily FX rate ingestion from a public exchange-rate API and automated weekly Google Trends demand ingestion using pytrends)
- Time-series feature engineering (Calendar spine creation, rolling averages, rolling volatility, z-scores, forward-filling, and alignment of signals with different granularities)
- Business-oriented metric design (Design of interpretable 0–100 indices such as FX Attractiveness Score, Search Intent Score, and a composite Luxury Demand Pulse) 
- Dashboarding for non-technical stakeholders 
- Comfort working with imperfect / incomplete data (Handling missing weekends in FX data, partial hotel ADR/availability history, differing update frequencies, and explicitly documenting assumptions and limitations)

---

## Limitations & Future Improvements

- Extend hotel pricing and availability history
- Add event-based features (conferences, holidays)
- Introduce simple forecasting on the demand pulse
- Segment demand by weekday vs weekend
- Compare Vancouver against peer cities

---

## Tech Stack

- Python (Cloud Run, data ingestion)
- Google BigQuery (analytics + transformations)
- Google Cloud Scheduler (periodic scheduled data ingestion)
- Looker Studio (dashboarding)

---

## Author

Roberto Mejia Lacayo  
Data Analytics / Data Science  
Vancouver, Canada
