# Cloud Run Services

This folder contains the Python services deployed on Google Cloud Run that power the automated data ingestion for this project.

These services are designed to run on a schedule and continuously refresh external data sources used in the analytics pipeline.

---

## Services Included

### 1. FX Rate Ingestion (`fx-daily-fetch`)
- Fetches the daily USD → CAD exchange rate from a public FX API
- Normalizes and stores the result in BigQuery
- Runs automatically on a scheduled basis
- Ensures currency data remains up to date for downstream analysis

Why?:
Currency strength directly affects international tourism demand and purchasing power, especially for U.S. visitors to Canada.

---

### 2. Google Trends Demand Ingestion (`pytrends-demand-interest`)
- Uses the `pytrends` library to retrieve Google Trends search interest
- Tracks luxury hotel–related search terms for Vancouver
- Stores weekly search interest scores in BigQuery
- Designed to be extensible as new keywords are added

Why?:
Search interest acts as a proxy for consumer intent and early-stage travel demand.

---

## Why Cloud Run?

Cloud Run was chosen because it:
- Supports containerized Python workloads
- Integrates with BigQuery
- Scales automatically
- Allows scheduled, serverless execution without infrastructure management

---

## Notes
- Each service includes a `main.py` entry point and `requirements.txt`
- Error handling is designed to fail gracefully and log issues for inspection
- Services can be re-run manually or on schedule without code changes
