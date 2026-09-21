# Saudi_FinHub_Project

## Project Overview

Saudi FinHub is a data engineering project designed to centralize Saudi market and economic data into a unified data platform.

The project integrates:

- Saudi stock market data
- Saudi economic indicators
- Currency exchange rate data

The data pipeline follows a layered architecture:

**Source → Azure Data Factory → ADLS Raw → Transformation → ADLS Processed → Synapse → Power BI**

The project focuses on preserving daily market data while preparing reliable, validated datasets for downstream analytics and visualization.

---

## Data Sources

### Saudi Stock Market

- Source: Saudi Exchange historical market data
- Dataset: TASI historical market data
- Frequency: Daily trading data
- Grain: One row per TASI trading day
- Historical coverage: 2014-01-01 to 2026-09-20

The original source data is preserved in the RAW layer without modification.

### Economic Data

The economic dataset contains Saudi economic indicators used to provide economic context for market analysis.

Examples include:

- GDP
- Inflation
- Unemployment

The economic data is integrated using `Date` as the common integration key.

### Currency Data

The currency dataset contains historical exchange rate information for SAR against major global currencies.

The currency data is integrated using `Date` as the common integration key.

---

# Data Architecture

The project follows a layered data architecture:

Source
      ↓
Azure Data Factory
      ↓
ADLS RAW Layer
      ↓
Data Transformation & Validation
      ↓
ADLS PROCESSED Layer
      ↓
Azure Synapse
      ↓
Power BI