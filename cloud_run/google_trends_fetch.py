import functions_framework
from datetime import datetime
from google.cloud import bigquery
from pytrends.request import TrendReq

@functions_framework.http
def main(request):
    keywords = [
        "Vancouver hotel",
        "Vancouver luxury hotel",
        "Fairmont Pacific Rim",
        "Fairmont Vancouver",
        "Shangri-La Vancouver",
        "Rosewood Hotel Georgia",
        "JW Marriott Parq Vancouver",
        "Vancouver spa hotel",
        "best hotel Vancouver",
        "Vancouver romantic getaway",
        "Vancouver 5 star hotel"
    ]

    pytrends = TrendReq(hl='en-US', tz=0)

    rows_to_insert = []
    today = datetime.utcnow().isoformat()

    for kw in keywords:
        # build trending request
        pytrends.build_payload(
            [kw],
            timeframe="2022-01-01 2025-12-31",
            geo="CA"
        )


        # get weekly time series
        df = pytrends.interest_over_time()

        if df.empty:
            continue

        for idx, value in df[kw].items():
            rows_to_insert.append({
                "date": idx.date().isoformat(),
                "search_term": kw,
                "interest": float(value),
                "created_at": today
            })

    #send to into BigQuery
    client = bigquery.Client()
    table_id = "luxury-hotel-marketing-radar.luxury_marketing.google_trends"

    errors = client.insert_rows_json(table_id, rows_to_insert)

    if errors:
        return {"error": str(errors)}, 500

    return {"status": "ok", "rows": len(rows_to_insert)}, 200
