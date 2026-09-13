# Saudi_FinHub_Project

## Input Schema - Mashael
## Project Overview
The project uses an ETL pipeline to extract historical stock data from an API, profile and clean the data, validate it against a defined schema, and transform the daily stock data into quarterly data.

## Data Source

### Saudi Stock Market

- Source: Tasilab API
- Endpoint: `GET /v1/historical/{symbol}`
- Authentication: API key using the `X-API-Key` header
- Rate limit: 120 requests per minute on the free tier
- Data period: 2013-01-01 to 2026-03-31

The raw API responses are stored without modification in `data/raw/`.

## Selected Companies

The stock dataset contains 15 Saudi companies:

- 1120 — Al Rajhi Bank
- 2080 — GASCO
- 1211 — Ma'aden
- 2010 — SABIC
- 2280 — Almarai
- 2310 — Sipchem
- 3030 — Saudi Cement
- 3060 — Yanbu Cement
- 4003 — Extra
- 4030 — Bahri
- 4190 — Jarir Marketing
- 5110 — Saudi Electricity
- 7010 — stc
- 7020 — Mobily
- 8210 — Bupa Arabia

## Input Schema

The cleaned stock dataset is validated using the following schema:

| Column | Type | Nullable | Validation |
|---|---|---|---|
| symbol | string | No | Must be one of the selected symbols |
| date | datetime | No | Valid date |
| open | float | No | Greater than 0 |
| high | float | No | Greater than 0 |
| low | float | No | Greater than 0 |
| close | float | No | Greater than 0 |
| adj_close | float | No | Greater than 0 |
| volume | integer | No | Greater than or equal to 0 |

All rows passed the validation checks and no rows were rejected.

## Data Profiling and Cleaning

The stock data was profiled for:

- Column names and data types
- Number of rows and columns
- Missing values
- Duplicate records
- Unique values
- Sample records
- Nested fields and mixed data types

During cleaning:

- Dates were converted to datetime.
- Price fields were converted to numeric values.
- Duplicate rows were removed.
- Column names were standardized.
- Records with zero volume were retained because they were not identified as invalid.

## Transformation

The validated daily stock data was aggregated to quarterly level.

The quarterly dataset contains the following derived fields:

- `quarter_open` — first opening price in the quarter
- `quarter_high` — highest price during the quarter
- `quarter_low` — lowest price during the quarter
- `quarter_close` — last closing price in the quarter
- `avg_close` — average closing price during the quarter
- `total_volume` — total trading volume during the quarter

### Grain

One row represents **one company for one quarter**.

The quarterly stock dataset contains:

- 15 companies
- 53 quarters
- 795 rows

Mashael