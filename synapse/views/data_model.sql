/* =========================================================
   STEP 1 — CREATE DIMDATE
   =========================================================
   Purpose:
   Create the Date Dimension for Saudi FinHub.

   Sources:
   - TASI stock dates
   - Currency dates
   - Economic quarter dates

   The three sources are combined into one Date Dimension.
   ========================================================= */
CREATE VIEW dw.DimDate
AS

SELECT
    CONVERT(INT, CONVERT(CHAR(8), date_value, 112)) AS date_key,
    date_value AS [date],
    DAY(date_value) AS [day],
    MONTH(date_value) AS [month],
    DATEPART(QUARTER, date_value) AS [quarter],
    YEAR(date_value) AS [year],
    CONCAT(
        YEAR(date_value),
        '-Q',
        DATEPART(QUARTER, date_value)
    ) AS year_quarter

FROM
(
    /* -----------------------------------------------------
       1. TASI dates
       ----------------------------------------------------- */
    SELECT
        CAST([Date] AS DATE) AS date_value
    FROM OPENROWSET(
        BULK 'https://sfh.dfs.core.windows.net/processed/stocks/tasi_cleaned.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS stock_data

    UNION

    /* -----------------------------------------------------
       2. Currency dates
       ----------------------------------------------------- */
    SELECT
        CAST(rate_date AS DATE) AS date_value
    FROM OPENROWSET(
        BULK 'https://sfh.dfs.core.windows.net/processed/currency/',
        FORMAT = 'DELTA'
    ) AS currency_data

    UNION

    /* -----------------------------------------------------
       3. Economic quarter dates
       Q1 = January 1
       Q2 = April 1
       Q3 = July 1
       Q4 = October 1
       ----------------------------------------------------- */
    SELECT
        CASE
            WHEN [quarter] = 'Q1' THEN DATEFROMPARTS([year], 1, 1)
            WHEN [quarter] = 'Q2' THEN DATEFROMPARTS([year], 4, 1)
            WHEN [quarter] = 'Q3' THEN DATEFROMPARTS([year], 7, 1)
            WHEN [quarter] = 'Q4' THEN DATEFROMPARTS([year], 10, 1)
        END AS date_value
    FROM OPENROWSET(
        BULK 'https://sfh.dfs.core.windows.net/processed/economics/economic_quarterly.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS economic_data

) AS AllDates;

/* =========================================================
   STEP 2 — CREATE DIMCURRENCY
   =========================================================
   Purpose:
   Create the Currency Dimension for Saudi FinHub.

   Source:
   Currency Delta Lake in ADLS.

   Output:
   currency_key
   currency_code
   currency_name
   ========================================================= */

CREATE VIEW dw.DimCurrency
AS

SELECT
    ROW_NUMBER() OVER (
        ORDER BY currency_code
    ) AS currency_key,

    currency_code,

    /* The source provides the currency code.
       No separate currency name exists in the source,
       so the code is currently used as the display name. */
    currency_code AS currency_name

FROM
(
    /* Get unique target currencies from the Currency data */
    SELECT DISTINCT
        CAST(target_currency AS VARCHAR(10)) AS currency_code

    FROM OPENROWSET(
        BULK 'https://sfh.dfs.core.windows.net/processed/currency/',
        FORMAT = 'DELTA'
    ) AS currency_data

) AS CurrencyCodes;

/* =========================================================
   STEP 3 — CREATE FACT STOCK MARKET
   =========================================================
   Purpose:
   Create the Stock Market Fact View for Saudi FinHub.

   Source:
   TASI processed CSV in ADLS.

   Relationship:
   Fact_Stock_Market → DimDate

   Grain:
   One row per TASI trading date.
   ========================================================= */

CREATE VIEW dw.Fact_Stock_Market
AS

SELECT
    /* Surrogate key for the stock fact */
    ROW_NUMBER() OVER (
        ORDER BY stock_date
    ) AS stock_key,

    /* Foreign key to DimDate */
    CONVERT(
        INT,
        CONVERT(CHAR(8), stock_date, 112)
    ) AS date_key,

    /* Stock market measures */
    [open],
    [high],
    [low],
    [close],
    change_percent,
    volume

FROM
(
    /* -----------------------------------------------------
       Read and type-cast the TASI processed data
       ----------------------------------------------------- */
    SELECT
        CAST([Date] AS DATE) AS stock_date,

        CAST([Open] AS DECIMAL(18,2)) AS [open],

        CAST([High] AS DECIMAL(18,2)) AS [high],

        CAST([Low] AS DECIMAL(18,2)) AS [low],

        CAST([Close] AS DECIMAL(18,2)) AS [close],

        CAST([Change%] AS DECIMAL(18,4)) AS change_percent,

        CAST([Volume] AS BIGINT) AS volume

    FROM OPENROWSET(
        BULK 'https://sfh.dfs.core.windows.net/processed/stocks/tasi_cleaned.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS stock_data

) AS StockData;

/* =========================================================
   STEP 4 — CREATE FACT CURRENCY
   =========================================================
   Purpose:
   Create the Currency Fact View for Saudi FinHub.

   Source:
   Currency Delta Lake in ADLS.

   Relationships:
   Fact_Currency → DimCurrency
   Fact_Currency → DimDate

   Grain:
   One row per currency rate per date.
   ========================================================= */

CREATE VIEW dw.Fact_Currency
AS

SELECT
    /* Surrogate key for the currency fact */
    ROW_NUMBER() OVER (
        ORDER BY
            rate_date,
            target_currency
    ) AS currency_rate_key,

    /* Foreign key to DimCurrency */
    dc.currency_key,

    /* Foreign key to DimDate */
    CONVERT(
        INT,
        CONVERT(CHAR(8), cd.rate_date, 112)
    ) AS date_key,

    /* Currency information */
    cd.base_currency,

    cd.exchange_rate

FROM
(
    /* -----------------------------------------------------
       Read Currency Delta data
       ----------------------------------------------------- */
    SELECT
        CAST(rate_date AS DATE) AS rate_date,

        CAST(base_currency AS VARCHAR(10)) AS base_currency,

        CAST(target_currency AS VARCHAR(10)) AS target_currency,

        CAST(exchange_rate AS DECIMAL(18,6)) AS exchange_rate

    FROM OPENROWSET(
        BULK 'https://sfh.dfs.core.windows.net/processed/currency/',
        FORMAT = 'DELTA'
    ) AS currency_data

) AS cd

/* ---------------------------------------------------------
   Connect each currency rate to DimCurrency
   --------------------------------------------------------- */
LEFT JOIN dw.DimCurrency dc
    ON cd.target_currency = dc.currency_code;


/* =========================================================
   STEP 5 — CREATE FACT ECONOMIC
   =========================================================
   Purpose:
   Create the Economic Fact View for Saudi FinHub.

   Source:
   Economic quarterly CSV in ADLS.

   Relationship:
   Fact_Economic → DimDate

   Grain:
   One row per economic quarter.
   ========================================================= */

CREATE VIEW dw.Fact_Economic
AS

SELECT
    /* Surrogate key for the economic fact */
    ROW_NUMBER() OVER (
        ORDER BY quarter_start_date
    ) AS economic_key,

    /* Foreign key to DimDate */
    CONVERT(
        INT,
        CONVERT(CHAR(8), quarter_start_date, 112)
    ) AS date_key,

    /* Economic measures */
    gdp_value,
    gdp_growth_rate,
    inflation_rate,
    unemployment_rate

FROM
(
    /* -----------------------------------------------------
       Read and type-cast Economic data
       ----------------------------------------------------- */
    SELECT
        CASE
            WHEN [quarter] = 'Q1'
                THEN DATEFROMPARTS([year], 1, 1)

            WHEN [quarter] = 'Q2'
                THEN DATEFROMPARTS([year], 4, 1)

            WHEN [quarter] = 'Q3'
                THEN DATEFROMPARTS([year], 7, 1)

            WHEN [quarter] = 'Q4'
                THEN DATEFROMPARTS([year], 10, 1)
        END AS quarter_start_date,

        CAST([gdp_value] AS DECIMAL(18,2)) AS gdp_value,

        CAST([gdp_growth_rate] AS DECIMAL(18,4)) AS gdp_growth_rate,

        CAST([inflation_rate] AS DECIMAL(18,4)) AS inflation_rate,

        CAST([unemployment_rate] AS DECIMAL(18,4)) AS unemployment_rate

    FROM OPENROWSET(
        BULK 'https://sfh.dfs.core.windows.net/processed/economics/economic_quarterly.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS economic_data

) AS EconomicData;
