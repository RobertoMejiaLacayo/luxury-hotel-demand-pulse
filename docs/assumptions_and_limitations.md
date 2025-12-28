# Assumptions and Limitations

This project is designed as a realistic analytics case study, not a production forecasting system.  
The following assumptions and limitations are acknowledged explicitly.

---

## Key Assumptions

1. Google Trends as Demand Proxy
Search interest is assumed to correlate with future booking intent, even though not all searches convert into reservations.

2. FX Impact on Tourism
USD → CAD exchange rates are assumed to influence U.S. travel demand, particularly in the luxury segment.

3. Limited Hotel Data Extrapolation
Hotel ADR and availability data are assumed to be representative for the period during which data exist (January–October 2025).

4. Weekend FX Handling
FX rates are forward-filled across weekends, reflecting common financial market practice.

---

## Limitations

1. Incomplete Hotel Data Coverage
Hotel pricing and availability data does not span multiple years, limiting long-term validation.

2. No Direct Booking Data
The model does not include proprietary booking or revenue data, which would significantly strengthen predictive accuracy.

3. Google Trends Granularity
Trends data is weekly and normalized, not absolute search volume.

4. Manually Weighted Composite Score
The final Luxury Demand Pulse uses heuristic weights rather than statistically optimized coefficients.

---

## Future Improvements

- Incorporate flight or criuse arrival data
- Integrate real hotel booking or revenue metrics
- Apply formal model training to learn optimal weights
- Extend demand signals to additional markets
