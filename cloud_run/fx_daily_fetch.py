import functions_framework
import requests
from google.cloud import bigquery
from datetime import datetime

@functions_framework.http
def main(request):
    # FX API URL
    url = "https://open.er-api.com/v6/latest/CAD"

    # Call the FX API
    resp = requests.get(url, timeout=10)
    if resp.status_code != 200:
        return {"error": "FX API request failed"}, 500

    data = resp.json()

    # Parse the fields we need
    api_date_raw = data.get("time_last_update_utc")
    cad_to_usd = data.get("rates", {}).get("USD")

    if api_date_raw is None or cad_to_usd is None:
        return {"error": "Missing fields in FX API response"}, 500

    # Convert CAD->USD to USD->CAD
    usd_to_cad = 1 / float(cad_to_usd)

    # Convert timestamp to clean date
    clean_date = datetime.strptime(
        api_date_raw, "%a, %d %b %Y %H:%M:%S %z"
    ).date()

    # Build BigQuery row
    row = {
        "date": clean_date.isoformat(),
        "usd_per_cad": usd_to_cad,
        "source": "open.er-api.com",
        "created_at": datetime.utcnow().isoformat()
    }

    # Insert into BigQuery
    client = bigquery.Client()
    table_id = "luxury-hotel-marketing-radar.luxury_marketing.fx_rates"

    errors = client.insert_rows_json(table_id, [row])
    if errors:
        return {"error": str(errors)}, 500

    # Return success response
    return {
        "status": "ok",
        "date": clean_date.isoformat(),
        "usd_per_cad": usd_to_cad
    }, 200
