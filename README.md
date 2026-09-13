# Saudi_FinHub_Project
# Saudi Riyal (SAR) Exchange Rates

Daily exchange-rate data for the Saudi Riyal (SAR) against five major currencies.

## Dataset Summary

- **File:** `clean.csv`
- **Base currency:** SAR
- **Quote currencies:** AED, CNY, EUR, GBP, USD
- **Date range:** 2013-01-01 to 2026-09-10
- **Frequency:** Daily
- **Rows:** approximately 25,005 rows
- **Format:** CSV

## Schema

| Column | Type | Description |
|---|---|---|
| `date` | string / date | Observation date in `YYYY-MM-DD` format |
| `base` | string | Base currency code. Always `SAR` in this dataset |
| `quote` | string | Quote currency code |
| `rate` | float | Amount of `quote` currency per 1 `base` currency (1 SAR) |

Example rows:

| date | base | quote | rate |
|---|---|---|---|
| 2013-01-01 | SAR | AED | 0.97933 |
| 2013-01-01 | SAR | CNY | 1.6628 |
| 2013-01-01 | SAR | EUR | 0.20207 |
| 2013-01-01 | SAR | GBP | 0.16508 |
| 2013-01-01 | SAR | USD | 0.26667 |

## Currencies

| Code | Currency | Notes |
|---|---|---|
| AED | UAE Dirham | Effectively pegged; SAR/AED remains around `0.97933` |
| CNY | Chinese Yuan | Floating market rate |
| EUR | Euro | Floating market rate |
| GBP | British Pound | Floating market rate |
| USD | US Dollar | Pegged; SAR/USD remains around `0.26667` |

## Important Notes

- `rate` represents how many units of the quote currency equal **1 SAR**.
- For example, `SAR/USD = 0.26667` means `1 SAR ≈ 0.26667 USD`.
- AED and USD series are constant because of currency pegs.
- The dataset includes every calendar date, including weekends and holidays. Exchange rates on non-trading days may be carried forward or repeated.
- Values are generally rounded to 5 decimal places.
- This dataset is for informational and analytical purposes only. It is not financial advice.
