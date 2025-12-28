# Data Sources

This project combines multiple data sources to model luxury tourism demand in Vancouver.  
Each source captures a different dimension of demand behaviour.

---

## 1. Foreign Exchange (USD → CAD)

Source: Public FX API  
Frequency: Daily  
Storage: BigQuery (`fx_rates` table)

why it matters:  
Exchange rates influence international travel affordability. A stronger USD relative to CAD increases purchasing power for U.S. visitors and can stimulate tourism demand.

---

## 2. Google Trends (Search Interest)

Source Google Trends (via `pytrends`)  
Frequency: Weekly  
Keywords:  
- Vancouver hotel  
- Vancouver luxury hotel  
- Fairmont Pacific Rim  
- Shangri-La Vancouver  
- Rosewood Hotel Georgia  
- Vancouver spa hotel  
- Other luxury-related terms

why it matters:
Search interest reflects early-stage consumer intent before bookings occur, making it a useful leading indicator of demand.

---

## 3. Hotel Pricing & Availability (Sample Data)

Source: CSV dataset (manually obtained)  
Coverage:** January 2025 – October 2025  
Metrics:  
- Average Daily Rate (ADR)  
- Availability/occupancy proxy

why it matters:  
Hotel pricing and availability reflect observed demand behaviour on the supply side.

---

## 4. Calendar / Date Spine

Source: Generated in BigQuery  
Coverage: Multi-year daily calendar

why it matters: 
Provides a consistent temporal backbone for joining all signals, enabling rolling metrics, seasonality analysis, and forward-looking projections.

---

## Data Philosophy

The project  blends:
- Automated external data
- Manual/limited real-world datasets
- Synthetic or extended values (but only where necessary)

This simulates real analytics work, where perfect data is rarely available.
