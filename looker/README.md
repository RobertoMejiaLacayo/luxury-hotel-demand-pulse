# Interactive Dashboard

## View the Looker Studio dashboard here
https://lookerstudio.google.com/s/rY7hgF1gtqU

*(View-only access; no login required)*

## Overview

Luxury Demand Pulse is designed to answer a simple question:

> *“How strong is luxury hotel demand in Vancouver right now, and why?”*

The dashboard surfaces:
- A single headline demand metric
- How demand has evolved over time
- The underlying drivers contributing to demand
- Specific dates where demand was unusually high

---

## Key Dashboard Elements

### 1. Luxury Demand Pulse — Last 30 Days

Metric:
- Last 30-day average of the Luxury Demand Pulse (0–100)

Why this matters:  
- Smooths daily volatility  
- Represents current demand conditions, not a long-term historical average  
- Appropriate for executive summaries and weekly decision-making

Interpretation:  
- 0–39: Low demand  
- 40–54: Medium demand  
- 55–69: High demand
- 70+ Very High demand

---

### 2. Demand for Luxury Hotels Over Time (Jan–Oct 2025)

Chart type: Time-series line chart  
Metric: Daily Luxury Demand Pulse (0–100)

What it shows: 
- Seasonality in luxury travel demand  
- Structural demand shifts (e.g., summer peak)  
- Periods of sustained strength vs. softness

How to read it: 
- Rising trend → improving demand conditions  
- Flat trend → stable market  
- Declining trend → weakening demand

---

### 3. Big 3 Individual Pulse Components

This chart decomposes the overall pulse into its three primary drivers, all normalized to a 0–100 scale for comparability.

#### a. FX Attractiveness Index
- Measures how favourable the USD → CAD exchange rate is for U.S. travellers
- Higher values indicate stronger foreign purchasing power

#### b. Trends Intent Index
- Based on Google search interest for luxury hotel–related queries
- Acts as a leading indicator of future bookings

#### c. Room Scarcity Index (Availability Inverted)
- Higher values indicate lower room availability
- Serves as a supply-side pressure indicator
- High scarcity + high intent typically supports pricing power

Important note:
These components are not expected to move perfectly together.  
For example:
- Search interest may rise before rooms become scarce  
- FX conditions can improve without immediately translating to bookings  

---

### 4. Top Demand Days

Table contents:
- Date
- Day Type (Weekday / Weekend)
- Pulse Tier (Low / Medium / High)
- Luxury Demand Pulse
- Individual component scores
- Estimated Occupancy %

Purpose: 
- Identify peak demand days
- Support use cases such as:
  - Pricing decisions
  - Promotional timing
  - Staffing and inventory planning

How to use it: 
- Sort by Luxury Demand Pulse to isolate high-pressure dates  
- Compare weekends vs. weekdays  
- Inspect which component drove demand on specific days

---

## How to Interpret the Pulse (Quick Guide)

- The Luxury Demand Pulse is a composite indicator, not a forecast
- It reflects relative demand strength, not absolute bookings
- Best used for:
  - Comparing days or periods
  - Identifying unusually strong or weak demand conditions
  - Explaining *why* demand looks the way it does

---

## Data Notes

- Main Coverage: January 1, 2025 – October 31, 2025
- Data for FX and Google Trends extends from the present day (running on scheduled Cloud Run functions) and back to 2022.
- Composite Luxury Pulse signal therefore is only viable from Jan 1, 2025 to Oct 31, 2025.
- Some inputs (e.g., hotel availability and ADR) are estimated due to limited public data
- Missing days are handled via calendar spine and forward-filling where appropriate

---

## Intended Audience

- Analytics & data teams
- Revenue management
- Marketing strategy
- Product and business stakeholders

This dashboard is intentionally designed to be interpretable without SQL or technical context.
