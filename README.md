# Saudi_FinHub_Project
# Saudi FinHub

# Hanin
## Data Sources — Economic Indicators

### GDP
- Source: General Authority for Statistics (GASTAT)
- Dataset: Gross Domestic Product at Current Prices by Main ISIC
- Source File: Gross domestic product (GDP) at current price by Main ISIC_data.csv
- Frequency: Quarterly
- Format: CSV
- Authentication: Not required
- Usage Terms: GASTAT data may be reused under its open data policy with proper attribution to GASTAT as the official source.

### Inflation
- Source: General Authority for Statistics (GASTAT)
- Dataset: Annual Change in Consumer Prices (National, %)
- Frequency: Monthly
- Format: CSV
- Raw File: Annual Change in Consumer Prices (National, %)_data.csv
- Usage Terms: GASTAT data may be reused under its open data policy with proper attribution to GASTAT as the official source.

### Unemployment
- Source: General Authority for Statistics (GASTAT)
- Dataset: Unemployment Rate by Nationality and Sex
- Frequency: Quarterly
- Format: CSV
- Raw File: Unemployment_rate_by_nationality_and_sex_2013_2026.csv
- Usage Terms: GASTAT data may be reused under its open data policy with proper attribution to GASTAT as the official source.


## Economic Indicators — Validation Schema

### GDP

| Column            | Expected dtype | Nullable | Allowed values / range   |
| ----------------- | -------------- | -------- | ------------------------ |
| `main_activities` | string         | No       | `Gross Domestic Product` |
| `year`            | integer        | No       | 2013–2026                |
| `quarter`         | string         | No       | `Q1`, `Q2`, `Q3`, `Q4`   |
| `year_quarter`    | string         | No       | Format `YYYY-Q#`         |
| `gdp_value`       | float          | No       | `>= 0`                   |


### Inflation

| Column | Data Type | Nullable | Allowed Values / Range |
|---|---|---|---|
| item_name | string | No | General Index |
| date | date | No | 2014-01-01 or later |
| inflation_rate | float | No | Numeric value |
| year | integer | No | 2014 or later |
| quarter | string | No | Q1, Q2, Q3, Q4 |
| year_quarter | string | No | YYYY-Q1 to YYYY-Q4 |

### Unemployment

| Column | Data Type | Nullable | Allowed Values / Range |
|---|---|---|---|
| indicator_name | string | No | Unemployment rate by nationality and sex |
| unemployment_rate | float | No | 0 to 100 |
| is_estimated | boolean | No | True, False |
| year | integer | No | 2013 or later |
| quarter | string | No | Q1, Q2, Q3, Q4 |
| year_quarter | string | No | YYYY-Q1 to YYYY-Q4 |
# Hanin