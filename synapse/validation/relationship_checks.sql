
/* =========================================================
   STEP 6 — FINAL RELATIONSHIP CHECK
   =========================================================
   Expected:
   All values should be 0.
   ========================================================= */

SELECT
    (SELECT COUNT(*)
     FROM dw.Fact_Stock_Market f
     LEFT JOIN dw.DimDate d
        ON f.date_key = d.date_key
     WHERE d.date_key IS NULL) AS missing_stock_dates,

    (SELECT COUNT(*)
     FROM dw.Fact_Currency f
     LEFT JOIN dw.DimDate d
        ON f.date_key = d.date_key
     WHERE d.date_key IS NULL) AS missing_currency_dates,

    (SELECT COUNT(*)
     FROM dw.Fact_Currency f
     LEFT JOIN dw.DimCurrency c
        ON f.currency_key = c.currency_key
     WHERE c.currency_key IS NULL) AS missing_currency_keys,

    (SELECT COUNT(*)
     FROM dw.Fact_Economic f
     LEFT JOIN dw.DimDate d
        ON f.date_key = d.date_key
     WHERE d.date_key IS NULL) AS missing_economic_dates;
