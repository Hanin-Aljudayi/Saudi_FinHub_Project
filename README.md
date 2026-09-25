# Saudi FinHub Project

End-to-end data platform for Saudi financial data: Currency, TASI Stock
Market, and Economic indicators.

## Architecture

    Source APIs / CSVs
            ↓
    Azure Data Factory
            ↓
    ADLS Gen2 (raw → processed)
            ↓
    Synapse Serverless SQL
            ↓
    Power BI

## Repository Structure

- `adf/` — Azure Data Factory pipelines, Data Flows, datasets, triggers
- `synapse/` — Synapse Serverless views, DDL, validation queries
- `notebooks/` — Exploratory notebooks (historical reference)
- `docs/` — Architecture diagram, data dictionary

## Data Sources

| Source | Type | ADF Pipeline |
|---|---|---|
| Frankfurter (Currency) | REST API | `PL_Currency_Ingestion` |
| TASI (Saudi Exchange) | Manual CSV | `PL_Stock` |
| GASTAT (Economic) | Public data | `PL_Economic` |

## Pipelines

- `PL_MAIN_ORCHESTRATE` — runs all three source pipelines in parallel
- `TR_Main_Daily` — daily trigger

## Synapse Views

- Dimensions: `dw.DimDate`, `dw.DimCurrency`
- Facts: `dw.Fact_Currency`, `dw.Fact_Stock_Market`, `dw.Fact_Economic`

## Output Schemas

### Currency (Delta)
Path: `abfss://processed@sfh.dfs.core.windows.net/currency/`
Grain: one row per (rate_date, base_currency, target_currency)

### Stock (CSV)
Path: `abfss://processed@sfh.dfs.core.windows.net/stocks/tasi_cleaned.csv`
Grain: one row per trading day

### Economic (CSV)
Path: `abfss://processed@sfh.dfs.core.windows.net/economics/economic_quarterly.csv`
Grain: one row per quarter

## Data Quality

Currency validation rules (from `DF_Currency_Transform`):
- rate_date not null
- base_currency not null
- target_currency not null
- exchange_rate not null and greater than zero
- no duplicate keys (upsert on composite key)

## Connection Details

- Synapse endpoint: `sfh-synapse-ondemand.sql.azuresynapse.net`
- Database: `SaudiFinHubServerless`
- ADF factory: `SaudiFinhub`

## Contributors

- [Dania] — Currency pipeline, ADF orchestration
- [Mashael] — Synapse views, data model
- [Hanin] — Power BI
## Relationship between Python and ADF

The Python code in `src/` and `notebooks/` is the original prototype that
defined the cleaning, validation, and transformation rules. It was used to
explore the data and prove the logic.

The production implementation now runs in Azure Data Factory (see `adf/`).
The ADF Data Flows implement the same rules. The Python code is retained as
reference documentation and for unit testing.

Note: files in `data/` are historical snapshots from the Python
prototype and are not kept up to date. Current processed data lives in ADLS
at `processed/`.
